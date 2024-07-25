class FetchHelper<T> {
  T? data;
  bool loading = false;
  Function fetch;
  Function onResponse;

  FetchHelper({required this.fetch, required this.onResponse}) {
    fetch().then((response) {
      onResponse(response);
    });
  }
}