import 'package:flutter/material.dart';
import '../views/units_view.dart';
import '../presenter/units_presenter.dart';

class HomePage extends StatefulWidget {
  final UNITSPresenter presenter;

  HomePage(this.presenter, {required Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> implements UNITSView {

  var _currentOdomController = TextEditingController();
  var _fuelUsedController = TextEditingController();
  var _prevOdomController = TextEditingController();
  String _prevOdom = "0.0";
  String _fuelUsed = "0.0";
  String _curOdom = "0.0";
  var _message = '';
  var _resultString = '';
  var _value = 0;
  final FocusNode _prevOdomFocus = FocusNode();
  final FocusNode _curOdomFocus = FocusNode();
  final FocusNode _fuelUsedFocus = FocusNode();

  var _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    this.widget.presenter.unitsView = this;
  }

  void handleRadioValueChanged(int? value) {
    this.widget.presenter.onOptionChanged(value!, curOdomString: _curOdom, fuelUsedString: _fuelUsed );
  }

  void _calculator() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      this.widget.presenter.onCalculateClicked(_prevOdom, _fuelUsed, _curOdom);
    }
  }

  @override
  void updateResultValue(String resultValue){
    setState(() {
      _resultString = resultValue;
    });
  }
  @override
  void updateFuelUsed({required String fuelUsed}){
    setState(() {
      // ignore: unnecessary_null_comparison
      _fuelUsedController.text = fuelUsed != null?fuelUsed:'';
    });
  }
  @override
  void updateCurrentOdom({required String currentOdom}){
    setState(() {
      // ignore: unnecessary_null_comparison
      _currentOdomController.text = currentOdom != null?currentOdom:'';
    });
  }
  @override
  void updatePrevOdom({required String prevOdom}) {
    setState(() {
      _prevOdomController.text = prevOdom != null ? prevOdom : '';
    });
  }
  @override
  void updateUnit(int value){
    setState(() {
      _value = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    var _unitView = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Radio<int>(
          activeColor: Colors.lightBlue,
          value: 0, groupValue: _value, onChanged: handleRadioValueChanged,
        ),
        Text(
          'MPG',
          style: TextStyle(color: Colors.blue),
        ),
        Radio<int>(
          activeColor: Colors.lightGreen,
          value: 1, groupValue: _value, onChanged: handleRadioValueChanged,
        ),
        Text(
          'KPG',
          style: TextStyle(color: Colors.green),
        )
      ],
    );

    var _mainPartView = Container(
      color: Colors.grey.shade300,
      margin: EdgeInsets.all(8.0),
      padding: EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              prevOdomFormField(context),
              currentOdomFormField(context),
              fuelUsedFormField(),
              Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: calculateButton()
                ,),
            ],
          ),
        ),
      ),
    );

    var _resultView = Column(
      children: <Widget>[
        Center(
          child: Text(
            'Result: $_resultString',
            style: TextStyle(
                color: Colors.blue,
                fontSize: 24.0,
                fontWeight: FontWeight.w700,
                fontStyle: FontStyle.italic
            ),
          ),
        ),
      ],
    );

    return Scaffold(
        appBar: AppBar(
          title: Text('UNITS'),
          centerTitle: true,
          backgroundColor: Colors.pinkAccent.shade400,
        ),
        backgroundColor: Colors.white,
        body: ListView(
          children: <Widget>[
            Padding(padding: EdgeInsets.all(5.0)),
            _unitView,
            Padding(padding: EdgeInsets.all(5.0)),
            _mainPartView,
            Padding(padding: EdgeInsets.all(5.0)),
            _resultView
          ],
        )
    );
  }

  RaisedButton calculateButton() {
    return RaisedButton(
      onPressed: _calculator,
      color: Colors.pinkAccent,
      child: Text(
        'Calculate',
        style: TextStyle(fontSize: 16.9),
      ),
      textColor: Colors.white70,
    );
  }

  TextFormField fuelUsedFormField() {
    return TextFormField(
      controller: _fuelUsedController,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.done,
      focusNode: _fuelUsedFocus,
      onFieldSubmitted: (value){
        _fuelUsedFocus.unfocus();
        _calculator();
      },
      validator: (value) {
        if (value!.length == 0 || double.parse(value) == 0.0) {
          return ('Fuel Used is not valid. Fuel Used > 0.0');
        }
      },
      onSaved: (value) {
        _fuelUsed = value!;
      },
      decoration: InputDecoration(
          hintText: 'e.g.) 400',
          labelText: 'Gallons of fuel used',
          icon: Icon(Icons.add_road),
          fillColor: Colors.white
      ),
    );
  }

  TextFormField currentOdomFormField(BuildContext context) {
    return TextFormField(
      controller: _currentOdomController,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.next,
      focusNode: _curOdomFocus,
      onFieldSubmitted: (term) {
        _fieldFocusChange(context, _curOdomFocus, _fuelUsedFocus);
      },
      validator: (value) {
        if (value!.length == 0 || double.parse(value) == 0.0) {
          return ('Current Odometer is not valid. Current Odometer > 0.0');
        }
      },
      onSaved: (value) {
        _curOdom = value!;
      },
      decoration: InputDecoration(
        hintText: "e.g.) 180000",
        labelText: "Current odometer",
        icon: Icon(Icons.assessment),
        fillColor: Colors.white,
      ),
    );
  }

  TextFormField prevOdomFormField(BuildContext context) {
    return TextFormField(
      controller: _prevOdomController,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.next,
      focusNode: _prevOdomFocus,
      onFieldSubmitted: (term){
        _fieldFocusChange(context, _prevOdomFocus, _curOdomFocus);
      },
      validator: (value) {
        if (value!.length == 0 || double.parse(value) <= 15) {
          return ('Previous Odometer is not valid. Previous Odometer > 0.0');
        }
      },
      onSaved: (value) {
        _prevOdom = value!;
      },
      decoration: InputDecoration(
        hintText: 'e.g.) 170000',
        labelText: 'Previous Odometer',
        icon: Icon(Icons.assessment),
        fillColor: Colors.white,
      ),
    );
  }

  _fieldFocusChange(BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }


}
