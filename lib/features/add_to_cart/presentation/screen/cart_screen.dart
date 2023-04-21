import 'package:badges/badges.dart';
import 'package:flutter/material.dart' hide Badge;
import 'package:flutter_shopping_cart/features/add_to_cart/service/cart_provider.dart';
import 'package:provider/provider.dart';

import '../../model/Cart.dart';
import '../../reposity/db_helper.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  DBHelper? dbHelper = DBHelper();
  List<bool> tapped = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<CartProvider>().getData();
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Shopping Cart'),
        actions: [
          Badge(
            badgeContent: Consumer<CartProvider>(
              builder: (context, value, child) {
                return Text(
                  value.getCounter().toString(),
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                );
              },
            ),
            position: const BadgePosition(start: 30, bottom: 30),
          ),
          const SizedBox(
            width: 20.0,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(child: Consumer<CartProvider>(
            builder: (context, provider, child) {
              if (provider.list.isEmpty) {
                return const Center(
                  child: Text(
                    'Your Cart is Empty',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                  ),
                );
              } else {
                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: provider.list.length,
                    itemBuilder: (context, index) {
                      return Card(
                        color: Colors.blueGrey.shade200,
                        elevation: 5.0,
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Image(
                                  width: 80,
                                  height: 80,
                                  image:
                                      AssetImage(provider.list[index].image!)),
                              SizedBox(
                                width: 130,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 5.0,
                                    ),
                                    RichText(
                                      overflow: TextOverflow.ellipsis,
                                      text: TextSpan(
                                          text: 'Name : ',
                                          style: TextStyle(
                                              color: Colors.blueGrey.shade800,
                                              fontSize: 16.0),
                                          children: [
                                            TextSpan(
                                                text:
                                                    '${provider.list[index].productName!}\n',
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ]),
                                    ),
                                    RichText(
                                      maxLines: 1,
                                      text: TextSpan(
                                          text: 'Unit: ',
                                          style: TextStyle(
                                              color: Colors.blueGrey.shade800,
                                              fontSize: 16.0),
                                          children: [
                                            TextSpan(
                                                text:
                                                    '${provider.list[index].unitTag!}\n',
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold))
                                          ]),
                                    ),
                                    RichText(
                                      maxLines: 1,
                                      text: TextSpan(
                                          text: 'Price: ' r"$",
                                          style: TextStyle(
                                              color: Colors.blueGrey.shade800,
                                              fontSize: 16.0),
                                          children: [
                                            TextSpan(
                                                text:
                                                    '${provider.list[index].productPrice!}\n',
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ]),
                                    ),
                                    ValueListenableBuilder<int>(
                                      valueListenable:
                                          provider.list[index].quantity!,
                                      builder: (context, val, child) {
                                        return PlusMinusButtons(
                                          addQuantity: () {
                                            cart.addQuantity(
                                                provider.list[index].id!);
                                            dbHelper!
                                                .updateQuantity(Cart(
                                                    id: index,
                                                    productId: index.toString(),
                                                    productName: provider
                                                        .list[index]
                                                        .productName,
                                                    initialPrice: provider
                                                        .list[index]
                                                        .initialPrice,
                                                    productPrice: provider
                                                        .list[index]
                                                        .productPrice,
                                                    quantity: ValueNotifier(
                                                        provider.list[index]
                                                            .quantity!.value),
                                                    unitTag: provider
                                                        .list[index].unitTag,
                                                    image: provider
                                                        .list[index].image))
                                                .then((value) {
                                              setState(() {
                                                cart.addTotalPrice(double.parse(
                                                    provider.list[index]
                                                        .productPrice
                                                        .toString()));
                                              });
                                            });
                                          },
                                          text: val.toString(),
                                          deleteQuantity: () {
                                            cart.deleteQuantity(
                                                provider.list[index].id!);
                                            cart.removeTotalPrice(double.parse(
                                                provider
                                                    .list[index].productPrice
                                                    .toString()));
                                          },
                                        );
                                      },
                                    )
                                  ],
                                ),
                              ),
                              IconButton(
                                  onPressed: () {
                                    dbHelper!.deleteCartItem(
                                        provider.list[index].id!);
                                    provider
                                        .removeItem(provider.list[index].id!);
                                    provider.removeCounter();
                                  },
                                  icon: const Icon(Icons.delete),
                                  color: Colors.red.shade800)
                            ],
                          ),
                        ),
                      );
                    });
              }
            },
          )),
          Consumer<CartProvider>(
            builder: (context, provider, child) {
              final ValueNotifier<int?> totalPrice = ValueNotifier(null);
              for (var element in provider.list) {
                totalPrice.value =
                    (element.productPrice! * element.quantity!.value) +
                        (totalPrice.value ?? 0);
              }
              return Column(
                children: [
                  ValueListenableBuilder<int?>(
                      valueListenable: totalPrice,
                      builder: (context, value, child) {
                        return ReusableWidget(
                            title: 'Sub-Total',
                            value: r'$' + (value?.toStringAsFixed(2) ?? '0'));
                      })
                ],
              );
            },
          )
        ],
      ),
      bottomNavigationBar: InkWell(
        child: Container(
          color: Colors.yellow.shade600,
          alignment: Alignment.center,
          height: 50,
          child: const Text(
            'Proceed to Pay',
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
        ),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Payment Successful'),
            duration: Duration(seconds: 2),
          ));
        },
      ),
    );
  }
}

class PlusMinusButtons extends StatelessWidget {
  final VoidCallback deleteQuantity;
  final VoidCallback addQuantity;
  final String text;

  const PlusMinusButtons(
      {Key? key,
      required this.deleteQuantity,
      required this.addQuantity,
      required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(onPressed: deleteQuantity, icon: const Icon(Icons.remove)),
        Text(text),
        IconButton(onPressed: addQuantity, icon: const Icon(Icons.add)),
      ],
    );
  }
}

class ReusableWidget extends StatelessWidget {
  final String title, value;
  const ReusableWidget({Key? key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.subtitle1,
          ),
          Text(
            value.toString(),
            style: Theme.of(context).textTheme.subtitle2,
          ),
        ],
      ),
    );
  }
}
