import 'package:flutter/material.dart';
import '../models/favorite_item.dart'; // Import model FavoriteItem

class FavoriteProvider with ChangeNotifier {
  List<FavoriteItem> _favoriteItems = [];

  List<FavoriteItem> get favoriteItems => _favoriteItems;

  void addToFavorites(FavoriteItem item) {
    _favoriteItems.add(item);
    notifyListeners(); // Memberitahu listener bahwa data berubah
  }

  void removeFromFavorites(FavoriteItem item) {
    _favoriteItems.remove(item);
    notifyListeners();
  }

  bool isFavorite(FavoriteItem item) {
    return _favoriteItems.contains(item);
  }
}