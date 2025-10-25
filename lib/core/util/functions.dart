import 'dart:io';

import 'package:dazzify/core/framework/export.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

List<T> toModelList<T>(
    List<dynamic> list, T Function(Map<String, dynamic>) fromJson) {
  return list.map<T>((json) => fromJson(json as Map<String, dynamic>)).toList();
}

Future<void> openUrlSheet({
  required String url,
  required BuildContext context,
}) async {
  print(url);

  try {
    // On iOS, we must specify where the share sheet will appear
    if (Platform.isIOS) {
      final box = context.findRenderObject() as RenderBox?;
      await Share.share(
        url,
        sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
      );
    } else {
      await Share.share(url);
    }
  } catch (e) {
    print('Error while sharing: $e');
  }
}

double reformatRating(double rating) {
  return double.parse(rating.toStringAsFixed(1));
}

String reformatPriceWithCommas(num price) {
  final formatter = NumberFormat('#,###');
  return formatter.format(price);
}

String truncateText(String text, int maxLength) {
  if (text.length <= maxLength) return text;
  return '${text.substring(0, maxLength)}...';
}
