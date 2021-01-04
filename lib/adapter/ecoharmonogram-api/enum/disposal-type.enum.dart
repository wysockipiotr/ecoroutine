import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DisposalType {
  static const Mixed = "ODPADY ZMIESZANE";
  static const Bio = "ODPADY BIO";
  static const Bio2 = "ODPADY BIODEGRADOWALNE";
  static const Bio3 = "ODPADY KUCHENNE ULEGAJĄCE BIODEGRADACJI";
  static const PlasticAndMetal = "METALE I TWORZYWA SZTUCZNE";
  static const Bulky = "ODPADY WIELKOGABARYTOWE";
  static const Glass = "SZKŁO";
  static const MixedCleaning = "MYCIE POJEMNIKÓW ZMIESZANE";
  static const Paper = "PAPIER";
  static const Paper2 = "PAPIER TEKTURA";
  static const BioCleaning = "MYCIE POJEMNIKÓW BIO";
  static const Ash = "POPIÓŁ";
  static const Ash2 = "POPIÓŁ I ŻUŻEL";
  static const Payment = "TERMIN PŁATNOŚCI";
  static const Payment2 = "PŁATNOŚCI";
}

const Map<String, IconData> ICON_MAP = const {
  DisposalType.Mixed: FontAwesomeIcons.solidTrashAlt,
  DisposalType.Bio: FontAwesomeIcons.seedling,
  DisposalType.Bio2: FontAwesomeIcons.seedling,
  DisposalType.Bio3: FontAwesomeIcons.seedling,
  DisposalType.Bulky: FontAwesomeIcons.dumpster,
  DisposalType.PlasticAndMetal: FontAwesomeIcons.recycle,
  DisposalType.Glass: FontAwesomeIcons.wineBottle,
  DisposalType.Paper: FontAwesomeIcons.solidNewspaper,
  DisposalType.Paper2: FontAwesomeIcons.solidNewspaper,
  DisposalType.BioCleaning: FontAwesomeIcons.faucet,
  DisposalType.MixedCleaning: FontAwesomeIcons.faucet,
  DisposalType.Ash: FontAwesomeIcons.fireAlt,
  DisposalType.Ash2: FontAwesomeIcons.fireAlt,
  DisposalType.Payment: FontAwesomeIcons.creditCard,
  DisposalType.Payment2: FontAwesomeIcons.creditCard
};
