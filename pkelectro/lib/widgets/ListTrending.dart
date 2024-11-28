class ListTrending {
  final int id;
  final String tiltle;
  final double price;
  final double cost;
  final String thumnail;
  int quantity;  // Add quantity field to track the quantity

  ListTrending({
    required this.id,
    required this.tiltle,
    required this.price,
    required this.cost,
    required this.thumnail,
    this.quantity = 1,  // Default quantity to 1
  });

  // Convert JSON to ListTrending
  factory ListTrending.fromJson(Map<String, dynamic> json) {
    return ListTrending(
      id: json['id'],
      tiltle: json['tiltle'],
      price: json['price'].toDouble(), // Convert to double if needed
      cost: json['cost'].toDouble(),
      thumnail: json['thumnail'],
      quantity: json['quantity'] ?? 1,  // Handle missing quantity
    );
  }

  // Convert ListTrending object to a map for saving in SharedPreferences
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tiltle': tiltle,
      'price': price,
      'cost': cost,
      'thumnail': thumnail,
      'quantity': quantity,
    };
  }
}
