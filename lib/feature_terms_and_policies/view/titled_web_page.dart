import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lykke_mobile_mavn/library_ui_components/layout/scaffold_with_app_bar.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/page_title.dart';
import 'package:lykke_mobile_mavn/library_ui_components/misc/spinner.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TitledWebPage extends HookWidget {
  const TitledWebPage({
    @required this.url,
    @required this.title,
    @required this.asset,
  });

  final String url;
  final String title;
  final String asset;

  @override
  Widget build(BuildContext context) {
    final stackNum = useState(1);
    return ScaffoldWithAppBar(
      body: Column(
        children: [
          PageTitle(
            title: title,
            assetIconLeading: asset,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: IndexedStack(index: stackNum.value, children: [
              Column(
                children: <Widget>[
                  Expanded(
                    child: WebView(
                      javascriptMode: JavascriptMode.unrestricted,
                      initialUrl: url,
                      onPageFinished: (_) {
                        stackNum.value = 0;
                      },
                    ),
                  ),
                ],
              ),
              const Center(child: Spinner()),
            ]),
          ),
        ],
      ),
    );
  }
}
