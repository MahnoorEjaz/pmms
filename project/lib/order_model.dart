// order.dart

class Order {
  final String id;
  final String type;
  final String size;
  final String paperorient;
  final String paper;
  final String des;
  final int quantity;
  final int totalPrice;
  final String userEmail;

  Order({
    required this.id,
    required this.type,
    required this.size,
    required this.paperorient,
    required this.paper,
    required this.des,
    required this.quantity,
    required this.totalPrice,
    required this.userEmail,
  });

  // Factory method to create an Order object from JSON data
  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['_id'] ?? '',
      type: json['type'] ?? '',
      size: json['size'] ?? '',
      paperorient: json['paperorient'] ?? '',
      paper: json['paper'] ?? '',
      des: json['des'] ?? '',
      quantity: json['quantity'] ?? 0,
      totalPrice: json['totalPrice'] ?? 0.0,
      userEmail: json['email'] ?? '',
    );
  }
}
