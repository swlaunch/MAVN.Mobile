import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/color_styles.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/app/resources/svg_assets.dart';
import 'package:lykke_mobile_mavn/base/common_blocs/generic_list_bloc_output.dart';
import 'package:lykke_mobile_mavn/base/repository/mapper/transaction_history_mapper.dart';
import 'package:lykke_mobile_mavn/feature_transaction_history/bloc/transaction_history_bloc.dart';
import 'package:lykke_mobile_mavn/feature_transaction_history/ui_components/transaction_history_group.dart';
import 'package:lykke_mobile_mavn/feature_transaction_history/ui_components/transaction_history_header.dart';
import 'package:lykke_mobile_mavn/feature_transaction_history/ui_components/transaction_history_item.dart';
import 'package:lykke_mobile_mavn/feature_transfer_vouchers/bloc/transfer_voucher_bloc.dart';
import 'package:lykke_mobile_mavn/feature_transfer_vouchers/bloc/transfer_voucher_bloc_output.dart';
import 'package:lykke_mobile_mavn/feature_voucher_purchase/bloc/voucher_purchase_success_bloc.dart';
import 'package:lykke_mobile_mavn/feature_voucher_purchase/bloc/voucher_purchase_success_bloc_output.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_ui_components/list/infinite_list_view.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/spinner.dart';

class TransactionHistoryWidget extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final transactionListBloc = useTransactionHistoryBloc();
    final transactionListBlocState = useBlocState(transactionListBloc);

    final transferVoucherBloc = useTransferVoucherBloc();
    final voucherPurchaseSuccessBloc = useVoucherPurchaseSuccessBloc();

    final transactionMapper = useTransactionMapper();

    final data = useState(<TransactionItem>[]);
    final isErrorDismissed = useState(false);

    void loadInitialData() {
      isErrorDismissed.value = false;
      transactionListBloc.updateGenericList();
    }

    void loadData() {
      isErrorDismissed.value = false;
      transactionListBloc.getList();
    }

    useBlocEventListener(transferVoucherBloc, (event) {
      if (event is TransferVoucherSuccessEvent) {
        loadInitialData();
      }
    });

    useBlocEventListener(voucherPurchaseSuccessBloc, (event) {
      if (event is VoucherPurchaseSuccessSuccessEvent) {
        loadInitialData();
      }
    });

    useEffect(() {
      loadInitialData();
    }, [transactionListBloc]);

    if (transactionListBlocState is GenericListLoadedState) {
      data.value = transactionMapper.mapTransactions(
          transactionListBlocState.list, context);
    }

    return Stack(
      children: [
        RefreshIndicator(
          color: ColorStyles.gold1,
          onRefresh: () async =>
              transactionListBloc.updateGenericList(refresh: true),
          child: Column(
            children: <Widget>[
              Expanded(
                child: InfiniteListWidget(
                  data: data.value,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  errorPadding: const EdgeInsets.all(16),
                  backgroundColor: ColorStyles.white,
                  isLoading: transactionListBlocState
                      is GenericListPaginationLoadingState,
                  isEmpty: transactionListBlocState is GenericListEmptyState,
                  emptyText: useLocalizedStrings().voucherListEmpty,
                  emptyIcon: SvgAssets.voucher,
                  retryOnError: loadData,
                  loadData: loadData,
                  showError: transactionListBlocState is GenericListErrorState,
                  errorText: transactionListBlocState is GenericListErrorState
                      ? transactionListBlocState.error.localize(useContext())
                      : null,
                  itemBuilder: (item, _, itemContext) {
                    if (item is TransactionHeader) {
                      return TransactionHistoryHeaderWidget(item: item);
                    }
                    if (item is TransactionGroup) {
                      return TransactionHistoryGroupWidget(group: item);
                    }
                  },
                  separatorBuilder: (position) => Container(),
                ),
              ),
            ],
          ),
        ),
        if (transactionListBlocState is GenericListLoadingState)
          const Center(child: Spinner())
      ],
    );
  }
}
