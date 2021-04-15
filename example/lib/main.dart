import 'package:country_state_city_pickers/country_state_city_pickers.dart';
import 'package:flutter/material.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String country;
  String state;
  String city;
  final _key = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Country Picker'),
        ),
        body: Form(
          key: _key,
          child: Column(
            children: [
              Center(
                  child: CountryStateCityPicker(
                    initialCountry: '🇮🇳India',
                    onCityChanged: (value) {
                      setState(() {
                        city = value;
                      });
                    },
                    onCountryChanged: (val) {
                      country = val;
                    },
                    onStateChanged: (value) {
                      state = value;
                    },
                  )),
              RaisedButton(
                  child: Text('Button'),
                  onPressed: () {
                    if (_key.currentState.validate()) {
                      print(country + state + city);
                    }
                  })
            ],
          ),
        ),
      ),
    );
  }
}
