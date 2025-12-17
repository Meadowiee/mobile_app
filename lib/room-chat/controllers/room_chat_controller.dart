import 'package:get/get.dart';
import '../services/room_service.dart';
import '../services/room_detail_service.dart';
import '../../utils/session_manager.dart';

class RoomChatController extends GetxController {
  var loadingMyRooms = true.obs;
  var myRooms = <Map<String, dynamic>>[].obs;

  final recommendedRooms = <Map<String, dynamic>>[
    {
      "id": "1",
      "name": "Sendu Brew Gang",
      "desc": "Kumpulan cerita pecinta kopi",
      "image": "assets/images/download (5).jpeg",
      "status": "join", // join | pending
    },
    {
      "id": "2",
      "name": "Seduh Bercerita",
      "desc": "Ngobrol santai tentang kopi & hidup",
      "image": "assets/images/download (5).jpeg",
      "status": "join",
    },
  ].obs;


  @override
  void onInit() {
    super.onInit();
    fetchMyRooms();
  }

  Future<void> fetchMyRooms() async {
    try {
      loadingMyRooms.value = true;

      final rooms = await RoomService.getMyRooms();

      myRooms.assignAll(
        rooms.map<Map<String, dynamic>>((r) => {
          "id": r['id'],
          "name": r['name'],
          "desc": r['description'] ?? '',
          "profileImage": r['profileImage'],
        }),
      );
    } finally {
      loadingMyRooms.value = false;
    }
  }

  Future<Map<String, dynamic>> openRoom(String roomId) async {
    final detail = await RoomDetailService.getRoomDetail(roomId);
    final myUserId = await SessionManager().getUserId();

    return {
      ...detail,
      'myUserId': myUserId,
    };
  }
  void requestJoinDummy(String roomId) {
    final index =
    recommendedRooms.indexWhere((r) => r['id'] == roomId);

    if (index == -1) return;

    recommendedRooms[index] = {
      ...recommendedRooms[index],
      'status': 'pending',
    };

    recommendedRooms.refresh();
  }

}
