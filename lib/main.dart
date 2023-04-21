import 'package:flutter/material.dart';
import 'package:flutter_shopping_cart/features/add_to_cart/service/cart_provider.dart';
import 'package:provider/provider.dart';

import 'features/product/presentation/screen/product_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CartProvider(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const ProductList(),
      ),
    );
  }
}
