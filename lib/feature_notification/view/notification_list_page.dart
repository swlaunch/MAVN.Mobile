import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/color_styles.dart';
import 'package:lykke_mobile_mavn/app/resources/localized_strings.dart';
import 'package:lykke_mobile_mavn/app/resources/svg_assets.dart';
import 'package:lykke_mobile_mavn/app/resources/text_styles.dart';
import 'package:lykke_mobile_mavn/base/common_blocs/generic_list_bloc_output.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/notification/response_model/notification_list_response_model.dart';
import 'package:lykke_mobile_mavn/base/repository/mapper/notification_mapper.dart';
import 'package:lykke_mobile_mavn/feature_notification/bloc/notification_count_bloc.dart';
import 'package:lykke_mobile_mavn/feature_notification/bloc/notification_list_bloc.dart';
import 'package:lykke_mobile_mavn/feature_notification/bloc/notification_mark_as_read_bloc.dart';
import 'package:lykke_mobile_mavn/feature_notification/bloc/notification_mark_as_read_bloc_output.dart';
import 'package:lykke_mobile_mavn/feature_notification/router/notification_router.dart';
import 'package:lykke_mobile_mavn/feature_notification/view/notification_list_item.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_ui_components/error/network_error.dart';
import 'package:lykke_mobile_mavn/library_ui_components/layout/scaffold_with_app_bar.dart';
import 'package:lykke_mobile_mavn/library_ui_components/list/infinite_list_view.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/page_title.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/spinner.dart';
import 'package:pedantic/pedantic.dart';

class NotificationListPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final notificationRouter = useNotificationRouter();
    final notificationListBloc = useNotificationListBloc();
    final notificationListBlocState = useBlocState(notificationListBloc);

    final notificationMarkAsReadBloc = useNotificationMarkAsReadBloc();
    final notificationMarkAsReadState =
        useBlocState(notificationMarkAsReadBloc);

    final notificationCountBloc = useNotificationCountBloc();

    final notificationMapper = useNotificationMapper();
    final data = useState(<NotificationListItem>[]);
    final isErrorDismissed = useState(false);

    void loadData() {
      isErrorDismissed.value = false;
      notificationListBloc.getList();
    }

    void loadInitialData() {
      isErrorDismissed.value = false;
      notificationListBloc.updateGenericList();
    }

    useBlocEventListener(notificationMarkAsReadBloc, (event) {
      if (event is NotificationSuccessfullyMarkedAsRead) {
        notificationCountBloc.getUnreadNotificationCount();
        notificationListBloc.updateGenericList();
      }
    });

    void onTap(NotificationMessage notification) {
      if (!notification.isRead) {
        //mark as read silently, do not indicate errors or loading
        unawaited(
            notificationMarkAsReadBloc.markAsRead(notification.messageGroupId));
      }
      notificationRouter.route(notification.payload);
    }

    useEffect(() {
      loadInitialData();
    }, [notificationListBloc]);

    if (notificationListBlocState is GenericListLoadedState) {
      //add headers only if we are displaying the first page
      data.value = notificationMapper.mapNotifications(
        notifications: notificationListBlocState.list,
        addSectionHeaders: notificationListBlocState.currentPage == 1,
      );
    }

    final body = notificationListBlocState is GenericListNetworkErrorState
        ? _buildNetworkError(loadInitialData)
        : _buildContent(
            notificationListBloc,
            data,
            notificationListBlocState,
            notificationMarkAsReadBloc,
            notificationMarkAsReadState,
            loadData,
            onTap,
          );

    return ScaffoldWithAppBar(body: body);
  }

  Widget _buildContent(
    NotificationListBloc notificationListBloc,
    ValueNotifier<List<NotificationListItem>> data,
    GenericListState notificationListBlocState,
    NotificationMarkAsReadBloc notificationMarkAsReadBloc,
    NotificationMarkAsReadState notificationMarkAsReadState,
    VoidCallback loadData,
    Function(NotificationMessage) onItemTap,
  ) =>
      Stack(
        children: [
          RefreshIndicator(
            color: ColorStyles.gold1,
            onRefresh: () async =>
                notificationListBloc.updateGenericList(refresh: true),
            child: Column(
              children: <Widget>[
                ..._buildHeader(
                    haveContent: data.value.isNotEmpty,
                    onMarkAllAsReadTap: () =>
                        notificationMarkAsReadBloc.markAllAsRead()),
                Expanded(
                  child: InfiniteListWidget(
                    data: data.value,
                    padding: const EdgeInsets.all(0),
                    errorPadding: const EdgeInsets.all(16),
                    backgroundColor: ColorStyles.white,
                    isLoading: notificationListBlocState
                        is GenericListPaginationLoadingState,
                    isEmpty: notificationListBlocState is GenericListEmptyState,
                    emptyText: useLocalizedStrings().notificationListEmpty,
                    emptyIcon: SvgAssets.bell,
                    retryOnError: loadData,
                    loadData: loadData,
                    showError:
                        notificationListBlocState is GenericListErrorState,
                    errorText: notificationListBlocState
                            is GenericListErrorState
                        ? notificationListBlocState.error.localize(useContext())
                        : null,
                    itemBuilder: (item, _, itemContext) {
                      if (item is NotificationListNotification) {
                        return NotificationListItemView(
                          notificationListItem: item,
                          onTap: () => onItemTap(item.notification),
                        );
                      }
                      return NotificationListHeaderView(item);
                    },
                    separatorBuilder: (position) => Container(),
                  ),
                ),
              ],
            ),
          ),
          if (notificationListBlocState is GenericListLoadingState ||
              notificationMarkAsReadState is NotificationMarkAsReadLoadingState)
            AbsorbPointer(
              child: Container(
                child: const Center(child: Spinner()),
              ),
            )
        ],
      );

  List<Widget> _buildHeader({
    @required bool haveContent,
    @required VoidCallback onMarkAllAsReadTap,
  }) =>
      [
        PageTitle(title: useLocalizedStrings().notifications),
        if (!haveContent) const SizedBox(height: 32),
        if (haveContent)
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              FlatButton(
                child: Text(
                  useLocalizedStrings().notificationListMarkAllAsRead,
                  style: TextStyles.linksTextLinkBoldHigh,
                ),
                onPressed: onMarkAllAsReadTap,
              )
            ],
          )
      ];

  Widget _buildNetworkError(VoidCallback reload) => Container(
        padding: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
        child: Column(
          children: <Widget>[
            NetworkErrorWidget(onRetry: reload),
          ],
        ),
      );
}
