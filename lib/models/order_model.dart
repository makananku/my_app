class Order {
  final String id;
  final DateTime orderTime;
  final DateTime pickupTime;
  final List<OrderItem> items;
  final String status;
  final String paymentMethod;
  final String merchantName;
  final String merchantEmail; // Baru
  final String customerName;
  final String? cancellationReason;
  final String? notes; // Baru

  Order({
    required this.id,
    required this.orderTime,
    required this.pickupTime,
    required this.items,
    required this.paymentMethod,
    required this.merchantName,
    required this.merchantEmail, // Baru
    required this.customerName,
    this.status = 'pending',
    this.cancellationReason,
    this.notes, // Baru
  });

  double get totalPrice {
    return items.fold(0, (sum, item) => sum + (item.price * item.quantity));
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'orderTime': orderTime.toIso8601String(),
      'pickupTime': pickupTime.toIso8601String(),
      'items': items.map((item) => item.toMap()).toList(),
      'status': status,
      'paymentMethod': paymentMethod,
      'merchantName': merchantName,
      'customerName': customerName,
      'cancellationReason': cancellationReason,
    };
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['id'],
      orderTime: DateTime.parse(map['orderTime']),
      pickupTime: DateTime.parse(map['pickupTime']),
      items: (map['items'] as List).map((i) => OrderItem.fromMap(i)).toList(),
      paymentMethod: map['paymentMethod'],
      merchantName: map['merchantName'],
      customerName: map['customerName'],
      status: map['status'] ?? 'pending',
      cancellationReason: map['cancellationReason'], merchantEmail: '',
    );
  }
}

class OrderItem {
  final String name;
  final String image;
  final String subtitle;
  final int price;
  final int quantity;

  OrderItem({
    required this.name,
    required this.image,
    required this.subtitle,
    required this.price,
    required this.quantity, required String sellerEmail,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'image': image,
      'subtitle': subtitle,
      'price': price,
      'quantity': quantity,
    };
  }

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      name: map['name'],
      image: map['image'],
      subtitle: map['subtitle'],
      price: map['price'],
      quantity: map['quantity'], sellerEmail: '',
    );
  }
}