import 'dart:async';
import 'package:event_bus/event_bus.dart';

import 'package:icreat_dct/6_util/logger.dart';

class EventBusService {
  static final EventBusService _instance = EventBusService._internal(); // singleton

  factory EventBusService() {
    return _instance;
  }

  EventBusService._internal();

  final EventBus eventBus = EventBus();

  void fire(dynamic event) {
    Logger.debug("event fired: $event");
    eventBus.fire(event);
  }

  StreamSubscription subscribe<T>(Function(dynamic) callback) { // T = eventTypeClass
    return eventBus.on<T>().listen((event) {
      callback(event);
    });
  }

  Future<void> unsubscribe(StreamSubscription sub) async {
    return sub.cancel();
  }

  Future<void> unsubscribeAll(List<StreamSubscription> subList) async {
    for (var sub in subList) {
      return sub.cancel();
    }
  }
}

class EventSubjectLoggedIn {
  EventSubjectLoggedIn();
}

class EventSessionExpired {
  EventSessionExpired();
}