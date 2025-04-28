// lib/core/cubits/data_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';

abstract class DataState<T> {
  const DataState();
}
class DataInitial<T> extends DataState<T> {}
class DataLoading<T> extends DataState<T> {}
class DataLoaded<T>  extends DataState<T> {
  final T data;
  const DataLoaded(this.data);
}
class DataError<T>   extends DataState<T> {
  final String message;
  const DataError(this.message);
}

abstract class DataCubit<T> extends Cubit<DataState<T>> {
  DataCubit() : super(DataInitial<T>());

  Future<void> load(Future<T> Function() loader) async {
    emit(DataLoading<T>());
    try {
      final result = await loader();
      emit(DataLoaded<T>(result));
    } catch (e) {
      emit(DataError<T>(e.toString()));
    }
  }
}
