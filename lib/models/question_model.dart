import 'package:dartx/dartx.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'question_model.freezed.dart';
part 'question_model.g.dart';

enum QuestionType {
  general,
  others,
}
@Deprecated('Use v2')
@unfreezed
class Question with _$Question {
  const Question._();
  factory Question({
    required String text,
    required List<String> options,
  }) = _Question;

  factory Question.fromJson(Map<String, dynamic> json) =>
      _$QuestionFromJson(json);
}

@unfreezed
class CureMethod with _$CureMethod {
  const CureMethod._();
  factory CureMethod(
    String method,
    String medicine,
    List<SymtomOption> symptoms,
  ) = _CureMethod;

  factory CureMethod.fromJson(Map<String, dynamic> json) =>
      _$CureMethodFromJson(json);
}

@freezed
class SymtomOption with _$SymtomOption {
  const SymtomOption._();
  const factory SymtomOption(
    String symtom,
    String option,
    int symtomQuestionIndex,
  ) = _SymtomOption;

  factory SymtomOption.fromJson(Map<String, dynamic> json) =>
      _$SymtomOptionFromJson(json);
}

class QuestionController {
  final List<Question> questions;
  final List<CureMethod> cureMethods;

  QuestionController({required this.questions, required this.cureMethods});

  int? getNextQuestion(int currentQuestionIndex, int? selectedAnsIndex) {
    print('Current question index: $currentQuestionIndex, '
        'selected answer index: $selectedAnsIndex');
    final currentQuestion = questions[currentQuestionIndex];
    final isOptionAnswered = selectedAnsIndex != null && selectedAnsIndex >= 0;
    print(
      cureMethods
          .where(
            (cm) => cm.symptoms.any(
              (sym) =>
                  sym.symtom == currentQuestion.text &&
                  (isOptionAnswered &&
                      sym.option == currentQuestion.options[selectedAnsIndex]),
            ),
          )
          .map(
            (e) => e.symptoms.elementAtOrNull(
              // Get the next question index for the first symptom
              e.symptoms.lastIndexWhere(
                    (sym) => sym.symtom == currentQuestion.text,
                  ) +
                  1,
            ),
          ),
    );
    final nextSymtomOptions = cureMethods
        .where(
          (cm) => cm.symptoms.any(
            (sym) =>
                sym.symtom == currentQuestion.text &&
                (isOptionAnswered &&
                    sym.option == currentQuestion.options[selectedAnsIndex]),
          ),
        )
        .map(
          (e) => e.symptoms.elementAtOrNull(
            // Get the next question index for the first symptom
            e.symptoms.lastIndexWhere(
                  (sym) => sym.symtom == currentQuestion.text,
                ) +
                1,
          ),
        )
        .toList();
    if (currentQuestionIndex > 10) {
      print(
        'Just testing algor, no need to answer more than 10 questions bye!',
      );
      return null;
    }
    if (nextSymtomOptions.isEmpty) {
      if (currentQuestionIndex != questions.length - 1) {
        print('Next question index: ${currentQuestionIndex + 1}');
        return currentQuestionIndex + 1;
      }
      print('No more questions to answer');
      return null;
    }
    final sortedCureMethods = nextSymtomOptions.sortedBy(
      (element) => element?.symtomQuestionIndex ?? -1,
    );
    print(
      sortedCureMethods
          .map((e) => '${e?.symtomQuestionIndex} ${e?.symtom}')
          .toList(),
    );
    print(
      'Next cure methods: ${sortedCureMethods.firstOrNull?.symtomQuestionIndex}',
    );
    return sortedCureMethods.firstOrNull?.symtomQuestionIndex;
  }
}
