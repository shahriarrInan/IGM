import 'package:flutter/cupertino.dart';
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

      for(var t in tecs) {
        tecVals.add(t.value.text.obs);
      }

      return tecVals;
    }

    // This creates the header widgets. It's built once and reused.
    final List<DataColumn> columns = List<DataColumn>.generate(
      controller.vesselTableHeadings.length,
          (index) =>
          DataColumn(
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
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(11)),
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
          (index) =>
          DataColumn(
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
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(11)),
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
          () =>
          Scaffold(
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
                    child: Image.asset(
                        'assets/images/reel.gif', fit: BoxFit.cover),
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
                      opacity: controller.shouldShowBottomSheet.value
                          ? 0.05
                          : 1,
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
                                      crossAxisAlignment: CrossAxisAlignment
                                          .start,
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
                                                  dataRowHeight: sizes
                                                      .appBarHeight,
                                                  columns: columns,
                                                  headingRowHeight: 0.0,
                                                  // Generates rows based on the number of controllers we have
                                                  rows: List.generate(
                                                      controller.rowCount, (
                                                      rowIndex,) {
                                                    return DataRow(
                                                      // Generates cells by iterating through the headings list
                                                      cells: controller
                                                          .vesselTableHeadings
                                                          .map((heading,) {
                                                        return DataCell(
                                                          Container(
                                                            width:
                                                            sizes
                                                                .calculateTextWidth(
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
                                                            const EdgeInsets
                                                                .symmetric(
                                                              horizontal: 8.0,
                                                            ),
                                                            decoration: BoxDecoration(
                                                              borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                15,
                                                              ),
                                                              color: Colors
                                                                  .white
                                                                  .withAlpha(
                                                                  31),
                                                            ),
                                                            child: Center(
                                                              child: TextField(
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
                                                  onTap: controller.rowCount >=
                                                      5
                                                      ? () {}
                                                      : () =>
                                                      controller.addRow(),
                                                  child: Padding(
                                                    padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 21.0,
                                                      vertical: 11.0,
                                                    ),
                                                    child: LiquidGlass(
                                                      clipBehavior: Clip
                                                          .antiAlias,
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
                                                        height: sizes
                                                            .appBarHeight,
                                                        child: Center(
                                                          child: Text(
                                                            "       add row      ",
                                                            style: TextStyle(
                                                              color:
                                                              controller
                                                                  .rowCount >=
                                                                  5
                                                                  ? Colors
                                                                  .white30
                                                                  : Colors
                                                                  .white,
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
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 31),
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
                                              decoration: BoxDecoration(
                                                color: Colors.white.withAlpha(
                                                    31),
                                                borderRadius: BorderRadius
                                                    .circular(
                                                  17,
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
                                                  onTap: () =>
                                                  {
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
                                                      color: Colors.white
                                                          .withAlpha(
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
                                                              .portOfShipmentTECs[0].value.text.isEmpty ? "CTG" : controller
                                                              .portOfShipmentTECs[0].value.text,
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
                                                  height: sizes.appBarHeight *
                                                      .77,
                                                  padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 8.0,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                    BorderRadius.circular(15),
                                                    color: Colors.white
                                                        .withAlpha(
                                                      31,
                                                    ),
                                                  ),
                                                  child: Center(
                                                    child: TextField(
                                                      // Gets the right controller using the helper method
                                                      controller: controller.slNoTECs[0],
                                                      textAlignVertical:
                                                      TextAlignVertical.center,
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontWeight: FontWeight
                                                            .w700,
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
                                                  height: sizes.appBarHeight *
                                                      .77,
                                                  padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 8.0,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                    BorderRadius.circular(15),
                                                    color: Colors.white
                                                        .withAlpha(
                                                      31,
                                                    ),
                                                  ),
                                                  child: Center(
                                                    child: TextField(
                                                      // Gets the right controller using the helper method
                                                      controller: controller.blLineNoTECs[0],
                                                      textAlignVertical:
                                                      TextAlignVertical.center,
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontWeight: FontWeight
                                                            .w700,
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
                                                  height: sizes.appBarHeight *
                                                      .77,
                                                  padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 8.0,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                    BorderRadius.circular(15),
                                                    color: Colors.white
                                                        .withAlpha(
                                                      31,
                                                    ),
                                                  ),
                                                  child: Center(
                                                    child: TextField(
                                                      // Gets the right controller using the helper method
                                                      controller: controller.blNoTECs[0],
                                                      textAlignVertical:
                                                      TextAlignVertical.center,
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontWeight: FontWeight
                                                            .w700,
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
                                                  height: sizes.appBarHeight *
                                                      .77,
                                                  child: Row(
                                                    mainAxisSize: MainAxisSize
                                                        .min,
                                                    spacing: 11,
                                                    children: [
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
                                                            2 *
                                                            .6 -
                                                            5.5,
                                                        height:
                                                        sizes.appBarHeight *
                                                            .77,
                                                        padding:
                                                        const EdgeInsets
                                                            .symmetric(
                                                          horizontal: 8.0,
                                                        ),
                                                        decoration: BoxDecoration(
                                                          borderRadius:
                                                          BorderRadius.circular(
                                                            15,
                                                          ),
                                                          color: Colors.white
                                                              .withAlpha(31),
                                                        ),
                                                        child: Center(
                                                          child: TextField(
                                                            // Gets the right controller using the helper method
                                                            controller: controller.fclTECs[0],
                                                            textAlignVertical:
                                                            TextAlignVertical
                                                                .center,
                                                            style: const TextStyle(
                                                              color: Colors
                                                                  .white,
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
                                                            2 *
                                                            .4 -
                                                            5.5,
                                                        height:
                                                        sizes.appBarHeight *
                                                            .77,
                                                        padding:
                                                        const EdgeInsets
                                                            .symmetric(
                                                          horizontal: 8.0,
                                                        ),
                                                        decoration: BoxDecoration(
                                                          borderRadius:
                                                          BorderRadius.circular(
                                                            15,
                                                          ),
                                                          color: Colors.white
                                                              .withAlpha(31),
                                                        ),
                                                        child: Center(
                                                          child: TextField(
                                                            // Gets the right controller using the helper method
                                                            controller: controller.fclQtyTECs[0],
                                                            textAlignVertical:
                                                            TextAlignVertical
                                                                .center,
                                                            style: const TextStyle(
                                                              color: Colors
                                                                  .white,
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
                                                  mainAxisSize: MainAxisSize
                                                      .min,
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
                                                      const EdgeInsets
                                                          .symmetric(
                                                        horizontal: 8.0,
                                                      ),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                        BorderRadius.circular(
                                                          15,
                                                        ),
                                                        color: Colors.white
                                                            .withAlpha(31),
                                                      ),
                                                      child: Center(
                                                        child: TextField(
                                                          // Gets the right controller using the helper method
                                                          controller: controller.lclTECs[0],
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
                                                      const EdgeInsets
                                                          .symmetric(
                                                        horizontal: 8.0,
                                                      ),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                        BorderRadius.circular(
                                                          15,
                                                        ),
                                                        color: Colors.white
                                                            .withAlpha(31),
                                                      ),
                                                      child: Center(
                                                        child: TextField(
                                                          // Gets the right controller using the helper method
                                                          controller: controller.lclConsolidatedTECs[0],
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
                                                  height: sizes.appBarHeight *
                                                      .77,
                                                  padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 8.0,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                    BorderRadius.circular(15),
                                                    color: Colors.white
                                                        .withAlpha(
                                                      31,
                                                    ),
                                                  ),
                                                  child: Center(
                                                    child: TextField(
                                                      // Gets the right controller using the helper method
                                                      controller: controller.consigneeCodeTECs[0],
                                                      textAlignVertical:
                                                      TextAlignVertical.center,
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontWeight: FontWeight
                                                            .w700,
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
                                                  height: sizes.appBarHeight *
                                                      .77,
                                                  padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 8.0,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                    BorderRadius.circular(15),
                                                    color: Colors.white
                                                        .withAlpha(
                                                      31,
                                                    ),
                                                  ),
                                                  child: Center(
                                                    child: TextField(
                                                      // Gets the right controller using the helper method
                                                      controller: controller.consigneeTECs[0],
                                                      textAlignVertical:
                                                      TextAlignVertical.center,
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontWeight: FontWeight
                                                            .w700,
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
                                                  height: sizes.appBarHeight *
                                                      .77,
                                                  padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 8.0,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                    BorderRadius.circular(15),
                                                    color: Colors.white
                                                        .withAlpha(
                                                      31,
                                                    ),
                                                  ),
                                                  child: Center(
                                                    child: TextField(
                                                      // Gets the right controller using the helper method
                                                      controller: controller.consigneeAddressTECs[0],
                                                      textAlignVertical:
                                                      TextAlignVertical.center,
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontWeight: FontWeight
                                                            .w700,
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
                                                    color: Colors.white
                                                        .withAlpha(
                                                      31,
                                                    ),
                                                  ),
                                                  child: Center(
                                                    child: TextField(
                                                      // Gets the right controller using the helper method
                                                      controller: controller.exporterTECs[0],
                                                      textAlignVertical:
                                                      TextAlignVertical.center,
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontWeight: FontWeight
                                                            .w700,
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
                                              padding: const EdgeInsets
                                                  .symmetric(
                                                horizontal: 8.0,
                                              ),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius
                                                    .circular(
                                                  15,
                                                ),
                                                color: Colors.white.withAlpha(
                                                    31),
                                              ),
                                              child: Center(
                                                child: TextField(
                                                  // Gets the right controller using the helper method
                                                  controller: controller.blRemarksTECs[0],
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
                                                  height: sizes.appBarHeight *
                                                      .77,
                                                  padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 8.0,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                    BorderRadius.circular(15),
                                                    color: Colors.white
                                                        .withAlpha(
                                                      31,
                                                    ),
                                                  ),
                                                  child: Center(
                                                    child: TextField(
                                                      // Gets the right controller using the helper method
                                                      controller: controller.notifyCodeTECs[0],
                                                      textAlignVertical:
                                                      TextAlignVertical.center,
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontWeight: FontWeight
                                                            .w700,
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
                                                  height: sizes.appBarHeight *
                                                      .77,
                                                  padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 8.0,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                    BorderRadius.circular(15),
                                                    color: Colors.white
                                                        .withAlpha(
                                                      31,
                                                    ),
                                                  ),
                                                  child: Center(
                                                    child: TextField(
                                                      // Gets the right controller using the helper method
                                                      controller: controller.notifyPartyTECs[0],
                                                      textAlignVertical:
                                                      TextAlignVertical.center,
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontWeight: FontWeight
                                                            .w700,
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
                                                  height: sizes.appBarHeight *
                                                      .77,
                                                  padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 8.0,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                    BorderRadius.circular(15),
                                                    color: Colors.white
                                                        .withAlpha(
                                                      31,
                                                    ),
                                                  ),
                                                  child: Center(
                                                    child: TextField(
                                                      // Gets the right controller using the helper method
                                                      controller: controller.notifyAddressTECs[0],
                                                      textAlignVertical:
                                                      TextAlignVertical.center,
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontWeight: FontWeight
                                                            .w700,
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
                                                    color: Colors.white
                                                        .withAlpha(
                                                      31,
                                                    ),
                                                  ),
                                                  child: Center(
                                                    child: TextField(
                                                      // Gets the right controller using the helper method
                                                      controller: controller.exporterAddressTECs[0],
                                                      textAlignVertical:
                                                      TextAlignVertical.center,
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontWeight: FontWeight
                                                            .w700,
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
                                                  height: sizes.appBarHeight *
                                                      .77,
                                                  padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 8.0,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                    BorderRadius.circular(15),
                                                    color: Colors.white
                                                        .withAlpha(
                                                      31,
                                                    ),
                                                  ),
                                                  child: Center(
                                                    child: TextField(
                                                      // Gets the right controller using the helper method
                                                      controller: controller.placeOfUnloadTECs[0],
                                                      textAlignVertical:
                                                      TextAlignVertical.center,
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontWeight: FontWeight
                                                            .w700,
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
                                                  height: sizes.appBarHeight *
                                                      .77,
                                                  padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 8.0,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                    BorderRadius.circular(15),
                                                    color: Colors.white
                                                        .withAlpha(
                                                      31,
                                                    ),
                                                  ),
                                                  child: Center(
                                                    child: TextField(
                                                      // Gets the right controller using the helper method
                                                      controller: controller.blNatureTECs[0],
                                                      textAlignVertical:
                                                      TextAlignVertical.center,
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontWeight: FontWeight
                                                            .w700,
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
                                                  onTap: () =>
                                                  {
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
                                                    height: sizes.appBarHeight *
                                                        .77,
                                                    padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 11.0,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                      BorderRadius.circular(15),
                                                      color: Colors.white
                                                          .withAlpha(
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
                                                          controller.blTypeCodeTECs[0].value.text.isEmpty ? "MSB" : controller.blTypeCodeTECs[0].value.text,
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
                                                    color: Colors.white
                                                        .withAlpha(
                                                      31,
                                                    ),
                                                  ),
                                                  child: Center(
                                                    child: TextField(
                                                      // Gets the right controller using the helper method
                                                      controller: controller.blLoadPortDtTECs[0],
                                                      textAlignVertical:
                                                      TextAlignVertical.center,
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontWeight: FontWeight
                                                            .w700,
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
                                              padding: const EdgeInsets
                                                  .symmetric(
                                                horizontal: 8.0,
                                              ),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius
                                                    .circular(
                                                  15,
                                                ),
                                                color: Colors.white.withAlpha(
                                                    31),
                                              ),
                                              child: Center(
                                                child: TextField(
                                                  // Gets the right controller using the helper method
                                                  controller: controller.marksTECs[0],
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
                                                  height: sizes.appBarHeight *
                                                      .85,
                                                  child: Center(
                                                    child: Text(
                                                      "Description of Goods",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight: FontWeight
                                                            .w700,
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
                                                    mainAxisSize: MainAxisSize
                                                        .min,
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
                                                        const EdgeInsets
                                                            .symmetric(
                                                          horizontal: 8.0,
                                                        ),
                                                        decoration: BoxDecoration(
                                                          borderRadius:
                                                          BorderRadius.circular(
                                                            25,
                                                          ),
                                                          color: Colors.white
                                                              .withAlpha(31),
                                                        ),
                                                        child: Center(
                                                          child: TextField(
                                                            // Gets the right controller using the helper method
                                                            // controller: controller.getControllerForCell(heading, rowIndex),
                                                            textAlignVertical:
                                                            TextAlignVertical
                                                                .center,
                                                            style: const TextStyle(
                                                              color: Colors
                                                                  .white,
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
                                                          color: Colors.white
                                                              .withAlpha(31),
                                                        ),
                                                        child: Center(
                                                          child: TextField(
                                                            // Gets the right controller using the helper method
                                                            // controller: controller.getControllerForCell(heading, rowIndex),
                                                            textAlignVertical:
                                                            TextAlignVertical
                                                                .center,
                                                            style: const TextStyle(
                                                              color: Colors
                                                                  .white,
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
                                                    mainAxisSize: MainAxisSize
                                                        .min,
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
                                                          color: Colors.white
                                                              .withAlpha(31),
                                                        ),
                                                        child: Center(
                                                          child: TextField(
                                                            // Gets the right controller using the helper method
                                                            // controller: controller.getControllerForCell(heading, rowIndex),
                                                            textAlignVertical:
                                                            TextAlignVertical
                                                                .center,
                                                            style: const TextStyle(
                                                              color: Colors
                                                                  .white,
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
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 17,
                                                                height: 0,
                                                                letterSpacing: 0,
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: GestureDetector(
                                                                onTap: () =>
                                                                {
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
                                                                      .value =
                                                                  !controller
                                                                      .shouldShowBottomSheet
                                                                      .value,
                                                                },
                                                                child: Container(
                                                                  height:
                                                                  (sizes
                                                                      .appBarHeight *
                                                                      .85),
                                                                  decoration:
                                                                  BoxDecoration(
                                                                    borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                      15,
                                                                    ),
                                                                    color: Colors
                                                                        .white
                                                                        .withAlpha(
                                                                      31,
                                                                    ),
                                                                  ),
                                                                  padding:
                                                                  EdgeInsets
                                                                      .symmetric(
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
                                                                        controller.dgStatusTECs[0].value.text.isEmpty ? "No" : controller.dgStatusTECs[0].value.text,
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
                                      var years = getDataOffOfTECs(controller.yearTECs);
                                      var feederVesselNames = getDataOffOfTECs(controller.feederVesselNameTECs);
                                      var fevRotationNos = getDataOffOfTECs(controller.fevRotationNoTECs);
                                      var fvVoys = getDataOffOfTECs(controller.fvVoyTECs);
                                      var netMTs = getDataOffOfTECs(controller.netMTTECs);
                                      var departureDates = getDataOffOfTECs(controller.departureDateTECs);
                                      var depCodes = getDataOffOfTECs(controller.depCodeTECs);
                                      var flagNames = getDataOffOfTECs(controller.flagNameTECs);
                                      var arrivalDates = getDataOffOfTECs(controller.arrivalDateTECs);
                                      var berthingDates = getDataOffOfTECs(controller.berthingDateTECs);
                                      var portOfShipments = getDataOffOfTECs(controller.portOfShipmentTECs);
                                      var flags = getDataOffOfTECs(controller.flagTECs);
                                      var lineNos = getDataOffOfTECs(controller.lineNoTECs);
                                      var contPrefixes = getDataOffOfTECs(controller.contPrefixTECs);
                                      var contNos = getDataOffOfTECs(controller.contNoTECs);
                                      var sizes = getDataOffOfTECs(controller.sizeTECs);
                                      var contTypes = getDataOffOfTECs(controller.contTypeTECs);
                                      var isoCodes = getDataOffOfTECs(controller.isoCodeTECs);
                                      var qtys = getDataOffOfTECs(controller.qtyTECs);
                                      var uoms = getDataOffOfTECs(controller.uomTECs);
                                      var weightKgms = getDataOffOfTECs(controller.weightKgmTECs);
                                      var contVolumes = getDataOffOfTECs(controller.contVolumeTECs);
                                      var vgmQtys = getDataOffOfTECs(controller.vgmQtyTECs);
                                      var cbms = getDataOffOfTECs(controller.cbmTECs);
                                      var sealNos = getDataOffOfTECs(controller.sealNoTECs);
                                      var imcos = getDataOffOfTECs(controller.imcoTECs);
                                      var uns = getDataOffOfTECs(controller.unTECs);
                                      var statuses = getDataOffOfTECs(controller.statusTECs);
                                      var loadPortDts = getDataOffOfTECs(controller.loadPortDtTECs);
                                      var remarks = getDataOffOfTECs(controller.remarksTECs);
                                      var parts = getDataOffOfTECs(controller.partTECs);
                                      var offDocks = getDataOffOfTECs(controller.offDockTECs);
                                      var commoCodes = getDataOffOfTECs(controller.commoCodeTECs);
                                      var perishables = getDataOffOfTECs(controller.perishableTECs);
                                      var portOfLanding = getDataOffOfTECs(controller.portOfLandingTECs);
                                      var slNo = getDataOffOfTECs(controller.slNoTECs);
                                      var blLineNo = getDataOffOfTECs(controller.blLineNoTECs);
                                      var blNo = getDataOffOfTECs(controller.blNoTECs);
                                      var fcl = getDataOffOfTECs(controller.fclTECs);
                                      var fclQty = getDataOffOfTECs(controller.fclQtyTECs);
                                      var lcl = getDataOffOfTECs(controller.lclTECs);
                                      var lclConsolidated = getDataOffOfTECs(controller.lclConsolidatedTECs);
                                      var consigneeCode = getDataOffOfTECs(controller.consigneeCodeTECs);
                                      var consignee = getDataOffOfTECs(controller.consigneeTECs);
                                      var consigneeAddress = getDataOffOfTECs(controller.consigneeAddressTECs);
                                      var exporter = getDataOffOfTECs(controller.exporterTECs);
                                      var blRemarks = getDataOffOfTECs(controller.blRemarksTECs);
                                      var notifyCode = getDataOffOfTECs(controller.notifyCodeTECs);
                                      var notifyParty = getDataOffOfTECs(controller.notifyPartyTECs);
                                      var notifyAddress = getDataOffOfTECs(controller.notifyAddressTECs);
                                      var exporterAddress = getDataOffOfTECs(controller.exporterAddressTECs);
                                      var placeOfUnload = getDataOffOfTECs(controller.placeOfUnloadTECs);
                                      var blNature = getDataOffOfTECs(controller.blNatureTECs);
                                      var blTypeCode = getDataOffOfTECs(controller.blTypeCodeTECs);
                                      var blLoadPortDt = getDataOffOfTECs(controller.blLoadPortDtTECs);
                                      var marks = getDataOffOfTECs(controller.marksTECs);
                                      var quantity = getDataOffOfTECs(controller.quantityTECs);
                                      var quantity2 = getDataOffOfTECs(controller.quantity2TECs);
                                      var commodity = getDataOffOfTECs(controller.commodityTECs);
                                      var dgStatus = getDataOffOfTECs(controller.dgStatusTECs);

                                      ImportBLXMLGeneration importBLXMLGeneration = ImportBLXMLGeneration(years: years, feederVesselNames: feederVesselNames, fevRotationNos: fevRotationNos, fvVoys: fvVoys, netMTs: netMTs, departureDates: departureDates, depCodes: depCodes, flagNames: flagNames, arrivalDates: arrivalDates, berthingDates: berthingDates, portOfShipments: portOfShipments, flags: flags, lineNos: lineNos, contPrefixes: contPrefixes, contNos: contNos, sizes: sizes, contTypes: contTypes, isoCodes: isoCodes, qtys: qtys, uoms: uoms, weightKgms: weightKgms, contVolumes: contVolumes, vgmQtys: vgmQtys, cbms: cbms, sealNos: sealNos, imcos: imcos, uns: uns, statuses: statuses, loadPortDts: loadPortDts, remarks: remarks, parts: parts, offDocks: offDocks, commoCodes: commoCodes, perishables: perishables, portOfLanding: portOfLanding, slNo: slNo, blLineNo: blLineNo, blNo: blNo, fcl: fcl, fclQty: fclQty, lcl: lcl, lclConsolidated: lclConsolidated, consigneeCode: consigneeCode, consignee: consignee, consigneeAddress: consigneeAddress, exporter: exporter, blRemarks: blRemarks, notifyCode: notifyCode, notifyParty: notifyParty, notifyAddress: notifyAddress, exporterAddress: exporterAddress, placeOfUnload: placeOfUnload, blNature: blNature, blTypeCode: blTypeCode, blLoadPortDt: blLoadPortDt, marks: marks, quantity: quantity, quantity2: quantity2, commodity: commodity, dgStatus: dgStatus);
                                      print(dgStatus);
                                      importBLXMLGeneration.generateXML();
                                      // ImportBLXMLGeneration(years: controller.yearTECs.iterator.current.text, feederVesselNames, fevRotationNos, fvVoys, netMTs, departureDates, depCodes, flagNames, arrivalDates, berthingDates, portOfShipments, flags, lineNos, contPrefixes, contNos, sizes, contTypes, isoCodes, qtys, uoms, weightKgms, contVolumes, vgmQtys, cbms, sealNos, imcos, uns, statuses, loadPortDts, remarks, parts, offDocks, commoCodes, perishables, portOfLanding, slNo, blLineNo, blNo, fcl, fclQty, lcl, lclConsolidated, consigneeCode, consignee, consigneeAddress, exporter, blRemarks, notifyCode, notifyParty, notifyAddress, exporterAddress, placeOfUnload, blNature, blTypeCode, blLoadPortDt, marks, quantity, quantity2, commodity, dgStatus)
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
                                              color: Colors.white.withAlpha(31),
                                              borderRadius: BorderRadius
                                                  .circular(
                                                17,
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
                                            ? controller.rowCountForContainer -
                                            1
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
                                      crossAxisAlignment: CrossAxisAlignment
                                          .start,
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
                                                  dataRowHeight: sizes
                                                      .appBarHeight,
                                                  columns: columnsForContainerTable,
                                                  headingRowHeight: 0.0,
                                                  // Generates rows based on the number of controllers we have
                                                  rows: List.generate(controller
                                                      .rowCountForContainer, (
                                                      rowIndex,) {
                                                    return DataRow(
                                                      // Generates cells by iterating through the headings list
                                                      cells: controller
                                                          .containerTableHeadings
                                                          .map((heading,) {
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

                                                                controller.shouldShowBottomSheet.value = true;
                                                                controller.selectedRemarksIndex.value = rowIndex;
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

                                                                controller.shouldShowBottomSheet.value = true;
                                                                controller.selectedStatusIndex.value = rowIndex;
                                                                controller.selectedHeading.value = heading;
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

                                                                controller.shouldShowBottomSheet.value = true;
                                                                controller.selectedPerishableIndex.value = rowIndex;
                                                                controller.selectedHeading.value = heading;
                                                              }
                                                              else {

                                                              }
                                                            },
                                                            child: Container(
                                                              width:
                                                              sizes
                                                                  .calculateTextWidth(
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
                                                              padding: EdgeInsets
                                                                  .symmetric(
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
                                                                BorderRadius
                                                                    .circular(
                                                                  15,
                                                                ),
                                                                color: Colors
                                                                    .white
                                                                    .withAlpha(
                                                                    31),
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
                                                                    controller.remarksTECs[rowIndex ?? 0].value.text == "" ? "Good" : controller.remarksTECs[rowIndex ?? 0].value.text,
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
                                                                    controller.perishableTECs[rowIndex ?? 0].value.text.isEmpty ? "Yes" : controller.perishableTECs[rowIndex ?? 0].value.text,
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
                                                                    controller.statusTECs[rowIndex ?? 0].value.text == "" ? "FCL" : controller.statusTECs[rowIndex ?? 0].value.text,
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
                                                              )
                                                                  : Center(
                                                                child: TextField(
                                                                  // Gets the right controller using the helper method
                                                                  controller: controller
                                                                      .getContainerControllerForCell(
                                                                    heading,
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
                                                                    border:
                                                                    InputBorder
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
                                                      : () =>
                                                  {
                                                    print("+++"),
                                                    controller
                                                        .addRowToContainerTable(),
                                                  },
                                                  child: Padding(
                                                    padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 21.0,
                                                      vertical: 11.0,
                                                    ),
                                                    child: LiquidGlass(
                                                      clipBehavior: Clip
                                                          .antiAlias,
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
                                                        height: sizes
                                                            .appBarHeight,
                                                        child: Center(
                                                          child: Text(
                                                            "       add row      ",
                                                            style: TextStyle(
                                                              color:
                                                              controller
                                                                  .rowCountForContainer >=
                                                                  5
                                                                  ? Colors
                                                                  .white30
                                                                  : Colors
                                                                  .white,
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
                                  controller.portOfShipmentTECs[0].text = controller.bottomSheetTag1.value;
                                  // controller.portOfShipment.value =
                                  //     controller.bottomSheetTag1.value;
                                }
                                if (controller.bottomSheetTag1.value == "MSB") {
                                  controller.blTypeCodeTECs[0].text =
                                      controller.bottomSheetTag1.value;
                                }
                                if (controller.bottomSheetTag1.value == "Yes") {
                                  controller.dgStatusTECs[0].text =
                                      controller.bottomSheetTag1.value;
                                }
                                if (controller.bottomSheetTag1.value == "FCL") {
                                  controller.statusTECs[controller.selectedStatusIndex.value].text =
                                      controller.bottomSheetTag1.value;
                                }
                                if (controller.bottomSheetTag1.value == "Good") {
                                  controller.remarksTECs[controller.selectedRemarksIndex.value].text =
                                      controller.bottomSheetTag1.value;
                                }
                                if (controller.selectedHeading.value == "Perishable") {
                                  controller.perishableTECs[controller.selectedPerishableIndex.value].text =
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
                                  controller.portOfShipmentTECs[0].text = controller.bottomSheetTag2.value;
                                  // controller.portOfShipment.value =
                                  //     controller.bottomSheetTag2.value;
                                }
                                if (controller.bottomSheetTag1.value == "MSB") {
                                  controller.blTypeCodeTECs[0].text =
                                      controller.bottomSheetTag2.value;
                                }
                                if (controller.bottomSheetTag1.value == "Yes") {
                                  controller.dgStatusTECs[0].text =
                                      controller.bottomSheetTag2.value;
                                }
                                if (controller.bottomSheetTag1.value == "FCL") {
                                  controller.statusTECs[controller.selectedStatusIndex.value].text =
                                      controller.bottomSheetTag2.value;
                                }
                                if (controller.bottomSheetTag1.value == "Good") {
                                  controller.remarksTECs[controller.selectedRemarksIndex.value].text =
                                      controller.bottomSheetTag2.value;
                                }
                                if (controller.selectedHeading.value == "Perishable") {
                                  controller.perishableTECs[controller.selectedPerishableIndex.value].text =
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
