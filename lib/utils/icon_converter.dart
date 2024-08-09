import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/Models/icon_pack.dart';
import 'package:flutter_iconpicker/Serialization/icondata_serialization.dart';

class IconConverter {
  static String parseIconToDb(IconData icon) {
    Map<String, dynamic> serializedIcon =
        serializeIcon(icon, iconPack: IconPack.fontAwesomeIcons)!;
    String iconJson = jsonEncode(serializedIcon);
    return iconJson;
  }

  static IconData parseIconFromDb(Map<String, dynamic> icon) {
    return deserializeIcon(icon) ?? Icons.warning_amber;
  }
}
