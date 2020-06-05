import 'package:flutter/foundation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/base/dependency_injection/app_module.dart';
import 'package:lykke_mobile_mavn/base/router/router.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';
import 'package:url_launcher/url_launcher.dart';

class ExternalRouter {
  ExternalRouter(this.router);

  final Router router;

//region Store ids

  static const whatsAppAppStoreId = '310633997';
  static const whatsAppPlayStoreId = 'com.whatsapp';

//endregion Store ids

//region App names

  static const whatsAppUrl = 'whatsapp://';

//endregion App names

  Future<void> pushWhatsApp({
    @required String phone,
    @required String message,
  }) async {
    final url = '{$whatsAppUrl}send?phone=$phone&text=$message';
    await canLaunchUrl(url)
        ? await launch(url)
        : await router.redirectToCustomAppStore(
            androidId: whatsAppPlayStoreId, iosId: whatsAppAppStoreId);
  }

  Future<bool> canLaunchUrl(String url) => canLaunch(url);

  Future<bool> launchUrl(String urlString, {VoidCallback onLaunchError}) async {
    if (await canLaunchUrl(urlString)) {
      await launch(urlString);
      // The delay to prevent instances where invocation is so quick,
      // throttling does not occur.
      await Future.delayed(const Duration(milliseconds: 100));
    } else {
      if (onLaunchError != null) onLaunchError();
    }
  }

  Future<bool> launchWebsite(String urlString,
      {VoidCallback onLaunchError}) async {
    if (await canLaunchUrl(urlString)) {
      await launch(
        urlString,
        forceSafariVC: false,
      );
      // The delay to prevent instances where invocation is so quick,
      // throttling does not occur.
      await Future.delayed(const Duration(milliseconds: 100));
    } else {
      if (onLaunchError != null) onLaunchError();
    }
  }

  Future<bool> launchEmail(
    String email, {
    String subject,
    String body,
    VoidCallback onLaunchError,
  }) async {
    final uri = 'mailto:$email?subject=${subject ?? ''}&body=${body ?? ''}';
    return launchUrl(uri, onLaunchError: onLaunchError);
  }

  Future<bool> launchPhone(
    String phone, {
    VoidCallback onLaunchError,
  }) async =>
      launchUrl(_getFormattedPhoneNumber(phone), onLaunchError: onLaunchError);

  String _getFormattedPhoneNumber(String contactNumber) => 'tel:$contactNumber';
}

ExternalRouter useExternalRouter() =>
    ModuleProvider.of<AppModule>(useContext()).externalRouter;
