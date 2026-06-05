import '/auth/custom_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/backend/schema/enums/enums.dart';
import '/components/global/light_isotype/light_isotype_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:async';
import 'dart:io';
import '/index.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'home_page_model.dart';
export 'home_page_model.dart';

class HomePageWidget extends StatefulWidget {
  const HomePageWidget({super.key});

  static String routeName = 'HomePage';
  static String routePath = '/homePage';

  @override
  State<HomePageWidget> createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  late HomePageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  Future<ApiCallResponse>? _currentShiftReportFuture;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HomePageModel());

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      if (FFAppState().bombs.length == 0) {
        context.pushNamed(SelectBombPageWidget.routeName);
      }
    });
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  void _refreshShiftReport() {
    final request = LoadsGroup.currentShiftReportCall.call(
      token: currentAuthenticationToken,
    );
    setState(() {
      _currentShiftReportFuture = request.then((response) {
        _model.currentShiftReportOutput = response;
        return response;
      });
    });
  }

  void _changeTab(int index) {
    if (_model.selectedTabIndex == index) {
      return;
    }

    setState(() {
      _model.selectedTabIndex = index;
    });

    if (index == 1 && _currentShiftReportFuture == null) {
      _refreshShiftReport();
    }
  }

  double _readNumber(dynamic source, String path, {double fallback = 0}) {
    try {
      final value = getJsonField(source, path);
      final parsed = double.tryParse(value?.toString() ?? '');
      return parsed ?? fallback;
    } catch (_) {
      return fallback;
    }
  }

  String _formatCurrency(double value) {
    return NumberFormat.currency(
      locale: 'es_MX',
      symbol: r'$',
      decimalDigits: 2,
    ).format(value);
  }

  String _formatDateTime(dynamic source) {
    final raw = source?.toString().trim() ?? '';
    if (raw.isEmpty || raw == 'null') {
      return '-';
    }

    final parsed = DateTime.tryParse(raw)?.toLocal();
    if (parsed == null) {
      return raw;
    }

    return DateFormat('dd/MM/yyyy HH:mm').format(parsed);
  }

  String _extractFilename(Map<String, String> headers) {
    final disposition =
        headers['content-disposition'] ?? headers['Content-Disposition'] ?? '';
    final match = RegExp(r'filename="?([^";]+)"?').firstMatch(disposition);

    if (match != null && match.groupCount > 0) {
      return match.group(1)!.trim();
    }

    final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    return 'corte_turno_$timestamp.pdf';
  }

  Future<String> _saveShiftReportPdf(ApiCallResponse response) async {
    final bytes = response.response?.bodyBytes;

    if (bytes == null || bytes.isEmpty) {
      throw Exception('No se recibieron bytes del archivo PDF.');
    }

    final directory = await getApplicationDocumentsDirectory();
    final reportsDir = Directory('${directory.path}/turnos');
    if (!await reportsDir.exists()) {
      await reportsDir.create(recursive: true);
    }

    final fileName = _extractFilename(response.headers);
    final file = File('${reportsDir.path}/$fileName');
    await file.writeAsBytes(bytes, flush: true);
    return file.path;
  }

  Future<bool> _openShiftReportPdf(String filePath) async {
    final fileUri = Uri.file(filePath);

    try {
      if (await canLaunchUrl(fileUri)) {
        return await launchUrl(
          fileUri,
          mode: LaunchMode.externalApplication,
        );
      }

      return await launchUrl(fileUri, mode: LaunchMode.platformDefault);
    } catch (_) {
      return false;
    }
  }

  Future<bool> _shareShiftReportPdf(String filePath) async {
    try {
      final result = await Share.shareXFiles(
        [
          XFile(
            filePath,
            mimeType: 'application/pdf',
          ),
        ],
        subject: 'Corte de turno',
        text: 'Corte de despachos del turno',
      );

      return result.status != ShareResultStatus.unavailable;
    } catch (_) {
      return false;
    }
  }

  void _openLoadSelectionFromQrValue(String? rawValue) {
    final qrValue = rawValue?.trim() ?? '';

    if (qrValue.isEmpty || qrValue == '-1') {
      return;
    }

    context.goNamed(
      LoadSelectionPageWidget.routeName,
      queryParameters: {
        'customerUuid': serializeParam(
          qrValue,
          ParamType.String,
        ),
      }.withoutNulls,
      extra: <String, dynamic>{
        '__transition_info__': TransitionInfo(
          hasTransition: true,
          transitionType: PageTransitionType.bottomToTop,
        ),
      },
    );
  }

  Widget _buildScanTab(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 100.0),
              child: Stack(
                alignment: AlignmentDirectional(0.0, 0.0),
                children: [
                  Lottie.asset(
                    'assets/jsons/Animation_-_1719349605961.json',
                    width: MediaQuery.sizeOf(context).width * 3.25,
                    height: 325.0,
                    fit: BoxFit.contain,
                    animate: true,
                  ),
                  InkWell(
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () async {
                      _model.scannedOutput =
                          await FlutterBarcodeScanner.scanBarcode(
                        '#C62828',
                        'Cancelar',
                        true,
                        ScanMode.QR,
                      );
                      _openLoadSelectionFromQrValue(_model.scannedOutput);

                      safeSetState(() {});
                    },
                    child: Container(
                      width: 75.0,
                      height: 75.0,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).tertiary,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 100.0,
                            color: Color(0x800197F6),
                            offset: Offset(0.0, 25.0),
                          )
                        ],
                        borderRadius: BorderRadius.circular(150.0),
                        border: Border.all(width: 0.0),
                      ),
                      alignment: AlignmentDirectional(0.0, 0.0),
                      child: Icon(
                        Icons.qr_code_rounded,
                        color: FlutterFlowTheme.of(context).primaryBackground,
                        size: 35.0,
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 300.0, 0.0, 0.0),
                    child: Text(
                      'Haz click para generar un nuevo registro.',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            font: GoogleFonts.poppins(
                              fontWeight: FontWeight.normal,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontStyle,
                            ),
                            color: Color(0x80FFFFFF),
                            fontSize: 12.0,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.normal,
                            fontStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .fontStyle,
                          ),
                    ),
                  ),
                ],
              ),
            ),
            if (kDebugMode)
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color(0x20FFFFFF),
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(color: Color(0x35FFFFFF), width: 1.0),
                ),
                child: Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'DEBUG: Emular escaneo QR',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              font: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .fontStyle,
                              ),
                              color: FlutterFlowTheme.of(context)
                                  .primaryBackground,
                              letterSpacing: 0.0,
                            ),
                      ),
                      SizedBox(height: 8.0),
                      TextFormField(
                        controller: _model.debugQrTextController ??=
                            TextEditingController(),
                        focusNode: _model.debugQrFocusNode ??= FocusNode(),
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              font: GoogleFonts.poppins(
                                fontWeight: FontWeight.w400,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .fontStyle,
                              ),
                              color: FlutterFlowTheme.of(context)
                                  .primaryBackground,
                              letterSpacing: 0.0,
                            ),
                        decoration: InputDecoration(
                          hintText: 'Pega aquí el payload del QR',
                          hintStyle:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    font: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w400,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                                    color: Color(0xB3FFFFFF),
                                    letterSpacing: 0.0,
                                  ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0x4DFFFFFF),
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0x99FFFFFF),
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          contentPadding: EdgeInsetsDirectional.fromSTEB(
                              12.0, 12.0, 12.0, 12.0),
                        ),
                      ),
                      SizedBox(height: 10.0),
                      FFButtonWidget(
                        onPressed: () async {
                          _openLoadSelectionFromQrValue(
                            _model.debugQrTextController?.text,
                          );
                        },
                        text: 'Usar QR Pegado',
                        icon: Icon(
                          Icons.play_arrow_rounded,
                          size: 18.0,
                        ),
                        options: FFButtonOptions(
                          width: double.infinity,
                          height: 40.0,
                          color: Color(0x320197F6),
                          textStyle:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    font: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w500,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                                    color: FlutterFlowTheme.of(context)
                                        .primaryBackground,
                                    letterSpacing: 0.0,
                                  ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildShiftSummary(BuildContext context, dynamic reportJson) {
    final start =
        _formatDateTime(getJsonField(reportJson, r'''$.shift.startedAt'''));
    final endValue = getJsonField(reportJson, r'''$.shift.endedAt''');
    final end = _formatDateTime(endValue);
    final endLabel = (endValue == null ||
            endValue.toString().isEmpty ||
            endValue.toString() == 'null')
        ? 'Turno activo'
        : end;

    final loadsCount =
        getJsonField(reportJson, r'''$.totals.loadsCount''')?.toString() ?? '0';
    final totalLiters = _readNumber(reportJson, r'''$.totals.totalLiters''');
    final subtotal = _readNumber(reportJson, r'''$.totals.subtotal''');
    final discountTotal =
        _readNumber(reportJson, r'''$.totals.discountTotal''');
    final total = _readNumber(reportJson, r'''$.totals.total''');

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color(0x20FFFFFF),
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Color(0x35FFFFFF), width: 1.0),
      ),
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Turno actual',
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    font: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontStyle:
                          FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                    ),
                    color: FlutterFlowTheme.of(context).primaryBackground,
                    fontSize: 16.0,
                    letterSpacing: 0.0,
                  ),
            ),
            SizedBox(height: 8.0),
            Text(
              'Entrada: $start',
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    font: GoogleFonts.poppins(
                      fontWeight: FontWeight.w400,
                      fontStyle:
                          FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                    ),
                    color: FlutterFlowTheme.of(context).primaryBackground,
                    letterSpacing: 0.0,
                  ),
            ),
            Text(
              'Salida: $endLabel',
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    font: GoogleFonts.poppins(
                      fontWeight: FontWeight.w400,
                      fontStyle:
                          FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                    ),
                    color: FlutterFlowTheme.of(context).primaryBackground,
                    letterSpacing: 0.0,
                  ),
            ),
            SizedBox(height: 10.0),
            Text(
              'Cargas: $loadsCount | Litros: ${totalLiters.toStringAsFixed(2)}',
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    font: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      fontStyle:
                          FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                    ),
                    color: FlutterFlowTheme.of(context).primaryBackground,
                    letterSpacing: 0.0,
                  ),
            ),
            Text(
              'Subtotal: ${_formatCurrency(subtotal)}',
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    font: GoogleFonts.poppins(
                      fontWeight: FontWeight.w400,
                      fontStyle:
                          FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                    ),
                    color: FlutterFlowTheme.of(context).primaryBackground,
                    letterSpacing: 0.0,
                  ),
            ),
            Text(
              'Descuento total: ${_formatCurrency(discountTotal)}',
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    font: GoogleFonts.poppins(
                      fontWeight: FontWeight.w400,
                      fontStyle:
                          FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                    ),
                    color: FlutterFlowTheme.of(context).primaryBackground,
                    letterSpacing: 0.0,
                  ),
            ),
            Text(
              'Total: ${_formatCurrency(total)}',
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    font: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontStyle:
                          FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                    ),
                    color: FlutterFlowTheme.of(context).primaryBackground,
                    letterSpacing: 0.0,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadCard(BuildContext context, dynamic load) {
    final date = _formatDateTime(getJsonField(load, r'''$.date'''));
    final quantity = _readNumber(load, r'''$.quantity''');
    final price = _readNumber(load, r'''$.price''');
    final subtotal = _readNumber(load, r'''$.subtotal''');
    final discount = _readNumber(load, r'''$.discount''');
    final discountTotal = _readNumber(load, r'''$.discountTotal''');
    final total = _readNumber(load, r'''$.total''');

    Widget itemRow(String label, String value, {bool highlighted = false}) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  font: GoogleFonts.poppins(
                    fontWeight: FontWeight.w400,
                    fontStyle:
                        FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                  ),
                  color: FlutterFlowTheme.of(context).primaryBackground,
                  letterSpacing: 0.0,
                ),
          ),
          Text(
            value,
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  font: GoogleFonts.poppins(
                    fontWeight: highlighted ? FontWeight.w600 : FontWeight.w500,
                    fontStyle:
                        FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                  ),
                  color: FlutterFlowTheme.of(context).primaryBackground,
                  letterSpacing: 0.0,
                ),
          ),
        ],
      );
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color(0x25FFFFFF),
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Color(0x35FFFFFF), width: 1.0),
      ),
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Column(
          children: [
            itemRow('Hora del despacho', date, highlighted: true),
            SizedBox(height: 8.0),
            itemRow('Litros', '${quantity.toStringAsFixed(2)} L'),
            itemRow('Precio', _formatCurrency(price)),
            itemRow('Subtotal', _formatCurrency(subtotal)),
            itemRow('Descuento / litro', _formatCurrency(discount)),
            itemRow('Descuento total', _formatCurrency(discountTotal)),
            SizedBox(height: 4.0),
            itemRow('Total', _formatCurrency(total), highlighted: true),
          ].divide(SizedBox(height: 6.0)),
        ),
      ),
    );
  }

  Widget _buildShiftReportTab(BuildContext context) {
    final reportFuture = _currentShiftReportFuture ??
        (_currentShiftReportFuture = LoadsGroup.currentShiftReportCall
            .call(token: currentAuthenticationToken)
            .then((response) {
          _model.currentShiftReportOutput = response;
          return response;
        }));

    return FutureBuilder<ApiCallResponse>(
      future: reportFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              color: FlutterFlowTheme.of(context).primaryBackground,
            ),
          );
        }

        final response = snapshot.data!;
        if (!response.succeeded) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'No se pudo cargar el reporte del turno.',
                    textAlign: TextAlign.center,
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          font: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            fontStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .fontStyle,
                          ),
                          color: FlutterFlowTheme.of(context).primaryBackground,
                          letterSpacing: 0.0,
                        ),
                  ),
                  SizedBox(height: 12.0),
                  FFButtonWidget(
                    onPressed: _refreshShiftReport,
                    text: 'Reintentar',
                    options: FFButtonOptions(
                      width: 180.0,
                      height: 40.0,
                      color: FlutterFlowTheme.of(context).tertiary,
                      textStyle:
                          FlutterFlowTheme.of(context).titleSmall.override(
                                font: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .fontStyle,
                                ),
                                color: Colors.white,
                                letterSpacing: 0.0,
                              ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        final reportJson = response.jsonBody;
        final loads =
            getJsonField(reportJson, r'''$.loads''', true)?.toList() ?? [];

        return RefreshIndicator(
          onRefresh: () async {
            _refreshShiftReport();
            await _currentShiftReportFuture;
          },
          color: FlutterFlowTheme.of(context).tertiary,
          child: ListView(
            padding: EdgeInsets.all(16.0),
            children: [
              _buildShiftSummary(context, reportJson),
              SizedBox(height: 16.0),
              if (loads.isEmpty)
                Container(
                  decoration: BoxDecoration(
                    color: Color(0x20FFFFFF),
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: Color(0x35FFFFFF), width: 1.0),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Aún no hay cargas registradas en este turno.',
                      textAlign: TextAlign.center,
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            font: GoogleFonts.poppins(
                              fontWeight: FontWeight.w400,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontStyle,
                            ),
                            color:
                                FlutterFlowTheme.of(context).primaryBackground,
                            letterSpacing: 0.0,
                          ),
                    ),
                  ),
                ),
              if (loads.isNotEmpty)
                ...loads.map((load) => Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(
                        0.0,
                        0.0,
                        0.0,
                        12.0,
                      ),
                      child: _buildLoadCard(context, load),
                    )),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTopbarAction({
    required IconData icon,
    required Future<void> Function() onPressed,
  }) {
    return SizedBox(
      width: 40.0,
      height: 40.0,
      child: Material(
        color: Color(0x32FFFFFF),
        borderRadius: BorderRadius.circular(12.0),
        child: InkWell(
          borderRadius: BorderRadius.circular(12.0),
          onTap: () async {
            await onPressed();
          },
          child: Center(
            child: Icon(
              icon,
              color: FlutterFlowTheme.of(context).primaryBackground,
              size: 22.0,
            ),
          ),
        ),
      ),
    );
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
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).primary,
          automaticallyImplyLeading: false,
          toolbarHeight: kToolbarHeight,
          leadingWidth: 124.0,
          titleSpacing: 0.0,
          leading: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(16.0, 8.0, 0.0, 8.0),
            child: wrapWithModel(
              model: _model.lightIsotypeModel,
              updateCallback: () => safeSetState(() {}),
              child: LightIsotypeWidget(
                scheme: ColorSchemes.light,
              ),
            ),
          ),
          actionsPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 16.0, 0.0),
          actions: [
            if (_model.selectedTabIndex == 1)
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 8.0, 0.0),
                child: _buildTopbarAction(
                  icon: Icons.refresh_sharp,
                  onPressed: () async {
                    _refreshShiftReport();
                  },
                ),
              ),
            _buildTopbarAction(
              icon: Icons.login_sharp,
              onPressed: () async {
                final shouldLogout = await showDialog<bool>(
                      context: context,
                      builder: (dialogContext) {
                        return AlertDialog(
                          title: Text('Cerrar sesión'),
                          content: Text(
                            'Si cierras sesión, se terminará el turno en curso y se realizará el corte de despachos.\n\n¿Deseas continuar?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () =>
                                  Navigator.of(dialogContext).pop(false),
                              child: Text('Cancelar'),
                            ),
                            TextButton(
                              onPressed: () =>
                                  Navigator.of(dialogContext).pop(true),
                              child: Text('Cerrar sesión'),
                            ),
                          ],
                        );
                      },
                    ) ??
                    false;

                if (!shouldLogout) {
                  return;
                }

                _model.logoutWithReportOutput =
                    await AuthGroup.logoutWithReportCall.call(
                  token: currentAuthenticationToken,
                );

                if (!(_model.logoutWithReportOutput?.succeeded ?? false)) {
                  await showDialog(
                    context: context,
                    builder: (dialogContext) {
                      return AlertDialog(
                        title: Text('No se pudo cerrar el turno'),
                        content: Text(
                          'No fue posible generar el corte en PDF. Intenta nuevamente.',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(dialogContext).pop(),
                            child: Text('Aceptar'),
                          ),
                        ],
                      );
                    },
                  );
                  return;
                }

                String savedFilePath = '';
                try {
                  savedFilePath = await _saveShiftReportPdf(
                    _model.logoutWithReportOutput!,
                  );
                } catch (_) {
                  await showDialog(
                    context: context,
                    builder: (dialogContext) {
                      return AlertDialog(
                        title: Text('Error al descargar el corte'),
                        content: Text(
                          'El turno se cerró, pero no se pudo guardar el PDF localmente. Intenta nuevamente.',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(dialogContext).pop(),
                            child: Text('Aceptar'),
                          ),
                        ],
                      );
                    },
                  );
                  return;
                }

                if (!context.mounted) {
                  return;
                }

                final sharedPdf = await _shareShiftReportPdf(savedFilePath);
                final openedPdf = !sharedPdf
                    ? await _openShiftReportPdf(savedFilePath)
                    : false;

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      sharedPdf
                          ? 'Corte generado. Selecciona dónde compartirlo.'
                          : openedPdf
                              ? 'Corte descargado y abierto automáticamente.'
                              : 'Corte descargado en:\n$savedFilePath',
                    ),
                    duration: Duration(seconds: 4),
                  ),
                );

                GoRouter.of(context).prepareAuthEvent();
                await authManager.signOut();
                GoRouter.of(context).clearRedirectLocation();

                context.goNamedAuth(LoginPageWidget.routeName, context.mounted);
                safeSetState(() {});
              },
            ),
          ],
          elevation: 0.0,
        ),
        body: IndexedStack(
          index: _model.selectedTabIndex,
          children: [
            _buildScanTab(context),
            _buildShiftReportTab(context),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _model.selectedTabIndex,
          onTap: _changeTab,
          backgroundColor: FlutterFlowTheme.of(context).primary,
          selectedItemColor: FlutterFlowTheme.of(context).primaryBackground,
          unselectedItemColor: Color(0x80FFFFFF),
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.qr_code_rounded),
              label: 'Escanear',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long_rounded),
              label: 'Turno',
            ),
          ],
        ),
      ),
    );
  }
}
