import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';

String base64String(Uint8List data) => base64Encode(data);
Image imageFromBase64String(String base64String, {double? width, double? height}) => Image.memory(
  base64Decode(base64String),
  fit: BoxFit.fill,
  width: width,
  height: height,
);