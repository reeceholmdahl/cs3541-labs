

import 'package:units/units/utils/units_constant.dart';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

double calculator(double prevOdom, double curOdom, double fuelUsed, UnitType uniType) {

  double result = 0.0;

  result = ((curOdom - prevOdom) / fuelUsed); // MPG

  if (uniType == UnitType.KPG) {
    result *= 1.609;
  }

  return result;
}

bool isEmptyString(String string){
  return string == null || string.length == 0;
}

Future<int> loadValue() async{
  SharedPreferences preferences = await SharedPreferences.getInstance();
  int? data = preferences.getInt('data');
  if( data != null ) {
    return data;
  } else {
    return 0;
  }

}

void saveValue(int value) async{
  SharedPreferences preferences = await SharedPreferences.getInstance();
  preferences.setInt('data', value);
}