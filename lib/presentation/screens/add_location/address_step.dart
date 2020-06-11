import 'package:ecoschedule/data/services/api/schedule_period.dart';
import 'package:ecoschedule/data/services/api/street.dart';
import 'package:ecoschedule/domain/street_query_result.dart';
import 'package:ecoschedule/presentation/screens/add_location/no_items_placeholder.dart';
import 'package:ecoschedule/presentation/screens/add_location/state/add_location_bloc.dart';
import 'package:ecoschedule/presentation/screens/add_location/state/add_location_events.dart';
import 'package:ecoschedule/presentation/screens/add_location/state/add_location_state.dart';
import 'package:ecoschedule/presentation/screens/add_location/state/add_location_step.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AddressStep extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AddressStepState();
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text?.toUpperCase(),
      selection: newValue.selection,
    );
  }
}

class _AddressStepState extends State<AddressStep> {
  final _streetFieldController = TextEditingController();
  final _houseNumberFieldController = TextEditingController();

  final _houseNumberFocusNode = FocusNode();

  StreetIdsQueryResult selectedStreetIds;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddLocationBloc, AddLocationState>(
        builder: (BuildContext context, AddLocationState state) {
      if (state.currentStep == AddLocationStep.EnterAddress) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            _buildStreetFormField(state),
            SizedBox(
              height: 16,
            ),
            _buildHouseNumberFormField(state),
            SizedBox(
              height: 16,
            ),
            RaisedButton.icon(
                icon: Icon(Icons.arrow_forward),
                onPressed: () {
                  if (this.selectedStreetIds != null &&
                      _houseNumberFieldController.text.isNotEmpty) {
                    BlocProvider.of<AddLocationBloc>(context).add(
                        StreetSelectedEvent(selectedStreetIds,
                            _houseNumberFieldController.text));
                  }
                },
                color: Theme.of(context).primaryColor,
                label: Text("Next")),
          ],
        );
      }
      return Container();
    });
  }

  Widget _buildStreetFormField(AddLocationState state) {
    return TypeAheadFormField(
      textFieldConfiguration: TextFieldConfiguration(
          inputFormatters: [
            WhitelistingTextInputFormatter(
                RegExp("[^\u0000-\u007F]|[a-zA-Z0-9 ]")),
          ],
          controller: _streetFieldController,
          autofocus: true,
          decoration: InputDecoration(
              labelText: "Street",
              prefixIcon: Icon(FontAwesomeIcons.mapSigns, size: 18),
              filled: true)),
      onSuggestionSelected: (StreetIdsQueryResult suggestion) {
        _streetFieldController.text = suggestion.name;
        _houseNumberFocusNode.requestFocus();
        selectedStreetIds = suggestion;
      },
      itemBuilder: (context, itemData) {
        return ListTile(
          title: Text(itemData.name),
        );
      },
      suggestionsCallback: (String pattern) async {
        if (pattern.length < 1) {
          return null;
        }
        final schedulePeriod =
            await getSchedulePeriods(townId: state.selectedTown.id);

        final streetNamesToIds = await getStreetIds(
            townId: state.selectedTown.id,
            streetNamePattern: pattern,
            schedulePeriodId: schedulePeriod.id);

        return streetNamesToIds;
      },
      noItemsFoundBuilder: (_) =>
          NoItemsPlaceholder(message: "No streets found"),
    );
  }

  Widget _buildHouseNumberFormField(AddLocationState state) {
    return TextFormField(
      controller: _houseNumberFieldController,
      focusNode: _houseNumberFocusNode,
      autofocus: true,
      inputFormatters: [
        WhitelistingTextInputFormatter(RegExp("[a-zA-Z0-9/]")),
        UpperCaseTextFormatter()
      ],
      decoration: InputDecoration(
          labelText: "House number",
          prefixIcon: Icon(Icons.location_on),
          filled: true),
    );
  }

  @override
  void dispose() {
    _houseNumberFocusNode.dispose();
    super.dispose();
  }
}
