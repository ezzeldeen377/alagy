import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';

Future<File?> pickImage() async {
  try {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (image != null) {
      final compressedPickedImage = await compressImages(image);
      if (compressedPickedImage != null) {
        return compressedPickedImage;
      } else {
        return null;
      }
    } else {
      return null;
    }
  } catch (e) {
    return null;
  }
}

Future<File?> compressImages(XFile image) async {
  

  var compressedImage = await compress(image, image.path);
  if (compressedImage != null) {
    double imageSize = compressedImage.lengthSync() / (1024 * 1024); // in MB
    if (imageSize > 2) {
      compressedImage = await compress(image, image.path);
    }
    return compressedImage;
  }
  return null;
}

Future<File?> compress(XFile image, String targetPath) async {
  final compressedImageBytes = await FlutterImageCompress.compressWithFile(
    image.path,
    quality: 70,
    minWidth: 800,
    minHeight: 600,
  );

  if (compressedImageBytes != null) {
    File compressedImage = File(targetPath);
    await compressedImage.writeAsBytes(compressedImageBytes);

    return compressedImage;
  }

  return null;
}
