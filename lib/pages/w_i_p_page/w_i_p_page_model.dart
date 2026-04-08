import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'w_i_p_page_widget.dart' show WIPPageWidget;
import 'package:flutter/material.dart';

class WIPPageModel extends FlutterFlowModel<WIPPageWidget> {
  ///  Local state fields for this page.

  String? product;

  int? quantity;

  int? price;

  int? total;

  int? selectedBomb;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - API (Assign Load)] action in WIPPage widget.
  ApiCallResponse? assignOutput;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
