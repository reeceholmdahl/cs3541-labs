import '../views/units_view.dart';
import '../viewmodel/units_viewmodel.dart';
import '../utils/units_constant.dart';
import '../utils/units_utils.dart';

class UNITSPresenter {
  void onCalculateClicked(String prevOdomString, String fuelUsedString, String curOdomString){

  }
  void onOptionChanged(int value, {required String fuelUsedString, required String curOdomString}) {

  }
  set unitsView(UNITSView value){}

  void onPrevOdomSubmitted(String prevOdom){}
  void onCurOdomSubmitted(String curOdom){}
  void onFuelUsedSubmitted(String fuelUsed){}
}

class BasicPresenter implements UNITSPresenter{
  late UNITSViewModel _viewModel;
  late UNITSView _view;

  BasicPresenter() {
    this._viewModel = UNITSViewModel();
    _loadUnit();
  }

  void _loadUnit() async{
    _viewModel.value = await loadValue();
    _view.updateUnit(_viewModel.value);
  }

  @override
  set unitsView(UNITSView value) {
    _view = value;
    _view.updateUnit(_viewModel.value);
  }

  @override
  void onCalculateClicked(String prevOdomString, String fuelUsedString, String curOdomString) {
    var prevOdom = 0.0;
    var curOdom = 0.0;
    var fuelUsed = 0.0;
    try {
      prevOdom = double.parse(prevOdomString);
    } catch (e){

    }
    try {
      curOdom = double.parse(curOdomString);
    } catch (e){

    }
    try {
      fuelUsed = double.parse(fuelUsedString);
    } catch (e) {

    }
    _viewModel.prevOdom = prevOdom;
    _viewModel.curOdom = curOdom;
    _viewModel.fuelUsed = fuelUsed;
    _viewModel.units = calculator(prevOdom,curOdom, fuelUsed, _viewModel.unitType);
    _view.updateResultValue(_viewModel.resultInString);
  }

  @override
  void onOptionChanged(int value, {required String fuelUsedString, required String curOdomString})  {

    if (value != _viewModel.value) {
      _viewModel.value = value;
      saveValue(_viewModel.value);
      var curOdom = 0.0;
      var fuelUsed = 0.0;
      if (!isEmptyString(curOdomString)) {
        try {
          curOdom = double.parse(curOdomString);
        } catch (e) {
        }
      }
      if (!isEmptyString(fuelUsedString)) {
        try {
          fuelUsed = double.parse(fuelUsedString);
        } catch (e) {

        }
      }


      _view.updateUnit(_viewModel.value);
      _view.updateCurrentOdom(currentOdom: _viewModel.heightInString);
      _view.updateFuelUsed(fuelUsed: _viewModel.weightInString);
    }
  }

  @override
  void onPrevOdomSubmitted(String prevOdom) {
    try{
      _viewModel.prevOdom = double.parse(prevOdom);
    }catch(e){

    }
  }

  @override
  void onCurOdomSubmitted(String curOdom) {
    try {
      _viewModel.curOdom = double.parse(curOdom);
    } catch (e){

    }
  }

  @override
  void onFuelUsedSubmitted(String fuelUsed) {
    try {
      _viewModel.fuelUsed = double.parse(fuelUsed);
    } catch (e){

    }
  }
}