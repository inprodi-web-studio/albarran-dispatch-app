import '/auth/custom_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/customer_qr_payload.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'w_i_p_page_model.dart';
export 'w_i_p_page_model.dart';

class WIPPageWidget extends StatefulWidget {
  const WIPPageWidget({
    super.key,
    required this.bomb,
    required this.customerUuid,
  });

  final dynamic bomb;
  final String? customerUuid;

  static String routeName = 'WIPPage';
  static String routePath = '/wIPPage';

  @override
  State<WIPPageWidget> createState() => _WIPPageWidgetState();
}

class _WIPPageWidgetState extends State<WIPPageWidget> {
  late WIPPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  String _buildAssignLoadLog({
    required String customerForLoad,
    required String? vehicleUuid,
    required String? fleetUuid,
    required String product,
    required String quantity,
    required String price,
    required String total,
    required String date,
    ApiCallResponse? response,
  }) {
    final lines = <String>[
      '[assignLoad] request',
      'customer: $customerForLoad',
      'vehicle: ${vehicleUuid ?? "null"}',
      'fleet: ${fleetUuid ?? "null"}',
      'product: $product',
      'quantity: $quantity',
      'price: $price',
      'total: $total',
      'date: $date',
      '',
      '[assignLoad] response',
      'status: ${response?.statusCode ?? "null"}',
      'succeeded: ${response?.succeeded ?? false}',
      'body: ${response?.bodyText ?? "(sin body)"}',
      'exception: ${response?.exceptionMessage ?? "(sin exception)"}',
    ];

    return lines.join('\n');
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => WIPPageModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      final customerPayload = CustomerQrPayload.parse(widget.customerUuid);

      if (!customerPayload.isValid) {
        await showDialog(
          context: context,
          builder: (alertDialogContext) {
            return AlertDialog(
              title: Text('QR inválido'),
              content: Text(
                'El código escaneado no contiene información válida.',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(alertDialogContext),
                  child: Text('Aceptar'),
                ),
              ],
            );
          },
        );

        context.pushNamed(HomePageWidget.routeName);

        return;
      }

      final requestProduct =
          '2' == getJsonField(widget.bomb, r'''$.codprd''').toString()
              ? 'magna'
              : 'premium';
      final requestQuantity =
          (getJsonField(widget.bomb, r'''$.can''').floor()).toString();
      final requestPrice = getJsonField(widget.bomb, r'''$.pre''').toString();
      final requestTotal = getJsonField(widget.bomb, r'''$.mto''').toString();
      final requestDate =
          getJsonField(widget.bomb, r'''$.datetime_combined''').toString();

      _model.assignOutput = await LoadsGroup.assignLoadCall.call(
        customer: customerPayload.customerValueForLoad,
        vehicle: customerPayload.vehicleUuid,
        fleet: customerPayload.fleetUuid,
        token: currentAuthenticationToken,
        product: requestProduct,
        quantity: requestQuantity,
        price: requestPrice,
        total: requestTotal,
        date: requestDate,
      );

      final assignLog = _buildAssignLoadLog(
        customerForLoad: customerPayload.customerValueForLoad,
        vehicleUuid: customerPayload.vehicleUuid,
        fleetUuid: customerPayload.fleetUuid,
        product: requestProduct,
        quantity: requestQuantity,
        price: requestPrice,
        total: requestTotal,
        date: requestDate,
        response: _model.assignOutput,
      );
      debugPrint(assignLog);

      if ((_model.assignOutput?.succeeded ?? false)) {
        final quantity = double.tryParse(
              getJsonField(
                (_model.assignOutput?.jsonBody ?? ''),
                r'''$.quantity''',
              ).toString(),
            ) ??
            0;
        final discountPerLiter = double.tryParse(
              getJsonField(
                (_model.assignOutput?.jsonBody ?? ''),
                r'''$.discount''',
              ).toString(),
            ) ??
            0;
        final total = double.tryParse(
              getJsonField(
                (_model.assignOutput?.jsonBody ?? ''),
                r'''$.total''',
              ).toString(),
            ) ??
            0;
        final price = double.tryParse(
              getJsonField(
                (_model.assignOutput?.jsonBody ?? ''),
                r'''$.price''',
              ).toString(),
            ) ??
            0;
        final subtotal = quantity * price;
        final discountTotal = quantity * discountPerLiter;
        final expectedNetTotal =
            (subtotal - discountTotal).clamp(0, double.infinity);
        final totalToCharge =
            (total > expectedNetTotal + 0.009 && discountTotal > 0)
                ? (total - discountTotal).clamp(0, double.infinity)
                : (total > 0 ? total : expectedNetTotal);

        context.goNamed(
          SuccessPageWidget.routeName,
          queryParameters: {
            'discount': serializeParam(
              valueOrDefault<String>(
                discountTotal.toStringAsFixed(2),
                '0',
              ),
              ParamType.String,
            ),
            'totalToCharge': serializeParam(
              valueOrDefault<String>(
                totalToCharge.toStringAsFixed(2),
                '0',
              ),
              ParamType.String,
            ),
          }.withoutNulls,
        );

        return;
      } else {
        await showDialog(
          context: context,
          builder: (alertDialogContext) {
            return AlertDialog(
              title: Text('Error de Servidor'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ha ocurrido un error al asignar la carga al cliente.',
                    ),
                    if (kDebugMode) ...[
                      SizedBox(height: 10.0),
                      SelectableText(
                        assignLog,
                        style: FlutterFlowTheme.of(alertDialogContext)
                            .bodyMedium
                            .override(
                              font: GoogleFonts.robotoMono(
                                fontWeight: FontWeight.w400,
                                fontStyle: FlutterFlowTheme.of(
                                  alertDialogContext,
                                ).bodyMedium.fontStyle,
                              ),
                              fontSize: 11.0,
                              letterSpacing: 0.0,
                            ),
                      ),
                    ],
                  ],
                ),
              ),
              actions: [
                if (kDebugMode)
                  TextButton(
                    onPressed: () async {
                      await Clipboard.setData(ClipboardData(text: assignLog));
                      if (!alertDialogContext.mounted) {
                        return;
                      }
                      ScaffoldMessenger.of(alertDialogContext).showSnackBar(
                        SnackBar(
                          content: Text('Logs copiados'),
                          duration: Duration(milliseconds: 1200),
                        ),
                      );
                    },
                    child: Text('Copiar logs'),
                  ),
                TextButton(
                  onPressed: () => Navigator.pop(alertDialogContext),
                  child: Text('Aceptar'),
                ),
              ],
            );
          },
        );

        context.pushNamed(HomePageWidget.routeName);

        return;
      }
    });
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primary,
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 20.0, 0.0, 0.0),
                child: Lottie.network(
                  'https://lottie.host/a1db721e-ad8c-4638-9980-4a9735b1c564/XqO5kfxfqL.json',
                  width: 200.0,
                  height: 200.0,
                  fit: BoxFit.cover,
                  animate: true,
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Estamos trabajando en ello...\nEsto tomará sólo un par de segundos.',
                    textAlign: TextAlign.center,
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          font: GoogleFonts.poppins(
                            fontWeight: FontWeight.w300,
                            fontStyle: FlutterFlowTheme.of(
                              context,
                            ).bodyMedium.fontStyle,
                          ),
                          color:
                              FlutterFlowTheme.of(context).secondaryBackground,
                          fontSize: 14.0,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w300,
                          fontStyle: FlutterFlowTheme.of(
                            context,
                          ).bodyMedium.fontStyle,
                          lineHeight: 1.5,
                        ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
