import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/image_assets.dart';
import 'package:lykke_mobile_mavn/base/common_use_cases/has_pin_use_case.dart';
import 'package:lykke_mobile_mavn/base/common_use_cases/route_authentication_use_case.dart';
import 'package:lykke_mobile_mavn/base/router/router.dart';
import 'package:lykke_mobile_mavn/feature_splash/bloc/splash_bloc.dart';
import 'package:lykke_mobile_mavn/feature_splash/bloc/splash_bloc_output.dart';
import 'package:lykke_mobile_mavn/feature_splash/view/splash_widget.dart';
import 'package:lykke_mobile_mavn/feature_theme/bloc/theme_bloc.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_ui_components/error/generic_error_widget.dart';
import 'package:lykke_mobile_mavn/library_ui_components/error/network_error.dart';

class SplashPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final themeBloc = useThemeBloc();
    final splashBloc = useSplashBloc();
    final splashBlocState = useBlocState<SplashState>(splashBloc);
    final router = useRouter();
    final hasPinUseCase = useHasPinUseCase(context);

    useBlocEventListener(splashBloc, (event) {
      _redirect(event, router, hasPinUseCase, context);
    });

    void initialize() {
      splashBloc.initialize();
    }

    useEffect(() {
      initialize();
    }, [splashBloc]);

    useEffect(() {
      themeBloc.getTheme();
    });
    _precacheWelcomeImage(context);

    return Material(
      type: MaterialType.transparency,
      child: Stack(
        children: <Widget>[
          const SplashWidget(),
          if (splashBlocState is SplashBaseErrorState)
            Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    _buildErrorState(splashBlocState, initialize)
                  ],
                ))
        ],
      ),
    );
  }

  Future<void> _redirect(
    BlocEvent event,
    Router router,
    HasPinUseCase hasPinUseCase,
    BuildContext context,
  ) async {
    if (event is SplashRedirectToTargetPageEvent) {
      if (event.target.page == RouteAuthenticationPage.onboarding) {
        await _precacheOnboardingBackgroundImages(context);
      }

      await router.navigateToAuthenticationFlow(event.target);
    }
  }

  Future<void> _precacheWelcomeImage(BuildContext context) async {
    await precacheImage(
        const AssetImage(ImageAssets.welcomePageImage), context);
  }

  Future<void> _precacheOnboardingBackgroundImages(BuildContext context) async {
    await Future.wait([
      precacheImage(const AssetImage(ImageAssets.onboarding1), context),
      precacheImage(const AssetImage(ImageAssets.onboarding2), context),
      precacheImage(const AssetImage(ImageAssets.onboarding3), context),
    ]);
  }

  Widget _buildErrorState(
      SplashBaseErrorState splashBaseErrorState, VoidCallback onRetryTap) {
    if (splashBaseErrorState is SplashNetworkErrorState) {
      return Padding(
        padding: const EdgeInsets.all(24),
        child: NetworkErrorWidget(onRetry: onRetryTap),
      );
    }
    return GenericErrorWidget(onRetryTap: onRetryTap);
  }
}
