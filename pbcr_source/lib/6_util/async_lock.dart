class AsyncLock {
  final Set<String> _locks = {};

  bool isLocked(String key) => _locks.contains(key);

  Future<void> run(String key, Future<void> Function() task) async {
    if (isLocked(key)) {
      return;
    }

    _locks.add(key);
    try {
      await task();
    } finally {
      _locks.remove(key);
    }
  }
}
