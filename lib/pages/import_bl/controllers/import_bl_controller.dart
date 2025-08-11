import 'package:flutter/material.dart';
import 'package:refreshed/refreshed.dart';

class ImportBLController extends GetxController {
  RxBool shouldShowBottomSheet = false.obs;
  RxString bottomSheetTag1 = "".obs;
  RxString bottomSheetTag2 = "".obs;
  RxString portOfShipment = "CTG".obs;
  RxString blTypeCode = "MSB".obs;
  RxString dgStatus = "NO".obs;
  RxString selectedHeading = "".obs;
  RxInt selectedStatusIndex = 0.obs;
  RxInt selectedRemarksIndex = 0.obs;
  RxInt selectedPerishableIndex = 0.obs;
  RxInt selectedBLIndex = 0.obs;
  RxBool emptyFieldEncountered = false.obs;
  RxList<Map<String, String>> empties = [
    {"": ""},
  ].obs;
  final FocusNode _focusNode = FocusNode();

  assignEmpties(String heading, List<RxString> tecs) {
    print("object");
    for(int i = 0; i < tecs.length; i++) {
      if(tecs[i].value.isEmpty) {
        print("$heading-${i.toString()}");
        empties.add({"key" : "$heading-${i.toString()}"});
        emptyFieldEncountered.value = true;
      }
    }
  }

  final List<String> vesselTableHeadings = [
    "Year",
    "Feeder Vessel Name",
    "Fe.V Rotation No.",
    "F.V. Voy",
    "Net MT",
    "Departure Date",
    "Dep. Code",
    "Flag Name",
    "Arrival Date",
    "Berthing Date",
    "Port of Shipment",
    "Flag",
  ];
  final List<String> containerTableHeadings = [
    "Line No.",
    "Cont. Prefix",
    "Cont. No.",
    "Size",
    "Cont. Type",
    "ISO Code",
    "Qty",
    "Uom",
    "Weight (KGM)",
    "Cont. Volume",
    "VGM Qty",
    "CBM",
    "Seal No.",
    "IMCO",
    "Un",
    "Status",
    "Load Port Dt",
    "Remarks",
    "Part",
    "Off Dock",
    "Commo. Code",
    "Perishable",
  ];

  final ScrollController horizontal = ScrollController();

  // --- EXPLICIT, NAMED LISTS OF CONTROLLERS FOR EACH COLUMN ---
  var yearTECs = <TextEditingController>[].obs;
  var feederVesselNameTECs = <TextEditingController>[].obs;
  var fevRotationNoTECs = <TextEditingController>[].obs;
  var fvVoyTECs = <TextEditingController>[].obs;
  var netMTTECs = <TextEditingController>[].obs;
  var departureDateTECs = <TextEditingController>[].obs;
  var depCodeTECs = <TextEditingController>[].obs;
  var flagNameTECs = <TextEditingController>[].obs;
  var arrivalDateTECs = <TextEditingController>[].obs;
  var berthingDateTECs = <TextEditingController>[].obs;
  var portOfShipmentTECs = <TextEditingController>[].obs;
  var flagTECs = <TextEditingController>[].obs;

  var sl_NoTECs = <TextEditingController>[].obs;

  var lineNoTECs = <List<TextEditingController>>[].obs;
  var contPrefixTECs = <List<TextEditingController>>[].obs;
  var contNoTECs = <List<TextEditingController>>[].obs;
  var sizeTECs = <List<TextEditingController>>[].obs;
  var contTypeTECs = <List<TextEditingController>>[].obs;
  var isoCodeTECs = <List<TextEditingController>>[].obs;
  var qtyTECs = <List<TextEditingController>>[].obs;
  var uomTECs = <List<TextEditingController>>[].obs;
  var weightKgmTECs = <List<TextEditingController>>[].obs;
  var contVolumeTECs = <List<TextEditingController>>[].obs;
  var vgmQtyTECs = <List<TextEditingController>>[].obs;
  var cbmTECs = <List<TextEditingController>>[].obs;
  var sealNoTECs = <List<TextEditingController>>[].obs;
  var imcoTECs = <List<TextEditingController>>[].obs;
  var unTECs = <List<TextEditingController>>[].obs;
  var statusTECs = <List<TextEditingController>>[].obs;
  var loadPortDtTECs = <List<TextEditingController>>[].obs;
  var remarksTECs = <List<TextEditingController>>[].obs;
  var partTECs = <List<TextEditingController>>[].obs;
  var offDockTECs = <List<TextEditingController>>[].obs;
  var commoCodeTECs = <List<TextEditingController>>[].obs;
  var perishableTECs = <List<TextEditingController>>[].obs;

