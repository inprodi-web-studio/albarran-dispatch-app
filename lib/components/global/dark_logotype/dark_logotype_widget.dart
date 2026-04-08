import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'dark_logotype_model.dart';
export 'dark_logotype_model.dart';

class DarkLogotypeWidget extends StatefulWidget {
  const DarkLogotypeWidget({
    super.key,
    int? width,
  }) : this.width = width ?? 250;

  final int width;

  @override
  State<DarkLogotypeWidget> createState() => _DarkLogotypeWidgetState();
}

class _DarkLogotypeWidgetState extends State<DarkLogotypeWidget> {
  late DarkLogotypeModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => DarkLogotypeModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: Image.asset(
        'assets/images/MARCA_ALBARRAN_GASOLINERAS_BLACK.png',
        width: widget.width.toDouble(),
        fit: BoxFit.cover,
      ),
    );
  }
}
