import 'package:bizzora_mobile/features/workers/controller/WorkerState.dart';
import 'package:bizzora_mobile/features/workers/models/response.dart';
import 'package:bizzora_mobile/features/workers/service/service.dart';
import 'package:bizzora_mobile/features/auth/models/login_request.dart';
import 'package:riverpod/riverpod.dart';
import 'package:bizzora_mobile/core/storage_service.dart';



class Workerlogin extends Notifier<Workerstate>{
  final _workerService = WorkerService();

  @override
  Workerstate build(){
    return Workerstate.initial();
  }

  Future<Response> login(String email,String password) async {
    try {
      final request = LoginRequest(email: email, password: password);
      final worker = await _workerService.login(request);

      await StorageService.saveToken(worker.token);
      

      state = state.copyWith(
        isAuthenticated: true,
        token: worker.token,
        worker: worker,
        role: worker.role
      );
      print("worker you logged in successfully");
      print(worker.phoneNumber ??  "Nothing found");
      return worker;

      }catch(e){
      throw e;
      
    }
  }

  Future<void> checkWorker() async {
    final token = await StorageService.getToken();
    if(token != null){
      state = state.copyWith(isAuthenticated: true, token:token);
    }
  }

Future<void> logOut() async {
    await StorageService.clearToken();
    state = Workerstate.initial();
  }

}
