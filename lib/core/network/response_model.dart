/// General Response Model to handle API responses
class ResponseModel<T> {
  final int statusCode;
  final String message;
  final T? data;

  ResponseModel({
    required this.statusCode,
    required this.message,
    this.data,
  });

  /// Factory method to create a ResponseModel from JSON
  factory ResponseModel.fromJson(Map<String, dynamic> json) {
    return ResponseModel<T>(
      statusCode: json['statusCode'],
      message: json['message'],
      data: json['data'] != null ? json['data'] : {}
    );
  }
}
/*
This declares a class ResponseModel that takes a generic type parameter T. This means that the
type of data it holds can be flexible and specified later (e.g., it could be a String, List, or
a custom object). This is useful for handling different types of data from an API.

 final T? data;
 data: This is the actual data returned from the API, and it is of the generic type T. It is
 nullable (T?), meaning it can either contain data or be null.

 data: json['data'] != null ? json['data'] : {}: This means if data exists in the JSON and is
 not null, it assigns the data field the value from json['data']. Otherwise, it defaults to an
 empty map ({}). Depending on how you handle T, you might want to refine this logic to match the
 type of data.
 */