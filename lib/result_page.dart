import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lixi/assets/assets.gen.dart';
import 'package:lixi/database.dart';
import 'package:lixi/models/question_model_controller.dart';
import 'package:lixi/models/question_model_v2.dart';

class ResultPage extends HookConsumerWidget {
  const ResultPage({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useMemoized(
      () => QuestionControllerV2(
        questions: parseDatabaseV2(databaseV2Json),
        ref: ref,
      ),
    );
    useEffect(
      () {
        controller.diagnose();
        return null;
      },
      const [],
    );
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        children: [
          Assets.images.appIconCopy.image(
            height: 50,
          ),
          const SizedBox(height: 20),
          const Icon(
            Icons.check_circle,
            color: Colors.pink,
            size: 100,
          ),
          SlideInLeft(
            duration: const Duration(seconds: 1),
            child: const Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 20),
                  Text('You have a cold!'),
                  SizedBox(height: 20),
                  Text('You should take some rest and drink lots of water.'),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(36.0),
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil('/', (route) => false);
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Try again'),
            ),
          ),
        ],
      ),
    );
  }
}
