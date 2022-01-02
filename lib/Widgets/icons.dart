import 'package:flutter/material.dart';

String _parseAssetName(name) => 'assets/icons/$name.png';

class TheIcon extends StatelessWidget {
  final String assetName;
  final bool lg;
  final bool xl;

  const TheIcon(this.assetName, {Key key, this.lg = false, this.xl = false})
      : super(key: key);

  double _getMetrics(sm, lg, xl) => this.xl
      ? xl
      : this.lg
          ? lg
          : sm;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _getMetrics(40.0, 100.0, 120.0),
      height: _getMetrics(40.0, 100.0, 120.0),
      padding: EdgeInsets.all(_getMetrics(8.0, 12.0, 16.0)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(_getMetrics(20.0, 48.0, 60.0)),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0.0, 2.0),
            blurRadius: 4.0,
          ),
        ],
      ),
      child: Image.asset(_parseAssetName(assetName)),
    );
  }
}
