// ignore_for_file: file_names, avoid_print

import 'dart:collection';
import 'package:customer_app/presentation/Buy%20Appliance%20model/class/itemModel.dart';
import 'package:customer_app/presentation/Buy%20Appliance%20model/services/toastService.dart';
import 'package:flutter/cupertino.dart';

class CartProvider extends ChangeNotifier {
  final List<ItemsModel> _cartItem = [];

  UnmodifiableListView get cartItem => UnmodifiableListView(_cartItem);

  void addItem(ItemsModel itemsModel, BuildContext context) {
    _cartItem.add(itemsModel);
    ToastService.sendAlert(
      context: context,
      message: 'Item Added',
      toastStatus: 'SUCCESS',
    );

    notifyListeners();
  }

  void deleteItem(ItemsModel itemsModel, BuildContext context) {
    _cartItem.remove(itemsModel);
    ToastService.sendAlert(
        context: context, message: 'Item Remove', toastStatus: 'ERROR');

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

  //SEARCH ITEMS PART FUNCTIONS
}
