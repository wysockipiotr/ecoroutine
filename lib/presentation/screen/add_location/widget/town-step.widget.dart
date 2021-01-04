import 'package:ecoroutine/adapter/adapter.dart';
import 'package:ecoroutine/presentation/screen/add_location/bloc/bloc.dart';
import 'package:ecoroutine/presentation/screen/add_location/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class TownStep extends StatefulWidget {
  const TownStep({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TownStepState();
}

class _TownStepState extends State<TownStep> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final _fieldKey = GlobalKey<FormFieldState>();
  bool touched = false;

  @override
  Widget build(BuildContext context) {
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus || touched) _fieldKey.currentState.validate();
    });

    return TypeAheadFormField(
        key: _fieldKey,
        textFieldConfiguration: TextFieldConfiguration(
            autofocus: true,
            focusNode: _focusNode,
            controller: _controller,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
                labelText: "Town",
                prefixIcon: Icon(Icons.location_city),
                filled: true)),
        suggestionsCallback: (String pattern) async {
          touched = true;
          if (pattern.length < 1) return null;
          return await getTowns(townNamePattern: pattern);
        },
        validator: (String pattern) {
          if (pattern.length < 1) {
            return "Field can't be empty";
          } else {
            return "Select one of available cities";
          }
        },
        itemBuilder: (_, TownDto town) => ListTile(
              title: Text(town.name),
              subtitle: Text("${town.district}, ${town.province}"),
            ),
        debounceDuration: Duration(milliseconds: 750),
        onSuggestionSelected: (TownDto selectedTown) =>
            context.read<AddLocationCubit>().onTownSelected(town: selectedTown),
        getImmediateSuggestions: true,
        loadingBuilder: (BuildContext ctx) => LinearProgressIndicator(),
        noItemsFoundBuilder: _buildNoItemsPlaceholder);
  }

  Widget _buildNoItemsPlaceholder(BuildContext context) =>
      NoItemsPlaceholder(message: "No cities found");

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }
}
