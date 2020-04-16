import 'package:flutter_test/flutter_test.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/error/errors.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/notification/response_model/unread_notification_count_response_model.dart';
import 'package:lykke_mobile_mavn/feature_notification/bloc/notification_count_bloc.dart';
import 'package:lykke_mobile_mavn/feature_notification/bloc/notification_count_bloc_output.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/bloc.dart';
import '../../mock_classes.dart';

void main() {
  group('NotificationCountBloc tests', () {
    final mockNotificationRepository = MockNotificationRepository();

    final expectedFullBlocOutput = <BlocOutput>[];

    BlocTester<NotificationCountBloc> blocTester;
    NotificationCountBloc subject;

    setUp(() {
      expectedFullBlocOutput.clear();

      subject = NotificationCountBloc(mockNotificationRepository);
      blocTester = BlocTester(subject);
    });

    test('initialState', () {
      blocTester.assertCurrentState(NotificationCountUninitializedState());
    });

    test('getUnreadNotificationCount success, empty', () async {
      final _notificationCountResponse =
          UnreadNotificationCountResponseModel(unreadMessagesCount: 0);
      when(mockNotificationRepository.getUnreadNotificationCount())
          .thenAnswer((_) => Future.value(_notificationCountResponse));

      await subject.getUnreadNotificationCount();

      expectedFullBlocOutput.addAll([
        NotificationCountUninitializedState(),
        NotificationCountLoadingState(),
        NotificationCountEmptyState()
      ]);

      await blocTester.assertFullBlocOutputInOrder(expectedFullBlocOutput);
    });

    test('network error', () async {
      when(mockNotificationRepository.getUnreadNotificationCount())
          .thenThrow(NetworkException());

      await subject.getUnreadNotificationCount();

      expectedFullBlocOutput.addAll([
        NotificationCountUninitializedState(),
        NotificationCountLoadingState(),
        NotificationCountNetworkErrorState(),
      ]);

      await blocTester.assertFullBlocOutputInOrder(expectedFullBlocOutput);
    });

    test('getUnreadNotificationCount both returns generic error', () async {
      when(mockNotificationRepository.getUnreadNotificationCount())
          .thenThrow(Exception());

      await subject.getUnreadNotificationCount();

      expectedFullBlocOutput.addAll([
        NotificationCountUninitializedState(),
        NotificationCountLoadingState(),
        NotificationCountGenericErrorState(),
      ]);

      await blocTester.assertFullBlocOutputInOrder(expectedFullBlocOutput);
    });
  });
}
