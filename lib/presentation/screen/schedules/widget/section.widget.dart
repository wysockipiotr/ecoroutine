import 'package:ecoschedule/presentation/screen/schedules/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class Section extends StatelessWidget {
  final String title;
  final List<CategoryTile> tiles;

  const Section({@required this.title, this.tiles = const []});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Padding(
          child: Text(
            title,
            style: GoogleFonts.monda(
                textStyle: Theme.of(context).textTheme.subtitle2),
          ),
          padding: EdgeInsets.only(left: 12.0, top: 16.0, bottom: 12.0),
        ),
        GridView(
          children: tiles,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, childAspectRatio: 1.8),
        )
      ],
    );
  }
}
