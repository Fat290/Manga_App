import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CachedImage extends StatelessWidget {
  const CachedImage({super.key, required this.mangaThumb, required this.height, required this.width});
  final String mangaThumb;
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: CachedNetworkImage(
            key:UniqueKey() ,
            imageUrl: mangaThumb ,
            fit: BoxFit.cover,
            placeholder: (context, url) => Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                color: Theme.of(context).colorScheme.inversePrimary.withOpacity(0.5),
              ),
            ),
        ),
      ),
    );
  }
}
