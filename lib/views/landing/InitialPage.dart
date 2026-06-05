import 'package:eduspace_mobile/core/theme/color_palette.dart';
import 'package:flutter/material.dart';

class InitialPage extends StatelessWidget {
  const InitialPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.whiteColor,

      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/logo-eduspace.png",
                  fit: BoxFit.cover,
                  width: 120,
                  height: 120,
                  ),

                  SizedBox(height: 24),

                  Text(
                    "EduSpace",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      color: ColorPalette.blackColor,
                    ),
                  ),

                  SizedBox(height: 16),

                  Text(
                    "Solucion inteligente para la gestión educativa.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      color: ColorPalette.greyColor,
                    ),
                  ),

                  SizedBox(height: 48),

                  SizedBox(
                    width: double.infinity,
                    height: 56,

                    child: FilledButton(
                      onPressed: () {
                        Navigator.pushNamed(context, "/login");
                      }, 
                      style: FilledButton.styleFrom(
                        backgroundColor: ColorPalette.primaryDarkColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        "Comenzar",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        )
                      ),
                      )
                  )
              ],
            ),
            ),
        )
        )
      );
  }
}