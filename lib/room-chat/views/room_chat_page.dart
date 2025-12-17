import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/room_chat_controller.dart';
import 'group_chat_page.dart';
import 'create_room_page.dart';
import '../../coffee-spot/views/coffee_spot_page.dart';
import '../../profile/views/profile_detail_page.dart';
import 'recommended_room_detail_page.dart';


const String baseUrl = "http://18.143.199.169:3000";

class RoomChatPage extends StatefulWidget {
  const RoomChatPage({super.key});

  @override
  State<RoomChatPage> createState() => _RoomChatPageState();
}

class _RoomChatPageState extends State<RoomChatPage> {
  int _selectedIndex = 0;

  late final RoomChatController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(RoomChatController(), permanent: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _searchBar(),
              const SizedBox(height: 24),

              _title("Room Chat"),
              _subtitle("Find your jam here"),
              const SizedBox(height: 32),

              _sectionTitle("Recommended Rooms"),
              const SizedBox(height: 14),
              _horizontalRooms(),

              const SizedBox(height: 36),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _sectionTitle("Your Room Chat"),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text("Create Room"),
                    onPressed: () async {
                      await Get.to(() => const CreateRoomPage());
                      controller.fetchMyRooms();
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Obx(() {
                if (controller.loadingMyRooms.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                return _verticalRooms();
              }),
            ],
          ),
        ),
      ),

      /// ================= BOTTOM NAV =================
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          if (_selectedIndex == index) return;

          setState(() => _selectedIndex = index);

          if (index == 1) {
            Get.to(() => CoffeeSpotPage());
          } else if (index == 2) {
            Get.to(() => ProfileDetailPage());
          }
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.chat_outlined),
            selectedIcon: Icon(Icons.chat),
            label: "Chat",
          ),
          NavigationDestination(
            icon: Icon(Icons.coffee_outlined),
            selectedIcon: Icon(Icons.coffee),
            label: "Coffee",
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }

  /* ================= WIDGETS ================= */

  Widget _horizontalRooms() {
    return SizedBox(
      height: 210,
      child: Obx(() => ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: controller.recommendedRooms.length,
        separatorBuilder: (_, __) => const SizedBox(width: 14),
        itemBuilder: (_, i) {
          final room = controller.recommendedRooms[i];

          return GestureDetector(
            onTap: () {
              Get.to(() => RecommendedRoomDetailPage(
                roomId: room['id'],
              ));
            },
            child: Container(
              width: 160,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                image: DecorationImage(
                  image: AssetImage(room['image']),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
      )),
    );
  }


  Widget _verticalRooms() {
    return Column(
      children: controller.myRooms.map<Widget>((room) {
        final imagePath = room['profileImage'];

        return GestureDetector(
          onTap: () async {
            final detail = await controller.openRoom(room['id']);
            Get.to(() => GroupChatPage(roomDetail: detail));
          },
          child: Card(
            margin: const EdgeInsets.only(bottom: 20),
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                imagePath != null
                    ? Image.network(
                  "$baseUrl$imagePath",
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                )
                    : Image.asset(
                  "assets/images/download (5).jpeg",
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                ListTile(
                  title: Text(room['name'] ?? "-"),
                  subtitle: Text(room['desc'] ?? ""),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  /* ================= SMALL UI ================= */

  Widget _searchBar() {
    return TextField(
      decoration: InputDecoration(
        hintText: "Search room...",
        prefixIcon: const Icon(Icons.search),
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _title(String t) =>
      Text(t, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold));

  Widget _subtitle(String t) =>
      Text(t, style: TextStyle(color: Colors.grey.shade600));

  Widget _sectionTitle(String t) =>
      Text(t, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600));
}
