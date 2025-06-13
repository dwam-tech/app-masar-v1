class OrderModel {
  final String id;
  final String customerName;
  final String customerImage;
  final DateTime orderTime;
  final double totalAmount;
  final String status; // قيد الانتظار، قيد التنفيذ، منتهية
  final List<OrderItem> items;

  OrderModel({
    required this.id,
    required this.customerName,
    required this.customerImage,
    required this.orderTime,
    required this.totalAmount,
    required this.status,
    required this.items,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      customerName: json['customerName'],
      customerImage: json['customerImage'],
      orderTime: DateTime.parse(json['orderTime']),
      totalAmount: json['totalAmount'].toDouble(),
      status: json['status'],
      items: (json['items'] as List)
          .map((item) => OrderItem.fromJson(item))
          .toList(),
    );
  }
}

class OrderItem {
  final String name;
  final String image;
  final double price;
  final int quantity;

  OrderItem({
    required this.name,
    required this.image,
    required this.price,
    required this.quantity,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      name: json['name'],
      image: json['image'],
      price: json['price'].toDouble(),
      quantity: json['quantity'],
    );
  }
}