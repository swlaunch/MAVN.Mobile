import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/error/errors.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/error/exception_to_message_mapper.dart';
import 'package:lykke_mobile_mavn/base/repository/sme/sme_repository.dart';
import 'package:lykke_mobile_mavn/feature_link_sme_account/bloc/sme_linking_bloc_output.dart';
import 'package:lykke_mobile_mavn/feature_link_sme_account/di/sme_linking_module.dart';
import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:lykke_mobile_mavn/library_dependency_injection/core.dart';

class SmeLinkingBloc extends Bloc<SmeLinkingState> {
  SmeLinkingBloc(
    this._smeRepository,
    this._exceptionToMessageMapper,
  );

  final ExceptionToMessageMapper _exceptionToMessageMapper;

  final SmeRepository _smeRepository;

  @override
  SmeLinkingState initialState() => SmeLinkingUninitializedState();

  Future<void> submitSmeLinking({
    @required String partnerCode,
    @required String linkingCode,
  }) async {
    setState(SmeLinkingSubmissionLoadingState());
    try {
      await _smeRepository.linkSmeAccount(
        partnerCode: partnerCode,
        linkingCode: linkingCode.toLowerCase(),
      );
      setState(SmeLinkingSubmissionSuccessState());
      sendEvent(SmeLinkingSubmissionSuccessEvent());
    } on Exception catch (e) {
      if (e is NetworkException) {
        setState(SmeLinkingNetworkErrorState());
        return;
      }
      setState(_getErrorFromException(e));
    }
  }

  SmeLinkingSubmissionErrorState _getErrorFromException(Exception e) {
    final errorMessage = _exceptionToMessageMapper.map(e);

    final nonRetryErrors = [
      ServiceExceptionType.customerAlreadyLinkedToAPartner,
      ServiceExceptionType.partnerLinkingInfoDoesNotExist,
      ServiceExceptionType.partnerLinkingInfoDoesNotMatch,
    ];
    final canRetry = !(e is ServiceException &&
        nonRetryErrors.any((element) => e.exceptionType == element));

    return SmeLinkingSubmissionErrorState(
      error: errorMessage,
      canRetry: canRetry,
    );
  }
}

SmeLinkingBloc useSmeLinkingBloc() =>
    ModuleProvider.of<SmeLinkingModule>(useContext()).smeLinkingBloc;
