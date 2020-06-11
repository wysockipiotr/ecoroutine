import 'dart:collection';

import 'package:ecoschedule/presentation/screens/add_location/bloc.dart';
import 'package:ecoschedule/presentation/screens/add_location/events.dart';
import 'package:ecoschedule/presentation/screens/add_location/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recase/recase.dart';

class AddressDetailsStep extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AddressDetailsStep();
}

class _AddressDetailsStep extends State<AddressDetailsStep> {
  String _selectedSides;
  String _selectedGroup;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddLocationBloc, AddLocationState>(
        builder: (BuildContext context, AddLocationState state) {
      if (state is SpecifyAddressDetailsState) {
        return _buildDetailsDropdowns(state);
      } else {
        return Container();
      }
    });
  }

  Widget _buildDetailsDropdowns(SpecifyAddressDetailsState state) {
    final sidesVariants = SplayTreeSet<String>.from(
        state.streetVariants.map((street) => street.sides));
    final groupVariants = SplayTreeSet<String>.from(
        state.streetVariants.map((street) => street.group));

    if (sidesVariants == null && groupVariants == null) {
      if (sidesVariants.length > 1) {
        _selectedSides = sidesVariants.first;
      }
      if (groupVariants.length > 1) {
        _selectedGroup = groupVariants.first;
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        if (sidesVariants.length > 1)
          DropdownButtonFormField(
            onChanged: (String sides) {
              setState(() {
                _selectedSides = sides;
              });
            },
            value: _selectedSides,
            items: [
              for (final sides in sidesVariants)
                DropdownMenuItem(child: Text(sides.titleCase), value: sides)
            ],
            decoration: InputDecoration(
                filled: true, labelText: "Region", prefixIcon: Icon(Icons.map)),
          ),
        if (sidesVariants.length > 1)
          SizedBox(
            height: 16,
          ),
        if (groupVariants.length > 1)
          DropdownButtonFormField(
            onChanged: (String group) {
              setState(() {
                _selectedGroup = group;
              });
            },
            value: _selectedGroup,
            items: [
              for (final group in groupVariants)
                DropdownMenuItem(child: Text(group.sentenceCase), value: group)
            ],
            decoration: InputDecoration(
                filled: true,
                labelText: "Disposal type",
                prefixIcon: Icon(Icons.category)),
          ),
        SizedBox(
          height: 16,
        ),
        RaisedButton.icon(
            onPressed: () {
              BlocProvider.of<AddLocationBloc>(context)
                  .add(DetailsSelectedEvent());
            },
            color: Theme.of(context).primaryColor,
            icon: Icon(Icons.arrow_forward),
            label: Text("Next"))
      ],
    );
  }
}
