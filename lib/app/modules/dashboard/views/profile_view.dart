import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:myapp/app/data/profile_response.dart';

import '../../profile/controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  @override
  final ProfileController controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: controller.logout,
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FutureBuilder<ProfileResponse>(
            future: controller.getProfile(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: Lottie.network(
                    'https://gist.githubusercontent.com/olipiskandar/4f08ac098c81c32ebc02c55f5b11127b/raw/6e21dc500323da795e8b61b5558748b5c7885157/loading.json',
                    repeat: true,
                    width: MediaQuery.of(context).size.width / 1,
                    errorBuilder: (context, error, stackTrace) {
                      return const Text("Loading animation failed");
                    },
                  ),
                );
              }

              if (snapshot.hasError) {
                return const Center(
                  child: Text("Failed to load profile"),
                );
              }

              final data = snapshot.data;

              if (data == null || data.email == null || data.email!.isEmpty) {
                return const Center(child: Text("No profile data available"));
              }

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (data.avatar != null)
                    CircleAvatar(
                      backgroundImage: NetworkImage(data.avatar!),
                      radius: 50,
                    ),
                  const SizedBox(height: 8),
                  Text(
                    "${data.name}",
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(" ${data.email}"),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}