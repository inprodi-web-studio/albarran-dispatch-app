import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'light_logotype_model.dart';
export 'light_logotype_model.dart';

class LightLogotypeWidget extends StatefulWidget {
  const LightLogotypeWidget({super.key});

  @override
  State<LightLogotypeWidget> createState() => _LightLogotypeWidgetState();
}

class _LightLogotypeWidgetState extends State<LightLogotypeWidget> {
  late LightLogotypeModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => LightLogotypeModel());
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
        'assets/images/MARCA_ALBARRAN_GASOLINERAS-WHITE.png',
        width: 250.0,
        fit: BoxFit.cover,
      ),
    );
  }
}
