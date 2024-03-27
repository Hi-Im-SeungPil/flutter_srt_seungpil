import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatelessWidget {
  final String url;
  final String title;
  final WebViewController controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted);

  WebViewScreen({super.key, required this.url, required this.title});

  @override
  Widget build(BuildContext context) {
    controller.loadRequest(Uri.parse(url));
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
          title: Center(
              child: Text(title,
                  style: const TextStyle(color: Color(0xff000000))))),
      body: WebViewWidget(controller: controller),
    ));
  }
}
