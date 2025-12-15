import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'user_controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(debugShowCheckedModeBanner: false, home: HomePage());
  }
}

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final UserController controller = Get.put(UserController());
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
          controller.fetchUsers(loadMore: true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("GitHub Users"), centerTitle: true),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.black),
          );
        }

        return ListView.builder(
          controller: scrollController,
          itemCount: controller.users.length + 1,
          itemBuilder: (context, index) {
            // bottom loader section
            if (index == controller.users.length) {
              return Obx(() {
                return controller.isLoadMore.value
                    ? const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Center(child: CircularProgressIndicator()),
                )
                    : const SizedBox();
              });
            }

            if (index < controller.users.length) {
              final user = controller.users[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(user.avatarUrl),
                ),
                title: Text(user.login),
                subtitle: Text("ID: ${user.id}"),
              );
            }
          },
        );
      }),
    );
  }
}
