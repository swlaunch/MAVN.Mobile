import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/app/resources/lazy_localized_strings.dart';
import 'package:lykke_mobile_mavn/base/common_blocs/generic_list_bloc_output.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/error/errors.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/notification/response_model/notification_list_response_model.dart';
import 'package:lykke_mobile_mavn/feature_notification/bloc/notification_list_bloc.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/bloc.dart';
import '../../mock_classes.dart';
import '../../test_constants.dart';

List<BlocOutput> _expectedFullBlocOutput = [];

final _mockNotificationRepository = MockNotificationRepository();

BlocTester<NotificationListBloc> _blocTester =
    BlocTester(NotificationListBloc(_mockNotificationRepository));

NotificationListBloc _subject;

void main() {
  group('NotificationListBlocTests', () {
    setUp(() {
      reset(_mockNotificationRepository);
      _expectedFullBlocOutput.clear();

      _subject = NotificationListBloc(_mockNotificationRepository);
      _blocTester = BlocTester(_subject);
    });

    test('intialState', () {
      _blocTester.assertCurrentState(GenericListUninitializedState());
    });
    const _initialPage = 1;
    final _notificationListResponseModel = NotificationListResponseModel(
        currentPage: TestConstants.stubCurrentPage,
        pageSize: TestConstants.stubPageSize,
        totalCount: TestConstants.stubTotalCount,
        notifications: [
          NotificationMessage(),
        ]);

    test('get notifications success', () async {
      when(
        _mockNotificationRepository.getPendingNotifications(
          currentPage: anyNamed('currentPage'),
        ),
      ).thenAnswer((_) => Future.value(_notificationListResponseModel));

      await _subject.getList();

      verify(_mockNotificationRepository.getPendingNotifications(
              currentPage: _initialPage))
          .called(1);

      _expectedFullBlocOutput.addAll([
        GenericListUninitializedState(),
        GenericListLoadingState(),
        GenericListLoadedState(
            totalCount: TestConstants.stubTotalCount,
            currentPage: TestConstants.stubCurrentPage,
            list: [..._notificationListResponseModel.notifications])
      ]);

      await _blocTester.assertFullBlocOutputInAnyOrder(_expectedFullBlocOutput);
    });

    test('get notifications generic error', () async {
      when(_mockNotificationRepository.getPendingNotifications(
        currentPage: anyNamed('currentPage'),
      )).thenThrow(Exception());

      await _subject.getList();

      _expectedFullBlocOutput.addAll([
        GenericListUninitializedState(),
        GenericListLoadingState(),
        GenericListErrorState<NotificationMessage>(
            error: LazyLocalizedStrings
                .notificationListRequestGenericErrorSubtitle,
            currentPage: 1,
            list: []),
      ]);

      await _blocTester.assertFullBlocOutputInOrder(_expectedFullBlocOutput);
    });

    test('get notifications network error', () async {
      when(_mockNotificationRepository.getPendingNotifications(
        currentPage: anyNamed('currentPage'),
      )).thenThrow(NetworkException());

      await _subject.getList();

      _expectedFullBlocOutput.addAll([
        GenericListUninitializedState(),
        GenericListLoadingState(),
        GenericListNetworkErrorState(),
      ]);

      await _blocTester.assertFullBlocOutputInOrder(_expectedFullBlocOutput);
    });
  });
}
