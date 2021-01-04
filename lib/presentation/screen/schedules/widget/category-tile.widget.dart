import 'package:auto_size_text/auto_size_text.dart';
import 'package:ecoroutine/adapter/adapter.dart';
import 'package:ecoroutine/adapter/ecoharmonogram-api/dto/dto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recase/recase.dart';

class CategoryTile extends StatelessWidget {
  final WasteDisposalDto disposal;

  const CategoryTile({this.disposal});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.grey[200],
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FaIcon(
              ICON_MAP[disposal.name.trim().toUpperCase()] ??
                  FontAwesomeIcons.recycle,
              color: disposal.color.withAlpha(255),
            ),
            SizedBox(
              height: 4.0,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: AutoSizeText(
                this.disposal.name.sentenceCase,
                maxLines: 3,
                textAlign: TextAlign.center,
                style: GoogleFonts.monda(color: disposal.color.withAlpha(255)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
