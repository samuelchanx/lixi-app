import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ContinueRow extends StatelessWidget {
  final Function() onPressed;
  final bool showLastPageButton;
  const ContinueRow({
    super.key,
    required this.onPressed,
    this.showLastPageButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: showLastPageButton
              ? Row(
                  children: [
                    InkWell(
                      onTap: () {
                        final currentStep =
                            Uri.base.queryParameters['step']?.toIntOrNull() ??
                                1;
                        context.go('/diagnosis?step=${currentStep - 1}');
                      },
                      child: const Row(
                        children: [
                          Icon(
                            Icons.arrow_back_ios,
                            color: Colors.black54,
                          ),
                          Text('上一頁'),
                        ],
                      ),
                    ),
                    const Expanded(child: SizedBox()),
                  ],
                )
              : const SizedBox(),
        ),
        Expanded(
          child: ElevatedButton(
            onPressed: onPressed,
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 18, vertical: 8.0),
              child: Text(
                '繼續',
                maxLines: 1,
              ),
            ),
          ),
        ),
        const Expanded(child: SizedBox()),
      ],
    );
  }
}
