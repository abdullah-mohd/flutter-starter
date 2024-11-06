class ServiceResponse<T> {
  ServiceResponse({this.data, this.errorCode});

  ServiceResponse<T> copyWith({
    T? data,
    int? errorCode,
  }) {
    return ServiceResponse(
      data: data ?? this.data,
      errorCode: errorCode ?? this.errorCode,
    );
  }

  final T? data;

  final int? errorCode;

  bool get haveErrors => errorCode != null;

  @override
  String toString() {
    return 'ServiceResponse{data: $data, errorCode: $errorCode}';
  }
}
