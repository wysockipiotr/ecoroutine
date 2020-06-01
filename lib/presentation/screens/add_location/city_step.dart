import 'package:ecoschedule/data/services/location.dart';
import 'package:ecoschedule/domain/city.dart';
import 'package:ecoschedule/presentation/screens/add_location/bloc.dart';
import 'package:ecoschedule/presentation/screens/add_location/events.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class CityStep extends StatefulWidget {
  const CityStep({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CityStepState();
}

class _CityStepState extends State<CityStep> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final _fieldKey = GlobalKey<FormFieldState>();
  bool touched = false;

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<AddLocationBloc>(context);

    _focusNode.addListener(() {
      if (!_focusNode.hasFocus || touched) _fieldKey.currentState.validate();
    });

    return TypeAheadFormField(
        key: _fieldKey,
        textFieldConfiguration: TextFieldConfiguration(
            autofocus: true,
            focusNode: _focusNode,
            controller: _controller,
            decoration: InputDecoration(
                labelText: "Enter city name",
                prefixIcon: Icon(Icons.location_city),
                filled: true)),
        suggestionsCallback: (String pattern) async {
          touched = true;
          if (pattern.length < 1) return null;
          return await getCities(cityName: pattern);
        },
        validator: (String pattern) {
          if (pattern.length < 1) {
            return "Field can't be empty";
          } else {
            return "Select one of available cities";
          }
        },
        itemBuilder: (_, City city) => ListTile(
              title: Text(city.name),
              subtitle: Text("${city.district}, ${city.province}"),
            ),
        debounceDuration: Duration(milliseconds: 750),
        onSuggestionSelected: (City selectedCity) {
          bloc.add(CitySelectedEvent(selectedCity: selectedCity));
        },
        getImmediateSuggestions: true,
        loadingBuilder: (BuildContext ctx) => LinearProgressIndicator(),
        noItemsFoundBuilder: _buildNoItemsPlaceholder);
  }

  Widget _buildNoItemsPlaceholder(BuildContext context) => Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FaIcon(FontAwesomeIcons.solidSadCry, size: 48),
            SizedBox(
              height: 16,
            ),
            Text("No cities found", style: GoogleFonts.monda(fontSize: 24))
          ],
        ),
      );

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }
}
