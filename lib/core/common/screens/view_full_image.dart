import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dismissible_page/dismissible_page.dart';
import 'package:flutter/material.dart';

class ViewFullImage extends StatelessWidget {
  const ViewFullImage({super.key, required this.imageUrl, this.tag});
  final String imageUrl;
  final String? tag;
  bool _isNetworkImage(String path) {
    return path.startsWith('http://') || path.startsWith('https://');
  }
  bool _isAssetsImage(String path) {
    return path.startsWith('assets/');
  }

  @override
  Widget build(BuildContext context) {
    return DismissiblePage(
      onDismissed: () {
        Navigator.of(context).pop();
      },
      direction: DismissiblePageDismissDirection.multi,
      isFullScreen: false,
      child: Hero(
          tag: tag??imageUrl,
          child: _isNetworkImage(imageUrl)
              ? CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.fitWidth,
                )
              : _isAssetsImage(imageUrl)
                  ? Image.asset(
                      imageUrl,
                      fit: BoxFit.fitWidth,
                    )
                  : Image.file(
                      File(imageUrl),
                      fit: BoxFit.fitWidth,
                    )),
    );
  }
}
