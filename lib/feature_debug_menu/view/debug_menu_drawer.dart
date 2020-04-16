import 'package:flutter/material.dart';
import 'package:lykke_mobile_mavn/app/resources/unlocalized_strings.dart';
import 'package:lykke_mobile_mavn/feature_debug_menu/view/settings/clear_secure_storage_settings.dart';
import 'package:lykke_mobile_mavn/feature_debug_menu/view/settings/expire_session_settings.dart';
import 'package:lykke_mobile_mavn/feature_debug_menu/view/settings/proxy_settings.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/dismiss_keyboard_on_tap.dart';

class DebugMenuDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Drawer(
        child: SafeArea(
          child: DismissKeyboardOnTap(
            child: ListView(
              children: <Widget>[
                _buildDrawerTitle(),
                const Divider(color: Colors.black),
                ProxySettings(),
                const Divider(color: Colors.black),
                ExpireSessionSettings(),
                const Divider(color: Colors.black),
                ClearSecureStorageSettings(),
                const Divider(color: Colors.black),
              ],
            ),
          ),
        ),
      );

  Widget _buildDrawerTitle() => const Center(
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Text(
            UnlocalizedStrings.debugMenuTitle,
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
        ),
      );
}
