import '/backend/api_requests/api_calls.dart';
import '/components/global/light_logotype/light_logotype_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'select_bomb_page_widget.dart' show SelectBombPageWidget;
import 'package:flutter/material.dart';

class SelectBombPageModel extends FlutterFlowModel<SelectBombPageWidget> {
  ///  Local state fields for this page.

  List<int> bombs = [];
  void addToBombs(int item) => bombs.add(item);
  void removeFromBombs(int item) => bombs.remove(item);
  void removeAtIndexFromBombs(int index) => bombs.removeAt(index);
  void insertAtIndexInBombs(int index, int item) => bombs.insert(index, item);
  void updateBombsAtIndex(int index, Function(int) updateFn) =>
      bombs[index] = updateFn(bombs[index]);

  ///  State fields for stateful widgets in this page.

  // Model for LightLogotype component.
  late LightLogotypeModel lightLogotypeModel;
  // Stores action output result for [Backend Call - API (Select Bombs)] action in Button widget.
  ApiCallResponse? selectOutput;

  @override
  void initState(BuildContext context) {
    lightLogotypeModel = createModel(context, () => LightLogotypeModel());
  }

  @override
  void dispose() {
    lightLogotypeModel.dispose();
  }
}
