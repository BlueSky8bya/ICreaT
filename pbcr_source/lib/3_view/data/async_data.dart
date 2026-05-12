import 'package:get/get.dart';
import 'package:icreat_dct/3_view/data/async_state.dart';

class AsyncData<T> {
  AsyncData({
    T? data,
    AsyncState loadState = AsyncState.initial,
  }) {
    _loadState = loadState.obs;
    _data = Rxn<T>(data);
  }

  factory AsyncData.error() {
    return AsyncData(loadState: AsyncState.error);
  }

  factory AsyncData.loading() {
    return AsyncData(loadState: AsyncState.loading);
  }

  factory AsyncData.loaded(T data) {
    return AsyncData(data: data, loadState: AsyncState.loaded);
  }
  
  late final Rx<AsyncState> _loadState;
  AsyncState get loadState => _loadState.value;
  void setLoadState(AsyncState state) => _loadState.value = state;

  late final Rxn<T> _data;
  T? get data => _data.value;
  void setData(T? data) => _data.value = data;
}
