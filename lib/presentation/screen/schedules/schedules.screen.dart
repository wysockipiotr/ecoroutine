import 'dart:async';

import 'package:ecoroutine/adapter/adapter.dart';
import 'package:ecoroutine/adapter/ecoharmonogram-api/dto/dto.dart';
import 'package:ecoroutine/bloc/bloc.dart';
import 'package:ecoroutine/config/app.config.dart';
import 'package:ecoroutine/domain/location/entity/location.entity.dart';
import 'package:ecoroutine/presentation/screen/schedules/widget/app-bar.widget.dart';
import 'package:ecoroutine/presentation/screen/schedules/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecoroutine/utility/utility.dart' show NthKey;

class SchedulesScreen extends StatefulWidget {
  static const RouteName = "/";

  final Map<LocationEntity, List<WasteDisposalDto>> locationsToDisposals;
  final int initialPage;

  SchedulesScreen({this.locationsToDisposals, this.initialPage = 0});

  @override
  _SchedulesScreenState createState() => _SchedulesScreenState();
}

class _SchedulesScreenState extends State<SchedulesScreen> {
  Completer<void> _refreshCompleter;
  ValueNotifier<LocationEntity> _activeLocation =
      ValueNotifier<LocationEntity>(null);
  ValueNotifier<bool> _elevateAppBar = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    _refreshCompleter = Completer<void>();
    _activeLocation.value =
        widget.locationsToDisposals.nthKey(widget.initialPage);
    _activeLocation.addListener(() {
      _elevateAppBar.value = false;
    });
  }

  @override
  Widget build(BuildContext context) =>
      BlocListener<SchedulesCubit, SchedulesState>(
        listener: (ctx, state) {
          if (state is SchedulesReady) {
            _refreshCompleter?.complete();
            _refreshCompleter = Completer<void>();
          }
        },
        child: _buildScaffold(widget.locationsToDisposals),
      );

  Widget _buildScaffold(
      Map<LocationEntity, List<WasteDisposalDto>> locationsToDisposals) {
    final controller = PageController(initialPage: widget.initialPage);

    return Scaffold(
        appBar: SchedulesAppBar(
          activeLocation: _activeLocation,
          elevated: _elevateAppBar,
          onSchedulesPageChange: (page) {
            // if (page != null) {
            //   controller.jumpToPage(page);
            //   _activeLocation.value = locationsToDisposals.nthKey(page);
            // }
          },
        ),
        body: MultiBlocListener(
          listeners: [
            BlocListener<SchedulesCubit, SchedulesState>(
              listener: (context, state) {
                if (state is SchedulesError) {
                  _refreshCompleter?.complete();
                  _refreshCompleter = Completer<void>();

                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text("No internet connection 🌎"),
                    action: null,
                  ));
                }
              },
            ),
          ],
          child: PageView(
            controller: controller,
            onPageChanged: (index) {
              _activeLocation.value = locationsToDisposals.nthKey(index);
              // _elevateAppBar.value = false;
            },
            children: locationsToDisposals.values
                .map((List<WasteDisposalDto> disposals) => RefreshIndicator(
                    color: Colors.green,
                    child: NotificationListener(
                      child: _buildSectionList(disposals),
                      onNotification: (Notification notification) {
                        if (notification is ScrollUpdateNotification) {
                          _elevateAppBar.value =
                              notification.metrics.pixels > 8;
                        }
                        return false;
                      },
                    ),
                    onRefresh: () async {
                      context.read<SchedulesCubit>().refresh();
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
              title: _formatDate(disposalsByDay.nthKey(index)),
              tiles: disposalsByDay[disposalsByDay.nthKey(index)]
                  .map((WasteDisposalDto disposal) =>
                      CategoryTile(disposal: disposal))
                  .toList(),
            ));
      },
      shrinkWrap: true,
    );
  }

  static String _formatDate(DateTime datetime) {
    final now = DateTime.now();
    if (datetime == DateTime(now.year, now.month, now.day)) {
      return "Today";
    } else if (datetime == DateTime(now.year, now.month, now.day + 1)) {
      return "Tomorrow";
    } else {
      return dateFormat.format(datetime);
    }
  }
}
