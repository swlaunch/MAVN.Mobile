import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/app/resources/unlocalized_strings.dart';
import 'package:lykke_mobile_mavn/feature_debug_menu/bloc/debug_menu_bloc.dart';
import 'package:lykke_mobile_mavn/library_custom_hooks/text_editing_controller_hook.dart';
import 'package:lykke_mobile_mavn/library_form/form_mixin.dart';

class ProxySettings extends HookWidget with FormMixin {
  @override
  Widget build(BuildContext context) {
    final debugMenuBloc = useDebugMenuBloc();

    final proxyEditingController = useCustomTextEditingController(
        text: debugMenuBloc.currentState.proxyUrl ?? '');

    return Column(
      children: <Widget>[
        const Padding(
          padding: EdgeInsets.all(8),
          child: Text(
            UnlocalizedStrings.proxySettingTitle,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            UnlocalizedStrings.proxySettingDescription,
            style: TextStyle(fontSize: 14),
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.all(8),
          child: TextField(
            key: const Key('proxySettingsInput'),
            style: const TextStyle(fontSize: 14),
            controller: proxyEditingController,
            onSubmitted: (_) => dismissKeyboard(context),
            onEditingComplete: () => dismissKeyboard(context),
            onChanged: (newProxyValue) {
              _saveProxy(debugMenuBloc, newProxyValue);
            },
            decoration: InputDecoration(
                suffixIcon: IconButton(
                  key: const Key('proxySettingsInputClear'),
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      proxyEditingController.clear();
                      _clearProxy(debugMenuBloc);
                    });
                  },
                ),
                labelText: UnlocalizedStrings.proxySettingsInputLabel,
                hintText: UnlocalizedStrings.proxySettingsInputHint,
                border: const OutlineInputBorder()),
          ),
        ),
      ],
    );
  }

  void _saveProxy(DebugMenuBloc bloc, String newProxyValue) {
    bloc.saveProxyUrl(newProxyValue);
  }

  void _clearProxy(DebugMenuBloc bloc) {
    bloc.clearProxyUrl();
  }
}
