// File: lib/custom_webview.dart
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CustomWebView extends StatefulWidget {
  final String url;
  final String? title;
  final bool showAppBar;
  final Color? refreshButtonColor;
  final double? refreshButtonSize;

  const CustomWebView({
    super.key,
    required this.url,
    this.title,
    this.showAppBar = true,
    this.refreshButtonColor,
    this.refreshButtonSize,
  });

  @override
  State<CustomWebView> createState() => _CustomWebViewState();
}

class _CustomWebViewState extends State<CustomWebView> {
  late WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initWebViewController();
  }

  void _initWebViewController() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('WebView error: ${error.description}');
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.showAppBar
          ? AppBar(
              title: Text(widget.title ?? 'WebView'),
              actions: [
                IconButton(
                  icon: Icon(
                    Icons.refresh,
                    color: widget.refreshButtonColor,
                    size: widget.refreshButtonSize,
                  ),
                  onPressed: () {
                    _controller.reload();
                  },
                ),
              ],
            )
          : null,
      body: Stack(
        children: [
          WebViewWidget(
            controller: _controller,
          ),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
