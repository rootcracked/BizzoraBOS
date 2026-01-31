import 'package:bizzora_mobile/features/workers/models/response.dart';

class Workerstate {
  final bool isAuthenticated;
  final String? token;
  final String? role;
  final Response? worker;

  Workerstate({
     this.isAuthenticated = false,
     this.token,
     this.worker,
     this.role
  });

  Workerstate copyWith({
    bool? isAuthenticated,
    String? token,
    String? role,
    Response? worker,
  }) {
    return Workerstate(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      token: token ?? this.token,
      worker: worker ?? this.worker,
      role: role ?? this.role,
    );
  }

  factory Workerstate.initial() => Workerstate(isAuthenticated: false);
}

class WorkerStoreState {
  final List<Response> workers;

  WorkerStoreState({this.workers = const []});

  WorkerStoreState copyWith({List<Response>? workers}) {
    return WorkerStoreState(workers: workers ?? this.workers);
  }

  factory WorkerStoreState.initial() => WorkerStoreState();
}
