import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/base/common_use_cases/route_authentication_use_case.dart';
import 'package:lykke_mobile_mavn/feature_landing/bloc/route_authentication_bloc.dart';
import 'package:lykke_mobile_mavn/feature_landing/bloc/route_authentication_bloc_output.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/bloc.dart';
import '../../mock_classes.dart';

List<BlocOutput> _expectedFullBlocOutput = [];

final _mockRouteAuthenticationUseCase = MockRouteAuthenticationUseCase();

BlocTester<RouteAuthenticationBloc> _blocTester;
RouteAuthenticationBloc _subject;

void main() {
  group('AcceptHotelReferralBlocTests', () {
    setUp(() {
      _subject = RouteAuthenticationBloc(_mockRouteAuthenticationUseCase);
      _blocTester = BlocTester(_subject);
    });

    test('intialState', () {
      _blocTester.assertCurrentState(RouteAuthenticationUninitializedState());
    });

    test('RouteAuthenticationLoaded', () async {
      _expectedFullBlocOutput.addAll([
        RouteAuthenticationUninitializedState(),
        RouteAuthenticationLoadingState(),
        RouteAuthenticationLoadedState(),
        RouteAuthenticationLoadedEvent(
            const RouteAuthenticationTarget(RouteAuthenticationPage.home)),
      ]);

      await _subject.routeTo(targetPage: RouteAuthenticationPage.home);

      verify(_mockRouteAuthenticationUseCase.execute(
              endPage: RouteAuthenticationPage.home))
          .called(1);

      await _blocTester.assertFullBlocOutputInOrder(_expectedFullBlocOutput);
    });
  });
}
