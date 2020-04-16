import 'package:lykke_mobile_mavn/library_bloc/core.dart';
import 'package:meta/meta.dart';

class DebugMenuState extends BlocState {
  DebugMenuState({@required this.proxyUrl});

  DebugMenuState copyWith({
    String proxyUrl,
  }) =>
      DebugMenuState(proxyUrl: proxyUrl ?? this.proxyUrl);

  final String proxyUrl;

  @override
  List get props => super.props..addAll([proxyUrl]);
}
