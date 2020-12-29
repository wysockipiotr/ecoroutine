import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class NoItemsPlaceholder extends StatelessWidget {
  final String message;

  const NoItemsPlaceholder({this.message});

  @override
  Widget build(BuildContext context) => Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FaIcon(FontAwesomeIcons.solidSadCry, size: 48),
            SizedBox(
              height: 16,
            ),
            Text(message, style: GoogleFonts.monda(fontSize: 24))
          ],
        ),
      );
}
