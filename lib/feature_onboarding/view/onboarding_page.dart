import 'package:auto_size_text/auto_size_text.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/color_styles.dart';
import 'package:lykke_mobile_mavn/app/resources/image_assets.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/app/resources/text_styles.dart';
import 'package:lykke_mobile_mavn/base/common_use_cases/get_mobile_settings_use_case.dart';
import 'package:lykke_mobile_mavn/base/constants/configuration.dart';
import 'package:lykke_mobile_mavn/base/local_data_source/shared_preferences_manager/shared_preferences_manager.dart';
import 'package:lykke_mobile_mavn/base/router/router.dart';
import 'package:lykke_mobile_mavn/feature_onboarding/analytics/onboarding_analytics_manager.dart';
import 'package:lykke_mobile_mavn/lib_dynamic_links/dynamic_link_manager_mixin.dart';
import 'package:lykke_mobile_mavn/library_ui_components/layout/auth_scaffold.dart';

class OnboardingPage extends HookWidget with DynamicLinkManagerMixin {
  static const pageDataLength = 4;

  @override
  Widget build(BuildContext context) {
    final tokenSymbol =
        useState(useGetMobileSettingsUseCase(context).execute()?.tokenSymbol);

    final router = useRouter();
    final sharedPrefsManager = useSharedPreferencesManager();
    final _analyticsManager = useOnboardingAnalyticsManager();
    startListenOnceForDynamicLinks();

    final currentPage = useState<int>(0);

    final List<_OnboardingPageData> pageData = [
      _OnboardingPageData(
          title:
              useLocalizedStrings().onboardingPage1Title(Configuration.appName),
          details: '',
          asset: ImageAssets.onboarding1),
      _OnboardingPageData(
          title: useLocalizedStrings().onboardingPage2Title(tokenSymbol.value),
          details: useLocalizedStrings().onboardingPage2Details(
              tokenSymbol.value, Configuration.appCompany),
          asset: ImageAssets.onboarding2),
      _OnboardingPageData(
          title: useLocalizedStrings().onboardingPage3Title(tokenSymbol.value),
          details: useLocalizedStrings().onboardingPage3Details(
              tokenSymbol.value, Configuration.appCompany),
          asset: ImageAssets.onboarding3),
    ];

    useEffect(() {
      _analyticsManager.onboardingPageChanged(previousPage: -1);
    }, [_analyticsManager]);

    final _pageController =
        PageController(initialPage: currentPage.value, keepPage: true);

    Future<void> goToWelcome() async {
      await router.replaceWithWelcomePage();
    }

    Future<void> skip() async {
      await _analyticsManager.onboardingSkipped(
        skippedPage: currentPage.value + 1,
      );
      await sharedPrefsManager.writeBool(
          key: SharedPreferencesKeys.shouldSeeOnboarding, value: false);
      await goToWelcome();
    }

    Future<void> getStarted() async {
      await _analyticsManager.onboardingCompleted();
      await sharedPrefsManager.writeBool(
          key: SharedPreferencesKeys.shouldSeeOnboarding, value: false);
      await goToWelcome();
    }

    Future<void> proceedToNextPage() async {
      if (_pageController.hasClients && currentPage.value < pageData.length) {
        await _pageController.animateToPage(
          _pageController.page.toInt() + 1,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    }

    return AuthScaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Column(
          children: <Widget>[
            const SizedBox(height: 48),
            Expanded(
              child: PageView.builder(
                physics: const ClampingScrollPhysics(),
                controller: _pageController,
                onPageChanged: (newPage) {
                  _analyticsManager.onboardingPageChanged(
                    previousPage: currentPage.value + 1,
                  );
                  currentPage.value = newPage;
                },
                itemCount: pageData.length,
                itemBuilder: (context, position) => pageData[position].build(),
              ),
            ),
            _buildDotIndicator(
                pageCount: pageData.length,
                currentPageIndex: currentPage.value),
            const SizedBox(height: 48),
            if (currentPage.value < pageData.length - 1)
              _buildButtonBar(onSkipTap: skip, onNextTap: proceedToNextPage)
            else
              Align(
                alignment: Alignment.bottomRight,
                child: _buildGetStartedButton(onGetStartedTap: getStarted),
              ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildDotIndicator({int pageCount, int currentPageIndex}) =>
      DotsIndicator(
          dotsCount: pageCount,
          position: currentPageIndex == null ? 0 : currentPageIndex.toDouble(),
          decorator: DotsDecorator(
            size: const Size(8, 8),
            spacing: const EdgeInsets.all(8),
            color: ColorStyles.charcoalGrey.withOpacity(0.5),
            activeColor: ColorStyles.charcoalGrey,
          ));

  Widget _buildButtonBar({VoidCallback onSkipTap, VoidCallback onNextTap}) =>
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            InkWell(
              key: const Key('onboardingPageSkipButton'),
              onTap: onSkipTap,
              child: Text(
                useLocalizedStrings().onboardingSkipButton,
                style: TextStyles.darkButtonExtraBold,
              ),
            ),
            RaisedButton(
              key: const Key('onboardingPageNextButton'),
              child: Container(
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Center(
                  child: Text(
                    useLocalizedStrings().nextPageButton,
                    style: TextStyles.lightButtonExtraBold,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              onPressed: onNextTap,
              color: ColorStyles.primaryDark,
              textColor: ColorStyles.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              elevation: 0,
            ),
          ],
        ),
      );

  Widget _buildGetStartedButton({VoidCallback onGetStartedTap}) => Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: RaisedButton(
              key: const Key('onboardingPageGetStartedButton'),
              child: Container(
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Center(
                  child: Text(
                    useLocalizedStrings().getStartedButton,
                    style: TextStyles.lightButtonExtraBold,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              onPressed: onGetStartedTap,
              color: ColorStyles.primaryDark,
              textColor: ColorStyles.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              elevation: 0,
            ),
          )
        ],
      );
}

class _OnboardingPageData {
  _OnboardingPageData({this.title, this.details, this.asset});

  final String title;
  final String details;
  final String asset;

  Widget build() => Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Align(
              alignment: Alignment.center,
              child: FractionallySizedBox(
                widthFactor: 0.8,
                child: Image(image: AssetImage(asset), fit: BoxFit.contain),
              ),
            ),
          ),
          const SizedBox(height: 32),
          if (details.isEmpty) _buildOnboardingBodyWithNoSubtitle(),
          if (details.isNotEmpty) _buildOnboardingBodyWithSubtitle(),
        ],
      );

  Widget _buildOnboardingBodyWithSubtitle() => Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              height: 40,
              child: Align(
                alignment: Alignment.centerLeft,
                child: AutoSizeText(
                  title,
                  style: TextStyles.darkHeadersH2,
                  maxLines: 1,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              height: 80,
              child: Align(
                alignment: Alignment.topLeft,
                child: AutoSizeText(
                  details,
                  style: TextStyles.darkBodyBody1RegularHigh,
                  maxLines: 3,
                ),
              ),
            ),
          ]);

  Widget _buildOnboardingBodyWithNoSubtitle() => Container(
        height: 120,
        child: Align(
          alignment: Alignment.center,
          child: AutoSizeText(
            title,
            style: TextStyles.darkHeadersH2,
            maxLines: 1,
          ),
        ),
      );
}
