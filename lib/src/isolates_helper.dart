import 'dart:async';

import 'package:isolate_manager/isolate_manager.dart';
import 'package:isolates_helper/src/function.dart';

/// [R] is the return type of the function
class IsolatesHelper<R> {
  /// The instance of the [IsolateManager]
  late final IsolateManager<R> _manager;

  /// Create multiple long live isolates for computation.
  ///
  /// [concurrent] is a number of isolates that you want to create.
  ///
  /// [worker] is the worker name for the isolates. Ex: worker.js => worker: 'worker'
  ///
  /// [workerConverter] is a converter for the worker, the data from the worker
  /// will be directly sent to this method to convert to the result format that
  /// you want to.
  IsolatesHelper({
    int concurrent = 1,
    String worker = '',
    R Function(dynamic)? workerConverter,
    bool isDebug = false,
  }) {
    IsolateManager.debugLogPrefix = 'Isolates Helper';
    _manager = IsolateManager.create(
      internalFunction,
      workerName: worker,
      workerConverter: workerConverter,
      concurrent: concurrent,
      isDebug: isDebug,
    )..start();
  }

  /// Compute the given [function] with its' [params].
  ///
  /// Equavient of [compute]
  Future<R> call(FutureOr<R> Function(dynamic) function, dynamic params) async {
    return _excute(function, params);
  }

  /// Compute the given [function] with its' [params].
  Future<R> compute(
      FutureOr<R> Function(dynamic) function, dynamic params) async {
    return _excute(function, params);
  }

  /// Execute the given [function] with its' [params].
  Future<R> _excute(
      FutureOr<R> Function(dynamic) function, dynamic params) async {
    return _manager.compute([function, params]);
  }

  /// Restart all the isolates
  Future<void> restart() => _manager.restart();

  /// Stop all the isolates
  Future<void> stop() => _manager.stop();
}
