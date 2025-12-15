import 'package:dio/dio.dart';
import 'package:flutter_pagination_demo/user_mdel.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  var users = <UserModel>[].obs;
  var isLoading = false.obs;
  var isLoadMore = false.obs;

  int perPage = 10;
  int since = 0; // required for next page

  final Dio dio = Dio();

  @override
  void onInit() {
    super.onInit();
    fetchUsers();
  }

  Future<void> fetchUsers({bool loadMore = false}) async {
    if (loadMore) {
      isLoadMore.value = true;
    } else {
      isLoading.value = true;
      users.clear();
      since = 0;
    }

    try {
      final url =
          "https://api.github.com/users?per_page=$perPage&since=$since";

      final response = await dio.get(url,
      // options: Options(
      //   headers: {
      //     'Content-Type': 'application/x-www-form-urlencoded',
      //     "Authorization": "Bearer YOUR_GITHUB_TOKEN", // optional
      //   },
      // ),
      /// If needed
      );
      List data = response.data;
      List<UserModel> newUsers =
      data.map((e) => UserModel.fromJson(e)).toList();


      users.addAll(newUsers);

      // update next page pointer
      if (newUsers.isNotEmpty) {
        since = newUsers.last.id;
      }
    } finally {

      isLoading.value = false;
      isLoadMore.value = false;
    }
  }
}
