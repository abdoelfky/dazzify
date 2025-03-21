import 'package:cached_network_image/cached_network_image.dart';
import 'package:dazzify/core/constants/app_constants.dart';
import 'package:dazzify/core/util/assets_manager.dart';
import 'package:dazzify/core/util/colors_manager.dart';
import 'package:dazzify/core/util/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:shimmer/shimmer.dart';

class DazzifyCachedNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final double borderRadius;
  final int? memCacheWidth;

  const DazzifyCachedNetworkImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit,
    this.borderRadius = 0,
    this.memCacheWidth,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final adjustedWidth =
              (constraints.maxWidth.isFinite ? constraints.maxWidth : width)
                  ?.toInt();
          return CachedNetworkImage(
            imageUrl: imageUrl,
            cacheKey: CustomCacheManager.getCacheKey(imageUrl),
            cacheManager: CustomCacheManager.instance,
            memCacheWidth: memCacheWidth ?? adjustedWidth,
            placeholder: (context, url) => Shimmer.fromColors(
              baseColor: context.isDarkTheme
                  ? ColorsManager.baseShimmerDark
                  : ColorsManager.baseShimmerLight,
              highlightColor: context.isDarkTheme
                  ? ColorsManager.highlightShimmerDark
                  : ColorsManager.highlightShimmerLight,
              child: Container(
                width: width ?? double.infinity,
                height: height ?? double.infinity,
                color: Colors.white,
              ),
            ),
            errorWidget: (context, url, error) {
              return AspectRatio(
                aspectRatio: 1,
                child: Image.asset(
                  AssetsManager.dazzifySmilyFace,
                  fit: BoxFit.cover,
                ),
              );
            },
            width: width,
            height: height,
            fit: fit,
          );
        },
      ),
    );
  }
}

class DazzifyCachedNetworkImageProvider extends CachedNetworkImageProvider {
  DazzifyCachedNetworkImageProvider(
    super.url, {
    super.maxHeight,
    super.maxWidth,
    super.scale = 1.0,
    super.errorListener,
    super.headers,
    super.imageRenderMethodForWeb,
  }) : super(
          cacheKey: CustomCacheManager.getCacheKey(url),
          cacheManager: CustomCacheManager.instance,
        );
}

class CustomCacheManager {
  static final instance = CacheManager(
    Config(
      AppConstants.cacheFolder,
      stalePeriod: const Duration(days: AppConstants.imagesCacheDuration),
    ),
  );

  static String getCacheKey(String url) {
    Uri uri = Uri.parse(url);
    String path = uri.path;
    return 'https://${uri.host}$path';
  }
}
