import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/app/resources/lazy_localized_strings.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/error/errors.dart';
import 'package:lykke_mobile_mavn/feature_hotel_welcome/bloc/hotel_welcome_bloc.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/bloc.dart';
import '../../mock_classes.dart';
import '../../test_constants.dart';

List<BlocOutput> _expectedFullBlocOutput = [];

final _mockPartnerRepository = MockPartnerRepository();
final _mockExceptionToMessageMapper = MockExceptionToMessageMapper();

BlocTester<HotelWelcomeBloc> _blocTester = BlocTester(
    HotelWelcomeBloc(_mockPartnerRepository, _mockExceptionToMessageMapper));

HotelWelcomeBloc _subject;

void main() {
  group('HotelWelcomeBlocTests', () {
    setUp(() {
      reset(_mockPartnerRepository);
      _expectedFullBlocOutput.clear();

      _subject = HotelWelcomeBloc(
          _mockPartnerRepository, _mockExceptionToMessageMapper);
      _blocTester = BlocTester(_subject);
    });

    test('intialState', () {
      _blocTester.assertCurrentState(HotelWelcomeUninitializedState());
    });

    test('getPartnerMessage success', () async {
      when(_mockPartnerRepository.getPartnerMessage(
        TestConstants.stubPartnerMessageId,
      )).thenAnswer((_) => Future.value(TestConstants.stubPartnerMessage));

      await _subject.getPartnerMessage(
        TestConstants.stubPartnerMessageId,
      );

      expect(
        verify(_mockPartnerRepository.getPartnerMessage(
          TestConstants.stubPartnerMessageId,
        )).callCount,
        1,
      );

      _expectedFullBlocOutput.addAll([
        HotelWelcomeUninitializedState(),
        HotelWelcomeLoadingState(),
        HotelWelcomeLoadedState(
          partnerName: TestConstants.stubPartnerMessage.partnerName,
          heading: TestConstants.stubPartnerMessage.subject,
          message: TestConstants.stubPartnerMessage.message,
        )
      ]);

      await _blocTester.assertFullBlocOutputInAnyOrder(_expectedFullBlocOutput);
    });

    test('getPartnerMessage generic error', () async {
      when(_mockPartnerRepository.getPartnerMessage(
        TestConstants.stubPartnerMessageId,
      )).thenThrow(Exception());

      when(_mockExceptionToMessageMapper.map(any))
          .thenReturn(LazyLocalizedStrings.defaultGenericError);

      await _subject.getPartnerMessage(
        TestConstants.stubPartnerMessageId,
      );

      _expectedFullBlocOutput.addAll([
        HotelWelcomeUninitializedState(),
        HotelWelcomeLoadingState(),
        HotelWelcomeErrorState(LazyLocalizedStrings.defaultGenericError),
      ]);

      await _blocTester.assertFullBlocOutputInOrder(_expectedFullBlocOutput);
    });

    test('getPartnerMessage network error', () async {
      when(_mockPartnerRepository.getPartnerMessage(
        TestConstants.stubPartnerMessageId,
      )).thenThrow(NetworkException());

      when(_mockExceptionToMessageMapper.map(any))
          .thenReturn(LazyLocalizedStrings.networkError);

      await _subject.getPartnerMessage(
        TestConstants.stubPartnerMessageId,
      );

      _expectedFullBlocOutput.addAll([
        HotelWelcomeUninitializedState(),
        HotelWelcomeLoadingState(),
        HotelWelcomeErrorState(LazyLocalizedStrings.networkError),
      ]);

      await _blocTester.assertFullBlocOutputInOrder(_expectedFullBlocOutput);
    });
  });
}
