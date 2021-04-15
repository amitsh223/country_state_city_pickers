import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'models/countryStateCitymodel.dart';

class CountryStateCityPicker extends StatefulWidget {
  final GlobalKey formKey;
  final String initialCountry;
  final double boxHeight;
  final double boxWidth;
  final ValueChanged<String> onCountryChanged;
  final ValueChanged<String> onStateChanged;
  final ValueChanged<String> onCityChanged;

  CountryStateCityPicker(
      {this.formKey,
      this.initialCountry = '🇮🇳India',
      this.boxHeight = 65,
      this.boxWidth = double.infinity,
      this.onCityChanged,
      this.onCountryChanged,
      this.onStateChanged});
  @override
  _CountryStateCityPickerState createState() => _CountryStateCityPickerState();
}

class _CountryStateCityPickerState extends State<CountryStateCityPicker> {
  Future getResponse() async {
    var res = await rootBundle.loadString(
        'packages/country_state_city_pickers/lib/assets/countriesData.json');
    return jsonDecode(res);
  }

  String _selectedState;
  String _selectedCountry;
  String _selectedCity;
  List _country = [];
  Future getCounty() async {
    _country.clear();
    var countries = await getResponse() as List;
    countries.forEach((data) {
      if (!mounted) return;
      setState(() {
        _country.add(data['emoji'] + data['name']);
      });
    });
    return _country;
  }

  List _states = [];
  List _cities = [];
  Future getStates() async {
    _states.clear();
    var responce = await getResponse() as List;

    List temp = responce
        .map((e) => Country.fromJson(e))
        .where((element) => element.emoji + element.name == _selectedCountry)
        .map((e) => e.state)
        .toList();
    temp.forEach((element) {
      if (!mounted) return;
      setState(() {
        var name = element.map((item) => item.name).toList();
        for (var statename in name) {
          _states.add(statename.toString());
        }
      });
    });
    _states.sort();
    return _states;
  }

  void _onSelectedCountry(String value) {
    if (!mounted) return;
    setState(() {
      if (value != _selectedCountry) {
        _states.clear();
        _cities.clear();
        _selectedState = null;
        _selectedCity = null;
        this.widget.onCountryChanged(value);
        this.widget.onStateChanged(null);
        this.widget.onCityChanged(null);
        _selectedCountry = value;
        getStates();
      } else {
        this.widget.onCountryChanged(value);
        this.widget.onStateChanged(_selectedState);
        this.widget.onCityChanged(_selectedCity);
      }
    });
  }

  void _onSelectedCity(String value) {
    if (!mounted) return;
    setState(() {
      _selectedCity = value;
      this.widget.onCityChanged(value);
    });
  }

  Future getCity() async {
    _cities.clear();
    var response = await getResponse();
    var takeCity = response
        .map((map) => Country.fromJson(map))
        .where((item) => item.emoji + item.name == _selectedCountry)
        .map((item) => item.state)
        .toList();

    var cities = takeCity as List;
    cities.forEach((f) {
      var name = f.where((item) => item.name == _selectedState);
      var cityName = name.map((item) => item.city).toList();
      cityName.forEach((ci) {
        if (!mounted) return;
        setState(() {
          var citiesName = ci.map((item) => item.name).toList();
          for (var cityName in citiesName) {
            _cities.add(cityName.toString());
          }
        });
      });
    });
    _cities.sort((a, b) => a.compareTo(b));
    return _cities;
  }

  void _onSelectedState(String value) {
    if (!mounted) return;
    setState(() {
      _cities.clear();
      _selectedCity = null;

      _selectedState = value;
      this.widget.onStateChanged(value);
      getCity();
    });
  }

  List<String> cities;
  @override
  void initState() {
    getCounty().then((value) {
      _selectedCountry = widget.initialCountry;
      this.widget.onCountryChanged(widget.initialCountry);
      getStates();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: widget.boxWidth,
          height: widget.boxHeight,
          child: DropdownButtonFormField(
            value: _selectedCountry,
            validator: (val) {
              if (val == null)
                return 'Required';
              else
                return null;
            },
            items: _country
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: (val) {
              _onSelectedCountry(val);
            },
          ),
        ),
        Container(
          width: widget.boxWidth,
          height: widget.boxHeight,
          child: DropdownButtonFormField(
            hint: Text('Select State'),
            value: _selectedState,
            validator: (val) {
              if (val == null)
                return 'Required';
              else
                return null;
            },
            items: _states.length == 0
                ? []
                : _states
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
            onChanged: (val) {
              _onSelectedState(val);
            },
          ),
        ),
        Container(
          width: widget.boxWidth,
          height: widget.boxHeight,
          child: DropdownButtonFormField(
            hint: Text('Select City'),
            value: _selectedCity,
            validator: (val) {
              if (val == null)
                return 'Required';
              else
                return null;
            },
            items: _cities.length == 0
                ? []
                : _cities
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
            onChanged: (val) {
              _onSelectedCity(val);
            },
          ),
        )
      ],
    );
  }
}
