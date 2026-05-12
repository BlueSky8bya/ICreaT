String combineUrlPaths(String baseUrl, String relativePath) {
  final baseUri = Uri.parse(baseUrl);
  String existingPath = baseUri.path;
  if (existingPath.endsWith('/')) {
    existingPath = existingPath.substring(0, existingPath.length - 1);
  }
  if (relativePath.startsWith('/')) {
    relativePath = relativePath.substring(1);
  }
  final newPath = '$existingPath/$relativePath';
  final absoluteUri = baseUri.replace(path: newPath);
  return absoluteUri.toString();
}