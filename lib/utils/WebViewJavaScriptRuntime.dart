import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class WebViewJavascriptRuntime {
  static final WebViewJavascriptRuntime _instance =
  WebViewJavascriptRuntime._internal();

  factory WebViewJavascriptRuntime() => _instance;

  WebViewJavascriptRuntime._internal();

  late InAppWebViewController _controller;
  bool _ready = false;

  Future<void> init() async {
    if (_ready) return;

    final completer = Completer<void>();

    final webView = InAppWebView(
      initialData: InAppWebViewInitialData(
        data: """
          <html>
            <body>
              <script>
                window.evalJS = function(code) {
                  try {
                    return String(eval(code));
                  } catch (e) {
                    return "false";
                  }
                }
              </script>
            </body>
          </html>
        """,
      ),
      onWebViewCreated: (controller) {
        _controller = controller;
      },
      onLoadStop: (_, __) {
        _ready = true;
        completer.complete();
      },
    );

    // Attach webView somewhere offstage
    Offstage(offstage: true, child: webView);

    await completer.future;
  }

  Future<String> evaluate(String jsCode) async {
    await init();

    final result = await _controller.evaluateJavascript(
      source: "window.evalJS(`$jsCode`);",
    );

    return result?.toString() ?? "false";
  }
}
