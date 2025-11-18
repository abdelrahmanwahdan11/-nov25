import 'dart:async';

typedef DisposeCallback = void Function();

class SimpleStreamController<T> {
  final _controller = StreamController<T>.broadcast();
  Stream<T> get stream => _controller.stream;

  void add(T value) => _controller.add(value);

  void dispose() => _controller.close();
}
