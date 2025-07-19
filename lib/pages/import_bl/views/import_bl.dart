import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:igm/pages/import_bl/controllers/import_bl_controller.dart';
import 'package:igm/processors/xml_processor/import_bl_xml_generation.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';
import 'package:refreshed/refreshed.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import '../../../routes/app_routes.dart';
import '../../../utils/dimensions/sizes.dart';

class ImportBL extends GetView<ImportBLController> {
  const ImportBL({super.key});

  @override
  Widget build(BuildContext context) {
    Sizes sizes = Sizes(context: context);

    dynamic getDataOffOfTECs(RxList<TextEditingController> tecs) {
      List<RxString> tecVals = [];

      for (var t in tecs) {
        tecVals.add(t.value.text.obs);
      }

      return tecVals;
    }

    List<List<RxString>> getDataOffOf2DTECs(
      List<List<TextEditingController>> tecs,
    ) {
      List<List<RxString>> tecVals = [];

      for (var rowOfControllers in tecs) {
        List<RxString> vals = [];

        for (var v in rowOfControllers) {
          vals.add(v.text.obs);
        }

        tecVals.add(vals);
      }

      return tecVals;
    }

    // This creates the header widgets. It's built once and reused.
    final List<DataColumn> columns = List<DataColumn>.generate(
      controller.vesselTableHeadings.length,
      (index) => DataColumn(
        label: Container(
          height: sizes.appBarHeight,
          width:
              sizes.calculateTextWidth(
                controller.vesselTableHeadings[index],
                const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ) *
              2,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(11)),
          child: Align(
            alignment: Alignment.center,
            child: Text(
              controller.vesselTableHeadings[index],
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 17,
              ),
            ),
          ),
        ),
      ),
    );

    final List<DataColumn> columnsForContainerTable = List<DataColumn>.generate(
      controller.containerTableHeadings.length,
      (index) => DataColumn(
        label: Container(
          height: sizes.appBarHeight,
          width:
              sizes.calculateTextWidth(
                controller.containerTableHeadings[index],
                const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ) *
              2,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(11)),
          child: Align(
            alignment: Alignment.center,
            child: Text(
              controller.containerTableHeadings[index],
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 17,
              ),
            ),
          ),
        ),
      ),
    );

    return Obx(
      () => Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          alignment: Alignment.center,
          children: [
            // Background GIF
            SizedBox(
              width: sizes.width,
              height: sizes.height,
              child: Opacity(
                opacity: .09,
                child: Image.asset('assets/images/reel.gif', fit: BoxFit.cover),
              ),
            ),
            // Main Content Container
            Positioned(
              top: sizes.appBarHeight * 2,
              left: sizes.width * .055,
              child: SizedBox(
                width: sizes.width * .89,
                height: sizes.height - sizes.appBarHeight * 2,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 755),
                  opacity: controller.shouldShowBottomSheet.value ? 0.05 : 1,
                  curve: Curves.linearToEaseOut,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 21,
                      children: [
                        Text(
                          "   Vessel Information",
                          style: TextStyle(
                            color: Colors.white54,
                            fontWeight: FontWeight.w100,
                            height: 0,
                            fontSize: 31,
                          ),
                        ),
                        LiquidGlass(
                          clipBehavior: Clip.antiAlias,
                          shape: const LiquidRoundedSuperellipse(
                            borderRadius: Radius.circular(100),
                          ),
                          settings: LiquidGlassSettings(
                            thickness: 50,
                            glassColor: const Color(0x09FFFFFF),
                            lightIntensity: 3,
                            blend: 40,
                            ambientStrength: .35,
                            lightAngle: math.pi / 7,
                            chromaticAberration: 0,
                            refractiveIndex: 1.07,
                          ),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 755),
                            curve: Curves.linearToEaseOut,
                            // Using controller.rowCount to dynamically calculate height
                            height:
                                sizes.appBarHeight * 1.1 +
                                sizes.appBarHeight *
                                    .85 *
                                    (controller.rowCount + 1) +
                                62 +
                                0 +
                                sizes.appBarHeight +
                                11 *
                                    (controller.rowCount > 0
                                        ? controller.rowCount - 1
                                        : 0),
                            width: sizes.width * .89,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 31.0,
                                  right: 31.0,
                                  top: 31.0,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // The Header Row of the DataTable
                                    DataTable(
                                      columnSpacing: 11.0,
                                      columns: columns,
                                      headingRowHeight:
                                          sizes.appBarHeight * 1.1,
                                      rows: const [],
                                      dividerThickness: 0.000001,
                                    ),
                                    // The Scrollable Body of the DataTable
                                    Flexible(
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.vertical,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // The Main Data Table with TextFields
                                            DataTable(
                                              dataRowHeight: sizes.appBarHeight,
                                              columns: columns,
                                              headingRowHeight: 0.0,
                                              // Generates rows based on the number of controllers we have
                                              rows: List.generate(controller.rowCount, (
                                                rowIndex,
                                              ) {
                                                return DataRow(
                                                  // Generates cells by iterating through the headings list
                                                  cells: controller.vesselTableHeadings.map((
                                                    heading,
                                                  ) {
                                                    return DataCell(
                                                      Container(
                                                        width:
                                                            sizes.calculateTextWidth(
                                                              heading,
                                                              const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                              ),
                                                            ) *
                                                            2,
                                                        height:
                                                            sizes.appBarHeight *
                                                            .77,
                                                        padding:
                                                            const EdgeInsets.symmetric(
                                                              horizontal: 8.0,
                                                            ),
                                                        decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                15,
                                                              ),
                                                          color:
                                                              controller
                                                                  .empties
                                                                  .value
                                                                  .where(
                                                                    (
                                                                      test,
                                                                    ) => test
                                                                        .values
                                                                        .contains(
                                                                          "$heading-$rowIndex",
                                                                        ),
                                                                  )
                                                                  .isNotEmpty
                                                              ? Colors.redAccent
                                                              : Colors.white
                                                                    .withAlpha(
                                                                      31,
                                                                    ),
                                                        ),
                                                        child: Center(
                                                          child: TextField(
                                                            cursorColor:
                                                                Colors.white,
                                                            // Gets the right controller using the helper method
                                                            controller: controller
                                                                .getControllerForCell(
                                                                  heading,
                                                                  rowIndex,
                                                                ),
                                                            textAlignVertical:
                                                                TextAlignVertical
                                                                    .center,
                                                            style:
                                                                const TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                ),
                                                            decoration:
                                                                const InputDecoration(
                                                                  border:
                                                                      InputBorder
                                                                          .none,
                                                                  isDense: true,
                                                                ),
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  }).toList(),
                                                );
                                              }),
                                              columnSpacing: 11,
                                              dividerThickness: 0.000001,
                                            ),
                                            // The "Add Row" Button
                                            GestureDetector(
                                              // Logic to limit rows to 5
                                              onTap: controller.rowCount >= 5
                                                  ? () {}
                                                  : () => controller.addRow(),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 21.0,
                                                      vertical: 11.0,
                                                    ),
                                                child: LiquidGlass(
                                                  clipBehavior: Clip.antiAlias,
                                                  shape:
                                                      const LiquidRoundedSuperellipse(
                                                        borderRadius:
                                                            Radius.circular(
                                                              100,
                                                            ),
                                                      ),
                                                  settings: LiquidGlassSettings(
                                                    thickness: 20,
                                                    glassColor: const Color(
                                                      0x11FFFFFF,
                                                    ),
                                                    lightIntensity: .5,
                                                    blend: 100,
                                                    ambientStrength: .0,
                                                    lightAngle: math.pi / 3,
                                                    chromaticAberration: 0,
                                                    refractiveIndex: 1.1,
                                                  ),
                                                  child: SizedBox(
                                                    height: sizes.appBarHeight,
                                                    child: Center(
                                                      child: Text(
                                                        "       add row      ",
                                                        style: TextStyle(
                                                          color:
                                                              controller
                                                                      .rowCount >=
                                                                  5
                                                              ? Colors.white30
                                                              : Colors.white,
                                                          fontWeight:
                                                              FontWeight.w900,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            // Bottom padding that scrolls away
                                            const SizedBox(height: 31.0),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: sizes.width * .89,
                          child: Center(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                spacing: 17,
                                children: [
                                  LiquidGlass(
                                    clipBehavior: Clip.antiAlias,
                                    shape: const LiquidRoundedSuperellipse(
                                      borderRadius: Radius.circular(35),
                                    ),
                                    settings: LiquidGlassSettings(
                                      thickness: 20,
                                      glassColor: const Color(0x09FFFFFF),
                                      lightIntensity: 3,
                                      blend: 40,
                                      ambientStrength: .35,
                                      lightAngle: math.pi / 7,
                                      chromaticAberration: 0,
                                      refractiveIndex: 1.1,
                                    ),
                                    child: Container(
                                      height: sizes.appBarHeight * 1.5,
                                      width: 400,
                                      padding: EdgeInsets.symmetric(horizontal: 31),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        spacing: 11,
                                        children: [
                                          Text(
                                            "SL_NO",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(
                                              height: sizes.appBarHeight * .85,
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 11,
                                              ),
                                              decoration: BoxDecoration(
                                                color: controller
                                                    .empties
                                                    .value
                                                    .where(
                                                      (
                                                      test,
                                                      ) => test
                                                      .values
                                                      .contains(
                                                    "SL_NO-0",
                                                  ),
                                                )
                                                    .isNotEmpty
                                                    ? Colors.redAccent
                                                    : Colors.white.withAlpha(31),
                                                borderRadius: BorderRadius.circular(
                                                  17,
                                                ),
                                              ),
                                              child: Center(
                                                child: TextField(
                                                  cursorColor: Colors.white,
                                                  // Gets the right controller using the helper method
                                                  controller:
                                                      controller.sl_NoTECs[0],
                                                  textAlignVertical:
                                                      TextAlignVertical.center,
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                  decoration: const InputDecoration(
                                                    border: InputBorder.none,
                                                    isDense: true,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: sizes.appBarHeight * .85,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(17),
                                      color: Colors.white,
                                    ),
                                    child: Center(
                                      child: Text(
                                        "      Position      ",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700,
                                          height: 0,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: sizes.appBarHeight * .85,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(17),
                                      color: Colors.white,
                                    ),
                                    child: Center(
                                      child: Text(
                                        "      Feeder Vessel Info.      ",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700,
                                          height: 0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Text(
                          "   BL Information",
                          style: TextStyle(
                            color: Colors.white54,
                            fontWeight: FontWeight.w100,
                            height: 0,
                            fontSize: 31,
                          ),
                        ),
                        LiquidGlass(
                          clipBehavior: Clip.antiAlias,
                          shape: const LiquidRoundedSuperellipse(
                            borderRadius: Radius.circular(100),
                          ),
                          settings: LiquidGlassSettings(
                            thickness: 50,
                            glassColor: const Color(0x09FFFFFF),
                            lightIntensity: 3,
                            blend: 40,
                            ambientStrength: .35,
                            lightAngle: math.pi / 7,
                            chromaticAberration: 0,
                            refractiveIndex: 1.07,
                          ),
                          child: SizedBox(
                            width: sizes.width * .89,
                            // height: sizes.height * .45,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                spacing: 11,
                                children: [
                                  const SizedBox(width: 62),
                                  SizedBox(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      spacing: 11,
                                      children: [
                                        SizedBox(height: 31),
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          spacing: 11,
                                          children: [
                                            Text(
                                              "CTG/ICD",
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w900,
                                                fontSize: 17,
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () => {
                                                controller
                                                        .bottomSheetTag1
                                                        .value =
                                                    "CTG",
                                                controller
                                                        .bottomSheetTag2
                                                        .value =
                                                    "ICD",
                                                controller
                                                    .shouldShowBottomSheet
                                                    .value = !controller
                                                    .shouldShowBottomSheet
                                                    .value,
                                              },
                                              child: Container(
                                                width:
                                                    sizes.calculateTextWidth(
                                                      "Feeder Vessel",
                                                      const TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                    ) *
                                                    2,
                                                height:
                                                    sizes.appBarHeight * .77,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 11.0,
                                                    ),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  color: Colors.white.withAlpha(
                                                    31,
                                                  ),
                                                ),
                                                child: Row(
                                                  // mainAxisSize: MainAxisSize.min,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      controller
                                                              .portOfLandingTECs[controller
                                                                  .selectedBLIndex
                                                                  .value]
                                                              .value
                                                              .text
                                                              .isEmpty
                                                          ? "CTG"
                                                          : controller
                                                                .portOfLandingTECs[controller
                                                                    .selectedBLIndex
                                                                    .value]
                                                                .value
                                                                .text,
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                    ),
                                                    Icon(
                                                      CupertinoIcons
                                                          .arrowtriangle_down_fill,
                                                      color: Colors.white,
                                                      size: 17,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          spacing: 11,
                                          children: [
                                            Text(
                                              "Sl No.",
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w900,
                                                fontSize: 17,
                                              ),
                                            ),
                                            Container(
                                              width:
                                                  sizes.calculateTextWidth(
                                                    "Feeder Vessel",
                                                    const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  ) *
                                                  2,
                                              height: sizes.appBarHeight * .77,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 8.0,
                                                  ),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                color: controller
                                                    .empties
                                                    .value
                                                    .where(
                                                      (
                                                      test,
                                                      ) => test
                                                      .values
                                                      .contains(
                                                    "Sl No.-${controller.selectedBLIndex.value}",
                                                  ),
                                                )
                                                    .isNotEmpty
                                                    ? Colors.redAccent
                                                    : Colors.white.withAlpha(
                                                  31,
                                                ),
                                              ),
                                              child: Center(
                                                child: Focus(
                                                  focusNode:
                                                      controller.focusNode,
                                                  onKey:
                                                      (
                                                        FocusNode node,
                                                        RawKeyEvent event,
                                                      ) {
                                                        // We only want to act when the right arrow key is pressed down.
                                                        if (event.logicalKey ==
                                                                LogicalKeyboardKey
                                                                    .arrowRight &&
                                                            event
                                                                is RawKeyDownEvent) {
                                                          print("boom");
                                                          controller
                                                              .addRowToContainerTable();
                                                          controller
                                                              .addBlTableTECs();
                                                          controller
                                                              .selectedBLIndex
                                                              .value++;

                                                          if (controller
                                                                  .blNoTECs
                                                                  .length <
                                                              controller
                                                                  .selectedBLIndex
                                                                  .value) {
                                                            controller
                                                                .addBlTableTECs();
                                                          }

                                                          return KeyEventResult
                                                              .handled;
                                                        }

                                                        // We only want to act when the left arrow key is pressed down.
                                                        if (event.logicalKey ==
                                                                LogicalKeyboardKey
                                                                    .arrowLeft &&
                                                            event
                                                                is RawKeyDownEvent) {
                                                          print("boom");
                                                          if (controller
                                                                  .selectedBLIndex
                                                                  .value >
                                                              0) {
                                                            controller
                                                                .selectedBLIndex
                                                                .value--;
                                                          }

                                                          return KeyEventResult
                                                              .handled;
                                                        }

                                                        // For all other keys, let the system handle them as usual.
                                                        return KeyEventResult
                                                            .ignored;
                                                      },
                                                  child: TextField(
                                                    cursorColor: Colors.white,
                                                    // Gets the right controller using the helper method
                                                    controller:
                                                        controller
                                                            .slNoTECs[controller
                                                            .selectedBLIndex
                                                            .value],
                                                    textAlignVertical:
                                                        TextAlignVertical
                                                            .center,
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                    decoration:
                                                        const InputDecoration(
                                                          border:
                                                              InputBorder.none,
                                                          isDense: true,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          spacing: 11,
                                          children: [
                                            Text(
                                              "Line No.",
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w900,
                                                fontSize: 17,
                                              ),
                                            ),
                                            Container(
                                              width:
                                                  sizes.calculateTextWidth(
                                                    "Feeder Vessel",
                                                    const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  ) *
                                                  2,
                                              height: sizes.appBarHeight * .77,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 8.0,
                                                  ),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                color: controller
                                                    .empties
                                                    .value
                                                    .where(
                                                      (
                                                      test,
                                                      ) => test
                                                      .values
                                                      .contains(
                                                    "Line No.-${controller.selectedBLIndex.value}",
                                                  ),
                                                )
                                                    .isNotEmpty
                                                    ? Colors.redAccent
                                                    : Colors.white.withAlpha(
                                                  31,
                                                ),
                                              ),
                                              child: Center(
                                                child: TextField(
                                                  cursorColor: Colors.white,
                                                  // Gets the right controller using the helper method
                                                  controller:
                                                      controller
                                                          .blLineNoTECs[controller
                                                          .selectedBLIndex
                                                          .value],
                                                  textAlignVertical:
                                                      TextAlignVertical.center,
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                  decoration:
                                                      const InputDecoration(
                                                        border:
                                                            InputBorder.none,
                                                        isDense: true,
                                                      ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          spacing: 11,
                                          children: [
                                            Text(
                                              "Bl No.",
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w900,
                                                fontSize: 17,
                                              ),
                                            ),
                                            Container(
                                              width:
                                                  sizes.calculateTextWidth(
                                                    "Feeder Vessel",
                                                    const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  ) *
                                                  2,
                                              height: sizes.appBarHeight * .77,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 8.0,
                                                  ),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                color: controller
                                                    .empties
                                                    .value
                                                    .where(
                                                      (
                                                      test,
                                                      ) => test
                                                      .values
                                                      .contains(
                                                    "Bl No.-${controller.selectedBLIndex.value}",
                                                  ),
                                                )
                                                    .isNotEmpty
                                                    ? Colors.redAccent
                                                    : Colors.white.withAlpha(
                                                  31,
                                                ),
                                              ),
                                              child: Center(
                                                child: TextField(
                                                  cursorColor: Colors.white,
                                                  // Gets the right controller using the helper method
                                                  controller:
                                                      controller
                                                          .blNoTECs[controller
                                                          .selectedBLIndex
                                                          .value],
                                                  textAlignVertical:
                                                      TextAlignVertical.center,
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                  decoration:
                                                      const InputDecoration(
                                                        border:
                                                            InputBorder.none,
                                                        isDense: true,
                                                      ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          spacing: 11,
                                          children: [
                                            Text(
                                              "Fcl/Qty",
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w900,
                                                fontSize: 17,
                                              ),
                                            ),
                                            SizedBox(
                                              width:
                                                  sizes.calculateTextWidth(
                                                    "Feeder Vessel",
                                                    const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  ) *
                                                  2,
                                              height: sizes.appBarHeight * .77,
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                spacing: 11,
                                                children: [
                                                  Container(
                                                    width:
                                                        sizes.calculateTextWidth(
                                                              "Feeder Vessel",
                                                              const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                              ),
                                                            ) *
                                                            2 *
                                                            .6 -
                                                        5.5,
                                                    height:
                                                        sizes.appBarHeight *
                                                        .77,
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 8.0,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            15,
                                                          ),
                                                      color: controller
                                                          .empties
                                                          .value
                                                          .where(
                                                            (
                                                            test,
                                                            ) => test
                                                            .values
                                                            .contains(
                                                          "Fcl-${controller.selectedBLIndex.value}",
                                                        ),
                                                      )
                                                          .isNotEmpty
                                                          ? Colors.redAccent
                                                          : Colors.white
                                                          .withAlpha(31),
                                                    ),
                                                    child: Center(
                                                      child: TextField(
                                                        cursorColor:
                                                            Colors.white,
                                                        // Gets the right controller using the helper method
                                                        controller:
                                                            controller
                                                                .fclTECs[controller
                                                                .selectedBLIndex
                                                                .value],
                                                        textAlignVertical:
                                                            TextAlignVertical
                                                                .center,
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                        ),
                                                        decoration:
                                                            const InputDecoration(
                                                              border:
                                                                  InputBorder
                                                                      .none,
                                                              isDense: true,
                                                            ),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    width:
                                                        sizes.calculateTextWidth(
                                                              "Feeder Vessel",
                                                              const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                              ),
                                                            ) *
                                                            2 *
                                                            .4 -
                                                        5.5,
                                                    height:
                                                        sizes.appBarHeight *
                                                        .77,
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 8.0,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            15,
                                                          ),
                                                      color: controller
                                                          .empties
                                                          .value
                                                          .where(
                                                            (
                                                            test,
                                                            ) => test
                                                            .values
                                                            .contains(
                                                          "Fcl/Qty-${controller.selectedBLIndex.value}",
                                                        ),
                                                      )
                                                          .isNotEmpty
                                                          ? Colors.redAccent
                                                          : Colors.white
                                                          .withAlpha(31),
                                                    ),
                                                    child: Center(
                                                      child: TextField(
                                                        cursorColor:
                                                            Colors.white,
                                                        // Gets the right controller using the helper method
                                                        controller:
                                                            controller
                                                                .fclQtyTECs[controller
                                                                .selectedBLIndex
                                                                .value],
                                                        textAlignVertical:
                                                            TextAlignVertical
                                                                .center,
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                        ),
                                                        decoration:
                                                            const InputDecoration(
                                                              border:
                                                                  InputBorder
                                                                      .none,
                                                              isDense: true,
                                                            ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          spacing: 11,
                                          children: [
                                            Text(
                                              "Lcl/Consl.",
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w900,
                                                fontSize: 17,
                                              ),
                                            ),

                                            Row(
                                              mainAxisSize: MainAxisSize.min,
                                              spacing: 11,
                                              children: [
                                                Container(
                                                  width:
                                                      sizes.calculateTextWidth(
                                                            "Feeder Vessel",
                                                            const TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                            ),
                                                          ) *
                                                          2 *
                                                          .6 -
                                                      5.5,
                                                  height:
                                                      sizes.appBarHeight * .77,
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 8.0,
                                                      ),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          15,
                                                        ),
                                                    color: controller
                                                        .empties
                                                        .value
                                                        .where(
                                                          (
                                                          test,
                                                          ) => test
                                                          .values
                                                          .contains(
                                                        "Lcl-${controller.selectedBLIndex.value}",
                                                      ),
                                                    )
                                                        .isNotEmpty
                                                        ? Colors.redAccent
                                                        : Colors.white
                                                        .withAlpha(31),
                                                  ),
                                                  child: Center(
                                                    child: TextField(
                                                      cursorColor: Colors.white,
                                                      // Gets the right controller using the helper method
                                                      controller:
                                                          controller
                                                              .lclTECs[controller
                                                              .selectedBLIndex
                                                              .value],
                                                      textAlignVertical:
                                                          TextAlignVertical
                                                              .center,
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                      decoration:
                                                          const InputDecoration(
                                                            border: InputBorder
                                                                .none,
                                                            isDense: true,
                                                          ),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  width:
                                                      sizes.calculateTextWidth(
                                                            "Feeder Vessel",
                                                            const TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                            ),
                                                          ) *
                                                          2 *
                                                          .4 -
                                                      5.5,
                                                  height:
                                                      sizes.appBarHeight * .77,
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 8.0,
                                                      ),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          15,
                                                        ),
                                                    color: controller
                                                        .empties
                                                        .value
                                                        .where(
                                                          (
                                                          test,
                                                          ) => test
                                                          .values
                                                          .contains(
                                                        "Lcl/Consl.-${controller.selectedBLIndex.value}",
                                                      ),
                                                    )
                                                        .isNotEmpty
                                                        ? Colors.redAccent
                                                        : Colors.white
                                                        .withAlpha(31),
                                                  ),
                                                  child: Center(
                                                    child: TextField(
                                                      cursorColor: Colors.white,
                                                      // Gets the right controller using the helper method
                                                      controller:
                                                          controller
                                                              .lclConsolidatedTECs[controller
                                                              .selectedBLIndex
                                                              .value],
                                                      textAlignVertical:
                                                          TextAlignVertical
                                                              .center,
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                      decoration:
                                                          const InputDecoration(
                                                            border: InputBorder
                                                                .none,
                                                            isDense: true,
                                                          ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 31),
                                      ],
                                    ),
                                  ),

                                  SizedBox(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      spacing: 11,
                                      children: [
                                        SizedBox(height: 31),
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          spacing: 11,
                                          children: [
                                            Text(
                                              "Consig. Code",
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w900,
                                                fontSize: 17,
                                              ),
                                            ),
                                            Container(
                                              width:
                                                  sizes.calculateTextWidth(
                                                    "Feeder Vessel",
                                                    const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  ) *
                                                  2,
                                              height: sizes.appBarHeight * .77,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 8.0,
                                                  ),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                color:
                                                controller
                                                    .empties
                                                    .value
                                                    .where(
                                                      (
                                                      test,
                                                      ) => test
                                                      .values
                                                      .contains(
                                                    "Consig. Code-${controller.selectedBLIndex.value}",
                                                  ),
                                                )
                                                    .isNotEmpty
                                                    ? Colors.redAccent
                                                    : Colors.white.withAlpha(
                                                  31,
                                                ),
                                              ),
                                              child: Center(
                                                child: TextField(
                                                  cursorColor: Colors.white,
                                                  // Gets the right controller using the helper method
                                                  controller:
                                                      controller
                                                          .consigneeCodeTECs[controller
                                                          .selectedBLIndex
                                                          .value],
                                                  textAlignVertical:
                                                      TextAlignVertical.center,
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                  decoration:
                                                      const InputDecoration(
                                                        border:
                                                            InputBorder.none,
                                                        isDense: true,
                                                      ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          spacing: 11,
                                          children: [
                                            Text(
                                              "Consignee",
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w900,
                                                fontSize: 17,
                                              ),
                                            ),
                                            Container(
                                              width:
                                                  sizes.calculateTextWidth(
                                                    "Feeder Vessel",
                                                    const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  ) *
                                                  2,
                                              height: sizes.appBarHeight * .77,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 8.0,
                                                  ),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                color:
                                                controller
                                                    .empties
                                                    .value
                                                    .where(
                                                      (
                                                      test,
                                                      ) => test
                                                      .values
                                                      .contains(
                                                    "Consignee-${controller.selectedBLIndex.value}",
                                                  ),
                                                )
                                                    .isNotEmpty
                                                    ? Colors.redAccent
                                                    : Colors.white.withAlpha(
                                                  31,
                                                ),
                                              ),
                                              child: Center(
                                                child: TextField(
                                                  cursorColor: Colors.white,
                                                  // Gets the right controller using the helper method
                                                  controller:
                                                      controller
                                                          .consigneeTECs[controller
                                                          .selectedBLIndex
                                                          .value],
                                                  textAlignVertical:
                                                      TextAlignVertical.center,
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                  decoration:
                                                      const InputDecoration(
                                                        border:
                                                            InputBorder.none,
                                                        isDense: true,
                                                      ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          spacing: 11,
                                          children: [
                                            Text(
                                              "Con. Address",
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w900,
                                                fontSize: 17,
                                              ),
                                            ),
                                            Container(
                                              width:
                                                  sizes.calculateTextWidth(
                                                    "Feeder Vessel",
                                                    const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  ) *
                                                  2,
                                              height: sizes.appBarHeight * .77,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 8.0,
                                                  ),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                color:
                                                controller
                                                    .empties
                                                    .value
                                                    .where(
                                                      (
                                                      test,
                                                      ) => test
                                                      .values
                                                      .contains(
                                                    "Con. Address-${controller.selectedBLIndex.value}",
                                                  ),
                                                )
                                                    .isNotEmpty
                                                    ? Colors.redAccent
                                                    : Colors.white.withAlpha(
                                                  31,
                                                ),
                                              ),
                                              child: Center(
                                                child: TextField(
                                                  cursorColor: Colors.white,
                                                  // Gets the right controller using the helper method
                                                  controller:
                                                      controller
                                                          .consigneeAddressTECs[controller
                                                          .selectedBLIndex
                                                          .value],
                                                  textAlignVertical:
                                                      TextAlignVertical.center,
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                  decoration:
                                                      const InputDecoration(
                                                        border:
                                                            InputBorder.none,
                                                        isDense: true,
                                                      ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          spacing: 11,
                                          children: [
                                            Text(
                                              "Exporter",
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w900,
                                                fontSize: 17,
                                              ),
                                            ),
                                            Container(
                                              width:
                                                  sizes.calculateTextWidth(
                                                    "Feeder Vessel",
                                                    const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  ) *
                                                  2,
                                              height:
                                                  sizes.appBarHeight * .77 * 3 +
                                                  22,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 8.0,
                                                  ),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                color:
                                                controller
                                                    .empties
                                                    .value
                                                    .where(
                                                      (
                                                      test,
                                                      ) => test
                                                      .values
                                                      .contains(
                                                    "Exporter-${controller.selectedBLIndex.value}",
                                                  ),
                                                )
                                                    .isNotEmpty
                                                    ? Colors.redAccent
                                                    : Colors.white.withAlpha(
                                                  31,
                                                ),
                                              ),
                                              child: Center(
                                                child: TextField(
                                                  cursorColor: Colors.white,
                                                  // Gets the right controller using the helper method
                                                  controller:
                                                      controller
                                                          .exporterTECs[controller
                                                          .selectedBLIndex
                                                          .value],
                                                  textAlignVertical:
                                                      TextAlignVertical.center,
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                  decoration:
                                                      const InputDecoration(
                                                        border:
                                                            InputBorder.none,
                                                        isDense: true,
                                                      ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 31),
                                      ],
                                    ),
                                  ),

                                  SizedBox(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      spacing: 0,
                                      children: [
                                        SizedBox(height: 31),
                                        SizedBox(
                                          height: sizes.appBarHeight * .85,
                                          child: Center(
                                            child: Text(
                                              "Remarks",
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w900,
                                                fontSize: 17,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width:
                                              sizes.calculateTextWidth(
                                                "Feeder Vessel",
                                                const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ) *
                                              2,
                                          height:
                                              sizes.appBarHeight * .77 * 5 + 55,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0,
                                          ),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              15,
                                            ),
                                            color:
                                            controller
                                                .empties
                                                .value
                                                .where(
                                                  (
                                                  test,
                                                  ) => test
                                                  .values
                                                  .contains(
                                                "BL Remarks-${controller.selectedBLIndex.value}",
                                              ),
                                            )
                                                .isNotEmpty
                                                ? Colors.redAccent
                                                : Colors.white.withAlpha(31),
                                          ),
                                          child: Center(
                                            child: TextField(
                                              cursorColor: Colors.white,
                                              // Gets the right controller using the helper method
                                              controller:
                                                  controller
                                                      .blRemarksTECs[controller
                                                      .selectedBLIndex
                                                      .value],
                                              textAlignVertical:
                                                  TextAlignVertical.center,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w700,
                                              ),
                                              decoration: const InputDecoration(
                                                border: InputBorder.none,
                                                isDense: true,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 31),
                                      ],
                                    ),
                                  ),

                                  SizedBox(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      spacing: 11,
                                      children: [
                                        SizedBox(height: 31),
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          spacing: 11,
                                          children: [
                                            Text(
                                              "Notify Code",
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w900,
                                                fontSize: 17,
                                              ),
                                            ),
                                            Container(
                                              width:
                                                  sizes.calculateTextWidth(
                                                    "Feeder Vessel",
                                                    const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  ) *
                                                  2,
                                              height: sizes.appBarHeight * .77,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 8.0,
                                                  ),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                color:
                                                controller
                                                    .empties
                                                    .value
                                                    .where(
                                                      (
                                                      test,
                                                      ) => test
                                                      .values
                                                      .contains(
                                                    "Notify Code-${controller.selectedBLIndex.value}",
                                                  ),
                                                )
                                                    .isNotEmpty
                                                    ? Colors.redAccent
                                                    : Colors.white.withAlpha(
                                                  31,
                                                ),
                                              ),
                                              child: Center(
                                                child: TextField(
                                                  cursorColor: Colors.white,
                                                  // Gets the right controller using the helper method
                                                  controller:
                                                      controller
                                                          .notifyCodeTECs[controller
                                                          .selectedBLIndex
                                                          .value],
                                                  textAlignVertical:
                                                      TextAlignVertical.center,
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                  decoration:
                                                      const InputDecoration(
                                                        border:
                                                            InputBorder.none,
                                                        isDense: true,
                                                      ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          spacing: 11,
                                          children: [
                                            Text(
                                              "Notify Party",
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w900,
                                                fontSize: 17,
                                              ),
                                            ),
                                            Container(
                                              width:
                                                  sizes.calculateTextWidth(
                                                    "Feeder Vessel",
                                                    const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  ) *
                                                  2,
                                              height: sizes.appBarHeight * .77,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 8.0,
                                                  ),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                color:
                                                controller
                                                    .empties
                                                    .value
                                                    .where(
                                                      (
                                                      test,
                                                      ) => test
                                                      .values
                                                      .contains(
                                                    "Notify Party-${controller.selectedBLIndex.value}",
                                                  ),
                                                )
                                                    .isNotEmpty
                                                    ? Colors.redAccent
                                                    : Colors.white.withAlpha(
                                                  31,
                                                ),
                                              ),
                                              child: Center(
                                                child: TextField(
                                                  cursorColor: Colors.white,
                                                  // Gets the right controller using the helper method
                                                  controller:
                                                      controller
                                                          .notifyPartyTECs[controller
                                                          .selectedBLIndex
                                                          .value],
                                                  textAlignVertical:
                                                      TextAlignVertical.center,
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                  decoration:
                                                      const InputDecoration(
                                                        border:
                                                            InputBorder.none,
                                                        isDense: true,
                                                      ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          spacing: 11,
                                          children: [
                                            Text(
                                              "Notify Address",
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w900,
                                                fontSize: 17,
                                              ),
                                            ),
                                            Container(
                                              width:
                                                  sizes.calculateTextWidth(
                                                    "Feeder Vessel",
                                                    const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  ) *
                                                  2,
                                              height: sizes.appBarHeight * .77,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 8.0,
                                                  ),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                color:
                                                controller
                                                    .empties
                                                    .value
                                                    .where(
                                                      (
                                                      test,
                                                      ) => test
                                                      .values
                                                      .contains(
                                                    "Notify Address-${controller.selectedBLIndex.value}",
                                                  ),
                                                )
                                                    .isNotEmpty
                                                    ? Colors.redAccent
                                                    : Colors.white.withAlpha(
                                                  31,
                                                ),
                                              ),
                                              child: Center(
                                                child: TextField(
                                                  cursorColor: Colors.white,
                                                  // Gets the right controller using the helper method
                                                  controller:
                                                      controller
                                                          .notifyAddressTECs[controller
                                                          .selectedBLIndex
                                                          .value],
                                                  textAlignVertical:
                                                      TextAlignVertical.center,
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                  decoration:
                                                      const InputDecoration(
                                                        border:
                                                            InputBorder.none,
                                                        isDense: true,
                                                      ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          spacing: 11,
                                          children: [
                                            Text(
                                              "Exporter Add.",
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w900,
                                                fontSize: 17,
                                              ),
                                            ),
                                            Container(
                                              width:
                                                  sizes.calculateTextWidth(
                                                    "Feeder Vessel",
                                                    const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  ) *
                                                  2,
                                              height:
                                                  sizes.appBarHeight * .77 * 3 +
                                                  22,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 8.0,
                                                  ),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                color:
                                                controller
                                                    .empties
                                                    .value
                                                    .where(
                                                      (
                                                      test,
                                                      ) => test
                                                      .values
                                                      .contains(
                                                    "Exporter Add.-${controller.selectedBLIndex.value}",
                                                  ),
                                                )
                                                    .isNotEmpty
                                                    ? Colors.redAccent
                                                    : Colors.white.withAlpha(
                                                  31,
                                                ),
                                              ),
                                              child: Center(
                                                child: TextField(
                                                  cursorColor: Colors.white,
                                                  // Gets the right controller using the helper method
                                                  controller:
                                                      controller
                                                          .exporterAddressTECs[controller
                                                          .selectedBLIndex
                                                          .value],
                                                  textAlignVertical:
                                                      TextAlignVertical.center,
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                  decoration:
                                                      const InputDecoration(
                                                        border:
                                                            InputBorder.none,
                                                        isDense: true,
                                                      ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 31),
                                      ],
                                    ),
                                  ),

                                  SizedBox(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      spacing: 11,
                                      children: [
                                        SizedBox(height: 31),
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          spacing: 11,
                                          children: [
                                            Text(
                                              "Place Unload",
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w900,
                                                fontSize: 17,
                                              ),
                                            ),
                                            Container(
                                              width:
                                                  sizes.calculateTextWidth(
                                                    "Feeder Vessel",
                                                    const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  ) *
                                                  2,
                                              height: sizes.appBarHeight * .77,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 8.0,
                                                  ),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                color:
                                                controller
                                                    .empties
                                                    .value
                                                    .where(
                                                      (
                                                      test,
                                                      ) => test
                                                      .values
                                                      .contains(
                                                    "Place Unload-${controller.selectedBLIndex.value}",
                                                  ),
                                                )
                                                    .isNotEmpty
                                                    ? Colors.redAccent
                                                    : Colors.white.withAlpha(
                                                  31,
                                                ),
                                              ),
                                              child: Center(
                                                child: TextField(
                                                  cursorColor: Colors.white,
                                                  // Gets the right controller using the helper method
                                                  controller:
                                                      controller
                                                          .placeOfUnloadTECs[controller
                                                          .selectedBLIndex
                                                          .value],
                                                  textAlignVertical:
                                                      TextAlignVertical.center,
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                  decoration:
                                                      const InputDecoration(
                                                        border:
                                                            InputBorder.none,
                                                        isDense: true,
                                                      ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          spacing: 11,
                                          children: [
                                            Text(
                                              "Bl Nature",
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w900,
                                                fontSize: 17,
                                              ),
                                            ),
                                            Container(
                                              width:
                                                  sizes.calculateTextWidth(
                                                    "Feeder Vessel",
                                                    const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  ) *
                                                  2,
                                              height: sizes.appBarHeight * .77,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 8.0,
                                                  ),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                color:
                                                controller
                                                    .empties
                                                    .value
                                                    .where(
                                                      (
                                                      test,
                                                      ) => test
                                                      .values
                                                      .contains(
                                                    "Bl Nature-${controller.selectedBLIndex.value}",
                                                  ),
                                                )
                                                    .isNotEmpty
                                                    ? Colors.redAccent
                                                    : Colors.white.withAlpha(
                                                  31,
                                                ),
                                              ),
                                              child: Center(
                                                child: TextField(
                                                  cursorColor: Colors.white,
                                                  // Gets the right controller using the helper method
                                                  controller:
                                                      controller
                                                          .blNatureTECs[controller
                                                          .selectedBLIndex
                                                          .value],
                                                  textAlignVertical:
                                                      TextAlignVertical.center,
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                  decoration:
                                                      const InputDecoration(
                                                        border:
                                                            InputBorder.none,
                                                        isDense: true,
                                                      ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          spacing: 11,
                                          children: [
                                            Text(
                                              "Bl Type Code",
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w900,
                                                fontSize: 17,
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () => {
                                                controller
                                                        .bottomSheetTag1
                                                        .value =
                                                    "MSB",
                                                controller
                                                        .bottomSheetTag2
                                                        .value =
                                                    "HSB",
                                                controller
                                                    .shouldShowBottomSheet
                                                    .value = !controller
                                                    .shouldShowBottomSheet
                                                    .value,
                                              },
                                              child: Container(
                                                width:
                                                    sizes.calculateTextWidth(
                                                      "Feeder Vessel",
                                                      const TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                    ) *
                                                    2,
                                                height:
                                                    sizes.appBarHeight * .77,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 11.0,
                                                    ),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  color: Colors.white.withAlpha(
                                                    31,
                                                  ),
                                                ),
                                                child: Row(
                                                  // mainAxisSize: MainAxisSize.min,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      controller
                                                              .blTypeCodeTECs[controller
                                                                  .selectedBLIndex
                                                                  .value]
                                                              .value
                                                              .text
                                                              .isEmpty
                                                          ? "MSB"
                                                          : controller
                                                                .blTypeCodeTECs[controller
                                                                    .selectedBLIndex
                                                                    .value]
                                                                .value
                                                                .text,
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                    ),
                                                    Icon(
                                                      CupertinoIcons
                                                          .arrowtriangle_down_fill,
                                                      color: Colors.white,
                                                      size: 17,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          spacing: 11,
                                          children: [
                                            Text(
                                              "Load Port Dt.",
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w900,
                                                fontSize: 17,
                                              ),
                                            ),
                                            Container(
                                              width:
                                                  sizes.calculateTextWidth(
                                                    "Feeder Vessel",
                                                    const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  ) *
                                                  2,
                                              height:
                                                  sizes.appBarHeight * .77 * 3 +
                                                  22,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 8.0,
                                                  ),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                color:
                                                controller
                                                    .empties
                                                    .value
                                                    .where(
                                                      (
                                                      test,
                                                      ) => test
                                                      .values
                                                      .contains(
                                                    "Load Port Dt.-${controller.selectedBLIndex.value}",
                                                  ),
                                                )
                                                    .isNotEmpty
                                                    ? Colors.redAccent
                                                    : Colors.white.withAlpha(
                                                  31,
                                                ),
                                              ),
                                              child: Center(
                                                child: TextField(
                                                  cursorColor: Colors.white,
                                                  // Gets the right controller using the helper method
                                                  controller:
                                                      controller
                                                          .blLoadPortDtTECs[controller
                                                          .selectedBLIndex
                                                          .value],
                                                  textAlignVertical:
                                                      TextAlignVertical.center,
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                  decoration:
                                                      const InputDecoration(
                                                        border:
                                                            InputBorder.none,
                                                        isDense: true,
                                                      ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 31),
                                      ],
                                    ),
                                  ),

                                  SizedBox(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      spacing: 0,
                                      children: [
                                        SizedBox(height: 31),
                                        SizedBox(
                                          height: sizes.appBarHeight * .85,
                                          child: Center(
                                            child: Text(
                                              "Marks",
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w900,
                                                fontSize: 17,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width:
                                              sizes.calculateTextWidth(
                                                "Feeder Vessel",
                                                const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ) *
                                              2,
                                          height:
                                              sizes.appBarHeight * .77 * 5 + 55,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0,
                                          ),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              15,
                                            ),
                                            color:
                                            controller
                                                .empties
                                                .value
                                                .where(
                                                  (
                                                  test,
                                                  ) => test
                                                  .values
                                                  .contains(
                                                "Marks-${controller.selectedBLIndex.value}",
                                              ),
                                            )
                                                .isNotEmpty
                                                ? Colors.redAccent
                                                : Colors.white.withAlpha(31),
                                          ),
                                          child: Center(
                                            child: TextField(
                                              cursorColor: Colors.white,
                                              // Gets the right controller using the helper method
                                              controller:
                                                  controller
                                                      .marksTECs[controller
                                                      .selectedBLIndex
                                                      .value],
                                              textAlignVertical:
                                                  TextAlignVertical.center,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w700,
                                              ),
                                              decoration: const InputDecoration(
                                                border: InputBorder.none,
                                                isDense: true,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 31),
                                      ],
                                    ),
                                  ),

                                  LiquidGlass(
                                    clipBehavior: Clip.antiAlias,
                                    shape: const LiquidRoundedSuperellipse(
                                      borderRadius: Radius.circular(45),
                                    ),
                                    settings: LiquidGlassSettings(
                                      thickness: 20,
                                      glassColor: const Color(0x09FFFFFF),
                                      lightIntensity: 3,
                                      blend: 40,
                                      ambientStrength: .35,
                                      lightAngle: math.pi / 7,
                                      chromaticAberration: 0,
                                      refractiveIndex: 1.07,
                                    ),
                                    child: Container(
                                      margin: EdgeInsets.all(21),
                                      width:
                                          (sizes.calculateTextWidth(
                                                "Feeder Vessel",
                                                const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ) *
                                              4) +
                                          11 +
                                          22,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          SizedBox(height: 11),
                                          LiquidGlass(
                                            clipBehavior: Clip.antiAlias,
                                            shape:
                                                const LiquidRoundedSuperellipse(
                                                  borderRadius: Radius.circular(
                                                    13,
                                                  ),
                                                ),
                                            settings: LiquidGlassSettings(
                                              thickness: 10,
                                              glassColor: const Color(
                                                0x09FFFFFF,
                                              ),
                                              lightIntensity: 3,
                                              blend: 40,
                                              ambientStrength: .35,
                                              lightAngle: math.pi / 7,
                                              chromaticAberration: 0,
                                              refractiveIndex: 1.07,
                                            ),
                                            child: SizedBox(
                                              width:
                                                  sizes.calculateTextWidth(
                                                    "Feeder Vessel",
                                                    const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  ) *
                                                  4,
                                              height: sizes.appBarHeight * .85,
                                              child: Center(
                                                child: Text(
                                                  "Description of Goods",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w700,
                                                    height: 0,
                                                    letterSpacing: 0,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 11),
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            spacing: 11,
                                            children: [
                                              Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                spacing: 11,
                                                children: [
                                                  Text(
                                                    "Quantity",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      height: 0,
                                                      letterSpacing: 0,
                                                      fontSize: 17,
                                                    ),
                                                  ),

                                                  Container(
                                                    width:
                                                        sizes
                                                            .calculateTextWidth(
                                                              "Feeder Vessel",
                                                              const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                              ),
                                                            ) *
                                                        2,
                                                    height:
                                                        (sizes.appBarHeight *
                                                                .77 *
                                                                6 +
                                                            55) -
                                                        sizes.appBarHeight *
                                                            .85 *
                                                            3 -
                                                        11 -
                                                        42 -
                                                        11,
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 8.0,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            25,
                                                          ),
                                                      color:
                                                      controller
                                                          .empties
                                                          .value
                                                          .where(
                                                            (
                                                            test,
                                                            ) => test
                                                            .values
                                                            .contains(
                                                          "Quantity-${controller.selectedBLIndex.value}",
                                                        ),
                                                      )
                                                          .isNotEmpty
                                                          ? Colors.redAccent
                                                          : Colors.white
                                                          .withAlpha(31),
                                                    ),
                                                    child: Center(
                                                      child: TextField(
                                                        cursorColor:
                                                            Colors.white,
                                                        // Gets the right controller using the helper method
                                                        // controller: controller.getControllerForCell(heading, rowIndex),
                                                        textAlignVertical:
                                                            TextAlignVertical
                                                                .center,
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                        ),
                                                        decoration:
                                                            const InputDecoration(
                                                              border:
                                                                  InputBorder
                                                                      .none,
                                                              isDense: true,
                                                            ),
                                                      ),
                                                    ),
                                                  ),

                                                  Container(
                                                    width:
                                                        sizes
                                                            .calculateTextWidth(
                                                              "Feeder Vessel",
                                                              const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                              ),
                                                            ) *
                                                        2,
                                                    height:
                                                        (sizes.appBarHeight *
                                                        .85),
                                                    padding:
                                                        const EdgeInsets.only(
                                                          bottom: 11,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            15,
                                                          ),
                                                      color:
                                                      controller
                                                          .empties
                                                          .value
                                                          .where(
                                                            (
                                                            test,
                                                            ) => test
                                                            .values
                                                            .contains(
                                                          "Quantity2-${controller.selectedBLIndex.value}",
                                                        ),
                                                      )
                                                          .isNotEmpty
                                                          ? Colors.redAccent
                                                          : Colors.white
                                                          .withAlpha(31),
                                                    ),
                                                    child: Center(
                                                      child: TextField(
                                                        cursorColor:
                                                            Colors.white,
                                                        // Gets the right controller using the helper method
                                                        // controller: controller.getControllerForCell(heading, rowIndex),
                                                        textAlignVertical:
                                                            TextAlignVertical
                                                                .center,
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                        ),
                                                        decoration:
                                                            const InputDecoration(
                                                              border:
                                                                  InputBorder
                                                                      .none,
                                                              isDense: true,
                                                            ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                spacing: 11,
                                                children: [
                                                  Text(
                                                    "Commodity",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      height: 0,
                                                      letterSpacing: 0,
                                                      fontSize: 17,
                                                    ),
                                                  ),

                                                  Container(
                                                    width:
                                                        sizes
                                                            .calculateTextWidth(
                                                              "Feeder Vessel",
                                                              const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                              ),
                                                            ) *
                                                        2,
                                                    height:
                                                        (sizes.appBarHeight *
                                                                .77 *
                                                                6 +
                                                            55) -
                                                        sizes.appBarHeight *
                                                            .85 *
                                                            3 -
                                                        11 -
                                                        42 -
                                                        11,
                                                    padding:
                                                        const EdgeInsets.only(
                                                          bottom: 11,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            25,
                                                          ),
                                                      color:
                                                      controller
                                                          .empties
                                                          .value
                                                          .where(
                                                            (
                                                            test,
                                                            ) => test
                                                            .values
                                                            .contains(
                                                          "Commodity-${controller.selectedBLIndex.value}",
                                                        ),
                                                      )
                                                          .isNotEmpty
                                                          ? Colors.redAccent
                                                          : Colors.white
                                                          .withAlpha(31),
                                                    ),
                                                    child: Center(
                                                      child: TextField(
                                                        cursorColor:
                                                            Colors.white,
                                                        // Gets the right controller using the helper method
                                                        controller: controller.commodityTECs[controller.selectedBLIndex.value],
                                                        textAlignVertical:
                                                            TextAlignVertical
                                                                .center,
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                        ),
                                                        decoration:
                                                            const InputDecoration(
                                                              border:
                                                                  InputBorder
                                                                      .none,
                                                              isDense: true,
                                                            ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width:
                                                        sizes
                                                            .calculateTextWidth(
                                                              "Feeder Vessel",
                                                              const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                              ),
                                                            ) *
                                                        2,
                                                    height:
                                                        (sizes.appBarHeight *
                                                        .85),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      spacing: 11,
                                                      children: [
                                                        Text(
                                                          "Dg",
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            color: Colors.white,
                                                            fontSize: 17,
                                                            height: 0,
                                                            letterSpacing: 0,
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: GestureDetector(
                                                            onTap: () => {
                                                              controller
                                                                      .bottomSheetTag1
                                                                      .value =
                                                                  "Yes",
                                                              controller
                                                                      .bottomSheetTag2
                                                                      .value =
                                                                  "No",
                                                              controller
                                                                  .shouldShowBottomSheet
                                                                  .value = !controller
                                                                  .shouldShowBottomSheet
                                                                  .value,
                                                            },
                                                            child: Container(
                                                              height:
                                                                  (sizes
                                                                      .appBarHeight *
                                                                  .85),
                                                              decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                      15,
                                                                    ),
                                                                color: Colors
                                                                    .white
                                                                    .withAlpha(
                                                                      31,
                                                                    ),
                                                              ),
                                                              padding:
                                                                  EdgeInsets.symmetric(
                                                                    horizontal:
                                                                        11,
                                                                  ),
                                                              child: Row(
                                                                // mainAxisSize: MainAxisSize.min,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Text(
                                                                    controller
                                                                            .dgStatusTECs[controller.selectedBLIndex.value]
                                                                            .value
                                                                            .text
                                                                            .isEmpty
                                                                        ? "No"
                                                                        : controller
                                                                              .dgStatusTECs[controller.selectedBLIndex.value]
                                                                              .value
                                                                              .text,
                                                                    style: const TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w700,
                                                                    ),
                                                                  ),
                                                                  Icon(
                                                                    CupertinoIcons
                                                                        .arrowtriangle_down_fill,
                                                                    color: Colors
                                                                        .white,
                                                                    size: 17,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 11),
                                        ],
                                      ),
                                    ),
                                  ),

                                  SizedBox(width: 62),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Text(
                          "   Bank Information",
                          style: TextStyle(
                            color: Colors.white54,
                            fontWeight: FontWeight.w100,
                            height: 0,
                            fontSize: 31,
                          ),
                        ),
                        SizedBox(
                          width: sizes.width * .89,
                          child: Center(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                spacing: 17,
                                children: [
                                  Container(
                                    height: sizes.appBarHeight * .85,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(17),
                                      color: Colors.white,
                                    ),
                                    child: Center(
                                      child: Text(
                                        "      New Record      ",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700,
                                          height: 0,
                                        ),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      //eee
                                      var years = getDataOffOfTECs(
                                        controller.yearTECs,
                                      );
                                      var feederVesselNames = getDataOffOfTECs(
                                        controller.feederVesselNameTECs,
                                      );
                                      var fevRotationNos = getDataOffOfTECs(
                                        controller.fevRotationNoTECs,
                                      );
                                      var fvVoys = getDataOffOfTECs(
                                        controller.fvVoyTECs,
                                      );
                                      var netMTs = getDataOffOfTECs(
                                        controller.netMTTECs,
                                      );
                                      var departureDates = getDataOffOfTECs(
                                        controller.departureDateTECs,
                                      );
                                      var depCodes = getDataOffOfTECs(
                                        controller.depCodeTECs,
                                      );
                                      var flagNames = getDataOffOfTECs(
                                        controller.flagNameTECs,
                                      );
                                      var arrivalDates = getDataOffOfTECs(
                                        controller.arrivalDateTECs,
                                      );
                                      var berthingDates = getDataOffOfTECs(
                                        controller.berthingDateTECs,
                                      );
                                      var portOfShipments = getDataOffOfTECs(
                                        controller.portOfShipmentTECs,
                                      );
                                      var flags = getDataOffOfTECs(
                                        controller.flagTECs,
                                      );
                                      var lineNos = getDataOffOf2DTECs(
                                        controller.lineNoTECs,
                                      );
                                      var contPrefixes = getDataOffOf2DTECs(
                                        controller.contPrefixTECs,
                                      );
                                      var contNos = getDataOffOf2DTECs(
                                        controller.contNoTECs,
                                      );
                                      var sizes = getDataOffOf2DTECs(
                                        controller.sizeTECs,
                                      );
                                      var contTypes = getDataOffOf2DTECs(
                                        controller.contTypeTECs,
                                      );
                                      var isoCodes = getDataOffOf2DTECs(
                                        controller.isoCodeTECs,
                                      );
                                      var qtys = getDataOffOf2DTECs(
                                        controller.qtyTECs,
                                      );
                                      var uoms = getDataOffOf2DTECs(
                                        controller.uomTECs,
                                      );
                                      var weightKgms = getDataOffOf2DTECs(
                                        controller.weightKgmTECs,
                                      );
                                      var contVolumes = getDataOffOf2DTECs(
                                        controller.contVolumeTECs,
                                      );
                                      var vgmQtys = getDataOffOf2DTECs(
                                        controller.vgmQtyTECs,
                                      );
                                      var cbms = getDataOffOf2DTECs(
                                        controller.cbmTECs,
                                      );
                                      var sealNos = getDataOffOf2DTECs(
                                        controller.sealNoTECs,
                                      );
                                      var imcos = getDataOffOf2DTECs(
                                        controller.imcoTECs,
                                      );
                                      var uns = getDataOffOf2DTECs(
                                        controller.unTECs,
                                      );
                                      var statuses = getDataOffOf2DTECs(
                                        controller.statusTECs,
                                      );
                                      var loadPortDts = getDataOffOf2DTECs(
                                        controller.loadPortDtTECs,
                                      );
                                      var remarks = getDataOffOf2DTECs(
                                        controller.remarksTECs,
                                      );
                                      var parts = getDataOffOf2DTECs(
                                        controller.partTECs,
                                      );
                                      var offDocks = getDataOffOf2DTECs(
                                        controller.offDockTECs,
                                      );
                                      var commoCodes = getDataOffOf2DTECs(
                                        controller.commoCodeTECs,
                                      );
                                      var perishables = getDataOffOf2DTECs(
                                        controller.perishableTECs,
                                      );
                                      var portOfLanding = getDataOffOfTECs(
                                        controller.portOfLandingTECs,
                                      );
                                      var slNo = getDataOffOfTECs(
                                        controller.slNoTECs,
                                      );
                                      var blLineNo = getDataOffOfTECs(
                                        controller.blLineNoTECs,
                                      );
                                      var blNo = getDataOffOfTECs(
                                        controller.blNoTECs,
                                      );
                                      var fcl = getDataOffOfTECs(
                                        controller.fclTECs,
                                      );
                                      var fclQty = getDataOffOfTECs(
                                        controller.fclQtyTECs,
                                      );
                                      var lcl = getDataOffOfTECs(
                                        controller.lclTECs,
                                      );
                                      var lclConsolidated = getDataOffOfTECs(
                                        controller.lclConsolidatedTECs,
                                      );
                                      var consigneeCode = getDataOffOfTECs(
                                        controller.consigneeCodeTECs,
                                      );
                                      var consignee = getDataOffOfTECs(
                                        controller.consigneeTECs,
                                      );
                                      var consigneeAddress = getDataOffOfTECs(
                                        controller.consigneeAddressTECs,
                                      );
                                      var exporter = getDataOffOfTECs(
                                        controller.exporterTECs,
                                      );
                                      var blRemarks = getDataOffOfTECs(
                                        controller.blRemarksTECs,
                                      );
                                      var notifyCode = getDataOffOfTECs(
                                        controller.notifyCodeTECs,
                                      );
                                      var notifyParty = getDataOffOfTECs(
                                        controller.notifyPartyTECs,
                                      );
                                      var notifyAddress = getDataOffOfTECs(
                                        controller.notifyAddressTECs,
                                      );
                                      var exporterAddress = getDataOffOfTECs(
                                        controller.exporterAddressTECs,
                                      );
                                      var placeOfUnload = getDataOffOfTECs(
                                        controller.placeOfUnloadTECs,
                                      );
                                      var blNature = getDataOffOfTECs(
                                        controller.blNatureTECs,
                                      );
                                      var blTypeCode = getDataOffOfTECs(
                                        controller.blTypeCodeTECs,
                                      );
                                      var blLoadPortDt = getDataOffOfTECs(
                                        controller.blLoadPortDtTECs,
                                      );
                                      var marks = getDataOffOfTECs(
                                        controller.marksTECs,
                                      );
                                      var quantity = getDataOffOfTECs(
                                        controller.quantityTECs,
                                      );
                                      var quantity2 = getDataOffOfTECs(
                                        controller.quantity2TECs,
                                      );
                                      var commodity = getDataOffOfTECs(
                                        controller.commodityTECs,
                                      );
                                      var dgStatus = getDataOffOfTECs(
                                        controller.dgStatusTECs,
                                      );
                                      var sl_Nos = getDataOffOfTECs(
                                        controller.sl_NoTECs,
                                      );
                                      var bankAddressForNotice = getDataOffOfTECs(
                                        controller.bankAddressForNoticeToConsigneeTECs,
                                      );

                                      controller.empties.clear();

                                      controller.assignEmpties("Year", years);
                                      controller.assignEmpties(
                                        "Feeder Vessel Name",
                                        feederVesselNames,
                                      );
                                      controller.assignEmpties(
                                        "Fe.V Rotation No.",
                                        fevRotationNos,
                                      );
                                      controller.assignEmpties(
                                        "F.V. Voy",
                                        fvVoys,
                                      );
                                      controller.assignEmpties("Net MT", netMTs);
                                      controller.assignEmpties(
                                        "Departure Date",
                                        departureDates,
                                      );
                                      controller.assignEmpties(
                                        "Dep. Code",
                                        depCodes,
                                      );
                                      controller.assignEmpties(
                                        "Flag Name",
                                        flagNames,
                                      );
                                      controller.assignEmpties(
                                        "Arrival Date",
                                        arrivalDates,
                                      );
                                      controller.assignEmpties(
                                        "Berthing Date",
                                        berthingDates,
                                      );
                                      controller.assignEmpties(
                                        "Port of Shipment",
                                        portOfShipments,
                                      );
                                      controller.assignEmpties(
                                        "Sl No.",
                                        slNo,
                                      );
                                      controller.assignEmpties("Flag", flags);
                                      controller.assignEmpties("SL_NO", sl_Nos);
                                      controller.assignEmpties("Line No.", blLineNo);
                                      controller.assignEmpties("Bl No.", blNo);
                                      controller.assignEmpties("Fcl", fcl);
                                      controller.assignEmpties("Fcl/Qty", fclQty);
                                      controller.assignEmpties("Lcl", lcl);
                                      controller.assignEmpties("Lcl/Consl.", lclConsolidated);
                                      controller.assignEmpties("Consig. Code", consigneeCode);
                                      controller.assignEmpties("Consignee", consignee);
                                      controller.assignEmpties("Con. Address", consigneeAddress);
                                      controller.assignEmpties("Exporter", exporter);
                                      controller.assignEmpties("BL Remarks", blRemarks);
                                      controller.assignEmpties("Notify Code", notifyCode);
                                      controller.assignEmpties("Notify Party", notifyParty);
                                      controller.assignEmpties("Notify Address", notifyAddress);
                                      controller.assignEmpties("Exporter Add.", exporterAddress);
                                      controller.assignEmpties("Place Unload", placeOfUnload);
                                      controller.assignEmpties("Bl Nature", blNature);
                                      controller.assignEmpties("Bl Type Code", blTypeCode);
                                      controller.assignEmpties("Load Port Dt.", blLoadPortDt);
                                      controller.assignEmpties("Marks", marks);
                                      controller.assignEmpties("Quantity", quantity);
                                      controller.assignEmpties("Quantity2", quantity2);
                                      controller.assignEmpties("Commodity", commodity);
                                      controller.assignEmpties("Dg", dgStatus);
                                      controller.assignEmpties("Bank address for notice to consignee", bankAddressForNotice);

                                      for(int i = 0; i < blNo.length; i++) {
                                        controller.assignEmpties("Line No.${controller.selectedBLIndex.value}", lineNos[i]);
                                        controller.assignEmpties("Cont. Prefix${controller.selectedBLIndex.value}", contPrefixes[i]);
                                        controller.assignEmpties("Cont. No.${controller.selectedBLIndex.value}", contNos[i]);
                                        controller.assignEmpties("Size${controller.selectedBLIndex.value}", sizes[i]);
                                        controller.assignEmpties("Cont. Type${controller.selectedBLIndex.value}", contTypes[i]);
                                        controller.assignEmpties("ISO Code${controller.selectedBLIndex.value}", isoCodes[i]);
                                        controller.assignEmpties("Qty${controller.selectedBLIndex.value}", qtys[i]);
                                        controller.assignEmpties("Uom${controller.selectedBLIndex.value}", uoms[i]);
                                        controller.assignEmpties("Weight (KGM)${controller.selectedBLIndex.value}", weightKgms[i]);
                                        controller.assignEmpties("Cont. Volume${controller.selectedBLIndex.value}", contVolumes[i]);
                                        controller.assignEmpties("VGM Qty${controller.selectedBLIndex.value}", vgmQtys[i]);
                                        controller.assignEmpties("CBM${controller.selectedBLIndex.value}", cbms[i]);
                                        controller.assignEmpties("Seal No.${controller.selectedBLIndex.value}", sealNos[i]);
                                        controller.assignEmpties("IMCO${controller.selectedBLIndex.value}", imcos[i]);
                                        controller.assignEmpties("Un${controller.selectedBLIndex.value}", uns[i]);
                                        controller.assignEmpties("Status${controller.selectedBLIndex.value}", statuses[i]);
                                        controller.assignEmpties("Load Port Dt${controller.selectedBLIndex.value}", loadPortDts[i]);
                                        controller.assignEmpties("Remarks${controller.selectedBLIndex.value}", remarks[i]);
                                        controller.assignEmpties("Part${controller.selectedBLIndex.value}", parts[i]);
                                        controller.assignEmpties("Line No.${controller.selectedBLIndex.value}", lineNos[i]);
                                        controller.assignEmpties("Off Dock${controller.selectedBLIndex.value}", offDocks[i]);
                                        controller.assignEmpties("Commo. Code${controller.selectedBLIndex.value}", commoCodes[i]);
                                        controller.assignEmpties("Perishable${controller.selectedBLIndex.value}", perishables[i]);
                                      }

                                      if (controller
                                          .emptyFieldEncountered
                                          .value) {
                                        return;
                                      }

                                      //eee

                                      ImportBLXMLGeneration
                                      importBLXMLGeneration =
                                          ImportBLXMLGeneration(
                                            years: years,
                                            feederVesselNames: feederVesselNames,
                                            fevRotationNos: fevRotationNos,
                                            fvVoys: fvVoys,
                                            netMTs: netMTs,
                                            departureDates: departureDates,
                                            depCodes: depCodes,
                                            flagNames: flagNames,
                                            arrivalDates: arrivalDates,
                                            berthingDates: berthingDates,
                                            portOfShipments: portOfShipments,
                                            flags: flags,
                                            lineNos: lineNos,
                                            contPrefixes: contPrefixes,
                                            contNos: contNos,
                                            sizes: sizes,
                                            contTypes: contTypes,
                                            isoCodes: isoCodes,
                                            qtys: qtys,
                                            uoms: uoms,
                                            weightKgms: weightKgms,
                                            contVolumes: contVolumes,
                                            vgmQtys: vgmQtys,
                                            cbms: cbms,
                                            sealNos: sealNos,
                                            imcos: imcos,
                                            uns: uns,
                                            statuses: statuses,
                                            loadPortDts: loadPortDts,
                                            remarks: remarks,
                                            parts: parts,
                                            offDocks: offDocks,
                                            commoCodes: commoCodes,
                                            perishables: perishables,
                                            portOfLanding: portOfLanding,
                                            slNo: slNo,
                                            blLineNo: blLineNo,
                                            blNo: blNo,
                                            fcl: fcl,
                                            fclQty: fclQty,
                                            lcl: lcl,
                                            lclConsolidated: lclConsolidated,
                                            consigneeCode: consigneeCode,
                                            consignee: consignee,
                                            consigneeAddress: consigneeAddress,
                                            exporter: exporter,
                                            blRemarks: blRemarks,
                                            notifyCode: notifyCode,
                                            notifyParty: notifyParty,
                                            notifyAddress: notifyAddress,
                                            exporterAddress: exporterAddress,
                                            placeOfUnload: placeOfUnload,
                                            blNature: blNature,
                                            blTypeCode: blTypeCode,
                                            blLoadPortDt: blLoadPortDt,
                                            marks: marks,
                                            quantity: quantity,
                                            quantity2: quantity2,
                                            commodity: commodity,
                                            dgStatus: dgStatus,
                                          );
                                      print(dgStatus);

                                      if (controller.blLineNoTECs.length == 1) {
                                        importBLXMLGeneration.generateXML();
                                      }

                                      if (controller.blLineNoTECs.length > 1) {
                                        importBLXMLGeneration.generateMultiBL();
                                      }
                                    },
                                    child: Container(
                                      height: sizes.appBarHeight * .85,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(17),
                                        color: Colors.white,
                                      ),
                                      child: Center(
                                        child: Text(
                                          "      Save      ",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w700,
                                            height: 0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: sizes.appBarHeight * .85,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(17),
                                      color: Colors.white,
                                    ),
                                    child: Center(
                                      child: Text(
                                        "      Print      ",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700,
                                          height: 0,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: sizes.appBarHeight * .85,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(17),
                                      color: Colors.white,
                                    ),
                                    child: Center(
                                      child: Text(
                                        "      Bank Info      ",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700,
                                          height: 0,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: sizes.appBarHeight * .85,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(17),
                                      color: Colors.white,
                                    ),
                                    child: Center(
                                      child: Text(
                                        "      Exit      ",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700,
                                          height: 0,
                                        ),
                                      ),
                                    ),
                                  ),
                                  LiquidGlass(
                                    clipBehavior: Clip.antiAlias,
                                    shape: const LiquidRoundedSuperellipse(
                                      borderRadius: Radius.circular(35),
                                    ),
                                    settings: LiquidGlassSettings(
                                      thickness: 20,
                                      glassColor: const Color(0x09FFFFFF),
                                      lightIntensity: 3,
                                      blend: 40,
                                      ambientStrength: .35,
                                      lightAngle: math.pi / 7,
                                      chromaticAberration: 0,
                                      refractiveIndex: 1.1,
                                    ),
                                    child: Container(
                                      // height: sizes.appBarHeight * 1.5,
                                      width:
                                          sizes.calculateTextWidth(
                                            "Bank address for notice to consignee",
                                            TextStyle(
                                              fontWeight: FontWeight.w700,
                                              color: Colors.white,
                                            ),
                                          ) *
                                          1.35,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 31,
                                        vertical: 31,
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        spacing: 11,
                                        children: [
                                          Text(
                                            "Bank address for notice to consignee",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Container(
                                            height: sizes.appBarHeight * .85,
                                            decoration: BoxDecoration(
                                              color:
                                              controller
                                                  .empties
                                                  .value
                                                  .where(
                                                    (
                                                    test,
                                                    ) => test
                                                    .values
                                                    .contains(
                                                  "Bank address for notice to consignee-0",
                                                ),
                                              )
                                                  .isNotEmpty
                                                  ? Colors.redAccent
                                                  : Colors.white.withAlpha(31),
                                              borderRadius: BorderRadius.circular(
                                                17,
                                              ),
                                            ),
                                            child: TextField(
                                              cursorColor:
                                              Colors.white,
                                              // Gets the right controller using the helper method
                                              controller: controller.bankAddressForNoticeToConsigneeTECs[0],
                                              textAlignVertical:
                                              TextAlignVertical
                                                  .center,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight:
                                                FontWeight.w700,
                                              ),
                                              decoration:
                                              const InputDecoration(
                                                border:
                                                InputBorder
                                                    .none,
                                                isDense: true,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Text(
                          "   Container Information",
                          style: TextStyle(
                            color: Colors.white54,
                            fontWeight: FontWeight.w100,
                            height: 0,
                            fontSize: 31,
                          ),
                        ),
                        LiquidGlass(
                          clipBehavior: Clip.antiAlias,
                          shape: const LiquidRoundedSuperellipse(
                            borderRadius: Radius.circular(100),
                          ),
                          settings: LiquidGlassSettings(
                            thickness: 50,
                            glassColor: const Color(0x09FFFFFF),
                            lightIntensity: 3,
                            blend: 40,
                            ambientStrength: .35,
                            lightAngle: math.pi / 7,
                            chromaticAberration: 0,
                            refractiveIndex: 1.07,
                          ),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 755),
                            curve: Curves.linearToEaseOut,
                            // Using controller.rowCount to dynamically calculate height
                            height:
                                sizes.appBarHeight * 1.1 +
                                sizes.appBarHeight *
                                    .85 *
                                    (controller.rowCountForContainer + 1) +
                                62 +
                                0 +
                                sizes.appBarHeight +
                                11 *
                                    (controller.rowCountForContainer > 0
                                        ? controller.rowCountForContainer - 1
                                        : 0),
                            width: sizes.width * .89,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 31.0,
                                  right: 31.0,
                                  top: 31.0,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // The Header Row of the DataTable
                                    DataTable(
                                      columnSpacing: 11.0,
                                      columns: columnsForContainerTable,
                                      headingRowHeight:
                                          sizes.appBarHeight * 1.1,
                                      rows: const [],
                                      dividerThickness: 0.000001,
                                    ),
                                    // The Scrollable Body of the DataTable
                                    Flexible(
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.vertical,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // The Main Data Table with TextFields
                                            DataTable(
                                              dataRowHeight: sizes.appBarHeight,
                                              columns: columnsForContainerTable,
                                              headingRowHeight: 0.0,
                                              // Generates rows based on the number of controllers we have
                                              rows: List.generate(controller.rowCountForContainer, (
                                                rowIndex,
                                              ) {
                                                return DataRow(
                                                  // Generates cells by iterating through the headings list
                                                  cells: controller.containerTableHeadings.map((
                                                    heading,
                                                  ) {
                                                    return DataCell(
                                                      GestureDetector(
                                                        onTap: () {
                                                          if (heading ==
                                                              "Remarks") {
                                                            controller
                                                                    .bottomSheetTag1
                                                                    .value =
                                                                "Good";
                                                            controller
                                                                    .bottomSheetTag2
                                                                    .value =
                                                                "Bad";

                                                            controller
                                                                    .shouldShowBottomSheet
                                                                    .value =
                                                                true;
                                                            controller
                                                                    .selectedRemarksIndex
                                                                    .value =
                                                                rowIndex;
                                                          }
                                                          if (heading ==
                                                              "Status") {
                                                            controller
                                                                    .bottomSheetTag1
                                                                    .value =
                                                                "FCL";
                                                            controller
                                                                    .bottomSheetTag2
                                                                    .value =
                                                                "LCL";

                                                            controller
                                                                    .shouldShowBottomSheet
                                                                    .value =
                                                                true;
                                                            controller
                                                                    .selectedStatusIndex
                                                                    .value =
                                                                rowIndex;
                                                            controller
                                                                    .selectedHeading
                                                                    .value =
                                                                heading;
                                                          }
                                                          if (heading ==
                                                              "Perishable") {
                                                            controller
                                                                    .bottomSheetTag1
                                                                    .value =
                                                                "Yes";
                                                            controller
                                                                    .bottomSheetTag2
                                                                    .value =
                                                                "No";

                                                            controller
                                                                    .shouldShowBottomSheet
                                                                    .value =
                                                                true;
                                                            controller
                                                                    .selectedPerishableIndex
                                                                    .value =
                                                                rowIndex;
                                                            controller
                                                                    .selectedHeading
                                                                    .value =
                                                                heading;
                                                          } else {}
                                                        },
                                                        child: Container(
                                                          width:
                                                              sizes.calculateTextWidth(
                                                                heading,
                                                                const TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                ),
                                                              ) *
                                                              2,
                                                          height:
                                                              sizes
                                                                  .appBarHeight *
                                                              .77,
                                                          padding: EdgeInsets.symmetric(
                                                            horizontal:
                                                                heading ==
                                                                        "Remarks" ||
                                                                    heading ==
                                                                        "Perishable" ||
                                                                    heading ==
                                                                        "Status"
                                                                ? 11.0
                                                                : 8.0,
                                                          ),
                                                          decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  15,
                                                                ),
                                                            color:
                                                            controller
                                                                .empties
                                                                .value
                                                                .where(
                                                                  (
                                                                  test,
                                                                  ) => test
                                                                  .values
                                                                  .contains(
                                                                "$heading${controller.selectedBLIndex.value}-$rowIndex",
                                                              ),
                                                            )
                                                                .isNotEmpty
                                                                ? Colors.redAccent
                                                                : Colors.white
                                                                .withAlpha(31),
                                                          ),
                                                          child:
                                                              heading ==
                                                                  "Remarks"
                                                              ? Row(
                                                                  // mainAxisSize: MainAxisSize.min,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Text(
                                                                      controller
                                                                                  .remarksTECs[controller.selectedBLIndex.value][rowIndex ??
                                                                                      0]
                                                                                  .value
                                                                                  .text ==
                                                                              ""
                                                                          ? "Good"
                                                                          : controller
                                                                                .remarksTECs[controller.selectedBLIndex.value][rowIndex ??
                                                                                    0]
                                                                                .value
                                                                                .text,
                                                                      style: const TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontWeight:
                                                                            FontWeight.w700,
                                                                      ),
                                                                    ),
                                                                    Icon(
                                                                      CupertinoIcons
                                                                          .arrowtriangle_down_fill,
                                                                      color: Colors
                                                                          .white,
                                                                      size: 17,
                                                                    ),
                                                                  ],
                                                                )
                                                              : heading ==
                                                                    "Perishable"
                                                              ? Row(
                                                                  // mainAxisSize: MainAxisSize.min,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Text(
                                                                      controller
                                                                              .perishableTECs[controller.selectedBLIndex.value][rowIndex ??
                                                                                  0]
                                                                              .value
                                                                              .text
                                                                              .isEmpty
                                                                          ? "Yes"
                                                                          : controller
                                                                                .perishableTECs[controller.selectedBLIndex.value][rowIndex ??
                                                                                    0]
                                                                                .value
                                                                                .text,
                                                                      style: const TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontWeight:
                                                                            FontWeight.w700,
                                                                      ),
                                                                    ),
                                                                    Icon(
                                                                      CupertinoIcons
                                                                          .arrowtriangle_down_fill,
                                                                      color: Colors
                                                                          .white,
                                                                      size: 17,
                                                                    ),
                                                                  ],
                                                                )
                                                              : heading ==
                                                                    "Status"
                                                              ? Row(
                                                                  // mainAxisSize: MainAxisSize.min,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Text(
                                                                      controller.statusTECs[controller.selectedBLIndex.value][rowIndex].value.text ==
                                                                              ""
                                                                          ? "FCL"
                                                                          : controller
                                                                                .statusTECs[controller.selectedBLIndex.value][rowIndex ??
                                                                                    0]
                                                                                .value
                                                                                .text,
                                                                      style: const TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontWeight:
                                                                            FontWeight.w700,
                                                                      ),
                                                                    ),
                                                                    Icon(
                                                                      CupertinoIcons
                                                                          .arrowtriangle_down_fill,
                                                                      color: Colors
                                                                          .white,
                                                                      size: 17,
                                                                    ),
                                                                  ],
                                                                )
                                                              : Center(
                                                                  child: TextField(
                                                                    cursorColor:
                                                                        Colors
                                                                            .white,
                                                                    // Gets the right controller using the helper method
                                                                    controller: controller.getContainerControllerForCell(
                                                                      heading,
                                                                      controller
                                                                          .selectedBLIndex
                                                                          .value,
                                                                      rowIndex,
                                                                    ),
                                                                    textAlignVertical:
                                                                        TextAlignVertical
                                                                            .center,
                                                                    style: const TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w700,
                                                                    ),
                                                                    decoration: const InputDecoration(
                                                                      border: InputBorder
                                                                          .none,
                                                                      isDense:
                                                                          true,
                                                                    ),
                                                                  ),
                                                                ),
                                                        ),
                                                      ),
                                                    );
                                                  }).toList(),
                                                );
                                              }),
                                              columnSpacing: 11,
                                              dividerThickness: 0.000001,
                                            ),
                                            // The "Add Row" Button
                                            GestureDetector(
                                              // Logic to limit rows to 5
                                              onTap:
                                                  controller
                                                          .rowCountForContainer >=
                                                      5
                                                  ? () {
                                                      print("...");
                                                    }
                                                  : () => {
                                                      print("+++"),
                                                      controller
                                                          .addRowToSpecificIndexInContainerTable(
                                                            controller
                                                                .selectedBLIndex
                                                                .value,
                                                          ),
                                                      print(
                                                        controller
                                                            .lineNoTECs[controller
                                                                .selectedBLIndex
                                                                .value]
                                                            .length,
                                                      ),
                                                    },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 21.0,
                                                      vertical: 11.0,
                                                    ),
                                                child: LiquidGlass(
                                                  clipBehavior: Clip.antiAlias,
                                                  shape:
                                                      const LiquidRoundedSuperellipse(
                                                        borderRadius:
                                                            Radius.circular(
                                                              100,
                                                            ),
                                                      ),
                                                  settings: LiquidGlassSettings(
                                                    thickness: 20,
                                                    glassColor: const Color(
                                                      0x11FFFFFF,
                                                    ),
                                                    lightIntensity: .5,
                                                    blend: 100,
                                                    ambientStrength: .0,
                                                    lightAngle: math.pi / 3,
                                                    chromaticAberration: 0,
                                                    refractiveIndex: 1.1,
                                                  ),
                                                  child: SizedBox(
                                                    height: sizes.appBarHeight,
                                                    child: Center(
                                                      child: Text(
                                                        "       add row      ",
                                                        style: TextStyle(
                                                          color:
                                                              controller
                                                                      .rowCountForContainer >=
                                                                  5
                                                              ? Colors.white30
                                                              : Colors.white,
                                                          fontWeight:
                                                              FontWeight.w900,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            // Bottom padding that scrolls away
                                            const SizedBox(height: 31.0),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: sizes.appBarHeight * 2),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Top Logo Image
            Positioned(
              top: 0,
              left: sizes.width * .055,
              child: SizedBox(
                height: sizes.appBarHeight * 2,
                width: sizes.width * .89,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: sizes.appBarHeight * 2,
                      width: sizes.appBarHeight * 3,
                      child: Image.asset("assets/images/mmgsll_w.png"),
                    ),
                    LiquidGlass(
                      clipBehavior: Clip.antiAlias,
                      shape: const LiquidRoundedSuperellipse(
                        borderRadius: Radius.circular(100),
                      ),
                      settings: LiquidGlassSettings(
                        thickness: 30,
                        glassColor: const Color(0x19FFFFFF),
                        lightIntensity: 3,
                        blend: 40,
                        ambientStrength: .35,
                        lightAngle: math.pi / 7,
                        chromaticAberration: 0,
                        refractiveIndex: 1.1,
                      ),
                      child: GestureDetector(
                        onTap: () => Get.offAndToNamed(Routes.COMPANY_PAGE),
                        child: SizedBox(
                          height: sizes.appBarHeight * 1.35,
                          child: Center(
                            child: Text(
                              "     Change Company     ",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 755),
              curve: Curves.linearToEaseOut,
              bottom: controller.shouldShowBottomSheet.value
                  ? sizes.width * .055
                  : -sizes.width * .75,
              left: sizes.width * .055,
              right: sizes.width * .055,
              child: LiquidGlass(
                clipBehavior: Clip.antiAlias,
                shape: const LiquidRoundedSuperellipse(
                  borderRadius: Radius.circular(100),
                ),
                settings: LiquidGlassSettings(
                  thickness: 50,
                  glassColor: const Color(0x11FFFFFF),
                  lightIntensity: 3,
                  blend: 40,
                  ambientStrength: .35,
                  lightAngle: math.pi / 7,
                  chromaticAberration: 0,
                  refractiveIndex: 1.07,
                ),
                child: SizedBox(
                  height: sizes.height * .45,
                  width: sizes.width * .89,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      spacing: 11,
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (controller.bottomSheetTag1.value == "CTG") {
                              controller
                                      .portOfLandingTECs[controller
                                          .selectedBLIndex
                                          .value]
                                      .text =
                                  controller.bottomSheetTag1.value;
                              // controller.portOfShipment.value =
                              //     controller.bottomSheetTag1.value;
                            }
                            if (controller.bottomSheetTag1.value == "MSB") {
                              controller
                                      .blTypeCodeTECs[controller
                                          .selectedBLIndex
                                          .value]
                                      .text =
                                  controller.bottomSheetTag1.value;
                            }
                            if (controller.bottomSheetTag1.value == "Yes") {
                              controller
                                      .dgStatusTECs[controller
                                          .selectedBLIndex
                                          .value]
                                      .text =
                                  controller.bottomSheetTag1.value;
                            }
                            if (controller.bottomSheetTag1.value == "FCL") {
                              controller
                                      .statusTECs[controller
                                          .selectedBLIndex
                                          .value][controller
                                          .selectedStatusIndex
                                          .value]
                                      .text =
                                  controller.bottomSheetTag1.value;
                            }
                            if (controller.bottomSheetTag1.value == "Good") {
                              controller
                                      .remarksTECs[controller
                                          .selectedBLIndex
                                          .value][controller
                                          .selectedRemarksIndex
                                          .value]
                                      .text =
                                  controller.bottomSheetTag1.value;
                            }
                            if (controller.selectedHeading.value ==
                                "Perishable") {
                              controller
                                      .perishableTECs[controller
                                          .selectedBLIndex
                                          .value][controller
                                          .selectedPerishableIndex
                                          .value]
                                      .text =
                                  controller.bottomSheetTag1.value;
                            }
                            controller.shouldShowBottomSheet.value = false;
                          },
                          child: Text(
                            controller.bottomSheetTag1.value,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w100,
                              height: 0,
                              letterSpacing: 0,
                              fontSize: 55,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            if (controller.bottomSheetTag1.value == "CTG") {
                              controller
                                      .portOfLandingTECs[controller
                                          .selectedBLIndex
                                          .value]
                                      .text =
                                  controller.bottomSheetTag2.value;
                              // controller.portOfShipment.value =
                              //     controller.bottomSheetTag2.value;
                            }
                            if (controller.bottomSheetTag1.value == "MSB") {
                              controller
                                      .blTypeCodeTECs[controller
                                          .selectedBLIndex
                                          .value]
                                      .text =
                                  controller.bottomSheetTag2.value;
                            }
                            if (controller.bottomSheetTag1.value == "Yes") {
                              controller
                                      .dgStatusTECs[controller
                                          .selectedBLIndex
                                          .value]
                                      .text =
                                  controller.bottomSheetTag2.value;
                            }
                            if (controller.bottomSheetTag1.value == "FCL") {
                              controller
                                      .statusTECs[controller
                                          .selectedBLIndex
                                          .value][controller
                                          .selectedStatusIndex
                                          .value]
                                      .text =
                                  controller.bottomSheetTag2.value;
                            }
                            if (controller.bottomSheetTag1.value == "Good") {
                              controller
                                      .remarksTECs[controller
                                          .selectedBLIndex
                                          .value][controller
                                          .selectedRemarksIndex
                                          .value]
                                      .text =
                                  controller.bottomSheetTag2.value;
                            }
                            if (controller.selectedHeading.value ==
                                "Perishable") {
                              controller
                                      .perishableTECs[controller
                                          .selectedBLIndex
                                          .value][controller
                                          .selectedPerishableIndex
                                          .value]
                                      .text =
                                  controller.bottomSheetTag2.value;
                            }
                            controller.shouldShowBottomSheet.value = false;
                          },
                          child: Text(
                            controller.bottomSheetTag2.value,
                            style: TextStyle(
                              color: Colors.white,
                              height: 0,
                              letterSpacing: 0,
                              fontWeight: FontWeight.w100,
                              fontSize: 55,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
