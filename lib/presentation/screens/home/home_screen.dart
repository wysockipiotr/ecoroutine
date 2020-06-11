import 'package:ecoschedule/data/services/api/schedules.dart';
import 'package:ecoschedule/domain/waste_disposal.dart';
import 'package:ecoschedule/presentation/screens/home/category_tile.dart';
import 'package:ecoschedule/presentation/screens/home/section.dart';
import 'package:ecoschedule/presentation/screens/locations_list/location_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> addresses = [
    "00-000 City, Street 0",
    "00-000 City, Street 1"
  ];
  int currentPage = 0;
  List<WasteDisposal> disposals = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).canvasColor,
          centerTitle: true,
          title: GestureDetector(
            onTap: () async {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => LocationsListScreen()));
            },
            child: Text(addresses[currentPage],
                style: GoogleFonts.monda().copyWith(fontSize: 16.0)),
          ),
        ),
        body: PageView.builder(onPageChanged: (int pageIndex) {
          setState(() {
            currentPage = pageIndex % 2;
          });
        }, itemBuilder: (context, index) {
          return RefreshIndicator(
              backgroundColor: Theme.of(context).backgroundColor,
              onRefresh: () async {
                final schedules = await getSchedule();

                setState(() {
                  this.disposals = schedules;
                });
              },
              child: Container(
                  height: double.infinity, child: _buildSectionList()));
        }));
  }

  ListView _buildSectionList() {
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
                  .map((WasteDisposal disposal) =>
                      CategoryTile(disposal: disposal))
                  .toList(),
            ));
      },
      shrinkWrap: true,
    );
  }
}
