import 'package:url_launcher/url_launcher.dart';

class MapHelper {
  static Future<String> openLocation({
    required double lat,
    required double long,
  }) async {
    String googleMapUrl =
        'https://www.google.com/maps/search/?api=1&query=$lat,$long';
    if (await canLaunchUrl(Uri.parse(googleMapUrl))) {
      await launchUrl(Uri.parse(googleMapUrl));
    } else {
      throw 'Could not launch $googleMapUrl';
    }
    return googleMapUrl;
  }
}
