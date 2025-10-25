import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

List<T> toModelList<T>(
    List<dynamic> list, T Function(Map<String, dynamic>) fromJson) {
  return list.map<T>((json) => fromJson(json as Map<String, dynamic>)).toList();
}

Future<void> openUrlSheet({required String url}) async {
  await Share.share(url);
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
