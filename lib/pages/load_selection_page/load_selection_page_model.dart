import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/request_manager.dart';

import '/index.dart';
import 'dart:async';
import 'load_selection_page_widget.dart' show LoadSelectionPageWidget;
import 'package:flutter/material.dart';

class LoadSelectionPageModel extends FlutterFlowModel<LoadSelectionPageWidget> {
  ///  Local state fields for this page.

  int? selectedBomb;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - API (Find One Customer)] action in LoadSelectionPage widget.
  ApiCallResponse? customerOutput;
  bool apiRequestCompleted = false;
  String? apiRequestLastUniqueKey;
  // Stores action output result for [Backend Call - API (Find Last Load)] action in Button widget.
  ApiCallResponse? bombOutput;
  // Stores action output result for [Backend Call - API (Resolve Promotion)] action in LoadSelectionPage widget.
  ApiCallResponse? resolvePromotionOutput;

  /// Query cache managers for this widget.

  final _loadManager = FutureRequestManager<ApiCallResponse>();
  Future<ApiCallResponse> load({
    String? uniqueQueryKey,
    bool? overrideCache,
    required Future<ApiCallResponse> Function() requestFn,
  }) =>
      _loadManager.performRequest(
        uniqueQueryKey: uniqueQueryKey,
        overrideCache: overrideCache,
        requestFn: requestFn,
      );
  void clearLoadCache() => _loadManager.clear();
  void clearLoadCacheKey(String? uniqueKey) =>
      _loadManager.clearRequest(uniqueKey);

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    /// Dispose query cache managers for this widget.

    clearLoadCache();
  }

  /// Additional helper methods.
  Future waitForApiRequestCompleted({
    double minWait = 0,
    double maxWait = double.infinity,
  }) async {
    final stopwatch = Stopwatch()..start();
    while (true) {
      await Future.delayed(Duration(milliseconds: 50));
      final timeElapsed = stopwatch.elapsedMilliseconds;
      final requestComplete = apiRequestCompleted;
      if (timeElapsed > maxWait || (requestComplete && timeElapsed > minWait)) {
        break;
      }
    }
  }
}
