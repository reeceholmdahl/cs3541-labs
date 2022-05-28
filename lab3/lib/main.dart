import 'package:flutter/material.dart';

import 'units/views/units_component.dart';
import 'units/presenter/units_presenter.dart';

void main() {
  runApp(
    new MaterialApp(
      title: 'UNITS',
      home: new HomePage(new BasicPresenter(), title: 'UNITS', key: Key("UNITS"),),
    )
  );
}


