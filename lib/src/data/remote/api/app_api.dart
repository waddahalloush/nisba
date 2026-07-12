import 'package:get/get.dart' hide FormData, MultipartFile;

import 'dio_client.dart';

class AppApi {
  final DioClient _dioClient = Get.find();
  // ====== Post requests======

  // Future<UserResponse> loginClient({required var data}) async {
  //   final res = await _dioClient.post(EndPoints.loginClient, data: data);

  //   return UserResponse.fromJson(res);
  // }

  // ====== Get requests======
}
