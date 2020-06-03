import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:ecoschedule/presentation/screens/add_location/bloc.dart';
import 'package:ecoschedule/presentation/screens/add_location/states.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddressDetailsStep extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AddressDetailsStep();
}

class _AddressDetailsStep extends State<AddressDetailsStep> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddLocationBloc, AddLocationState>(
        builder: (BuildContext context, AddLocationState state) {
      if (state is SpecifyAddressDetailsState) {
        return Column(
          children: <Widget>[Text("...")],
        );
      } else {
        return Container();
      }
    });
  }
}
