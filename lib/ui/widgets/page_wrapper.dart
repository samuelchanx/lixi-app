import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lixi/assets/assets.gen.dart';

class PageWrapper extends StatelessWidget {
  const PageWrapper({
    super.key,
    required this.child,
    this.showLogo = false,
  });

  final Widget child;
  final bool showLogo;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SizedBox(
        width: width,
        height: height,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              top: height * 0.059,
              left: width * 0.53,
              child: Assets.images.lixiSplash.image(
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
              child: Assets.images.lixiSplash.image(
                width: 37,
              ),
            ),
            Positioned(
              top: height * 560 / 932,
              left: width * 68 / 430,
              child: Assets.images.lixiSplash.image(
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
              child: Assets.images.lixiSplash.image(
                height: 48.6,
              ),
            ),
            Positioned(
              top: height * 865 / 932,
              left: width * 367 / 430,
              child: Assets.images.lixiSplash.image(
                height: 36.7,
              ),
            ),
            Positioned(
              top: height * 878.7 / 932,
              child: Center(
                child: Text(
                  '@journeywithlixi',
                  style: GoogleFonts.gildaDisplay(
                    fontSize: 18,
                    color: const Color(0xffDFCAC1),
                  ),
                ),
              ),
            ),
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
    );
  }
}
