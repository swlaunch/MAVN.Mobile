import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/error/errors.dart';
import 'package:lykke_mobile_mavn/feature_notification/bloc/notification_mark_as_read_bloc.dart';
import 'package:lykke_mobile_mavn/feature_notification/bloc/notification_mark_as_read_bloc_output.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/bloc.dart';
import '../../mock_classes.dart';
import '../../test_constants.dart';

void main() {
  group('NotificationMarkAsReadBloc tests', () {
    final mockNotificationRepository = MockNotificationRepository();

    final expectedFullBlocOutput = <BlocOutput>[];

    BlocTester<NotificationMarkAsReadBloc> blocTester;
    NotificationMarkAsReadBloc subject;

    setUp(() {
      expectedFullBlocOutput.clear();

      subject = NotificationMarkAsReadBloc(mockNotificationRepository);
      blocTester = BlocTester(subject);
    });

    test('initialState', () {
      blocTester.assertCurrentState(NotificationMarkAsReadUninitializedState());
    });

    test('markAsRead success', () async {
      when(mockNotificationRepository.markAsRead(messageGroupId: null))
          .thenAnswer((_) => Future.value());

      await subject.markAsRead(TestConstants.stubMessageGroupId);

      expectedFullBlocOutput.addAll([
        NotificationMarkAsReadUninitializedState(),
        NotificationMarkAsReadLoadingState(),
        NotificationMarkAsReadLoadedState(),
        NotificationSuccessfullyMarkedAsRead(),
      ]);

      await blocTester.assertFullBlocOutputInOrder(expectedFullBlocOutput);
    });

    test('network error', () async {
      when(mockNotificationRepository.markAsRead(
              messageGroupId: TestConstants.stubMessageGroupId))
          .thenThrow(NetworkException());

      await subject.markAsRead(TestConstants.stubMessageGroupId);

      expectedFullBlocOutput.addAll([
        NotificationMarkAsReadUninitializedState(),
        NotificationMarkAsReadLoadingState(),
        NotificationMarkAsReadNetworkErrorState(),
      ]);

      await blocTester.assertFullBlocOutputInOrder(expectedFullBlocOutput);
    });

    test('markAsRead returns generic error', () async {
      when(mockNotificationRepository.markAsRead(
              messageGroupId: TestConstants.stubMessageGroupId))
          .thenThrow(Exception());

      await subject.markAsRead(TestConstants.stubMessageGroupId);

      expectedFullBlocOutput.addAll([
        NotificationMarkAsReadUninitializedState(),
        NotificationMarkAsReadLoadingState(),
        NotificationMarkAsReadGenericErrorState(),
      ]);

      await blocTester.assertFullBlocOutputInOrder(expectedFullBlocOutput);
    });

    test('markAllAsRead success', () async {
      when(mockNotificationRepository.markAsRead(messageGroupId: null))
          .thenAnswer((_) => Future.value());

      await subject.markAllAsRead();

      expectedFullBlocOutput.addAll([
        NotificationMarkAsReadUninitializedState(),
        NotificationMarkAsReadLoadingState(),
        NotificationMarkAsReadLoadedState(),
        NotificationSuccessfullyMarkedAsRead(),
      ]);

      await blocTester.assertFullBlocOutputInOrder(expectedFullBlocOutput);
    });

    test('markAllAsRead network error', () async {
      when(mockNotificationRepository.markAllAsRead())
          .thenThrow(NetworkException());

      await subject.markAllAsRead();

      expectedFullBlocOutput.addAll([
        NotificationMarkAsReadUninitializedState(),
        NotificationMarkAsReadLoadingState(),
        NotificationMarkAsReadNetworkErrorState(),
      ]);

      await blocTester.assertFullBlocOutputInOrder(expectedFullBlocOutput);
    });

    test('markAllAsRead returns generic error', () async {
      when(mockNotificationRepository.markAllAsRead()).thenThrow(Exception());

      await subject.markAllAsRead();

      expectedFullBlocOutput.addAll([
        NotificationMarkAsReadUninitializedState(),
        NotificationMarkAsReadLoadingState(),
        NotificationMarkAsReadGenericErrorState(),
      ]);

      await blocTester.assertFullBlocOutputInOrder(expectedFullBlocOutput);
    });
  });
}
