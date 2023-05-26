import 'package:flutter/material.dart';

extension BuildContextProperty on BuildContext {
  Object? get arguments => ModalRoute.of(this)?.settings.arguments;
}
