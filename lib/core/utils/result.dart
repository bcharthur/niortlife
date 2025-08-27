sealed class Result<T> {
  const Result();
  bool get isOk => this is Ok<T>;
  bool get isErr => this is Err<T>;
  T? get data => switch (this) { Ok(value: final v) => v, _ => null };
  Object? get error => switch (this) { Err(error: final e) => e, _ => null };
}

class Ok<T> extends Result<T> {
  final T value;
  const Ok(this.value);
}

class Err<T> extends Result<T> {
  final Object error;
  final StackTrace? stackTrace;
  const Err(this.error, [this.stackTrace]);
}
