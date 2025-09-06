class DataSourceException implements Exception {
  final String? message;
  final int? statusCode;
  final dynamic  data;
  DataSourceException({
    this.message,
    this.statusCode,
    this.data,
  });
}
