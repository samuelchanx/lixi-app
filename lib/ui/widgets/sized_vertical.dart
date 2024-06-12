import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class SizedVertical extends StatelessWidget {
  const SizedVertical(
    this.size, {
    super.key,
  });
  final double size;

  @override
  Widget build(BuildContext context) {
    return Gap(
      MediaQuery.of(context).size.height * size / 932,
    );
  }
}

class SizedHorizontal extends StatelessWidget {
  final double size;
  const SizedHorizontal(
    this.size, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Gap(
      MediaQuery.of(context).size.width * size / 430,
    );
  }
}
