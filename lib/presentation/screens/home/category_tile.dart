import 'package:auto_size_text/auto_size_text.dart';
import 'package:ecoschedule/data/services/schedules_service.dart';
import 'package:ecoschedule/domain/disposal_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recase/recase.dart';

class CategoryTile extends StatelessWidget {
  final WasteDisposal disposal;

  const CategoryTile({this.disposal});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: disposal.color,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FaIcon(ICON_MAP[disposal.name] ?? FontAwesomeIcons.recycle),
            SizedBox(
              height: 4.0,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: AutoSizeText(
                this.disposal.name.sentenceCase,
                maxLines: 2,
                textAlign: TextAlign.center,
                style: GoogleFonts.monda(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
