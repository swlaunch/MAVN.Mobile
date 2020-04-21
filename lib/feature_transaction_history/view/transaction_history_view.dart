import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lykke_mobile_mavn/app/resources/app_theme.dart';
import 'package:lykke_mobile_mavn/app/resources/color_styles.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/app/resources/svg_assets.dart';
import 'package:lykke_mobile_mavn/app/resources/text_styles.dart';
import 'package:lykke_mobile_mavn/feature_transaction_history/bloc/transaction_history_bloc.dart';
import 'package:lykke_mobile_mavn/feature_transaction_history/bloc/transaction_history_bloc_output.dart';
import 'package:lykke_mobile_mavn/feature_transaction_history/view/transaction_history_list.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_ui_components/list/pagination_error_state.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/spinner.dart';

class TransactionHistoryView extends HookWidget {
  const TransactionHistoryView({@required this.theme});

  final BaseAppTheme theme;

  @override
  Widget build(BuildContext context) {
    final transactionHistoryBloc = useTransactionHistoryBloc();
    final transactionHistoryState =
        useBlocState<TransactionHistoryState>(transactionHistoryBloc);

    useEffect(() {
      transactionHistoryBloc.loadTransactionHistory();
    }, [transactionHistoryBloc]);

    if (transactionHistoryState is TransactionHistoryInitialPageNetworkError) {
      return const SizedBox();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _buildContent(transactionHistoryBloc, transactionHistoryState),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildContent(
    TransactionHistoryBloc transactionHistoryBloc,
    TransactionHistoryState transactionHistoryState,
  ) {
    if (transactionHistoryState is TransactionHistoryInitialPageLoading) {
      return const _LoadingSpinner();
    }

    if (transactionHistoryState is TransactionHistoryInitialPageError) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: PaginationErrorWidget(
          errorText: transactionHistoryState.error.localize(useContext()),
          onRetry: transactionHistoryBloc.loadTransactionHistory,
        ),
      );
    }

    if (transactionHistoryState is TransactionHistoryEmpty) {
      return TransactionHistoryViewEmpty();
    }

    if (transactionHistoryState is TransactionHistoryLoaded) {
      return Padding(
        padding: const EdgeInsets.only(top: 16),
        child: TransactionHistoryViewList(
          transactionList: transactionHistoryState
              .transactionHistoryResponseModel.transactionList,
          theme: theme,
        ),
      );
    }

    if (transactionHistoryState is TransactionHistoryPaginationLoading) {
      return Column(
        children: <Widget>[
          TransactionHistoryViewList(
            transactionList: transactionHistoryState
                .transactionHistoryResponseModel.transactionList,
            theme: theme,
          ),
          const _LoadingSpinner(),
        ],
      );
    }

    if (transactionHistoryState is TransactionHistoryPaginationError) {
      return Column(
        children: <Widget>[
          TransactionHistoryViewList(
            transactionList: transactionHistoryState
                .transactionHistoryResponseModel.transactionList,
            theme: theme,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            child: PaginationErrorWidget(
              errorText: transactionHistoryState.error.localize(useContext()),
              onRetry: transactionHistoryBloc.loadTransactionHistory,
            ),
          )
        ],
      );
    }

    return Container();
  }
}

class _LoadingSpinner extends StatelessWidget {
  const _LoadingSpinner();

  @override
  Widget build(BuildContext context) => const Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Align(
          alignment: Alignment.center,
          child: Spinner(),
        ),
      );
}

class UpArrow extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
        height: 22,
        width: 22,
        decoration: BoxDecoration(
          color: ColorStyles.pale,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: RotatedBox(
          quarterTurns: -1,
          child: SvgPicture.asset(
            SvgAssets.arrow,
            width: 16,
            height: 16,
          ),
        ),
      );
}

class DownArrow extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
        height: 22,
        width: 22,
        decoration: BoxDecoration(
          color: ColorStyles.accentSeaGreen,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: RotatedBox(
          quarterTurns: 1,
          child: SvgPicture.asset(
            SvgAssets.arrow,
            width: 16,
            height: 16,
          ),
        ),
      );
}

class TransactionHistoryViewEmpty extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              LocalizedStrings.of(context).walletPageTransactionHistoryEmpty,
              style: TextStyles.darkBodyBody1RegularHigh,
            ),
            const SizedBox(height: 16),
            Stack(
              children: <Widget>[
                DownArrow(),
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: UpArrow(),
                ),
              ],
            ),
          ],
        ),
      );
}
