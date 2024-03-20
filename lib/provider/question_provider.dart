import 'package:csv/csv.dart';
import 'package:dartx/dartx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lixi/database.dart';
import 'package:lixi/models/question_model.dart';
import 'package:lixi/models/question_model_v2.dart';

final questionsProvider = FutureProvider<List<QuestionModelV2>>((ref) {
  return parseDatabaseV2(databaseV2Json);
});

final databaseFutureProvider =
    FutureProvider<(List<Question>, List<CureMethod>)>((ref) async {
  List<List<dynamic>> rowsAsListOfValues = const CsvToListConverter(
    eol: '\n',
  ).convert(databaseString);
  List<Question> questions = [];
  List<CureMethod> cureMethods = [];
  cureMethods.addAll(
    rowsAsListOfValues.slice(2).map(
          (e) => CureMethod(e[1], e[0], []),
        ),
  );
  rowsAsListOfValues[0].forEachIndexed(
    (symptom, columnIndex) {
      if (columnIndex == 0 || columnIndex == 1) {
        // Skipping the first two columns
        return;
      }
      final currentOption = rowsAsListOfValues[1][columnIndex].toString();
      if (symptom == null || symptom.toString().isEmpty) {
        if (currentOption.isNotEmpty) {
          questions[questions.length - 1].options.add(
                rowsAsListOfValues[1][columnIndex].toString(),
              );
        }
      } else {
        questions.add(
          Question(
            text: symptom.toString(),
            options: [
              if (currentOption.isNotEmpty) currentOption,
            ],
          ),
        );
      }
      var currentSymtom = symptom.toString();
      if (currentSymtom.isEmpty) {
        currentSymtom = questions[questions.length - 1].text;
      }

      cureMethods.forEachIndexed((element, index) {
        final cellValue = rowsAsListOfValues[index + 2][columnIndex];
        if (cellValue == 'T') {
          element.symptoms.add(
            SymtomOption(
              currentSymtom,
              currentOption,
              questions.length - 1,
            ),
          );
        }
      });
    },
  );
  return (questions, cureMethods);
});