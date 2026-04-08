import '/auth/custom_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/components/global/light_logotype/light_logotype_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'select_bomb_page_model.dart';
export 'select_bomb_page_model.dart';

class SelectBombPageWidget extends StatefulWidget {
  const SelectBombPageWidget({super.key});

  static String routeName = 'SelectBombPage';
  static String routePath = '/selectBombPage';

  @override
  State<SelectBombPageWidget> createState() => _SelectBombPageWidgetState();
}

class _SelectBombPageWidgetState extends State<SelectBombPageWidget> {
  late SelectBombPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SelectBombPageModel());
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
        body: SafeArea(
          top: true,
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 40.0, 0.0, 0.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        wrapWithModel(
                          model: _model.lightLogotypeModel,
                          updateCallback: () => safeSetState(() {}),
                          child: LightLogotypeWidget(),
                        ),
                      ].divide(SizedBox(height: 4.0)),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Configura tu Turno',
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  font: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w500,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                                  color: FlutterFlowTheme.of(context)
                                      .primaryBackground,
                                  fontSize: 24.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w500,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .fontStyle,
                                ),
                          ),
                          Text(
                            'Selecciona la(s) bomba(s) en las que estarás despachando el día de hoy:',
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  font: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w300,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                  fontSize: 14.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w300,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .fontStyle,
                                  lineHeight: 1.5,
                                ),
                          ),
                        ],
                      ),
                      FutureBuilder<ApiCallResponse>(
                        future: BombsGroup.findManyBombsCall.call(
                          token: currentAuthenticationToken,
                        ),
                        builder: (context, snapshot) {
                          // Customize what your widget looks like when it's loading.
                          if (!snapshot.hasData) {
                            return Center(
                              child: SizedBox(
                                width: 40.0,
                                height: 40.0,
                                child: SpinKitDualRing(
                                  color: FlutterFlowTheme.of(context)
                                      .primaryBackground,
                                  size: 40.0,
                                ),
                              ),
                            );
                          }
                          final columnFindManyBombsResponse = snapshot.data!;

                          return Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Builder(
                                builder: (context) {
                                  final bomb = getJsonField(
                                    columnFindManyBombsResponse.jsonBody,
                                    r'''$''',
                                  ).toList();

                                  return ListView.separated(
                                    padding: EdgeInsets.zero,
                                    primary: false,
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    itemCount: bomb.length,
                                    separatorBuilder: (_, __) =>
                                        SizedBox(height: 10.0),
                                    itemBuilder: (context, bombIndex) {
                                      final bombItem = bomb[bombIndex];
                                      return Opacity(
                                        opacity: getJsonField(
                                          bombItem,
                                          r'''$.available''',
                                        )
                                            ? 1.0
                                            : 0.25,
                                        child: InkWell(
                                          splashColor: Colors.transparent,
                                          focusColor: Colors.transparent,
                                          hoverColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onTap: () async {
                                            if (getJsonField(
                                              bombItem,
                                              r'''$.available''',
                                            )) {
                                              if (_model.bombs
                                                  .contains(getJsonField(
                                                bombItem,
                                                r'''$.bomb''',
                                              ))) {
                                                _model.removeFromBombs(
                                                    getJsonField(
                                                  bombItem,
                                                  r'''$.bomb''',
                                                ));
                                                safeSetState(() {});
                                              } else {
                                                _model.addToBombs(getJsonField(
                                                  bombItem,
                                                  r'''$.bomb''',
                                                ));
                                                safeSetState(() {});
                                              }

                                              return;
                                            } else {
                                              return;
                                            }
                                          },
                                          child: Container(
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              color: valueOrDefault<Color>(
                                                _model.bombs
                                                        .contains(getJsonField(
                                                  bombItem,
                                                  r'''$.bomb''',
                                                ))
                                                    ? Color(0x4D0197F6)
                                                    : Color(0x27FFFFFF),
                                                Color(0x26FFFFFF),
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(6.0),
                                              border: Border.all(
                                                color: valueOrDefault<Color>(
                                                  _model.bombs.contains(
                                                          getJsonField(
                                                    bombItem,
                                                    r'''$.bomb''',
                                                  ))
                                                      ? Color(0x800197F6)
                                                      : Color(0x27FFFFFF),
                                                  Color(0x26FFFFFF),
                                                ),
                                                width: 1.0,
                                              ),
                                            ),
                                            child: Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      16.0, 10.0, 16.0, 10.0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Icon(
                                                    Icons.local_gas_station,
                                                    color:
                                                        valueOrDefault<Color>(
                                                      _model.bombs.contains(
                                                              getJsonField(
                                                        bombItem,
                                                        r'''$.bomb''',
                                                      ))
                                                          ? FlutterFlowTheme.of(
                                                                  context)
                                                              .tertiary
                                                          : FlutterFlowTheme.of(
                                                                  context)
                                                              .primaryBackground,
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .primaryBackground,
                                                    ),
                                                    size: 20.0,
                                                  ),
                                                  Text(
                                                    'Bomba #${getJsonField(
                                                      bombItem,
                                                      r'''$.bomb''',
                                                    ).toString()}',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          font: GoogleFonts
                                                              .poppins(
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontStyle,
                                                          ),
                                                          color: valueOrDefault<
                                                              Color>(
                                                            _model.bombs.contains(
                                                                    getJsonField(
                                                              bombItem,
                                                              r'''$.bomb''',
                                                            ))
                                                                ? FlutterFlowTheme.of(
                                                                        context)
                                                                    .tertiary
                                                                : FlutterFlowTheme.of(
                                                                        context)
                                                                    .primaryBackground,
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primaryBackground,
                                                          ),
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                  ),
                                                ].divide(SizedBox(width: 12.0)),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 16.0, 0.0, 16.0),
                                child: FFButtonWidget(
                                  onPressed: (_model.bombs.length == 0)
                                      ? null
                                      : () async {
                                          var _shouldSetState = false;
                                          _model.selectOutput = await AuthGroup
                                              .selectBombsCall
                                              .call(
                                            bombsList: _model.bombs,
                                            token: currentAuthenticationToken,
                                          );

                                          _shouldSetState = true;
                                          if ((_model.selectOutput?.succeeded ??
                                              true)) {
                                            FFAppState().bombs = _model.bombs
                                                .toList()
                                                .cast<int>();

                                            context.goNamed(
                                                HomePageWidget.routeName);

                                            if (_shouldSetState)
                                              safeSetState(() {});
                                            return;
                                          } else {
                                            await showDialog(
                                              context: context,
                                              builder: (alertDialogContext) {
                                                return AlertDialog(
                                                  title:
                                                      Text('Error de Servidor'),
                                                  content: Text(
                                                      'Ha ocurrido un error desconocido. Por favor, intenta nuevamente más tarde.'),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                              alertDialogContext),
                                                      child: Text('Aceptar'),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                            if (_shouldSetState)
                                              safeSetState(() {});
                                            return;
                                          }

                                          if (_shouldSetState)
                                            safeSetState(() {});
                                        },
                                  text: 'Seleccionar',
                                  options: FFButtonOptions(
                                    width: double.infinity,
                                    height: 48.0,
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        24.0, 0.0, 24.0, 0.0),
                                    iconPadding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 0.0, 0.0, 0.0),
                                    color:
                                        FlutterFlowTheme.of(context).tertiary,
                                    textStyle: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .override(
                                          font: GoogleFonts.poppins(
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .titleSmall
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .titleSmall
                                                    .fontStyle,
                                          ),
                                          color: Colors.white,
                                          letterSpacing: 0.0,
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .titleSmall
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .titleSmall
                                                  .fontStyle,
                                        ),
                                    elevation: 0.0,
                                    borderSide: BorderSide(
                                      color: Colors.transparent,
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(8.0),
                                    disabledColor: Color(0x330197F6),
                                    disabledTextColor: Color(0x32FFFFFF),
                                  ),
                                ),
                              ),
                            ].divide(SizedBox(height: 0.0)),
                          );
                        },
                      ),
                    ].divide(SizedBox(height: 20.0)),
                  ),
                ].divide(SizedBox(height: 40.0)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