  var portOfLandingTECs = <TextEditingController>[].obs;
  var slNoTECs = <TextEditingController>[].obs;
  var blLineNoTECs = <TextEditingController>[].obs;
  var blNoTECs = <TextEditingController>[].obs;
  var fclTECs = <TextEditingController>[].obs;
  var fclQtyTECs = <TextEditingController>[].obs;
  var lclTECs = <TextEditingController>[].obs;
  var lclConsolidatedTECs = <TextEditingController>[].obs;
  var consigneeCodeTECs = <TextEditingController>[].obs;
  var consigneeTECs = <TextEditingController>[].obs;
  var consigneeAddressTECs = <TextEditingController>[].obs;
  var exporterTECs = <TextEditingController>[].obs;
  var blRemarksTECs = <TextEditingController>[].obs;
  var notifyCodeTECs = <TextEditingController>[].obs;
  var notifyPartyTECs = <TextEditingController>[].obs;
  var notifyAddressTECs = <TextEditingController>[].obs;
  var exporterAddressTECs = <TextEditingController>[].obs;
  var placeOfUnloadTECs = <TextEditingController>[].obs;
  var blNatureTECs = <TextEditingController>[].obs;
  var blTypeCodeTECs = <TextEditingController>[].obs;
  var blLoadPortDtTECs = <TextEditingController>[].obs;
  var marksTECs = <TextEditingController>[].obs;
  var quantityTECs = <TextEditingController>[].obs;
  var quantity2TECs = <TextEditingController>[].obs;
  var commodityTECs = <TextEditingController>[].obs;
  var dgStatusTECs = <TextEditingController>[].obs;

  var bankAddressForNoticeToConsigneeTECs = <TextEditingController>[].obs;
  // var sl_NoTECs = <TextEditingController>[].obs;

  // Helper to easily get the row count
  int get rowCount => yearTECs.length;

  int get rowCountForContainer =>
      loadPortDtTECs.isEmpty ? 0 : loadPortDtTECs[selectedBLIndex.value].length;

  // This helper maps a heading string to the correct list of controllers.
  // This keeps the view file clean.
  List<TextEditingController> _getControllerListByHeading(String heading) {
    switch (heading) {
      case "Year":
        return yearTECs;
      case "Feeder Vessel Name":
        return feederVesselNameTECs;
      case "Fe.V Rotation No.":
        return fevRotationNoTECs;
      case "F.V. Voy":
        return fvVoyTECs;
      case "Net MT":
        return netMTTECs;
      case "Departure Date":
        return departureDateTECs;
      case "Dep. Code":
        return depCodeTECs;
      case "Flag Name":
        return flagNameTECs;
      case "Arrival Date":
        return arrivalDateTECs;
      case "Berthing Date":
        return berthingDateTECs;
      case "Port of Shipment":
        return portOfShipmentTECs;
      case "Flag":
        return flagTECs;
      default:
        return []; // Should never happen
    }
  }

  List<TextEditingController> _getContainerControllerListByHeading(
    String heading,
    int blIndex,
  ) {
    switch (heading) {
      case "Line No.":
        return lineNoTECs[blIndex];
      case "Cont. Prefix":
        return contPrefixTECs[blIndex];
      case "Cont. No.":
        return contNoTECs[blIndex];
      case "Size":
        return sizeTECs[blIndex];
      case "Cont. Type":
        return contTypeTECs[blIndex];
      case "ISO Code":
        return isoCodeTECs[blIndex];
      case "Qty":
        return qtyTECs[blIndex];
      case "Uom":
        return uomTECs[blIndex];
      case "Weight (KGM)":
        return weightKgmTECs[blIndex];
      case "Cont. Volume":
        return contVolumeTECs[blIndex];
      case "VGM Qty":
        return vgmQtyTECs[blIndex];
      case "CBM":
        return cbmTECs[blIndex];
      case "Seal No.":
        return sealNoTECs[blIndex];
      case "IMCO":
        return imcoTECs[blIndex];
      case "Un":
        return unTECs[blIndex];
      case "Status":
        return statusTECs[blIndex];
      case "Load Port Dt":
        return loadPortDtTECs[blIndex];
      case "Remarks":
        return remarksTECs[blIndex];
      case "Part":
        return partTECs[blIndex];
      case "Off Dock":
        return offDockTECs[blIndex];
      case "Commo. Code":
        return commoCodeTECs[blIndex];
      case "Perishable":
        return perishableTECs[blIndex];
      default:
        return []; // Should never happen
    }
  }

