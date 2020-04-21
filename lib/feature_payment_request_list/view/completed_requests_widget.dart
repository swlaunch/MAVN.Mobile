import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/feature_payment_request_list/bloc/completed_payment_requests_bloc.dart';
import 'package:lykke_mobile_mavn/feature_payment_request_list/view/paginated_payment_request_list.dart';

class CompletedRequestsWidget extends HookWidget {
  const CompletedRequestsWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => PaginatedRequestsListWidget(
        key: const Key('completedRequestsList'),
        useBloc: () => usePartnerPaymentsCompletedBloc(),
        emptyStateText: useLocalizedStrings().transferRequestEmptyCompleted,
      );
}
