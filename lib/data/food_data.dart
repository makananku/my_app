class FoodData {
  static List<Map<String, String>> getFoodItems(String category) {
    if (category == 'All' || category == 'Food') {
      return [
        {
          "title": "Soto Ayam",
          "subtitle": "Soto khas betawi",
          "time": "8 mins",
          "imgUrl": "assets/food/soto_ayam.jpg",
          "price": "20.000",
        },
        {
          "title": "Nasi Pecel",
          "subtitle": "Indonesian Food",
          "time": "5 mins",
          "imgUrl": "assets/food/nasi_pecel.jpg",
          "price": "15.000",
        },
        {
          "title": "Bakso",
          "subtitle": "Makanan tradisional",
          "time": "15 mins",
          "imgUrl": "assets/food/bakso.jpg",
          "price": "20.000",
        },
        {
          "title": "Mie Ayam",
          "subtitle": "Bakmi pake ayam",
          "time": "3 mins",
          "imgUrl": "assets/food/mie_ayam.jpg",
          "price": "20.000",
        },
      ];
    } else if (category == 'All' || category == 'Drinks') {
      return [
        {
          "title": "Matcha Latte",
          "subtitle": "Drink",
          "time": "10 mins",
          "imgUrl": "assets/drink/matcha_latte.jpg",
          "price": "25.000",
        },
        {
          "title": "Cappucino",
          "subtitle": "Kopi mantab",
          "time": "6 mins",
          "imgUrl": "assets/drink/cappucino.jpg",
          "price": "8.000",
        },
      ];
    } else if (category == 'All' || category == 'Snack') {
      return [
        {
          "title": "Burger",
          "subtitle": "Snack",
          "time": "10 mins",
          "imgUrl": "assets/snack/burger.jpg",
          "price": "30.000",
        },
        {
          "title": "Kentang Goreng",
          "subtitle": "Kentang digoreng",
          "time": "3 mins",
          "imgUrl": "assets/snack/french_fries.jpg",
          "price": "12.000",
        },
      ];
    } else {
      return [];
    }
  }
}