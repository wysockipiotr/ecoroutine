import 'package:ecoschedule/utils/random.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoryTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: randomColor(),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FaIcon(FontAwesomeIcons.recycle),
            Text(
              "Waste",
              style: GoogleFonts.monda(),
            )
          ],
        ),
      ),
    );
  }
}
