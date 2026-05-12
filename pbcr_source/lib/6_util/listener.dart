import 'package:flutter/material.dart';

class ValueListener<T> {
  final Map<int, Function(T)> _listenerMap = <int, Function(T)>{};
  int _listenId = 0;
  int get currentListenerCnt => _listenerMap.length;

  void notify(T data) {
    for (Function(T) callback in _listenerMap.values) {
      callback.call(data);
    }
  }

  int add(Function(T) listener) {
    _listenId++;
    _listenerMap[_listenId] = listener;

    return _listenId;
  }

  void remove(int? listenId) {
    _listenerMap.remove(listenId);
  }

  void clear() {
    _listenerMap.clear();
  }
}

class AwaitValueListener<T> {
  final Map<int, Future Function(T)> _listenerMap = <int, Future Function(T)>{};
  int _listenId = 0;
  int get currentListenerCnt => _listenerMap.length;

  void notify(T data) async {
    for (Future Function(T) callback in _listenerMap.values) {
      await callback.call(data);
    }
  }

  int add(Future Function(T) awaitListener) {
    _listenId++;
    _listenerMap[_listenId] = awaitListener;

    return _listenId;
  }

  void remove(int? listenId) {
    _listenerMap.remove(listenId);
  }

  void clear() {
    _listenerMap.clear();
  }
}

class ChangeListener {
  final Map<int, VoidCallback> _listenerMap = <int, VoidCallback>{};
  int _listenId = 0;
  int get currentListenerCnt => _listenerMap.length;

  void notify() {
    for (VoidCallback callback in _listenerMap.values) {
      callback.call();
    }
  }

  int add(VoidCallback listener) {
    _listenId++;
    _listenerMap[_listenId] = listener;

    return _listenId;
  }

  void remove(int? listenId) {
    _listenerMap.remove(listenId);
  }

  void clear() {
    _listenerMap.clear();
  }
}

class AwaitChangeListener {
  final Map<int, Future Function()> _listenerMap = <int, Future Function()>{};
  int _listenId = 0;
  int get currentListenerCnt => _listenerMap.length;

  void notify() async {
    for (Future Function() callback in _listenerMap.values) {
      await callback.call();
    }
  }

  int add(Future Function() awaitListener) {
    _listenId++;
    _listenerMap[_listenId] = awaitListener;

    return _listenId;
  }

  void remove(int? listenId) {
    _listenerMap.remove(listenId);
  }

  void clear() {
    _listenerMap.clear();
  }
}
