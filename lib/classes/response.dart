class DbProviderResponse {
  dynamic payload;
  String? errorMessage;
  DateTime? errorTime;

  DbProviderResponse({
    this.payload,
    this.errorMessage,
  }) : errorTime = DateTime.now();
}

class BlocResponse implements DbProviderResponse {
  @override
  String? errorMessage;

  @override
  DateTime? errorTime;

  @override
  dynamic payload;

  BlocResponse({
    this.payload,
    this.errorMessage,
  }) : errorTime = DateTime.now();

  BlocResponse.fromDbProviderResponse(DbProviderResponse response)
      : payload = response.payload,
        errorMessage = response.errorMessage,
        errorTime = response.errorTime;
}
