import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/coffee_spot_controller.dart';
import 'coffee_favourite_page.dart';
import '../../profile/views/profile_detail_page.dart';
import '../../room-chat/views/room_chat_page.dart';

class CoffeeSpotPage extends StatefulWidget {
  @override
  State<CoffeeSpotPage> createState() => _CoffeeSpotPageState();
}

class _CoffeeSpotPageState extends State<CoffeeSpotPage> {
  final CoffeeSpotController controller = Get.put<CoffeeSpotController>(
    CoffeeSpotController(),
  );
  final TextEditingController searchController = TextEditingController();
  int _selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Coffee Spots',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              Get.to(() => const CoffeeFavoritePage());
            },
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.isNotEmpty) {
          return Center(child: Text('Error: ${controller.errorMessage.value}'));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Search bar for cafes
              _cafeSearchBar(),
              const SizedBox(height: 20),

              // Recent Spots Section
              const Text(
                'Recent Spots',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              _recentCafeCarousel(context, controller),
              const SizedBox(height: 10),

              // Discover Spots Section
              const Text(
                'Discover More',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 10),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.filteredCoffeeSpotList.length,
                itemBuilder: (context, index) {
                  final spot = controller.filteredCoffeeSpotList[index];

                  final isFavorite = controller.favoriteSpotList.any(
                    (fav) => fav.spotId == spot.id,
                  );

                  return GestureDetector(
                    onTap: () {
                      showSpotDetailsSheet(
                        context: context,
                        spot: spot,
                        isFavorite: isFavorite,
                        onLike: () {
                          if (isFavorite) {
                            final spotCheckId = controller.favoriteSpotList
                                .firstWhere((fav) => fav.spotId == spot.id)
                                .id;
                            controller.deleteCheckIn(spotCheckId);
                          } else {
                            controller.checkInToSpot(spot.id);
                          }
                        },
                        onCheckIn: () => controller.checkInToSpot(spot.id),
                      );
                    },
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: 100,
                        minHeight: 100,
                      ),
                      child: Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        margin: const EdgeInsets.only(bottom: 12, right: 10),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // name and address
                              Text(
                                spot.titleCaseName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    spot.address != null
                                        ? Icons.location_on
                                        : Icons.location_off,
                                    size: 16,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                  ),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      spot.address != null &&
                                              spot.address!.isNotEmpty
                                          ? spot.address!
                                          : 'No address provided',
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      }),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() => _selectedIndex = index);

          if (index == 0) {
            Get.to(() => RoomChatPage());
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

  Widget _cafeSearchBar() {
    return SearchBar(
      controller: searchController,
      elevation: MaterialStateProperty.all(1),
      hintText: "Search coffee spot",
      leading: const Icon(Icons.search),
      trailing: [
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            FocusScope.of(context).unfocus();
            controller.filterCoffeeSpots("");
            searchController.clear();
          },
        ),
      ],
      onChanged: (query) {
        controller.filterCoffeeSpots(query);
      },
    );
  }

  Widget _recentCafeCarousel(
    BuildContext context,
    CoffeeSpotController controller,
  ) {
    return Obx(() {
      final double itemWidth = MediaQuery.of(context).size.width * 0.70;

      if (controller.recentSpotList.isEmpty) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(12.0),
            child: Text('There are no places visited yet.'),
          ),
        );
      }

      return Container(
        height: 250,
        child: CarouselView(
          itemExtent: itemWidth,

          padding: const EdgeInsets.symmetric(vertical: 12),
          children: controller.recentSpotList.map((spotCheck) {
            final spot = spotCheck.spot;
            final visitCount = spotCheck.visitCount;

            if (spot == null) return const SizedBox.shrink();
            return Card(
              elevation: 4,
              color: Theme.of(context).colorScheme.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Gambar
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                    child: (spot.image == null || spot.image!.isEmpty)
                        ? Image.asset(controller.placeholderImage)
                        : Image.network(
                            spot.image!,
                            height: 120,
                            width: double.infinity,
                            fit: BoxFit.cover,

                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                controller.placeholderImage,
                                height: 120,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              );
                            },
                          ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // name and visit count
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                spot.titleCaseName,
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(fontWeight: FontWeight.bold),
                                maxLines: 1,
                                overflow: TextOverflow.fade,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.secondary,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '$visitCount',
                                maxLines: 1,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                  overflow: TextOverflow.fade,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        // location
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 16,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                spot.address != null && spot.address!.isNotEmpty
                                    ? spot.address!
                                    : 'No address provided',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      );
    });
  }
}

// top level function
Widget _buildDetailRow(
  BuildContext context, {
  required IconData icon,
  required String text,
}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
      const SizedBox(width: 10),
      Expanded(
        child: Text(
          text,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: (icon == Icons.link || icon == Icons.public)
                ? Colors.blue.shade700
                : Colors.black87,
          ),
        ),
      ),
    ],
  );
}

void showSpotDetailsSheet({
  required BuildContext context,
  required dynamic spot,
  required bool isFavorite,
  required VoidCallback onLike,
  required VoidCallback onCheckIn,
}) {
  final CoffeeSpotController controller = Get.find<CoffeeSpotController>();
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (BuildContext bc) {
      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // show image
            if (spot.image != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  spot.image,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      'assets/images/coffee-placeholder.jpg',
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
            const SizedBox(height: 16),

            // name and visit count
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    spot.titleCaseName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Obx(() {
                  final latestSpotCheck = controller.favoriteSpotList
                      .firstWhereOrNull((fav) => fav.spotId == spot.id);
                  final latestVisitCount = latestSpotCheck?.visitCount ?? 0;
                  final displayVisitCount = (latestVisitCount == 0)
                      ? "Never"
                      : latestVisitCount;

                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Visited: $displayVisitCount',
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }),
              ],
            ),
            const SizedBox(height: 16),

            // more info rows
            _buildDetailRow(
              context,
              icon: Icons.location_on,
              text: spot.address ?? 'No address provided',
            ),
            const SizedBox(height: 12),
            _buildDetailRow(
              context,
              icon: Icons.phone,
              text: spot.contact ?? 'No contact provided',
            ),
            const SizedBox(height: 12),
            _buildDetailRow(
              context,
              icon: Icons.link,
              text: spot.urlBlog ?? 'No blog provided',
            ),
            const SizedBox(height: 12),
            _buildDetailRow(
              context,
              icon: Icons.public,
              text: spot.urlAddress ?? 'No website provided',
            ),
            const SizedBox(height: 20),

            // divider
            Divider(color: Colors.grey.shade300),
            const SizedBox(height: 10),

            // action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  iconSize: 30,
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : Colors.grey,
                  ),
                  onPressed: () {
                    onLike();
                    Navigator.pop(context);
                  },
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    onCheckIn();
                  },
                  icon: const Icon(Icons.check),
                  label: const Text('Check Spot'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      );
    },
  );
}
