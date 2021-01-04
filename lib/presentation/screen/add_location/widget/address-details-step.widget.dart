import 'package:ecoroutine/presentation/screen/add_location/bloc/bloc.dart';
import 'package:ecoroutine/presentation/screen/add_location/enum/enum.dart';
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
  bool _touched = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddLocationCubit, AddLocationState>(
        builder: (BuildContext context, AddLocationState state) {
      if (state.currentStep == AddLocationStep.SelectDetails) {
        return _buildDetailsDropdowns(state);
      } else {
        return Container();
      }
    });
  }

  Widget _buildDetailsDropdowns(AddLocationState state) {
    final streetCandidates = state.streetCandidates;

    final sidesVariants =
        streetCandidates.map((candidate) => candidate.sides).toSet();
    final groupVariants =
        streetCandidates.map((candidate) => candidate.group).toSet();

    if (!_touched) {
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
                _touched = true;
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
                _touched = true;
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
              context.read<AddLocationCubit>().onDetailsSelected(
                  sides: _selectedSides, group: _selectedGroup);
            },
            color: Theme.of(context).primaryColor,
            icon: Icon(Icons.arrow_forward),
            label: Text("Next"))
      ],
    );
  }
}