  // Gets the specific controller for any cell
  TextEditingController getControllerForCell(String heading, int rowIndex) {
    return _getControllerListByHeading(heading)[rowIndex];
  }

  // Gets the specific controller for any cell
  // TextEditingController getControllerForCellForContainerTable(
  //   String heading,
  //   int rowIndex,
  // ) {
  //   return _getContainerControllerListByHeading(heading)[rowIndex];
  // }

  // Gets the specific controller for any cell
  TextEditingController getContainerControllerForCell(
    String heading,
    int blIndex,
    int rowIndex,
  ) {
    return _getContainerControllerListByHeading(heading, blIndex)[rowIndex];
  }

  addTECsToSl_No() {
    sl_NoTECs.add(TextEditingController());
  }

  addTECsToBankAddressForNotice() {
    bankAddressForNoticeToConsigneeTECs.add(TextEditingController());
  }

  @override
  void onInit() {
    super.onInit();
    addRow(); // Start with one row
    addRowToContainerTable();
    addBlTableTECs();
    addTECsToSl_No();
    addTECsToBankAddressForNotice();
  }

  void addRow() {
    if (rowCount >= 5) return;

    // Add one new controller to EACH of the lists
    yearTECs.add(TextEditingController());
    feederVesselNameTECs.add(TextEditingController());
    fevRotationNoTECs.add(TextEditingController());
    fvVoyTECs.add(TextEditingController());
    netMTTECs.add(TextEditingController());
    departureDateTECs.add(TextEditingController());
    depCodeTECs.add(TextEditingController());
    flagNameTECs.add(TextEditingController());
    arrivalDateTECs.add(TextEditingController());
    berthingDateTECs.add(TextEditingController());
    portOfShipmentTECs.add(TextEditingController());
    flagTECs.add(TextEditingController());
  }

  void addRowToContainerTable() {
    // if (rowCountForContainer >= 5) return;

    lineNoTECs.add([TextEditingController()].obs);
    contPrefixTECs.add([TextEditingController()].obs);
    contNoTECs.add([TextEditingController()].obs);
    sizeTECs.add([TextEditingController()].obs);
    contTypeTECs.add([TextEditingController()].obs);
    isoCodeTECs.add([TextEditingController()].obs);
    qtyTECs.add([TextEditingController()].obs);
    uomTECs.add([TextEditingController()].obs);
    weightKgmTECs.add([TextEditingController()].obs);
    contVolumeTECs.add([TextEditingController()].obs);
    vgmQtyTECs.add([TextEditingController()].obs);
    cbmTECs.add([TextEditingController()].obs);
    sealNoTECs.add([TextEditingController()].obs);
    imcoTECs.add([TextEditingController()].obs);
    unTECs.add([TextEditingController()].obs);
    statusTECs.add([TextEditingController()].obs);
    loadPortDtTECs.add([TextEditingController()].obs);
    remarksTECs.add([TextEditingController()].obs);
    partTECs.add([TextEditingController()].obs);
    offDockTECs.add([TextEditingController()].obs);
    commoCodeTECs.add([TextEditingController()].obs);
    perishableTECs.add([TextEditingController()].obs);

    perishableTECs[0][0].text = "NO";
    remarksTECs[0][0].text = "Good";
    statusTECs[0][0].text = "FCL";

  }

