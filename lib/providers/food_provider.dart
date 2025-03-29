import 'package:flutter/material.dart';

class FoodProvider extends ChangeNotifier {
  Future<void> refreshData() async {
    await Future.delayed(const Duration(seconds: 2));
    notifyListeners(); 
  }
}
