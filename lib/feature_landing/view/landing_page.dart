import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/base/common_use_cases/route_authentication_use_case.dart';
import 'package:lykke_mobile_mavn/base/router/router.dart';
import 'package:lykke_mobile_mavn/feature_email_verification/bloc/email_confirmation_bloc.dart';
import 'package:lykke_mobile_mavn/feature_landing/bloc/route_authentication_bloc.dart';
import 'package:lykke_mobile_mavn/feature_landing/bloc/route_authentication_bloc_output.dart';
import 'package:lykke_mobile_mavn/lib_dynamic_links/dynamic_link_manager.dart';
import 'package:lykke_mobile_mavn/lib_dynamic_links/dynamic_link_manager_mixin.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/spinner.dart';

class LandingPage extends HookWidget with DynamicLinkManagerMixin {
  @override
  Widget build(BuildContext context) {
    startListenOnceForDynamicLinks();
    final router = useRouter();
    final dynamicLinkManager = useDynamicLinkManager();
    final routeAuthenticationBloc = useRouteAuthenticationBloc();
    final routeAuthenticationState =
        useBlocState<RouteAuthenticationState>(routeAuthenticationBloc);
    final emailConfirmationBloc = useEmailConfirmationBloc();

    useBlocEventListener(routeAuthenticationBloc, (event) {
      if (event is RouteAuthenticationLoadedEvent) {
        if (event.target.page == RouteAuthenticationPage.verifyEmail &&
            emailConfirmationBloc.hasPendingEmailConfirmation()) {
          dynamicLinkManager.routeEmailConfirmationRequests();
          return;
        }

        router.navigateToAuthenticationFlow(event.target);
      }
    });

    useEffect(() {
      routeAuthenticationBloc.routeTo(targetPage: RouteAuthenticationPage.home);
    }, [routeAuthenticationBloc]);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            if (routeAuthenticationState is RouteAuthenticationLoadingState)
              const Expanded(child: Center(child: Spinner())),
          ],
        ),
      ),
    );
  }
}