  void addRowToSpecificIndexInContainerTable(int index) {
    // if (rowCountForContainer >= 5) return;

    lineNoTECs[index].add(TextEditingController());
    contPrefixTECs[index].add(TextEditingController());
    contNoTECs[index].add(TextEditingController());
    sizeTECs[index].add(TextEditingController());
    contTypeTECs[index].add(TextEditingController());
    isoCodeTECs[index].add(TextEditingController());
    qtyTECs[index].add(TextEditingController());
    uomTECs[index].add(TextEditingController());
    weightKgmTECs[index].add(TextEditingController());
    contVolumeTECs[index].add(TextEditingController());
    vgmQtyTECs[index].add(TextEditingController());
    cbmTECs[index].add(TextEditingController());
    sealNoTECs[index].add(TextEditingController());
    imcoTECs[index].add(TextEditingController());
    unTECs[index].add(TextEditingController());
    statusTECs[index].add(TextEditingController());
    loadPortDtTECs[index].add(TextEditingController());
    remarksTECs[index].add(TextEditingController());
    partTECs[index].add(TextEditingController());
    offDockTECs[index].add(TextEditingController());
    commoCodeTECs[index].add(TextEditingController());
    perishableTECs[index].add(TextEditingController());

    perishableTECs[index][perishableTECs[index].length - 1].text = "NO";
    remarksTECs[index][remarksTECs[index].length - 1].text = "Good";
    statusTECs[index][statusTECs[index].length - 1].text = "FCL";
  }

  void addBlTableTECs() {
    portOfLandingTECs.add(TextEditingController());
    slNoTECs.add(TextEditingController());
    blLineNoTECs.add(TextEditingController());
    blNoTECs.add(TextEditingController());
    fclTECs.add(TextEditingController());
    fclQtyTECs.add(TextEditingController());
    lclTECs.add(TextEditingController());
    lclConsolidatedTECs.add(TextEditingController());
    consigneeCodeTECs.add(TextEditingController());
    consigneeTECs.add(TextEditingController());
    consigneeAddressTECs.add(TextEditingController());
    exporterTECs.add(TextEditingController());
    blRemarksTECs.add(TextEditingController());
    notifyCodeTECs.add(TextEditingController());
    notifyPartyTECs.add(TextEditingController());
    notifyAddressTECs.add(TextEditingController());
    exporterAddressTECs.add(TextEditingController());
    placeOfUnloadTECs.add(TextEditingController());
    blNatureTECs.add(TextEditingController());
    blTypeCodeTECs.add(TextEditingController());
    blLoadPortDtTECs.add(TextEditingController());
    marksTECs.add(TextEditingController());
    quantityTECs.add(TextEditingController());
    quantity2TECs.add(TextEditingController());
    commodityTECs.add(TextEditingController());
    dgStatusTECs.add(TextEditingController());

    blNatureTECs.last.text = "23";
    if(slNoTECs.length == 1) {
      slNoTECs.first.text = "1";
    }
    else {
      slNoTECs.last.text = (int.parse(slNoTECs[slNoTECs.length - 2].text) + 1).toString();
    }

    dgStatusTECs[dgStatusTECs.length - 1].text = "NO";
    portOfLandingTECs[portOfLandingTECs.length - 1].text = "CTG";
    blTypeCodeTECs[blTypeCodeTECs.length - 1].text = "MSB";
  }

  get focusNode => _focusNode;

  @override
  void dispose() {
    // Dispose all controllers in every list to prevent memory leaks
    final allLists = [
      yearTECs,
      feederVesselNameTECs,
      fevRotationNoTECs,
      fvVoyTECs,
      netMTTECs,
      departureDateTECs,
      depCodeTECs,
      flagNameTECs,
      arrivalDateTECs,
      berthingDateTECs,
      portOfShipmentTECs,
      flagTECs,
      lineNoTECs,
      contPrefixTECs,
      contNoTECs,
      sizeTECs,
      contTypeTECs,
      isoCodeTECs,
      qtyTECs,
      uomTECs,
      weightKgmTECs,
      contVolumeTECs,
      vgmQtyTECs,
      cbmTECs,
      sealNoTECs,
      imcoTECs,
      unTECs,
      statusTECs,
      loadPortDtTECs,
      remarksTECs,
      partTECs,
      offDockTECs,
      commoCodeTECs,
      perishableTECs,
    ];
    for (List controllerList in allLists) {
      for (List controller in controllerList) {
        for (var val in controller) {
          val.dispose();
        }
      }
    }
    horizontal.dispose();
    _focusNode.dispose();
    super.dispose();
  }
}
