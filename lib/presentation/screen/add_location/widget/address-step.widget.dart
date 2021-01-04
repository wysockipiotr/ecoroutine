import 'package:ecoroutine/adapter/adapter.dart';
import 'package:ecoroutine/adapter/ecoharmonogram-api/dto/dto.dart';
import 'package:ecoroutine/presentation/screen/add_location/bloc/bloc.dart';
import 'package:ecoroutine/presentation/screen/add_location/enum/enum.dart';
import 'package:ecoroutine/presentation/screen/add_location/widget/widget.dart';
import 'package:ecoroutine/utility/utility.dart';
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

  StreetIdsQueryResultDto selectedStreetIds;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddLocationCubit, AddLocationState>(
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
                onPressed: _nextStep,
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
            WhitelistingTextInputFormatter(RegExp(STREET_NAME_REGEX)),
          ],
          textCapitalization: TextCapitalization.words,
          controller: _streetFieldController,
          autofocus: true,
          decoration: InputDecoration(
              labelText: "Street",
              prefixIcon: Icon(FontAwesomeIcons.mapSigns, size: 18),
              filled: true)),
      onSuggestionSelected: (StreetIdsQueryResultDto suggestion) {
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
      onFieldSubmitted: (_) => _nextStep(),
      inputFormatters: [
        WhitelistingTextInputFormatter(RegExp(HOUSE_NUMBER_REGEX)),
        UpperCaseTextFormatter()
      ],
      decoration: InputDecoration(
          labelText: "House number",
          prefixIcon: Icon(Icons.location_on),
          filled: true),
    );
  }

  void _nextStep() {
    if (this.selectedStreetIds != null &&
        _houseNumberFieldController.text.isNotEmpty) {
      context.read<AddLocationCubit>().onStreetSelected(
          streetIds: selectedStreetIds,
          houseNumber: _houseNumberFieldController.text);
    }
  }

  @override
  void dispose() {
    _houseNumberFocusNode.dispose();
    super.dispose();
  }
}
