import 'dart:async';

import 'package:ecoroutine/adapter/adapter.dart';
import 'package:ecoroutine/adapter/ecoharmonogram-api/dto/dto.dart';
import 'package:ecoroutine/domain/location/entity/location.entity.dart';
import 'package:ecoroutine/presentation/screen/locations/locations.screen.dart';
import 'package:ecoroutine/presentation/screen/schedules/bloc/bloc.dart';
import 'package:ecoroutine/presentation/screen/schedules/bloc/page.bloc.dart';
import 'package:ecoroutine/presentation/screen/schedules/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class SchedulesScreen extends StatefulWidget {
  @override
  _SchedulesScreenState createState() => _SchedulesScreenState();
}

class _SchedulesScreenState extends State<SchedulesScreen> {
  Completer<void> _refreshCompleter;
  ValueNotifier<LocationEntity> _activeTitle =
      ValueNotifier<LocationEntity>(null);

  @override
  void initState() {
    super.initState();
    _refreshCompleter = Completer<void>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SchedulesCubit, SchedulesState>(
      listener: (context, state) {
        if (state is SchedulesReady) {
          _refreshCompleter?.complete();
          _refreshCompleter = Completer<void>();
        }
      },
      builder: (context, state) {
        if (state is SchedulesReady) {
          if (state.locationsToDisposals.isEmpty) {
            return _buildNoLocations();
          }
          return _buildScaffold(state.locationsToDisposals);
        } else {
          return _buildLoader();
        }
      },
    );
  }

  Widget _buildScaffold(
      Map<LocationEntity, List<WasteDisposalDto>> locationsToDisposals) {
    final controller = PageController(initialPage: 0);
    _activeTitle.value = locationsToDisposals.entries.toList()[0].key;

    return Scaffold(
        appBar: AppBar(
            backgroundColor: Theme.of(context).canvasColor,
            elevation: 1,
            toolbarHeight: 75,
            centerTitle: true,
            title: InkWell(
              borderRadius: BorderRadius.circular(6.0),
              onTap: () async {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LocationsScreen()));
              },
              child: ValueListenableBuilder(
                valueListenable: _activeTitle,
                builder: (context, value, _) => AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                    return ScaleTransition(child: child, scale: animation);
                  },
                  switchInCurve: Curves.easeOut,
                  switchOutCurve: Curves.easeIn,
                  child: Padding(
                    key: ValueKey<LocationEntity>(value),
                    padding: const EdgeInsets.all(6.0),
                    child: Column(
                      children: <Widget>[
                        Text(value.name,
                            style:
                                GoogleFonts.monda().copyWith(fontSize: 16.0)),
                        Text(
                            "${value.town.name}, ${value.streetName} ${value.houseNumber}",
                            style:
                                GoogleFonts.monda().copyWith(fontSize: 12.0)),
                      ],
                    ),

                    // child: Text(value,
                    //     style: GoogleFonts.monda(), key: ValueKey<String>(value)
                  ),
                ),
              ),
            )),
        body: BlocListener<PageCubit, int>(
          listener: (context, pageIndex) {
            controller.animateToPage(pageIndex,
                duration: Duration(milliseconds: 100), curve: Curves.linear);
            _activeTitle.value =
                locationsToDisposals.entries.toList()[pageIndex].key;
          },
          child: PageView(
            controller: controller,
            onPageChanged: (index) {
              _activeTitle.value =
                  locationsToDisposals.entries.toList()[index].key;
            },
            children: locationsToDisposals.values
                .map((List<WasteDisposalDto> disposals) => RefreshIndicator(
                    child: _buildSectionList(disposals),
                    onRefresh: () async {
                      context.read<SchedulesCubit>().onRefreshRequested();
                      return _refreshCompleter.future;
                    }))
                .toList(),
          ),
        ));
  }

  Widget _buildNoLocations() => Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).canvasColor,
          centerTitle: true,
          title: GestureDetector(
            onTap: () async {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LocationsScreen()));
            },
            child: Text("No locations", style: GoogleFonts.monda()),
          ),
        ),
        body: Container(),
      );

  Widget _buildLoader() => Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );

  ListView _buildSectionList(disposals) {
    final disposalsByDay = groupByDate(disposals);

    return ListView.builder(
      itemCount: disposalsByDay.length,
      itemBuilder: (context, index) {
        return Container(
            margin: EdgeInsets.only(left: 8.0, right: 8.0, bottom: 16.0),
            child: Section(
              title: DateFormat("d MMMM yyyy")
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
