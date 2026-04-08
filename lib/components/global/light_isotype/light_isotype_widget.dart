import '/backend/schema/enums/enums.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'light_isotype_model.dart';
export 'light_isotype_model.dart';

class LightIsotypeWidget extends StatefulWidget {
  const LightIsotypeWidget({
    super.key,
    required this.scheme,
  });

  final ColorSchemes? scheme;

  @override
  State<LightIsotypeWidget> createState() => _LightIsotypeWidgetState();
}

class _LightIsotypeWidgetState extends State<LightIsotypeWidget> {
  late LightIsotypeModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => LightIsotypeModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.asset(
            'assets/images/a_logo.png',
            width: 125.0,
            fit: BoxFit.cover,
          ),
        ),
      ],
    );
  }
}
