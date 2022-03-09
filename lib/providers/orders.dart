import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../utils/constants.dart';
import 'cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime datetime;

  OrderItem(
      {required this.id,
      required this.amount,
      required this.products,
      required this.datetime});
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  final String authToken;
  final String userId;

  Orders(this.authToken, this.userId, this._orders);

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    //final url = Uri.https(Products.serverUrl, '/orders.json');
    final url =
        Uri.parse('https://$serverUrl/orders/$userId.json?auth=$authToken');
    try {
      final response = await http.get(url);
      final List<OrderItem> loadedOrders = [];
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      extractedData.forEach(
        (orderId, orderData) {
          loadedOrders.add(
            OrderItem(
              id: orderId,
              amount: orderData['amount'],
              products: (orderData['products'] as List<dynamic>)
                  .map((item) => CartItem(
                        id: item['id'],
                        price: item['price'],
                        quantity: item['quantity'],
                        title: item['title'],
                      ))
                  .toList(),
              datetime: DateTime.parse(orderData['datetime']),
            ),
          );
        },
      );
      _orders = loadedOrders.reversed.toList();
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    //final url = Uri.https(Products.serverUrl, '/orders.json');
    final url =
        Uri.parse('https://$serverUrl/orders/$userId.json?auth=$authToken');
    final timestamp = DateTime.now();
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'amount': total,
            'datetime': timestamp.toIso8601String(),
            'products': cartProducts
                .map(
                  (cp) => {
                    'id': cp.id,
                    'title': cp.title,
                    'quantity': cp.quantity,
                    'price': cp.price,
                    //'': cp.,
                  },
                )
                .toList(),
          },
        ),
      );

      _orders.insert(
        0,
        OrderItem(
            id: json.decode(response.body)['name'],
            amount: total,
            products: cartProducts,
            datetime: timestamp),
      );
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }
}
