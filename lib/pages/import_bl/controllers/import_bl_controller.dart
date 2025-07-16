import 'package:flutter/material.dart';
import 'package:refreshed/refreshed.dart';

class ImportBLController extends GetxController {

  RxBool shouldShowBottomSheet = false.obs;
  RxString bottomSheetTag1 = "".obs;
  RxString bottomSheetTag2 = "".obs;
  RxString portOfShipment = "CTG".obs;
  RxString blTypeCode = "MSB".obs;
  RxString dgStatus = "No".obs;
  RxString selectedHeading = "".obs;
  RxInt selectedStatusIndex = 0.obs;
  RxInt selectedRemarksIndex = 0.obs;
  RxInt selectedPerishableIndex = 0.obs;

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

  var lineNoTECs = <TextEditingController>[].obs;
  var contPrefixTECs = <TextEditingController>[].obs;
  var contNoTECs = <TextEditingController>[].obs;
  var sizeTECs = <TextEditingController>[].obs;
  var contTypeTECs = <TextEditingController>[].obs;
  var isoCodeTECs = <TextEditingController>[].obs;
  var qtyTECs = <TextEditingController>[].obs;
  var uomTECs = <TextEditingController>[].obs;
  var weightKgmTECs = <TextEditingController>[].obs;
  var contVolumeTECs = <TextEditingController>[].obs;
  var vgmQtyTECs = <TextEditingController>[].obs;
  var cbmTECs = <TextEditingController>[].obs;
  var sealNoTECs = <TextEditingController>[].obs;
  var imcoTECs = <TextEditingController>[].obs;
  var unTECs = <TextEditingController>[].obs;
  var statusTECs = <TextEditingController>[].obs;
  var loadPortDtTECs = <TextEditingController>[].obs;
  var remarksTECs = <TextEditingController>[].obs;
  var partTECs = <TextEditingController>[].obs;
  var offDockTECs = <TextEditingController>[].obs;
  var commoCodeTECs = <TextEditingController>[].obs;
  var perishableTECs = <TextEditingController>[].obs;

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
  var sl_NoTECs = <TextEditingController>[].obs;

  // Helper to easily get the row count
  int get rowCount => yearTECs.length;
  int get rowCountForContainer => loadPortDtTECs.length;

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
  ) {
    switch (heading) {
      case "Line No.":
        return lineNoTECs;
      case "Cont. Prefix":
        return contPrefixTECs;
      case "Cont. No.":
        return contNoTECs;
      case "Size":
        return sizeTECs;
      case "Cont. Type":
        return contTypeTECs;
      case "ISO Code":
        return isoCodeTECs;
      case "Qty":
        return qtyTECs;
      case "Uom":
        return uomTECs;
      case "Weight (KGM)":
        return weightKgmTECs;
      case "Cont. Volume":
        return contVolumeTECs;
      case "VGM Qty":
        return vgmQtyTECs;
      case "CBM":
        return cbmTECs;
      case "Seal No.":
        return sealNoTECs;
      case "IMCO":
        return imcoTECs;
      case "Un":
        return unTECs;
      case "Status":
        return statusTECs;
      case "Load Port Dt":
        return loadPortDtTECs;
      case "Remarks":
        return remarksTECs;
      case "Part":
        return partTECs;
      case "Off Dock":
        return offDockTECs;
      case "Commo. Code":
        return commoCodeTECs;
      case "Perishable":
        return perishableTECs;
      default:
        return []; // Should never happen
    }
  }

  // Gets the specific controller for any cell
  TextEditingController getControllerForCell(String heading, int rowIndex) {
    return _getControllerListByHeading(heading)[rowIndex];
  }

  // Gets the specific controller for any cell
  TextEditingController getControllerForCellForContainerTable(String heading, int rowIndex) {
    return _getContainerControllerListByHeading(heading)[rowIndex];
  }

  // Gets the specific controller for any cell
  TextEditingController getContainerControllerForCell(
    String heading,
    int rowIndex,
  ) {
    return _getContainerControllerListByHeading(heading)[rowIndex];
  }

  @override
  void onInit() {
    super.onInit();
    addRow(); // Start with one row
    addRowToContainerTable();
    prepareBlTableTECs();
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
    if (rowCountForContainer >= 5) return;

    lineNoTECs.add(TextEditingController());
    contPrefixTECs.add(TextEditingController());
    contNoTECs.add(TextEditingController());
    sizeTECs.add(TextEditingController());
    contTypeTECs.add(TextEditingController());
    isoCodeTECs.add(TextEditingController());
    qtyTECs.add(TextEditingController());
    uomTECs.add(TextEditingController());
    weightKgmTECs.add(TextEditingController());
    contVolumeTECs.add(TextEditingController());
    vgmQtyTECs.add(TextEditingController());
    cbmTECs.add(TextEditingController());
    sealNoTECs.add(TextEditingController());
    imcoTECs.add(TextEditingController());
    unTECs.add(TextEditingController());
    statusTECs.add(TextEditingController());
    loadPortDtTECs.add(TextEditingController());
    remarksTECs.add(TextEditingController());
    partTECs.add(TextEditingController());
    offDockTECs.add(TextEditingController());
    commoCodeTECs.add(TextEditingController());
    perishableTECs.add(TextEditingController());
  }

  void prepareBlTableTECs() {
    // if (rowCountForContainer >= 5) return;

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


     dgStatusTECs[0].text = "No";
     portOfLandingTECs[0].text = "CTG";
     blTypeCodeTECs[0].text = "MSB";

  }

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
    for (var controllerList in allLists) {
      for (var controller in controllerList) {
        controller.dispose();
      }
    }
    horizontal.dispose();
    super.dispose();
  }
}
