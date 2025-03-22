import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../providers/favorite_provider.dart';
import '../widgets/custom_bottom_navigation.dart';
import '../models/cart_item.dart';
import '../models/favorite_item.dart';
import 'favorite_screen.dart';
import '../data/food_data.dart';
import '../data/search_data.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  int selectedIndex = 0;
  String selectedCategory = 'All';
  bool isDetailVisible = false;
  String selectedFoodItem = '';
  String selectedFoodPrice = '';
  String selectedFoodImgUrl = '';
  late AnimationController _boxController;
  late AnimationController _navController;
  final TextEditingController _searchController = TextEditingController();

  bool isSearchVisible = false;
  bool isKeyboardVisible = false;

  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _boxController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _navController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _loadRecentSearches(); // Load recent searches saat inisialisasi
  }

  @override
  void dispose() {
    _boxController.dispose();
    _navController.dispose();
    _searchFocusNode.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    if (isDetailVisible) {
      _closeDetailBox();
      return Future.value(false);
    }
    if (isSearchVisible) {
      setState(() {
        isSearchVisible = false;
      });
      return Future.value(false);
    }
    return Future.value(true);
  }

  // Simulated data refresh method
  Future<void> _refreshData() async {
    await Future.delayed(const Duration(seconds: 2));
    setState(() {});
  }

  // Fungsi untuk memuat recent searches dari SharedPreferences
  Future<void> _loadRecentSearches() async {
    await SearchData.loadRecentSearches();
    setState(() {}); // Perbarui UI setelah data dimuat
  }

  // Fungsi untuk menangani pencarian
  void _handleSearch(String query) {
    if (query.isNotEmpty) {
      SearchData.addRecentSearch(query); // Tambahkan ke recent searches
      setState(() {}); // Perbarui UI
      // Lakukan logika pencarian (misalnya, filter daftar makanan)
      // ...
    }
  }

  // Fungsi untuk menghapus recent search
  void _removeRecentSearch(String query) {
    SearchData.removeRecentSearch(query); // Hapus dari recent searches
    setState(() {}); // Perbarui UI
  }

  @override
  Widget build(BuildContext context) {
    final favoriteProvider = Provider.of<FavoriteProvider>(context);

    return WillPopScope(
      onWillPop: _onWillPop,
      child: KeyboardVisibilityProvider(
        child: Scaffold(
          appBar: AppBar(
            title: const Text(
              'Home',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
            leading: IconButton(
              icon: Stack(
                children: [
                  const Icon(Icons.favorite_border),
                  if (favoriteProvider.favoriteItems.isNotEmpty)
                    Positioned(
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 12,
                          minHeight: 12,
                        ),
                        child: Text(
                          '${favoriteProvider.favoriteItems.length}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
              onPressed: () {
                // Navigate to Favorites Screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FavoritesScreen(),
                  ),
                );
              },
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: () {
                  // Handle notification icon press
                },
              ),
            ],
            elevation: 0,
          ),
          body: KeyboardVisibilityBuilder(
            builder: (context, isKeyboardVisible) {
              this.isKeyboardVisible = isKeyboardVisible;

              return GestureDetector(
                onTap: () {
                  if (isDetailVisible) {
                    _closeDetailBox();
                  }
                },
                child: Stack(
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            children: [
                              TextField(
                                controller: _searchController,
                                focusNode: _searchFocusNode,
                                decoration: InputDecoration(
                                  hintText: "Search",
                                  prefixIcon: const Icon(Icons.search),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: BorderSide.none,
                                  ),
                                  fillColor: Colors.grey.shade200,
                                  filled: true,
                                ),
                                onTap: () {
                                  if (isDetailVisible) {
                                    _closeDetailBox();
                                  }
                                  _searchFocusNode.requestFocus();
                                  setState(() {
                                    isSearchVisible = true;
                                  });
                                },
                                onSubmitted:
                                    _handleSearch, // Saat pengguna menekan enter
                              ),
                              const SizedBox(height: 20),
                              if (!isSearchVisible && !isKeyboardVisible)
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: [
                                      _buildCategory(
                                        "All",
                                        selectedCategory == 'All',
                                      ),
                                      _buildCategory(
                                        "Food",
                                        selectedCategory == 'Food',
                                      ),
                                      _buildCategory(
                                        "Drinks",
                                        selectedCategory == 'Drinks',
                                      ),
                                      _buildCategory(
                                        "Snack",
                                        selectedCategory == 'Snack',
                                      ),
                                    ],
                                  ),
                                ),
                              if (isSearchVisible) _buildSearchResults(),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Expanded(
                          child: RefreshIndicator(
                            onRefresh: _refreshData,
                            backgroundColor: Colors.white,
                            color: Colors.blue,
                            displacement: 50,
                            strokeWidth: 3,
                            child: ListView(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              children: [
                                const Text(
                                  "Food for you",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                _buildFoodList(),
                                const SizedBox(height: 20),
                                const Text(
                                  "Order again",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                _buildFoodList(),
                                const SizedBox(height: 100),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (isDetailVisible)
                      AnimatedPositioned(
                        duration: const Duration(milliseconds: 300),
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Material(
                          elevation: 8,
                          color: Colors.white,
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            width: double.infinity,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: Image.asset(
                                    selectedFoodImgUrl,
                                    height: 200,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  selectedFoodItem,
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  "$selectedFoodPrice",
                                  style: const TextStyle(fontSize: 18),
                                ),
                                const SizedBox(height: 10),
                                ElevatedButton(
                                  onPressed: () {
                                    final cartProvider =
                                        Provider.of<CartProvider>(
                                          context,
                                          listen: false,
                                        );
                                    cartProvider.addToCart(
                                      CartItem(
                                        name: selectedFoodItem,
                                        price: int.parse(
                                          selectedFoodPrice.replaceAll(".", ""),
                                        ),
                                        image: selectedFoodImgUrl,
                                      ),
                                    );
                                    _closeDetailBox();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: const Size(
                                      double.infinity,
                                      50,
                                    ),
                                    backgroundColor: Colors.blue,
                                    foregroundColor: Colors.white,
                                  ),
                                  child: const Text("Add to Cart"),
                                ),
                                const SizedBox(height: 10),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: GestureDetector(
                                    onTap: () {
                                      final favoriteProvider =
                                          Provider.of<FavoriteProvider>(
                                            context,
                                            listen: false,
                                          );
                                      favoriteProvider.addToFavorites(
                                        FavoriteItem(
                                          name: selectedFoodItem,
                                          price: selectedFoodPrice,
                                          image: selectedFoodImgUrl,
                                        ),
                                      );
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text("Added to favorites!"),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12,
                                        horizontal: 20,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(30),
                                        border: Border.all(
                                          color: Colors.black,
                                          width: 1,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(
                                            Icons.favorite_border,
                                            color: Colors.black,
                                          ),
                                          const SizedBox(width: 8),
                                          const Text(
                                            'Save',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            bottom:
                isKeyboardVisible
                    ? MediaQuery.of(context).viewInsets.bottom + 16
                    : 0,
            left: 0,
            right: 0,
            child: AnimatedOpacity(
              opacity: isDetailVisible ? 0 : 1,
              duration: const Duration(milliseconds: 300),
              child: IgnorePointer(
                ignoring: isDetailVisible,
                child: CustomBottomNavigation(
                  selectedIndex: 0,
                  context: context,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onCategorySelected(String category) {
    if (isDetailVisible) {
      setState(() {
        isDetailVisible = false;
      });
    }
    setState(() {
      selectedCategory = category;
    });
  }

  void _closeDetailBox() {
    setState(() {
      isDetailVisible = false;
    });
    _boxController.reverse();
    _navController.forward();
  }

  Widget _buildCategory(String title, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onTap: () => _onCategorySelected(title),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.blue : Colors.grey.shade800,
              ),
            ),
            if (isSelected)
              Container(
                margin: const EdgeInsets.only(top: 4),
                height: 3,
                width: 30,
                color: Colors.blue,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFoodList() {
    final foodItems = FoodData.getFoodItems(selectedCategory);

    return SizedBox(
      height: 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: foodItems.length,
        itemBuilder: (context, index) {
          return _buildFoodCard(
            foodItems[index]["title"]!,
            foodItems[index]["subtitle"]!,
            foodItems[index]["time"]!,
            foodItems[index]["imgUrl"]!,
            foodItems[index]["price"]!,
          );
        },
      ),
    );
  }

  Widget _buildFoodCard(
    String title,
    String subtitle,
    String time,
    String imgUrl,
    String price,
  ) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedFoodItem = title;
          selectedFoodPrice = price;
          selectedFoodImgUrl = imgUrl;
          isDetailVisible = true;
          _boxController.forward();
          _navController.reverse();
        });
      },
      child: Container(
        width: 160,
        margin: const EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 5,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(15),
              ),
              child: Image.asset(
                imgUrl,
                height: 100,
                width: 160,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(subtitle, style: const TextStyle(color: Colors.grey)),
                  Text(
                    time,
                    style: const TextStyle(color: Colors.blue, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResults() {
    final recentSearches = SearchData.getRecentSearches();
    final popularCuisines = SearchData.getPopularCuisines();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Recent Searches",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        if (recentSearches.isEmpty) const Text("No recent searches"),
        if (recentSearches.isNotEmpty)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children:
                recentSearches.map((search) {
                  return Chip(
                    label: Text(search),
                    deleteIcon: const Icon(Icons.clear),
                    onDeleted:
                        () =>
                            _removeRecentSearch(search), // Hapus saat x ditekan
                  );
                }).toList(),
          ),
        const SizedBox(height: 20),
        const Text(
          "Popular Cuisines",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children:
              popularCuisines.map((cuisine) {
                return Chip(label: Text(cuisine));
              }).toList(),
        ),
      ],
    );
  }
}
