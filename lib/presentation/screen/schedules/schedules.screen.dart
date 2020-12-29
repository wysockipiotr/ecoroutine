import 'dart:async';

import 'package:ecoschedule/adapter/adapter.dart';
import 'package:ecoschedule/adapter/ecoharmonogram-api/dto/dto.dart';
import 'package:ecoschedule/presentation/screen/locations/locations.screen.dart';
import 'package:ecoschedule/presentation/screen/schedules/bloc/bloc.dart';
import 'package:ecoschedule/presentation/screen/schedules/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class SchedulesScreen extends StatefulWidget {
  @override
  _SchedulesScreenState createState() => _SchedulesScreenState();
}

class _SchedulesScreenState extends State<SchedulesScreen> {
  int currentPage;
  Completer<void> _refreshCompleter;

  @override
  void initState() {
    super.initState();
    _refreshCompleter = Completer<void>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SchedulesBloc, SchedulesState>(
      listener: (context, state) {
        if (state is SchedulesReady) {
          _refreshCompleter?.complete();
          _refreshCompleter = Completer<void>();

          if (state.locationsToDisposals.isNotEmpty) {
            if (currentPage == null) {
              setState(() {
                currentPage = 0;
              });
            } else {
              if (currentPage >= state.locationsToDisposals.length) {
                setState(() {
                  currentPage = 0;
                });
              }
            }
          }
        }
      },
      builder: (context, state) {
        if (state is SchedulesReady) {
          if (state.locationsToDisposals.isEmpty) {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Theme.of(context).canvasColor,
                centerTitle: true,
                title: GestureDetector(
                  onTap: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LocationsScreen()));
                  },
                  child: Text("No locations"),
                ),
              ),
              body: Container(),
            );
          }

          final activeLocation =
              state.locationsToDisposals.keys.toList()[currentPage];

          return Scaffold(
              appBar: AppBar(
                backgroundColor: Theme.of(context).canvasColor,
                elevation: 0,
                centerTitle: true,
                title: GestureDetector(
                    onTap: () async {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LocationsScreen()));
                    },
                    child: Column(
                      children: <Widget>[
                        Text(activeLocation.name,
                            style:
                                GoogleFonts.monda().copyWith(fontSize: 16.0)),
                        Text(
                            "${activeLocation.town.name}, ${activeLocation.streetName} ${activeLocation.houseNumber}",
                            style:
                                GoogleFonts.monda().copyWith(fontSize: 12.0)),
                      ],
                    )),
              ),
              body: PageView(
                  controller: PageController(initialPage: currentPage),
                  onPageChanged: (int pageIndex) {
                    setState(() {
                      this.currentPage = pageIndex;
                    });
                  },
                  children: state.locationsToDisposals.values
                      .map((List<WasteDisposalDto> disposals) {
                    return RefreshIndicator(
                        child: _buildSectionList(disposals),
                        onRefresh: () async {
                          BlocProvider.of<SchedulesBloc>(context)
                              .add(SchedulesEvent.RefreshRequested);
                          return _refreshCompleter.future;
                        });
                  }).toList()));
        } else {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }

  ListView _buildSectionList(disposals) {
    final disposalsByDay = groupByDate(disposals);

    return ListView.builder(
      itemCount: disposalsByDay.length,
      itemBuilder: (context, index) {
        return Container(
            margin: EdgeInsets.only(left: 8.0, right: 8.0, bottom: 16.0),
            child: Section(
              title: DateFormat("d MMMM")
                  .format(disposalsByDay.keys.toList()[index]),
              tiles: disposalsByDay[disposalsByDay.keys.toList()[index]]
                  .map((WasteDisposalDto disposal) =>
                      CategoryTile(disposal: disposal))
                  .toList(),
            ));
      },
      shrinkWrap: true,
    );
  }
}
