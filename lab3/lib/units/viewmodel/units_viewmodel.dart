import '../utils/units_constant.dart';
import '../utils/units_utils.dart';
class UNITSViewModel {
  double _units = 0.0;
  UnitType _unitType = UnitType.MPG;

  double prevOdom = 0.0;
  double curOdom = 0.0;
  double fuelUsed = 0.0;

  double get units => _units;
  set units(double outResult){
    _units = outResult;
  }

  UnitType get unitType => _unitType;
  set unitType(UnitType setValue){
    _unitType = setValue;
  }

  int get value => _unitType == UnitType.MPG ? 0 : 1; //Set unit type - 1 is KPG
  set value(int value){
    if(value == 0){
      _unitType = UnitType.MPG;
    } else if (value == 1) {
      _unitType = UnitType.KPG;
    }
  }

  String get resultInString => units.toStringAsFixed(2);
  String get heightInString => curOdom != null ? curOdom.toString():'';
  String get weightInString => fuelUsed != null ? fuelUsed.toString():'';

  UNITSViewModel();
}