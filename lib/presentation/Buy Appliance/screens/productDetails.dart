// ignore_for_file: file_names

import 'package:awesome_icons/awesome_icons.dart';
import 'package:customer_app/presentation/Buy%20Appliance%20model/class/itemModel.dart';
import 'package:customer_app/presentation/Buy%20Appliance%20model/provider/cartProvider.dart';
import 'package:customer_app/presentation/Buy%20Appliance%20model/services/toastService.dart';
import 'package:customer_app/presentation/Buy%20Appliance/screens/cart.dart';
import 'package:customer_app/presentation/Buy%20Appliance/widgets/containers/containerButton.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductDetailScreen extends StatelessWidget {
  final String productId;
  final String productName;
  final double productPrice;
  final String productImagePath;

  const ProductDetailScreen({
    super.key,
    required this.productId,
    required this.productName,
    required this.productPrice,
    required this.productImagePath,
  });

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CartProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Screen'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          Consumer<CartProvider>(
            builder: (context, value, child) => IconButton(
              onPressed: () {
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
          IconButton(
              onPressed: () {}, icon: const Icon(Icons.line_weight_rounded)),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(10),
              children: [
                Image.asset(productImagePath, fit: BoxFit.cover),
                const SizedBox(height: 16),
                Text(
                  productName,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'INR ${productPrice.toString()}',
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Per 1 Piece',
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                const Row(
                  children: [
                    Icon(
                      FontAwesomeIcons.truckMoving,
                      color: Colors.green,
                      size: 18,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      'Estimated Delivery Time: 1 - 2 hours',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.green,
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                if (productId == '0')
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Available Options',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          OptionBox(text: '6 liters', available: true),
                          OptionBox(text: '10 liters', available: false),
                          OptionBox(text: '25 liters', available: false),
                        ],
                      ),
                      SizedBox(height: 30),
                    ],
                  ),
                Row(
                  children: [
                    Expanded(
                        child: ContainerButton(
                      onTap: () => provider.addItem(
                        ItemsModel(
                            productId: productId,
                            productPrice: productPrice,
                            productImagePath: productImagePath,
                            productName: productName),
                        context,
                      ),
                      color: Colors.transparent,
                      text: "Add Cart",
                      textColor: Colors.black,
                      fontWeight: FontWeight.bold,
                    )),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                        child: ContainerButton(
                      onTap: () {
                        buyNow(provider, context);
                      },
                      color: Colors.black,
                      text: "Buy Now",
                      textColor: Colors.white,
                      fontWeight: FontWeight.bold,
                    )),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                Column(
                  children: [
                    const Text(
                      'Store Information',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: 250,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 25,
                        horizontal: 25,
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Icon(
                                CupertinoIcons.car_detailed,
                                color: Colors.red,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text('Fast Shipping'),
                            ],
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Column(
                            children: [
                              Icon(
                                CupertinoIcons.creditcard,
                                color: Colors.red,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text('Payments'),
                            ],
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Column(
                            children: [
                              Icon(
                                CupertinoIcons.location_fill,
                                color: Colors.red,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text('Order Tracking'),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          Consumer<CartProvider>(builder: (context, value, child) {
            if (value.totalItems >= 1) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Items: ${value.totalItems}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'INR ${value.productTotalPrice.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ContainerButton(
                      color: Colors.black,
                      text: "View Cart",
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CartScreen(),
                            ));
                      },
                      textColor: Colors.white,
                    ),
                  ),
                ],
              );
            } else {
              return Container();
            }
          }),
        ],
      ),
    );
  }

  //Buy Now Function

  Future<void> buyNow(CartProvider provider, BuildContext context) async {
    provider.addItem(
      ItemsModel(
          productId: productId,
          productPrice: productPrice,
          productImagePath: productImagePath,
          productName: productName),
      context,
    );
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const CartScreen(),
        ));
    await ToastService.sendAlert(
      context: context,
      message: "Added to Cart",
      toastStatus: "SUCCESS",
    );
  }
}

class OptionBox extends StatelessWidget {
  final String text;
  final bool available;

  const OptionBox({super.key, required this.text, this.available = true});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: available ? Colors.black : Colors.transparent,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: available ? Colors.white : Colors.black38,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
