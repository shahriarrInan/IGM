import 'package:igm/pages/company_list/controllers/company_pagel_controller.dart';
import 'package:igm/routes/app_routes.dart';
import 'package:igm/utils/dimensions/sizes.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';
import 'package:refreshed/refreshed.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class CompanyPage extends GetView<CompanyListController> {
  const CompanyPage({super.key});

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
                opacity: .07,
                child: Image.asset('assets/images/reel.gif', fit: BoxFit.cover),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 17,
              children: [
                Glassify(
                  settings: const LiquidGlassSettings(
                    thickness: 5,
                    glassColor: Color(0x23FFFFFF),
                    lightIntensity: 0,
                    refractiveIndex: 1.2
                  ),
                  child: Text(
                    "Company List",
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 55,
                      // color: Colors.white54,
                    ),
                  ),
                ),
                LiquidGlass(
                  clipBehavior: Clip.antiAlias,
                  shape: const LiquidRoundedSuperellipse(
                    borderRadius: Radius.circular(100),
                  ),
                  settings: LiquidGlassSettings(
                    thickness: 40,
                    glassColor: const Color(0x09FFFFFF),
                    lightIntensity: 3,
                    blend: 40,
                    ambientStrength: .35,
                    lightAngle: math.pi / 7,
                    chromaticAberration: 0,
                    refractiveIndex: 1.4,
                  ),
                  child: SizedBox(
                    // height: sizes.height * .45,
                    width: sizes.width * .59,
                    child: Column(
                      spacing: 11,
                      children: [
                        SizedBox(height: sizes.appBarHeight * 2,),
                        GestureDetector(
                          onTap: () {
                            Get.toNamed(Routes.IMPORT_BL);
                          },
                          child: Text("MMG SHIPPING LINES LTD.",
                          style: TextStyle(
                            fontWeight: FontWeight.w100,
                            color: Colors.white,
                            fontSize: 31
                          ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.toNamed(Routes.IMPORT_BL);
                          },
                          child: Text("MMG SEAWAYS LTD.",
                          style: TextStyle(
                            fontWeight: FontWeight.w100,
                            color: Colors.white,
                            fontSize: 31
                          ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.offAndToNamed(Routes.IMPORT_BL);
                          },
                          child: Text("MM SEAWAYS LTD.",
                          style: TextStyle(
                            fontWeight: FontWeight.w100,
                            color: Colors.white,
                            fontSize: 31
                          ),
                          ),
                        ),
                        SizedBox(height: sizes.appBarHeight * 2,),
                      ],
                    ),
                  ),
                )
              ],
            ),
            Positioned(
              top: 0,
              left: sizes.width * .055,
              child: SizedBox(
                height: sizes.appBarHeight * 2,
                width: sizes.appBarHeight * 3,
                child: Image.asset("assets/images/mmgsll_w.png"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
