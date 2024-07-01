import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lixi/assets/assets.gen.dart';

const calculatingPageWidth = 393;
const calculatingPageHeight = 852;

List<Widget> getFirstPageStars(BuildContext context) {
  final width = MediaQuery.of(context).size.width;
  final height = MediaQuery.of(context).size.height;
  return [
    Positioned(
      top: height * 0.059,
      left: width * 0.53,
      child: Assets.images.lixiSplashRotate.image(
        width: 50,
      ),
    ),
    Positioned(
      top: height * 204 / 932,
      left: width * 54 / 430,
      child: Assets.images.lixiSplash.image(
        width: 37,
      ),
    ),
    Positioned(
      top: height * 277 / 932,
      left: width * 356 / 430,
      child: Assets.images.lixiSplashFlash.image(
        width: 37,
      ),
    ),
    Positioned(
      top: height * 560 / 932,
      left: width * 68 / 430,
      child: Assets.images.lixiSplashFlash.image(
        width: 31,
      ),
    ),
    Positioned(
      top: height * 606 / 932,
      left: width * 329 / 430,
      child: Assets.images.lixiSplash.image(
        width: 31,
      ),
    ),
    Positioned(
      top: height * 816 / 932,
      left: width * 23 / 430,
      child: Assets.images.lixiSplashRotate.image(
        height: 48.6,
      ),
    ),
    Positioned(
      top: height * 865 / 932,
      left: width * 367 / 430,
      child: Assets.images.lixiSplashRotate.image(
        height: 36.7,
      ),
    ),
  ];
}

List<Widget> getSecondPageStars(BuildContext context) {
  final width = MediaQuery.of(context).size.width;
  final height = MediaQuery.of(context).size.height;
  const fullWidth = 393;
  const fullHeight = 852;
  return [
    Positioned(
      top: height * 35 / fullHeight,
      left: width * 329 / fullWidth,
      child: Assets.images.lixiSplashRotate.image(
        width: 29,
      ),
    ),
    Positioned(
      top: height * 149 / fullHeight,
      left: width * 23 / fullWidth,
      child: Assets.images.lixiSplash.image(
        width: 29,
      ),
    ),
    Positioned(
      top: height * 277 / fullHeight,
      left: width * 294 / fullWidth,
      child: Assets.images.lixiSplashFlash.image(
        width: 19,
      ),
    ),
    Positioned(
      top: height * 349 / fullHeight,
      left: width * 62 / fullWidth,
      child: Assets.images.lixiSplashFlash.image(
        width: 27,
      ),
    ),
    Positioned(
      top: height * 457 / fullHeight,
      left: width * 349 / fullWidth,
      child: Assets.images.lixiSplashFlash.image(
        width: 27,
      ),
    ),
    Positioned(
      top: height * 591 / fullHeight,
      left: width * 23 / fullWidth,
      child: Assets.images.staticSplash.image(
        height: 26.6,
      ),
    ),
    Positioned(
      top: height * 701 / fullHeight,
      left: width * 323 / fullWidth,
      child: Assets.images.lixiSplash.image(
        height: 29,
      ),
    ),
  ];
}

class PageWrapper extends StatelessWidget {
  const PageWrapper({
    super.key,
    required this.child,
    this.stars,
    this.showLogo = false,
    this.showFooter = false,
  });

  final Widget child;
  final List<Widget>? stars;
  final bool showLogo;
  final bool showFooter;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        if (stars != null) ...stars!,
        Scaffold(
          bottomNavigationBar: showFooter
              ? const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      PageFooter(),
                    ],
                  ),
                )
              : null,
          body: SafeArea(
            child: SizedBox(
              width: width,
              height: height,
              child: Stack(
                alignment: showLogo ? Alignment.center : Alignment.topCenter,
                children: [
                  if (stars != null) ...stars!,
                  if (showLogo)
                    Positioned(
                      top: height * 242 / 932,
                      child: Center(
                        child: Assets.images.logo.svg(),
                      ),
                    ),
                  child,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class PageFooter extends StatelessWidget {
  const PageFooter({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Text(
        '@journeywithlixi',
        style: GoogleFonts.gildaDisplay(
          fontSize: 18,
          color: const Color(0xffDFCAC1),
        ),
      ),
    );
  }
}
