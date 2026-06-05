import '/backend/api_requests/api_calls.dart';
import '/components/global/light_isotype/light_isotype_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'home_page_widget.dart' show HomePageWidget;
import 'package:flutter/material.dart';

class HomePageModel extends FlutterFlowModel<HomePageWidget> {
  ///  Local state fields for this page.

  int selectedTabIndex = 0;

  ///  State fields for stateful widgets in this page.

  // Model for LightIsotype component.
  late LightIsotypeModel lightIsotypeModel;
  // Stores action output result for [Backend Call - API (Logout)] action in IconButton widget.
  ApiCallResponse? logoutOutput;
  // Stores action output result for [Backend Call - API (Logout With Report)] action in IconButton widget.
  ApiCallResponse? logoutWithReportOutput;
  // Stores action output result for [Backend Call - API (Current Shift Report)] action in HomePage widget.
  ApiCallResponse? currentShiftReportOutput;
  var scannedOutput = '';
  // State field(s) for Debug QR input widget.
  FocusNode? debugQrFocusNode;
  TextEditingController? debugQrTextController;

  @override
  void initState(BuildContext context) {
    lightIsotypeModel = createModel(context, () => LightIsotypeModel());
  }

  @override
  void dispose() {
    lightIsotypeModel.dispose();
    debugQrFocusNode?.dispose();
    debugQrTextController?.dispose();
  }
}
