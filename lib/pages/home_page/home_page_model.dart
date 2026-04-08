import '/backend/api_requests/api_calls.dart';
import '/components/global/light_isotype/light_isotype_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'home_page_widget.dart' show HomePageWidget;
import 'package:flutter/material.dart';

class HomePageModel extends FlutterFlowModel<HomePageWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for LightIsotype component.
  late LightIsotypeModel lightIsotypeModel;
  // Stores action output result for [Backend Call - API (Logout)] action in IconButton widget.
  ApiCallResponse? logoutOutput;
  var scannedOutput = '';

  @override
  void initState(BuildContext context) {
    lightIsotypeModel = createModel(context, () => LightIsotypeModel());
  }

  @override
  void dispose() {
    lightIsotypeModel.dispose();
  }
}
