import 'package:bizzora_mobile/features/workers/controller/WorkerState.dart';
import 'package:bizzora_mobile/features/workers/models/request.dart';
import 'package:bizzora_mobile/features/workers/models/response.dart';
import 'package:bizzora_mobile/features/workers/service/service.dart';
import 'package:riverpod/riverpod.dart';

final workerServiceProvider = Provider<WorkerService>((ref) {
  return WorkerService();
});

class Workernotifier extends Notifier<WorkerStoreState> {
  late final WorkerService _workerService;

  @override
  WorkerStoreState build() {
    _workerService = ref.read(workerServiceProvider);
    return WorkerStoreState.initial();
  }

  Future<Response> addWorker(
    String workerName,
    phoneNumber,
    String email,
    String password,
  ) async {
    try {
      final workerData = Request(
        workerName: workerName,
        phoneNumber: phoneNumber,
        email: email,
        password: password,
      );

      final newWorker = await _workerService.addWorker(workerData);
      state = state.copyWith(workers: [...state.workers, newWorker]);
      return newWorker;
    } catch (e) {
      throw Exception("Error adding Worker $e");
    }
  }

  Future<void> getWorkers() async {
    try {
      final List<Response> workers = await _workerService.getWorkers();
      state = state.copyWith(workers: workers);
    } catch (e) {
      throw Exception('Error fetching workers: $e');
    }
  }


  
}

// Notifier Provider
final workerProvider = NotifierProvider<Workernotifier, WorkerStoreState>(
  Workernotifier.new,
);
