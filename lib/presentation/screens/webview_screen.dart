import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../config/app_config.dart';
import '../widgets/error_view.dart';
import '../widgets/loading_indicator.dart';
import '../../core/services/connectivity_service.dart';
import '../../core/utils/url_validator.dart';

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({super.key});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';
  double _loadingProgress = 0.0;
  final ConnectivityService _connectivityService = ConnectivityService();

  @override
  void initState() {
    super.initState();
    _initializeWebView();
    _checkConnectivity();
  }

  void _checkConnectivity() async {
    final isConnected = await _connectivityService.checkConnectivity();
    if (!isConnected && mounted) {
      setState(() {
        _hasError = true;
        _errorMessage = 'No internet connection';
      });
    }
  }

  void _initializeWebView() {
    _controller = WebViewController()
      ..setJavaScriptMode(
        AppConfig.enableJavaScript
            ? JavaScriptMode.unrestricted
            : JavaScriptMode.disabled,
      )
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            setState(() {
              _loadingProgress = progress / 100;
            });
          },
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
              _hasError = false;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
          },
          onWebResourceError: (WebResourceError error) {
            setState(() {
              _hasError = true;
              _errorMessage = error.description;
              _isLoading = false;
            });
          },
          onNavigationRequest: (NavigationRequest request) {
            // Domain restriction logic
            if (AppConfig.allowedDomains.isNotEmpty) {
              final isAllowed = UrlValidator.isAllowedDomain(
                request.url,
                AppConfig.allowedDomains,
              );
              if (!isAllowed) {
                return NavigationDecision.prevent;
              }
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(AppConfig.targetUrl));

    // Configure additional settings
    if (AppConfig.enableDomStorage) {
      _controller.enableZoom(AppConfig.enableZoom);
    }

    if (AppConfig.userAgent.isNotEmpty) {
      _controller.setUserAgent(AppConfig.userAgent);
    }
  }

  Future<void> _reload() async {
    setState(() {
      _hasError = false;
      _isLoading = true;
    });
    await _controller.reload();
  }

  Future<bool> _onWillPop() async {
    if (await _controller.canGoBack()) {
      await _controller.goBack();
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppConfig.appName),
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _reload,
              tooltip: 'Refresh',
            ),
          ],
        ),
        body: SafeArea(
          child: Stack(
            children: [
              if (!_hasError)
                AppConfig.enablePullToRefresh
                    ? RefreshIndicator(
                        onRefresh: _reload,
                        child: WebViewWidget(controller: _controller),
                      )
                    : WebViewWidget(controller: _controller),
              if (_hasError)
                ErrorView(
                  message: _errorMessage,
                  onRetry: _reload,
                ),
              if (_isLoading && AppConfig.showLoadingIndicator)
                LoadingIndicatorWidget(progress: _loadingProgress),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _connectivityService.dispose();
    super.dispose();
  }
}
