// ignore_for_file: file_names


import 'package:customer_app/presentation/Buy%20Appliance%20model/provider/cartProvider.dart';
import 'package:customer_app/presentation/Buy%20Appliance/screens/cart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UniversalAppBar extends StatelessWidget implements PreferredSizeWidget {
  const UniversalAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Universal AppBar'),
      actions: [
        IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
        Consumer<CartProvider>(
          builder: (context, value, child) => IconButton(
            onPressed: () {
              // Navigate to cart screen (assumes you have a CartScreen defined)
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CartScreen(),
                  ));
            },
            icon: Badge(
              label: Text(value.totalItems.toString()),
              child: const Icon(Icons.shopping_basket_outlined),
            ),
          ),
        ),
        IconButton(onPressed: () {}, icon: const Icon(Icons.person_4_outlined)),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
