import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';

part 'image_names.dart';

class ImageHelper {
  static const String _pathToImageAssets = 'assets/images';
  static const String _pathToIconAssets = 'assets/vectors';

  static SvgPicture categorySvgByCustomPath(
    String path, {
    Color? color,
    double? width,
    double? height,
  }) {
    return SvgPicture.asset(
      path,
      color: color,
      width: width,
      height: height,
    );
  }

  static String categorySvgPath(
    String name, {
    Color? color,
    double? width,
    double? height,
  }) {
    try {
      return 'assets/category/${name.split('"').first}.svg';
    } on Exception {
      return '';
    }
  }

  static Widget svgImage(
    String name, {
    Color? color,
    double? width,
    double? height,
  }) {
    try {
      return SvgPicture.asset(
        '$_pathToIconAssets/$name.svg',
        color: color,
        width: width,
        height: height,
      );
    } on Exception {
      return Container();
    }
  }

  static String getImagePath(String name) {
    return '$_pathToImageAssets/$name.png';
  }

  static Image getImage(
    String name, {
    double? width,
    double? height,
    BoxFit? fit,
    ImageLoadingBuilder? loadingBuilder,
  }) {
    return Image(
      width: width,
      height: height,
      image: AssetImage('$_pathToImageAssets/$name.png'),
      fit: fit,
      loadingBuilder: loadingBuilder,
      gaplessPlayback: true,
    );
  }

  static AssetImage getAssetImage(String name) {
    return AssetImage('$_pathToImageAssets/$name.png');
  }

  static Future<Uint8List> getBytesFromAsset({
    required String name,
    required int width,
  }) async {
    ByteData data = await rootBundle.load(
      '$_pathToImageAssets/$name.png',
    );
    Codec codec = await instantiateImageCodec(
      data.buffer.asUint8List(),
      targetWidth: width,
    );
    FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(
      format: ImageByteFormat.png,
    ))!
        .buffer
        .asUint8List();
  }
}
