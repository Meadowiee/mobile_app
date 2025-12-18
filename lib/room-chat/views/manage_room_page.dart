import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/manage_room_controller.dart';

class ManageRoomPage extends StatelessWidget {
  final Map roomDetail;

  const ManageRoomPage({super.key, required this.roomDetail});

  /// 🧪 DUMMY JOIN REQUEST (UI ONLY)
  static const List<Map<String, dynamic>> dummyJoinRequests = [
    {
      "id": "dummy-1",
      "user": {
        "name": "John Doe",
        "username": "@johndoe",
      }
    },
    {
      "id": "dummy-2",
      "user": {
        "name": "Jane Coffee",
        "username": "@janecoffee",
      }
    },
  ];

  @override
  Widget build(BuildContext context) {
    final controller =
    Get.put(ManageRoomController(roomDetail['id']));

    return Scaffold(
      appBar: AppBar(title: const Text("Manage Room")),
      body: Obx(() {
        if (controller.loading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        /// ✅ FIX TIPE DATA
        final List<Map<String, dynamic>> joinRequests =
        controller.joinRequests.isNotEmpty
            ? List<Map<String, dynamic>>.from(controller.joinRequests)
            : dummyJoinRequests;

        return ListView(
          padding: const EdgeInsets.all(20),
          children: [
            /// ===== JOIN REQUESTS =====
            const Text(
              "Join Requests",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            if (joinRequests.isEmpty)
              const Text("No pending requests"),

            ...joinRequests.map((r) {
              final user = r['user'] as Map<String, dynamic>;
              final bool isDummy =
              r['id'].toString().startsWith("dummy");

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user['name'] ?? "User",
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        user['username'] ?? "",
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                      const SizedBox(height: 14),

                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                if (isDummy) {
                                  Get.snackbar(
                                      "Dummy", "Reject clicked");
                                } else {
                                  controller.reject(r['id']);
                                }
                              },
                              child: const Text("Reject"),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                if (isDummy) {
                                  Get.snackbar(
                                      "Dummy", "Approve clicked");
                                } else {
                                  controller.approve(r['id']);
                                }
                              },
                              child: const Text("Approve"),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }),

            const Divider(height: 40),

            const Text(
              "Members",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            ...controller.members.map((m) => ListTile(
              leading: const CircleAvatar(),
              title: Text(m['user']?['name'] ?? "User"),
              subtitle: Text(m['user']?['username'] ?? ""),
              trailing: IconButton(
                icon: const Icon(Icons.remove_circle,
                    color: Colors.red),
                onPressed: () =>
                    controller.removeMember(m['id']),
              ),
            )),

            const Divider(height: 40),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: () async {
                final confirm = await Get.dialog<bool>(
                  AlertDialog(
                    title: const Text("Delete Room"),
                    content:
                    const Text("This action cannot be undone."),
                    actions: [
                      TextButton(
                        onPressed: () =>
                            Get.back(result: false),
                        child: const Text("Cancel"),
                      ),
                      TextButton(
                        onPressed: () =>
                            Get.back(result: true),
                        child: const Text(
                          "Delete",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                );

                if (confirm == true) {
                  controller.deleteRoom();
                }
              },
              child: const Text("Delete Room"),
            ),
          ],
        );
      }),
    );
  }
}
