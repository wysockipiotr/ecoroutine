import 'package:ecoschedule/presentation/screens/home/category_tile.dart';
import 'package:ecoschedule/presentation/screens/home/section.dart';
import 'package:ecoschedule/presentation/screens/locations_list/location_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).canvasColor,
          centerTitle: true,
          title: GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => LocationsListScreen()));
            },
            child: Text(addresses[currentPage],
                style: GoogleFonts.monda().copyWith(fontSize: 16.0)),
          ),
        ),
        body: PageView.builder(
            physics: BouncingScrollPhysics(),
            onPageChanged: (int pageIndex) {
              setState(() {
                currentPage = pageIndex % 2;
              });
            },
            itemBuilder: (context, index) {
              return RefreshIndicator(
                  backgroundColor: Theme.of(context).backgroundColor,
                  onRefresh: () async {
                    await Future.delayed(Duration(seconds: 1));
                    setState(() {});
                  },
                  child: _buildSectionList());
            }));
  }

  ListView _buildSectionList() {
    return ListView.builder(
      physics: BouncingScrollPhysics(),
      itemCount: 4,
      itemBuilder: (context, index) {
        return Container(
            margin: EdgeInsets.only(left: 8.0, right: 8.0, bottom: 16.0),
            child: Section(
              title: "Section $index",
              tiles: <CategoryTile>[for (int i = 0; i < 6; i++) CategoryTile()],
            ));
      },
      shrinkWrap: true,
    );
  }
}
