import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DisposalType {
  static const Mixed = "ODPADY ZMIESZANE";
  static const Bio = "ODPADY BIO";
  static const PlasticAndMetal = "METALE I TWORZYWA SZTUCZNE";
  static const Bulky = "ODPADY WIELKOGABARYTOWE";
  static const Glass = "SZKŁO";
  static const MixedCleaning = "MYCIE POJEMNIKÓW ZMIESZANE";
  static const Paper = "PAPIER";
  static const BioCleaning = "MYCIE POJEMNIKÓW BIO";
}

const Map<String, IconData> ICON_MAP = const {
  DisposalType.Mixed: FontAwesomeIcons.solidTrashAlt,
  DisposalType.Bio: FontAwesomeIcons.seedling,
  DisposalType.Bulky: FontAwesomeIcons.dumpster,
  DisposalType.PlasticAndMetal: FontAwesomeIcons.recycle,
  DisposalType.Glass: FontAwesomeIcons.wineBottle,
  DisposalType.Paper: FontAwesomeIcons.solidNewspaper,
  DisposalType.BioCleaning: FontAwesomeIcons.faucet,
  DisposalType.MixedCleaning: FontAwesomeIcons.faucet
};
