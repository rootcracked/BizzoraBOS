import 'package:riverpod/riverpod.dart';
import 'WorkerNotifier.dart';
import 'WorkerState.dart';

final workerProvider = NotifierProvider<Workernotifier, WorkerStoreState>(
  () => Workernotifier(),
);
