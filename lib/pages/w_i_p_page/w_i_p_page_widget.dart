import '/auth/custom_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/customer_qr_payload.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
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

      _model.assignOutput = await LoadsGroup.assignLoadCall.call(
        customer: customerPayload.customerValueForLoad,
        vehicle: customerPayload.vehicleUuid,
        fleet: customerPayload.fleetUuid,
        token: currentAuthenticationToken,
        product: '2' == getJsonField(widget.bomb, r'''$.codprd''').toString()
            ? 'magna'
            : 'premium',
        quantity: (getJsonField(widget.bomb, r'''$.can''').floor()).toString(),
        price: getJsonField(widget.bomb, r'''$.pre''').toString(),
        total: getJsonField(widget.bomb, r'''$.mto''').toString(),
        date: getJsonField(widget.bomb, r'''$.datetime_combined''').toString(),
      );

      if ((_model.assignOutput?.succeeded ?? true)) {
        context.goNamed(
          SuccessPageWidget.routeName,
          queryParameters: {
            'discount': serializeParam(
              valueOrDefault<String>(
                (getJsonField(
                          (_model.assignOutput?.jsonBody ?? ''),
                          r'''$.quantity''',
                        ) *
                        getJsonField(
                          (_model.assignOutput?.jsonBody ?? ''),
                          r'''$.discount''',
                        ))
                    .toStringAsFixed(2),
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
              content: Text(
                'Ha ocurrido un error al asignar la carga al cliente.',
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
                      color: FlutterFlowTheme.of(context).secondaryBackground,
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
