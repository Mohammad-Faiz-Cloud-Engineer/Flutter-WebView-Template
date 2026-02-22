class UrlValidator {
  static bool isAllowedDomain(String url, List<String> allowedDomains) {
    if (allowedDomains.isEmpty) return true;

    try {
      final uri = Uri.parse(url);
      final host = uri.host.toLowerCase();

      for (final domain in allowedDomains) {
        if (host == domain.toLowerCase() ||
            host.endsWith('.${domain.toLowerCase()}')) {
          return true;
        }
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  static bool isValidUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https');
    } catch (e) {
      return false;
    }
  }
}
