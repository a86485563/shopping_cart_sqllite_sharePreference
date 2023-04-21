import 'package:badges/badges.dart';
import 'package:flutter/material.dart' hide Badge;
import 'package:flutter_shopping_cart/features/add_to_cart/service/cart_provider.dart';
import 'package:flutter_shopping_cart/features/product/reposity/item_reposity.dart';
import 'package:provider/provider.dart';

import '../../../add_to_cart/model/Cart.dart';
import '../../../add_to_cart/presentation/screen/cart_screen.dart';
import '../../../add_to_cart/reposity/db_helper.dart';
import '../../model/item_model.dart';

class ProductList extends StatefulWidget {
  const ProductList({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  List<Item> products = ItemReposity.getProduct();
  DBHelper dbHelper = DBHelper();

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    void insert(int index) {
      dbHelper
          .insert(Cart(
        id: index,
        productId: index.toString(),
        productName: products[index].name,
        initialPrice: products[index].price,
        productPrice: products[index].price,
        quantity: ValueNotifier(1),
        unitTag: products[index].unit,
        image: products[index].image,
      ))
          .then((value) {
        cart.addTotalPrice(products[index].price.toDouble());
        cart.addCounter();
        print('product added');
      }).onError((error, stackTrace) {
        print(error.toString());
      });
    }

    void addQuantity(int index) {
      cart.addQuantity(index);
      dbHelper
          .updateQuantity(Cart(
              id: index,
              productId: index.toString(),
              productName: cart.list[index].productName,
              initialPrice: cart.list[index].initialPrice,
              productPrice: cart.list[index].productPrice,
              quantity: ValueNotifier(cart.list[index].quantity!.value),
              unitTag: cart.list[index].unitTag,
              image: cart.list[index].image))
          .then((value) {
        setState(() {
          cart.addTotalPrice(
              double.parse(cart.list[index].productPrice.toString()));
        });
      });
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Product List'),
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
            child: IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CartScreen()));
              },
            ),
          )
        ],
      ),
      body: ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
          shrinkWrap: true,
          itemCount: products.length,
          itemBuilder: ((context, index) {
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
                      height: 80,
                      width: 80,
                      image: AssetImage(products[index].image.toString()),
                    ),
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
                                maxLines: 1,
                                text: TextSpan(
                                    text: 'Name: ',
                                    style: TextStyle(
                                        color: Colors.blueGrey.shade800,
                                        fontSize: 16.0),
                                    children: [
                                      TextSpan(
                                          text:
                                              '${products[index].name.toString()}\n',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold)),
                                    ])),
                            RichText(
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                text: TextSpan(
                                    text: 'Unit: ',
                                    style: TextStyle(
                                        color: Colors.blueGrey.shade800,
                                        fontSize: 16.0),
                                    children: [
                                      TextSpan(
                                          text:
                                              '${products[index].unit.toString()}\n',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold)),
                                    ])),
                            RichText(
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                text: TextSpan(
                                    text: 'price: ',
                                    style: TextStyle(
                                        color: Colors.blueGrey.shade800,
                                        fontSize: 16.0),
                                    children: [
                                      TextSpan(
                                          text:
                                              '${products[index].price.toString()}\n',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold)),
                                    ])),
                          ]),
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.blueGrey.shade900),
                        onPressed: () {
                          dbHelper.getCartById(index).then((value) => {
                                (value.isEmpty)
                                    ? insert(index)
                                    : addQuantity(index)
                              });
                        },
                        child: const Text('Add to Cart'))
                  ],
                ),
              ),
            );
          })),
    );
  }
}
