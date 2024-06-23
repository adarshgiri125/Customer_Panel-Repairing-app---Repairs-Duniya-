import 'dart:collection';
import 'package:customer_app/toast/toast.dart';
import 'package:flutter/material.dart';
import 'package:customer_app/presentation/Buy%20Appliance%20model/class/itemModel.dart';

class CartProvider extends ChangeNotifier {
  final List<ItemsModel> _cartItem = [];
  String _selectedLiterOption = 'None';

  UnmodifiableListView<ItemsModel> get cartItem =>
      UnmodifiableListView(_cartItem);
  String get selectedLiterOption => _selectedLiterOption;

  void selectLiterOption(String option) {
    _selectedLiterOption = option;
    notifyListeners();
  }

  void addItem(ItemsModel itemsModel, BuildContext context) {
    _cartItem.add(itemsModel);
    ToastService.sendAlert(
      context: context,
      message: 'Item Added',
      toastStatus: 'SUCCESS',
    );

    notifyListeners();
  }

  Future<void> deleteItem(ItemsModel itemsModel, BuildContext context) async {
    print("delete calls");
    _cartItem.remove(itemsModel);
    print("delete calls2");

    await ToastService.sendAlert(
        context: context, message: 'Item Remove', toastStatus: 'ERROR');
    print("delete calls3");

    notifyListeners();
  }

  void resetItem() {
    _cartItem.clear();
    notifyListeners();
  }

  double get productTotalPrice => _cartItem.fold(
        0.0,
        (previousValue, element) =>
            previousValue + (element.productPrice * element.quantity),
      );

  int get totalItems => _cartItem.fold(
        0,
        (previousValue, element) => previousValue + element.quantity,
      );

  void increaseQuantity(ItemsModel item) {
    item.quantity++;
    notifyListeners();
  }

  void decreaseQuantity(ItemsModel item) {
    if (item.quantity > 1) {
      item.quantity--;
      notifyListeners();
    }
  }

  List<Map<String, dynamic>> getCartItemsDetails() {
    return _cartItem.map((item) {
      return {
        'productName': item.productName,
        'productPrice': item.productPrice,
        'quantity': item.quantity,
        'filter': _selectedLiterOption,
      };
    }).toList();
  }
}
