import 'package:dazzify/core/constants/app_constants.dart';
import 'package:dazzify/core/constants/brand_governorates_keys.dart';
import 'package:dazzify/core/util/extensions.dart';
import 'package:flutter/material.dart';

String getLocalizedGovernorate(BuildContext context, int governorateIndex) {
  String governorateKey = BrandGovernoratesKeys.governorates[governorateIndex]!;

  switch (governorateKey) {
    case AppConstants.cairo:
      return context.tr.cairo;
    case AppConstants.alexandria:
      return context.tr.alexandria;
    case AppConstants.giza:
      return context.tr.giza;
    case AppConstants.portSaid:
      return context.tr.portSaid;
    case AppConstants.suez:
      return context.tr.suez;
    case AppConstants.damietta:
      return context.tr.damietta;
    case AppConstants.dakahlia:
      return context.tr.dakahlia;
    case AppConstants.sharqia:
      return context.tr.sharqia;
    case AppConstants.qalyubia:
      return context.tr.qalyubia;
    case AppConstants.kafrElSheikh:
      return context.tr.kafrElsheikh;
    case AppConstants.gharbia:
      return context.tr.gharbia;
    case AppConstants.monufia:
      return context.tr.monufia;
    case AppConstants.beheira:
      return context.tr.beheira;
    case AppConstants.ismailia:
      return context.tr.ismailia;
    case AppConstants.beniSuef:
      return context.tr.benisuef;
    case AppConstants.fayoum:
      return context.tr.fayoum;
    case AppConstants.minya:
      return context.tr.minya;
    case AppConstants.asyut:
      return context.tr.asyut;
    case AppConstants.sohag:
      return context.tr.sohag;
    case AppConstants.qena:
      return context.tr.qena;
    case AppConstants.luxor:
      return context.tr.luxor;
    case AppConstants.aswan:
      return context.tr.aswan;
    case AppConstants.redSea:
      return context.tr.redSea;
    case AppConstants.newValley:
      return context.tr.newValley;
    case AppConstants.matruh:
      return context.tr.matruh;
    case AppConstants.northSinai:
      return context.tr.northSinai;
    case AppConstants.southSinai:
      return context.tr.southSinai;
    default:
      return '';
  }
}
