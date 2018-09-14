class APIClient {
  final String baseURL = 'https://alis.to/api';

  String createURL(String path) {
    return baseURL + path;
  }
}
