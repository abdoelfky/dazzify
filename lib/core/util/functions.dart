import 'package:share_plus/share_plus.dart';

List<T> toModelList<T>(
    List<dynamic> list, T Function(Map<String, dynamic>) fromJson) {
  return list.map<T>((json) => fromJson(json as Map<String, dynamic>)).toList();
}

Future<void> openUrlSheet({required String url}) async {
  await Share.shareUri(Uri.parse(url));
}
