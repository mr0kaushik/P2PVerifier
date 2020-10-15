import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class UrlLauncher extends StatefulWidget {
  final String url;

  const UrlLauncher({Key key, this.url}) : super(key: key);

  @override
  _UrlLauncherState createState() => _UrlLauncherState();
}

class _UrlLauncherState extends State<UrlLauncher> {
  final webViewPlugin = new FlutterWebviewPlugin();

  bool isLoading = false;

  void _setLoading(bool loading) {
    isLoading = loading;
    if (mounted) setState(() {});
  }

  @override
  void initState() {
    isLoading = true;
    webViewPlugin.onStateChanged.listen((event) {
      switch (event.type) {
        case WebViewState.shouldStart:
          break;
        case WebViewState.startLoad:
          _setLoading(true);
          break;
        case WebViewState.finishLoad:
        case WebViewState.abortLoad:
          _setLoading(false);
          break;
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      url: widget.url,
      appBar: AppBar(
        elevation: 0,
        bottom: isLoading ? MyLinearProgressIndicator() : null,
      ),
      withZoom: true,
      withLocalStorage: true,
      hidden: true,
      initialChild: Container(),
    );
  }
}

class MyLinearProgressIndicator extends LinearProgressIndicator
    implements PreferredSizeWidget {
  MyLinearProgressIndicator({
    Key key,
    double value,
    Color backgroundColor,
    Animation<Color> valueColor,
  }) : super(
          key: key,
          value: value,
          backgroundColor: backgroundColor,
          valueColor: valueColor,
        ) {
    preferredSize = Size(double.infinity, 6.0);
  }

  @override
  Size preferredSize;
}
