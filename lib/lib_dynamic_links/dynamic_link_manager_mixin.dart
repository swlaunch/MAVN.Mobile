import 'package:lykke_mobile_mavn/lib_dynamic_links/dynamic_link_manager.dart';

mixin DynamicLinkManagerMixin {
  void startListenOnceForDynamicLinks() {
    useDynamicLinkManager().startListenOnceForDynamicLinks();
  }
}
