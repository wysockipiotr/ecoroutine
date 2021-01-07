import 'package:flutter/material.dart';

class LoadingCurtainScreen extends StatelessWidget {
  const LoadingCurtainScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
}
