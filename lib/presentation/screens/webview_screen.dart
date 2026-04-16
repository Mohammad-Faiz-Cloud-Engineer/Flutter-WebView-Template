import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
import '../../config/app_config.dart';
import '../widgets/error_view.dart';
import '../widgets/loading_indicator.dart';
import '../../core/services/connectivity_service.dart';
import '../../core/utils/url_validator.dart';
import 'dart:developer' as developer;

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
    // Check connectivity after frame is built to avoid setState during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkConnectivity();
    });
  }

  Future<void> _checkConnectivity() async {
    final isConnected = await _connectivityService.checkConnectivity();
    if (!isConnected && mounted) {
      setState(() {
        _hasError = true;
        _errorMessage = 'No internet connection. Please check your network settings.';
      });
    }
  }

  void _initializeWebView() {
    // Create platform-specific parameters for enhanced security
    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is AndroidWebViewPlatform) {
      params = AndroidWebViewControllerCreationParams();
    } else if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    _controller = WebViewController.fromPlatformCreationParams(params)
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
            // Categorize error types for better user feedback
            String errorMessage = 'Unable to load the page';
            
            if (error.errorType == WebResourceErrorType.hostLookup ||
                error.errorType == WebResourceErrorType.connect ||
                error.errorType == WebResourceErrorType.timeout) {
              errorMessage = 'Network error. Please check your internet connection.';
            } else if (error.errorType == WebResourceErrorType.fileNotFound) {
              errorMessage = 'Page not found (404)';
            } else if (error.errorType == WebResourceErrorType.authentication) {
              errorMessage = 'Authentication required';
            } else if (error.description.isNotEmpty) {
              errorMessage = error.description;
            }
            
            developer.log(
              'WebView error: ${error.description}',
              error: error,
              name: 'WebViewScreen',
            );
            
            setState(() {
              _hasError = true;
              _errorMessage = errorMessage;
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

    // Configure platform-specific security settings
    if (_controller.platform is AndroidWebViewController) {
      final androidController = _controller.platform as AndroidWebViewController;
      androidController.setMediaPlaybackRequiresUserGesture(false);
      
      // Enhanced security settings for Android
      androidController.setGeolocationPermissionsPromptCallbacks(
        onShowPrompt: (request) async {
          // Deny geolocation by default for security
          return GeolocationPermissionsResponse(
            allow: false,
            retain: false,
          );
        },
      );
    }

    // Apply zoom setting
    _controller.enableZoom(AppConfig.enableZoom);

    // Apply custom user agent if specified
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

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        if (didPop) {
          return;
        }
        
        final canGoBack = await _controller.canGoBack();
        if (canGoBack) {
          await _controller.goBack();
        } else {
          if (context.mounted) {
            Navigator.of(context).pop();
          }
        }
      },
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
