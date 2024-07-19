

import 'package:doan_cs3/models/nav/rive_model.dart';

class NavItemModel{

  final String title;
  final RiveModel rive;

  NavItemModel({required this.title, required this.rive});
}

List<RiveModel> bottomNavItems = [
  RiveModel(
      src: "assets/RiveAssets/iconss.riv",
      artboard: "HOME",
      stateMachineName: "HOME_Interactivity"),
  RiveModel(
      src: "assets/RiveAssets/iconss.riv",
      artboard: "SEARCH",
      stateMachineName: "SEARCH_Interactivity"),
  RiveModel(
      src: "assets/RiveAssets/iconss.riv",
      artboard: "LIKE/STAR",
      stateMachineName: "STAR_Interactivity"),
  RiveModel(
      src: "assets/RiveAssets/iconss.riv",
      artboard: "USER",
      stateMachineName: "USER_Interactivity"),
];