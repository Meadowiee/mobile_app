import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/coffee_spot_controller.dart';
import 'coffee_spot_page.dart';

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
                      borderRadius: BorderRadius.circular(8),
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

class CoffeeFavoritePage extends StatefulWidget {
  const CoffeeFavoritePage({Key? key}) : super(key: key);

  @override
  State<CoffeeFavoritePage> createState() => _CoffeeFavoritePageState();
}

class _CoffeeFavoritePageState extends State<CoffeeFavoritePage> {
  final CoffeeSpotController controller = Get.find<CoffeeSpotController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Favorite Spots',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final favoriteSpots = controller.favoriteSpotList;

        if (favoriteSpots.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.favorite_border, size: 60, color: Colors.grey),
                SizedBox(height: 10),
                Text(
                  'You have no favorite coffee spots yet.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: favoriteSpots.length,
          itemBuilder: (context, index) {
            final favoriteItem = favoriteSpots[index];
            final spot = favoriteItem.spot;
            final visitCount = favoriteItem.visitCount;

            if (spot == null) return const SizedBox.shrink();

            final isFavorite = true;

            return _FavoriteSpotCard(
              spot: spot,
              controller: controller,
              visitCount: visitCount,
              isFavorite: isFavorite,
              onTap: () {
                showSpotDetailsSheet(
                  context: context,
                  spot: spot,
                  isFavorite: isFavorite,
                  onLike: () {
                    controller.deleteCheckIn(favoriteItem.id);
                  },
                  onCheckIn: () => controller.checkInToSpot(spot.id),
                );
              },
            );
          },
        );
      }),
    );
  }
}

class _FavoriteSpotCard extends StatelessWidget {
  final dynamic spot;
  final int visitCount;
  final bool isFavorite;
  final VoidCallback onTap;
  final CoffeeSpotController controller;

  const _FavoriteSpotCard({
    required this.spot,
    required this.visitCount,
    required this.isFavorite,
    required this.onTap,
    required this.controller,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String? cleanedImageUrl = spot.image?.split('?')[0];

    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        color: Theme.of(context).colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.only(bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // gambar
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child: (cleanedImageUrl == null || cleanedImageUrl.isEmpty)
                  ? Image.asset(
                      controller.placeholderImage,
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    )
                  : Image.network(
                      cleanedImageUrl,
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          controller.placeholderImage,
                          height: 150,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        );
                      },
                    ),
            ),

            // info
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
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Visited: $visitCount',
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // more information
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 14,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 6),
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
      ),
    );
  }
}
