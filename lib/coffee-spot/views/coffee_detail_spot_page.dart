import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/coffee_spot_controller.dart';
import 'temp.dart';
import 'coffee_favourite_page.dart';

class CoffeeDetailSpotPage extends StatefulWidget {
  @override
  State<CoffeeDetailSpotPage> createState() => _CoffeeDetailSpotPageState();
}

class _CoffeeDetailSpotPageState extends State<CoffeeDetailSpotPage> {
  final CoffeeSpotController controller = Get.put(CoffeeSpotController());
  final TextEditingController searchController = TextEditingController();
  final CarouselController carouselController = CarouselController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          "Coffee Spots",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(margin: const EdgeInsets.all(16), child: _cafeSearchBar()),

          Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }
            if (controller.filteredCoffeeSpotList.isEmpty) {
              return const Center(child: Text("No Coffee Spots Found"));
            }
            return _cafeCarousel();
          }),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // go to temp page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const StandardBottomSheetExample(),
            ),
          );
        },
        child: const Icon(Icons.refresh),
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

  Widget _cafeCarousel() {
    final double itemWidth = MediaQuery.of(context).size.width * 0.77;

    return Container(
      padding: const EdgeInsets.all(12),
      height: 320,
      child: CarouselView(
        controller: carouselController,
        itemExtent: itemWidth,
        padding: const EdgeInsets.symmetric(vertical: 10),
        children: controller.filteredCoffeeSpotList.map((spot) {
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
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                  child: Image.network(
                    spot.image == null || spot.image!.isEmpty
                        ? 'https://via.placeholder.com/400x200.png?text=No+Image'
                        : spot.image!,
                    height: 160,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        spot.name,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
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
                              spot.address ?? 'No address provided',
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
  }

  void _showMaterial3BottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200,
          child: Center(
            child: Text('This is a Material 3 Modal Bottom Sheet!'),
          ),
        );
      },
    );
  }
}
