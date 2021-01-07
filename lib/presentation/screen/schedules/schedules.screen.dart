import 'dart:async';

import 'package:ecoroutine/adapter/adapter.dart';
import 'package:ecoroutine/adapter/ecoharmonogram-api/dto/dto.dart';
import 'package:ecoroutine/config/app.config.dart';
import 'package:ecoroutine/domain/location/entity/location.entity.dart';
import 'package:ecoroutine/presentation/screen/schedules/bloc/bloc.dart';
import 'package:ecoroutine/presentation/screen/schedules/bloc/page.bloc.dart';
import 'package:ecoroutine/presentation/screen/schedules/widget/app-bar.widget.dart';
import 'package:ecoroutine/presentation/screen/schedules/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecoroutine/utility/utility.dart' show NthKey;

class SchedulesScreen extends StatefulWidget {
  final Map<LocationEntity, List<WasteDisposalDto>> locationsToDisposals;

  SchedulesScreen({this.locationsToDisposals});

  @override
  _SchedulesScreenState createState() => _SchedulesScreenState();
}

class _SchedulesScreenState extends State<SchedulesScreen> {
  Completer<void> _refreshCompleter;
  ValueNotifier<LocationEntity> _activeLocation =
      ValueNotifier<LocationEntity>(null);

  @override
  void initState() {
    super.initState();
    _refreshCompleter = Completer<void>();
  }

  @override
  Widget build(BuildContext context) =>
      BlocListener<SchedulesCubit, SchedulesState>(
        listener: (context, state) {
          if (state is SchedulesReady) {
            _refreshCompleter?.complete();
            _refreshCompleter = Completer<void>();
          }
        },
        child: _buildScaffold(widget.locationsToDisposals),
      );

  Widget _buildScaffold(
      Map<LocationEntity, List<WasteDisposalDto>> locationsToDisposals) {
    final controller = PageController(initialPage: 0);
    _activeLocation.value = locationsToDisposals.nthKey(0);

    return Scaffold(
        appBar: SchedulesAppBar(activeLocation: _activeLocation),
        body: BlocListener<PageCubit, int>(
          listener: (context, pageIndex) {
            controller.jumpToPage(pageIndex);
            _activeLocation.value = locationsToDisposals.nthKey(pageIndex);
          },
          child: PageView(
            controller: controller,
            onPageChanged: (index) {
              _activeLocation.value = locationsToDisposals.nthKey(index);
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

  ListView _buildSectionList(disposals) {
    final disposalsByDay = groupByDate(disposals);
    return ListView.builder(
      itemCount: disposalsByDay.length,
      itemBuilder: (context, index) {
        return Container(
            margin: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 16.0),
            child: Section(
              title: dateFormat.format(disposalsByDay.keys.toList()[index]),
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
