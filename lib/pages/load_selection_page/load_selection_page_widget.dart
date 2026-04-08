import '/auth/custom_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/customer_qr_payload.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/index.dart';
import 'package:styled_divider/styled_divider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'load_selection_page_model.dart';
export 'load_selection_page_model.dart';

class LoadSelectionPageWidget extends StatefulWidget {
  const LoadSelectionPageWidget({super.key, required this.customerUuid});

  final String? customerUuid;

  static String routeName = 'LoadSelectionPage';
  static String routePath = '/loadSelectionPage';

  @override
  State<LoadSelectionPageWidget> createState() =>
      _LoadSelectionPageWidgetState();
}

class _LoadSelectionPageWidgetState extends State<LoadSelectionPageWidget> {
  late LoadSelectionPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => LoadSelectionPageModel());

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

        context.goNamed(HomePageWidget.routeName);

        return;
      }

      if (FFAppState().bombs.length == 0) {
        context.pushNamed(SelectBombPageWidget.routeName);

        return;
      } else {
        _model.customerOutput = await CustomersGroup.findOneCustomerCall.call(
          token: currentAuthenticationToken,
          uuid: customerPayload.customerUuid,
        );

        if ((_model.customerOutput?.succeeded ?? true)) {
          return;
        }

        await showDialog(
          context: context,
          builder: (alertDialogContext) {
            return AlertDialog(
              title: Text('Cliente no Encontrado'),
              content: Text(
                'No hemos encontrado ningún cliente con el QR scaneado.',
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

        context.goNamed(HomePageWidget.routeName);

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
    context.watch<FFAppState>();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primary,
        body: NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: (context, _) => [
            SliverAppBar(
              pinned: false,
              floating: true,
              snap: false,
              backgroundColor: FlutterFlowTheme.of(context).primary,
              automaticallyImplyLeading: false,
              leading: Align(
                alignment: AlignmentDirectional(0.0, 0.0),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 0.0, 0.0),
                  child: FlutterFlowIconButton(
                    borderColor: Colors.transparent,
                    borderRadius: 40.0,
                    borderWidth: 0.0,
                    buttonSize: 40.0,
                    fillColor: Color(0x32FFFFFF),
                    icon: Icon(
                      Icons.close,
                      color: FlutterFlowTheme.of(context).primaryBackground,
                      size: 20.0,
                    ),
                    onPressed: () async {
                      context.goNamed(
                        HomePageWidget.routeName,
                        extra: <String, dynamic>{
                          '__transition_info__': TransitionInfo(
                            hasTransition: true,
                            transitionType: PageTransitionType.topToBottom,
                          ),
                        },
                      );
                    },
                  ),
                ),
              ),
              actions: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(
                        0.0,
                        0.0,
                        16.0,
                        0.0,
                      ),
                      child: FlutterFlowIconButton(
                        borderRadius: 40.0,
                        buttonSize: 40.0,
                        fillColor: Color(0x32FFFFFF),
                        icon: Icon(
                          Icons.refresh_sharp,
                          color: FlutterFlowTheme.of(context).primaryBackground,
                          size: 20.0,
                        ),
                        onPressed: () async {
                          safeSetState(() {
                            _model.clearLoadCacheKey(
                              _model.apiRequestLastUniqueKey,
                            );
                            _model.apiRequestCompleted = false;
                          });
                          await _model.waitForApiRequestCompleted();
                        },
                      ),
                    ),
                  ],
                ),
              ],
              centerTitle: false,
              elevation: 0.0,
            ),
          ],
          body: Builder(
            builder: (context) {
              return Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(),
                child: Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  'Selecciona una Carga',
                                  style: FlutterFlowTheme.of(context).bodyMedium
                                      .override(
                                        font: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w500,
                                          fontStyle: FlutterFlowTheme.of(
                                            context,
                                          ).bodyMedium.fontStyle,
                                        ),
                                        color: FlutterFlowTheme.of(
                                          context,
                                        ).primaryBackground,
                                        fontSize: 24.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w500,
                                        fontStyle: FlutterFlowTheme.of(
                                          context,
                                        ).bodyMedium.fontStyle,
                                      ),
                                ),
                                Text(
                                  'A continuación te mostramos la última carga de las bombas en las que estás despachando. Selecciona la carga a la que se relacionará al descuento del cliente.',
                                  style: FlutterFlowTheme.of(context).bodyMedium
                                      .override(
                                        font: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w300,
                                          fontStyle: FlutterFlowTheme.of(
                                            context,
                                          ).bodyMedium.fontStyle,
                                        ),
                                        color: FlutterFlowTheme.of(
                                          context,
                                        ).secondaryBackground,
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
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                0.0,
                                20.0,
                                0.0,
                                56.0,
                              ),
                              child: Builder(
                                builder: (context) {
                                  final bomb = FFAppState().bombs.toList();

                                  return ListView.separated(
                                    padding: EdgeInsets.zero,
                                    primary: false,
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    itemCount: bomb.length,
                                    separatorBuilder: (_, __) =>
                                        SizedBox(height: 24.0),
                                    itemBuilder: (context, bombIndex) {
                                      final bombItem = bomb[bombIndex];
                                      return Column(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          Text(
                                            'Bomba #${bombItem.toString()}',
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  font: GoogleFonts.poppins(
                                                    fontWeight: FontWeight.w500,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                          context,
                                                        ).bodyMedium.fontStyle,
                                                  ),
                                                  color: FlutterFlowTheme.of(
                                                    context,
                                                  ).primaryBackground,
                                                  fontSize: 18.0,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.w500,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                        context,
                                                      ).bodyMedium.fontStyle,
                                                ),
                                          ),
                                          FutureBuilder<ApiCallResponse>(
                                            future: _model
                                                .load(
                                                  uniqueQueryKey: bombItem
                                                      .toString(),
                                                  requestFn: () => LoadsGroup
                                                      .findLastLoadCall
                                                      .call(
                                                        token:
                                                            currentAuthenticationToken,
                                                        bombId: bombItem,
                                                      ),
                                                )
                                                .then((result) {
                                                  try {
                                                    _model.apiRequestCompleted =
                                                        true;
                                                    _model.apiRequestLastUniqueKey =
                                                        bombItem.toString();
                                                  } finally {}
                                                  return result;
                                                }),
                                            builder: (context, snapshot) {
                                              // Customize what your widget looks like when it's loading.
                                              if (!snapshot.hasData) {
                                                return Center(
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsetsDirectional.fromSTEB(
                                                          0.0,
                                                          30.0,
                                                          0.0,
                                                          30.0,
                                                        ),
                                                    child: SizedBox(
                                                      width: 30.0,
                                                      height: 30.0,
                                                      child: SpinKitDualRing(
                                                        color:
                                                            FlutterFlowTheme.of(
                                                              context,
                                                            ).primaryBackground,
                                                        size: 30.0,
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              }
                                              final containerFindLastLoadResponse =
                                                  snapshot.data!;

                                              return InkWell(
                                                splashColor: Colors.transparent,
                                                focusColor: Colors.transparent,
                                                hoverColor: Colors.transparent,
                                                highlightColor:
                                                    Colors.transparent,
                                                onTap: () async {
                                                  if (getJsonField(
                                                        containerFindLastLoadResponse
                                                            .jsonBody,
                                                        r'''$.can''',
                                                      ) !=
                                                      null) {
                                                    _model.selectedBomb =
                                                        bombItem;
                                                    safeSetState(() {});
                                                    return;
                                                  } else {
                                                    return;
                                                  }
                                                },
                                                child: Container(
                                                  width: double.infinity,
                                                  decoration: BoxDecoration(
                                                    color:
                                                        valueOrDefault<Color>(
                                                          _model.selectedBomb ==
                                                                  bombItem
                                                              ? Color(
                                                                  0x4C0197F6,
                                                                )
                                                              : Color(
                                                                  0x27FFFFFF,
                                                                ),
                                                          Color(0x25FFFFFF),
                                                        ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          6.0,
                                                        ),
                                                    border: Border.all(
                                                      color:
                                                          valueOrDefault<Color>(
                                                            _model.selectedBomb ==
                                                                    bombItem
                                                                ? Color(
                                                                    0x800197F6,
                                                                  )
                                                                : Color(
                                                                    0x27FFFFFF,
                                                                  ),
                                                            Color(0x25FFFFFF),
                                                          ),
                                                      width: 1.0,
                                                    ),
                                                  ),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      if (getJsonField(
                                                            containerFindLastLoadResponse
                                                                .jsonBody,
                                                            r'''$.can''',
                                                          ) !=
                                                          null)
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                10.0,
                                                              ),
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children:
                                                                [
                                                                  Row(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .max,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Text(
                                                                        'Hora de Carga:',
                                                                        style:
                                                                            FlutterFlowTheme.of(
                                                                              context,
                                                                            ).bodyMedium.override(
                                                                              font: GoogleFonts.poppins(
                                                                                fontWeight: FlutterFlowTheme.of(
                                                                                  context,
                                                                                ).bodyMedium.fontWeight,
                                                                                fontStyle: FlutterFlowTheme.of(
                                                                                  context,
                                                                                ).bodyMedium.fontStyle,
                                                                              ),
                                                                              color: FlutterFlowTheme.of(
                                                                                context,
                                                                              ).primaryBackground,
                                                                              letterSpacing: 0.0,
                                                                              fontWeight: FlutterFlowTheme.of(
                                                                                context,
                                                                              ).bodyMedium.fontWeight,
                                                                              fontStyle: FlutterFlowTheme.of(
                                                                                context,
                                                                              ).bodyMedium.fontStyle,
                                                                            ),
                                                                      ),
                                                                      Text(
                                                                        getJsonField(
                                                                          containerFindLastLoadResponse
                                                                              .jsonBody,
                                                                          r'''$.converted_time''',
                                                                        ).toString(),
                                                                        style:
                                                                            FlutterFlowTheme.of(
                                                                              context,
                                                                            ).bodyMedium.override(
                                                                              font: GoogleFonts.poppins(
                                                                                fontWeight: FontWeight.w600,
                                                                                fontStyle: FlutterFlowTheme.of(
                                                                                  context,
                                                                                ).bodyMedium.fontStyle,
                                                                              ),
                                                                              color: FlutterFlowTheme.of(
                                                                                context,
                                                                              ).primaryBackground,
                                                                              letterSpacing: 0.0,
                                                                              fontWeight: FontWeight.w600,
                                                                              fontStyle: FlutterFlowTheme.of(
                                                                                context,
                                                                              ).bodyMedium.fontStyle,
                                                                            ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  Row(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .max,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Text(
                                                                        'Cantidad:',
                                                                        style:
                                                                            FlutterFlowTheme.of(
                                                                              context,
                                                                            ).bodyMedium.override(
                                                                              font: GoogleFonts.poppins(
                                                                                fontWeight: FlutterFlowTheme.of(
                                                                                  context,
                                                                                ).bodyMedium.fontWeight,
                                                                                fontStyle: FlutterFlowTheme.of(
                                                                                  context,
                                                                                ).bodyMedium.fontStyle,
                                                                              ),
                                                                              color: FlutterFlowTheme.of(
                                                                                context,
                                                                              ).primaryBackground,
                                                                              letterSpacing: 0.0,
                                                                              fontWeight: FlutterFlowTheme.of(
                                                                                context,
                                                                              ).bodyMedium.fontWeight,
                                                                              fontStyle: FlutterFlowTheme.of(
                                                                                context,
                                                                              ).bodyMedium.fontStyle,
                                                                            ),
                                                                      ),
                                                                      Text(
                                                                        '${num.tryParse(getJsonField(containerFindLastLoadResponse.jsonBody, r'''$.can''').toString())?.toStringAsFixed(2)} Litros',
                                                                        style:
                                                                            FlutterFlowTheme.of(
                                                                              context,
                                                                            ).bodyMedium.override(
                                                                              font: GoogleFonts.poppins(
                                                                                fontWeight: FontWeight.w600,
                                                                                fontStyle: FlutterFlowTheme.of(
                                                                                  context,
                                                                                ).bodyMedium.fontStyle,
                                                                              ),
                                                                              color: FlutterFlowTheme.of(
                                                                                context,
                                                                              ).primaryBackground,
                                                                              letterSpacing: 0.0,
                                                                              fontWeight: FontWeight.w600,
                                                                              fontStyle: FlutterFlowTheme.of(
                                                                                context,
                                                                              ).bodyMedium.fontStyle,
                                                                            ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  Row(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .max,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Text(
                                                                        'Precio:',
                                                                        style:
                                                                            FlutterFlowTheme.of(
                                                                              context,
                                                                            ).bodyMedium.override(
                                                                              font: GoogleFonts.poppins(
                                                                                fontWeight: FlutterFlowTheme.of(
                                                                                  context,
                                                                                ).bodyMedium.fontWeight,
                                                                                fontStyle: FlutterFlowTheme.of(
                                                                                  context,
                                                                                ).bodyMedium.fontStyle,
                                                                              ),
                                                                              color: FlutterFlowTheme.of(
                                                                                context,
                                                                              ).primaryBackground,
                                                                              letterSpacing: 0.0,
                                                                              fontWeight: FlutterFlowTheme.of(
                                                                                context,
                                                                              ).bodyMedium.fontWeight,
                                                                              fontStyle: FlutterFlowTheme.of(
                                                                                context,
                                                                              ).bodyMedium.fontStyle,
                                                                            ),
                                                                      ),
                                                                      Text(
                                                                        '\$${num.tryParse(getJsonField(containerFindLastLoadResponse.jsonBody, r'''$.pre''').toString())?.toStringAsFixed(2)}',
                                                                        style:
                                                                            FlutterFlowTheme.of(
                                                                              context,
                                                                            ).bodyMedium.override(
                                                                              font: GoogleFonts.poppins(
                                                                                fontWeight: FontWeight.w600,
                                                                                fontStyle: FlutterFlowTheme.of(
                                                                                  context,
                                                                                ).bodyMedium.fontStyle,
                                                                              ),
                                                                              color: FlutterFlowTheme.of(
                                                                                context,
                                                                              ).primaryBackground,
                                                                              letterSpacing: 0.0,
                                                                              fontWeight: FontWeight.w600,
                                                                              fontStyle: FlutterFlowTheme.of(
                                                                                context,
                                                                              ).bodyMedium.fontStyle,
                                                                            ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  Row(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .max,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Text(
                                                                        'Gasolina:',
                                                                        style:
                                                                            FlutterFlowTheme.of(
                                                                              context,
                                                                            ).bodyMedium.override(
                                                                              font: GoogleFonts.poppins(
                                                                                fontWeight: FlutterFlowTheme.of(
                                                                                  context,
                                                                                ).bodyMedium.fontWeight,
                                                                                fontStyle: FlutterFlowTheme.of(
                                                                                  context,
                                                                                ).bodyMedium.fontStyle,
                                                                              ),
                                                                              color: FlutterFlowTheme.of(
                                                                                context,
                                                                              ).primaryBackground,
                                                                              letterSpacing: 0.0,
                                                                              fontWeight: FlutterFlowTheme.of(
                                                                                context,
                                                                              ).bodyMedium.fontWeight,
                                                                              fontStyle: FlutterFlowTheme.of(
                                                                                context,
                                                                              ).bodyMedium.fontStyle,
                                                                            ),
                                                                      ),
                                                                      Text(
                                                                        '1' ==
                                                                                getJsonField(
                                                                                  containerFindLastLoadResponse.jsonBody,
                                                                                  r'''$.codprd''',
                                                                                ).toString()
                                                                            ? 'Premium'
                                                                            : 'Regular',
                                                                        style:
                                                                            FlutterFlowTheme.of(
                                                                              context,
                                                                            ).bodyMedium.override(
                                                                              font: GoogleFonts.poppins(
                                                                                fontWeight: FontWeight.w600,
                                                                                fontStyle: FlutterFlowTheme.of(
                                                                                  context,
                                                                                ).bodyMedium.fontStyle,
                                                                              ),
                                                                              color: FlutterFlowTheme.of(
                                                                                context,
                                                                              ).primaryBackground,
                                                                              letterSpacing: 0.0,
                                                                              fontWeight: FontWeight.w600,
                                                                              fontStyle: FlutterFlowTheme.of(
                                                                                context,
                                                                              ).bodyMedium.fontStyle,
                                                                            ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  StyledDivider(
                                                                    thickness:
                                                                        1.0,
                                                                    color: Color(
                                                                      0x3FFFFFFF,
                                                                    ),
                                                                    lineStyle:
                                                                        DividerLineStyle
                                                                            .dashed,
                                                                  ),
                                                                  Row(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .max,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Text(
                                                                        'Importe:',
                                                                        style:
                                                                            FlutterFlowTheme.of(
                                                                              context,
                                                                            ).bodyMedium.override(
                                                                              font: GoogleFonts.poppins(
                                                                                fontWeight: FlutterFlowTheme.of(
                                                                                  context,
                                                                                ).bodyMedium.fontWeight,
                                                                                fontStyle: FlutterFlowTheme.of(
                                                                                  context,
                                                                                ).bodyMedium.fontStyle,
                                                                              ),
                                                                              color: FlutterFlowTheme.of(
                                                                                context,
                                                                              ).primaryBackground,
                                                                              letterSpacing: 0.0,
                                                                              fontWeight: FlutterFlowTheme.of(
                                                                                context,
                                                                              ).bodyMedium.fontWeight,
                                                                              fontStyle: FlutterFlowTheme.of(
                                                                                context,
                                                                              ).bodyMedium.fontStyle,
                                                                            ),
                                                                      ),
                                                                      Text(
                                                                        '\$${num.tryParse(getJsonField(containerFindLastLoadResponse.jsonBody, r'''$.mto''').toString())?.toStringAsFixed(2)}',
                                                                        style:
                                                                            FlutterFlowTheme.of(
                                                                              context,
                                                                            ).bodyMedium.override(
                                                                              font: GoogleFonts.poppins(
                                                                                fontWeight: FontWeight.w600,
                                                                                fontStyle: FlutterFlowTheme.of(
                                                                                  context,
                                                                                ).bodyMedium.fontStyle,
                                                                              ),
                                                                              color: FlutterFlowTheme.of(
                                                                                context,
                                                                              ).primaryBackground,
                                                                              fontSize: 20.0,
                                                                              letterSpacing: 0.0,
                                                                              fontWeight: FontWeight.w600,
                                                                              fontStyle: FlutterFlowTheme.of(
                                                                                context,
                                                                              ).bodyMedium.fontStyle,
                                                                            ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ].divide(
                                                                  SizedBox(
                                                                    height: 8.0,
                                                                  ),
                                                                ),
                                                          ),
                                                        ),
                                                      if (getJsonField(
                                                            containerFindLastLoadResponse
                                                                .jsonBody,
                                                            r'''$.can''',
                                                          ) ==
                                                          null)
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                10.0,
                                                              ),
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .stretch,
                                                            children:
                                                                [
                                                                  Icon(
                                                                    Icons
                                                                        .local_gas_station,
                                                                    color: FlutterFlowTheme.of(
                                                                      context,
                                                                    ).primaryBackground,
                                                                    size: 24.0,
                                                                  ),
                                                                  Text(
                                                                    'Sin Cargas Disponibles',
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                      font: GoogleFonts.poppins(
                                                                        fontWeight: FlutterFlowTheme.of(
                                                                          context,
                                                                        ).bodyMedium.fontWeight,
                                                                        fontStyle: FlutterFlowTheme.of(
                                                                          context,
                                                                        ).bodyMedium.fontStyle,
                                                                      ),
                                                                      color: FlutterFlowTheme.of(
                                                                        context,
                                                                      ).primaryBackground,
                                                                      letterSpacing:
                                                                          0.0,
                                                                      fontWeight: FlutterFlowTheme.of(
                                                                        context,
                                                                      ).bodyMedium.fontWeight,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                        context,
                                                                      ).bodyMedium.fontStyle,
                                                                    ),
                                                                  ),
                                                                ].divide(
                                                                  SizedBox(
                                                                    height:
                                                                        10.0,
                                                                  ),
                                                                ),
                                                          ),
                                                        ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ].divide(SizedBox(height: 4.0)),
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (_model.selectedBomb != null)
                      Align(
                        alignment: AlignmentDirectional(0.0, 1.0),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                            0.0,
                            0.0,
                            0.0,
                            16.0,
                          ),
                          child: FFButtonWidget(
                            onPressed: () async {
                              var _shouldSetState = false;
                              var confirmDialogResponse =
                                  await showDialog<bool>(
                                    context: context,
                                    builder: (alertDialogContext) {
                                      return AlertDialog(
                                        title: Text('Asignar Despacho'),
                                        content: Text(
                                          'Al aceptar se asignará el despacho al ciente y se aplicarán los descuentos correspondientes. Esta acción no será reversible.',
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.pop(
                                              alertDialogContext,
                                              false,
                                            ),
                                            child: Text('Cancelar'),
                                          ),
                                          TextButton(
                                            onPressed: () => Navigator.pop(
                                              alertDialogContext,
                                              true,
                                            ),
                                            child: Text('Confirmar'),
                                          ),
                                        ],
                                      );
                                    },
                                  ) ??
                                  false;
                              if (confirmDialogResponse) {
                                _model.bombOutput = await LoadsGroup
                                    .findLastLoadCall
                                    .call(
                                      token: currentAuthenticationToken,
                                      bombId: _model.selectedBomb,
                                    );

                                _shouldSetState = true;

                                context.goNamed(
                                  WIPPageWidget.routeName,
                                  queryParameters: {
                                    'bomb': serializeParam(
                                      getJsonField(
                                        (_model.bombOutput?.jsonBody ?? ''),
                                        r'''$''',
                                      ),
                                      ParamType.JSON,
                                    ),
                                    'customerUuid': serializeParam(
                                      widget.customerUuid,
                                      ParamType.String,
                                    ),
                                  }.withoutNulls,
                                );

                                if (_shouldSetState) safeSetState(() {});
                                return;
                              } else {
                                if (_shouldSetState) safeSetState(() {});
                                return;
                              }

                              if (_shouldSetState) safeSetState(() {});
                            },
                            text: 'Seleccionar Carga',
                            icon: Icon(Icons.check, size: 20.0),
                            options: FFButtonOptions(
                              height: 40.0,
                              padding: EdgeInsetsDirectional.fromSTEB(
                                24.0,
                                0.0,
                                24.0,
                                0.0,
                              ),
                              iconPadding: EdgeInsetsDirectional.fromSTEB(
                                0.0,
                                0.0,
                                0.0,
                                0.0,
                              ),
                              color: FlutterFlowTheme.of(context).tertiary,
                              textStyle: FlutterFlowTheme.of(context).titleSmall
                                  .override(
                                    font: GoogleFonts.poppins(
                                      fontWeight: FlutterFlowTheme.of(
                                        context,
                                      ).titleSmall.fontWeight,
                                      fontStyle: FlutterFlowTheme.of(
                                        context,
                                      ).titleSmall.fontStyle,
                                    ),
                                    color: Colors.white,
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(
                                      context,
                                    ).titleSmall.fontWeight,
                                    fontStyle: FlutterFlowTheme.of(
                                      context,
                                    ).titleSmall.fontStyle,
                                  ),
                              elevation: 3.0,
                              borderSide: BorderSide(
                                color: Colors.transparent,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
