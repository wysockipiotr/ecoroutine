import 'package:ecoroutine/config/app.config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';

class LoadingCurtainScreen extends StatelessWidget {
  const LoadingCurtainScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(APP_TITLE,
                style: GoogleFonts.monda(
                    fontWeight: FontWeight.bold, color: Colors.green)),
            SizedBox(
              height: 24,
            ),
            SpinKitWanderingCubes(color: Colors.green),
          ],
        )),
      );
}
