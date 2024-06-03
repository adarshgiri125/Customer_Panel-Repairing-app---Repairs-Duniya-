import 'package:customer_app/presentation/Buy%20Appliance%20model/provider/cartProvider.dart';
import 'package:customer_app/presentation/Buy%20Appliance/screens/addressScreen.dart';
import 'package:customer_app/presentation/Buy%20Appliance/widgets/containers/containerButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping Cart'),
        actions: [
          IconButton(
              onPressed: () {}, icon: const Icon(Icons.line_weight_rounded)),
        ],
      ),
      body: Consumer<CartProvider>(
        builder: (context, value, child) => Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: value.cartItem.length,
                itemBuilder: (context, index) {
                  final item = value.cartItem[index];
                  final quantityController =
                      TextEditingController(text: item.quantity.toString());

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Image.asset(
                          item.productImagePath,
                          height: 80,
                          width: 80,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.productName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                width: 150,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                  color: Colors.black,
                                )),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        value.decreaseQuantity(item);
                                      },
                                      icon: const Icon(Icons.remove),
                                    ),
                                    SizedBox(
                                      width: 50,
                                      child: TextFormField(
                                        controller: quantityController,
                                        textAlign: TextAlign.center,
                                        decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          contentPadding:
                                              EdgeInsets.symmetric(vertical: 5),
                                        ),
                                        readOnly: true,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        value.increaseQuantity(item);
                                      },
                                      icon: const Icon(Icons.add),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'INR ${(item.productPrice * item.quantity).toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    shape: const LinearBorder(),
                                    content: const Text(
                                        'Eep! Are you sure you want to delete this item from your cart?'),
                                    actions: [
                                      ElevatedButton(
                                          // style: const ButtonStyle(
                                          //   shape: WidgetStatePropertyAll(
                                          //       LinearBorder()),
                                          // ),
                                          onPressed: () {
                                            value.deleteItem(item, context);
                                            Navigator.pop(context);
                                          },
                                          child: const Text(
                                            'DELETE',
                                            style: TextStyle(
                                              color: Colors.black,
                                            ),
                                          )),
                                      ElevatedButton(
                                          // style: const ButtonStyle(
                                          //   backgroundColor:
                                          //       WidgetStatePropertyAll(
                                          //     Colors.black,
                                          //   ),
                                          //   shape: WidgetStatePropertyAll(
                                          //       LinearBorder()),
                                          // ),
                                          onPressed: () {},
                                          child: const Text(
                                            'CANCEL',
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          )),
                                    ],
                                  ),
                                );
                              },
                              icon: const Icon(
                                CupertinoIcons.delete,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'ITEMS: ${value.totalItems}',
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'INR ${value.productTotalPrice.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ContainerButton(
                      color: Colors.black,
                      text: "CHECK OUT",
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AddressScreen(),
                            ));
                      },
                      textColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
