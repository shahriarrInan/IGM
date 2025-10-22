import 'package:igm/routes/app_routes.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';
import 'package:refreshed/refreshed.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../../../utils/dimensions/sizes.dart';
import '../controllers/home_controller.dart';
import 'dart:math' as math;

class Home extends GetView<HomeController> {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {

    Sizes sizes = Sizes(context: context);

    return Scaffold(
      backgroundColor: Colors.black,
      body: SizedBox(
        width: sizes.width,
        height: sizes.height,
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: sizes.width,
              height: sizes.height,
              child: Opacity(
                opacity: .09,
                child: Image.asset('assets/images/reel.gif', fit: BoxFit.cover),
              ),
            ),
            Positioned(
              top: 0,
              left: sizes.width * .055,
              child: SizedBox(
                height: sizes.appBarHeight * 2,
                width: sizes.appBarHeight * 3,
                child: Image.asset("assets/images/mmgsll (trbg).png"),
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              spacing: sizes.appBarHeight,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 11,
                  children: [
                    LiquidGlass(
                      clipBehavior: Clip.antiAlias,
                      shape: const LiquidRoundedSuperellipse(
                        borderRadius: Radius.circular(1000),
                      ),
                      settings: LiquidGlassSettings(
                        thickness: 50,
                        glassColor: const Color(0x11FFFFFF),
                        lightIntensity: 3,
                        blend: 40,
                        ambientStrength: .0,
                        lightAngle: math.pi / 7,
                        chromaticAberration: 0,
                        refractiveIndex: 1.9,
                      ),
                      child: SizedBox(
                        height: sizes.appBarHeight * 4,
                        width: sizes.appBarHeight * 4,child: Glassify(
                          settings: LiquidGlassSettings(
                            thickness: 70,
                            glassColor: const Color(0x00FFFFFF),
                            lightIntensity: 3,
                            blend: 50,
                            ambientStrength: .35,
                            lightAngle: math.pi / 7,
                            chromaticAberration: 0,
                            refractiveIndex: 1.5,
                          ),
                          child: Icon(Icons.attach_money_rounded, size: 105, color: Colors.white54,)),

                      ),
                    ),
                    Glassify(
                      settings: const LiquidGlassSettings(
                          thickness: 5,
                          glassColor: Color(0x23FFFFFF),
                          lightIntensity: 0,
                          refractiveIndex: 1.2
                      ),
                      child: Text(
                        "Money Receipt",
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 25,
                          // color: Colors.white54,
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 11,
                  children: [
                    GestureDetector(
                      onTap: () => Get.offNamed(Routes.COMPANY_PAGE),
                      child: LiquidGlass(
                        clipBehavior: Clip.antiAlias,
                        shape: const LiquidRoundedSuperellipse(
                          borderRadius: Radius.circular(1000),
                        ),
                        settings: LiquidGlassSettings(
                          thickness: 50,
                          glassColor: const Color(0x11FFFFFF),
                          lightIntensity: 3,
                          blend: 40,
                          ambientStrength: .0,
                          lightAngle: math.pi / 7,
                          chromaticAberration: 0,
                          refractiveIndex: 1.9,
                        ),
                        child: SizedBox(
                          height: sizes.appBarHeight * 4,
                          width: sizes.appBarHeight * 4,child: Glassify(
                            settings: LiquidGlassSettings(
                              thickness: 70,
                              glassColor: const Color(0x00FFFFFF),
                              lightIntensity: 3,
                              blend: 50,
                              ambientStrength: .35,
                              lightAngle: math.pi / 7,
                              chromaticAberration: 0,
                              refractiveIndex: 1.5,
                            ),
                            child: Icon(CupertinoIcons.arrow_down_square, size: 105, color: Colors.white54,)),
                      
                        ),
                      ),
                    ),

                    Glassify(
                      settings: const LiquidGlassSettings(
                          thickness: 5,
                          glassColor: Color(0x23FFFFFF),
                          lightIntensity: 0,
                          refractiveIndex: 1.2
                      ),
                      child: Text(
                        "Import BL",
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 25,
                          // color: Colors.white54,
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 11,
                  children: [
                    LiquidGlass(
                      clipBehavior: Clip.antiAlias,
                      shape: const LiquidRoundedSuperellipse(
                        borderRadius: Radius.circular(1000),
                      ),
                      settings: LiquidGlassSettings(
                        thickness: 50,
                        glassColor: const Color(0x11FFFFFF),
                        lightIntensity: 3,
                        blend: 40,
                        ambientStrength: .0,
                        lightAngle: math.pi / 7,
                        chromaticAberration: 0,
                        refractiveIndex: 1.9,
                      ),
                      child: SizedBox(
                        height: sizes.appBarHeight * 4,
                        width: sizes.appBarHeight * 4,child: Glassify(
                          settings: LiquidGlassSettings(
                            thickness: 70,
                            glassColor: const Color(0x00FFFFFF),
                            lightIntensity: 3,
                            blend: 50,
                            ambientStrength: .35,
                            lightAngle: math.pi / 7,
                            chromaticAberration: 0,
                            refractiveIndex: 1.5,
                          ),
                          child: Icon(Icons.airplanemode_active, size: 105, color: Colors.white54,)),

                      ),
                    ),

                    Glassify(
                      settings: const LiquidGlassSettings(
                          thickness: 5,
                          glassColor: Color(0x23FFFFFF),
                          lightIntensity: 0,
                          refractiveIndex: 1.2
                      ),
                      child: Text(
                        "Forwarding BL",
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 25,
                          // color: Colors.white54,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );

  }

}