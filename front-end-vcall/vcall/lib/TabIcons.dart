import 'package:flutter/material.dart';

class TabIconData {
  TabIconData({
    this.imagePath = '',
    this.index = 0,
    this.selectedImagePath = '',
    this.isSelected = false,
    this.animationController,
  });

  String imagePath;
  String selectedImagePath;
  bool isSelected;
  int index;

  AnimationController? animationController;

  static List<TabIconData> tabIconsList = <TabIconData>[
    TabIconData(
      imagePath: 'assets/bar/cat_before.svg',
      selectedImagePath: 'assets/bar/cat.svg',
      index: 0,
      isSelected: true,
      animationController: null,
    ),
    TabIconData(
      imagePath: 'assets/bar/rooms_before.svg',
      selectedImagePath: 'assets/bar/rooms.svg',
      index: 1,
      isSelected: false,
      animationController: null,
    ),
    TabIconData(
      imagePath: 'assets/bar/profil_before.svg',
      selectedImagePath: 'assets/bar/profil.svg',
      index: 2,
      isSelected: false,
      animationController: null,
    ),
    TabIconData(
      imagePath: 'assets/bar/reglage_before.svg',
      selectedImagePath: 'assets/bar/reglage.svg',
      index: 3,
      isSelected: false,
      animationController: null,
    ),
  ];
}
