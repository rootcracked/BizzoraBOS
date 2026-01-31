import 'package:riverpod/riverpod.dart';
import './WorkerLogin.dart';
import './WorkerState.dart';

final LoginProvider = NotifierProvider<Workerlogin,Workerstate>(() {
  return Workerlogin();
});
