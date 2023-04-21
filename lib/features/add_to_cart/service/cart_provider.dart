import 'package:flutter/cupertino.dart';
import 'package:flutter_shopping_cart/features/add_to_cart/model/Cart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../reposity/db_helper.dart';

//用此class 串接ＤＢ 分離ＵＩ
class CartProvider extends ChangeNotifier {
  static const CART_ITEM = 'cart_item';
  static const ITEM_QUANTITY = 'item_quantity';
  static const TOTAL_PRICE = 'total_price';

  DBHelper dbHelper = new DBHelper();
  int _counter = 0;
  int _quantity = 1;
  double _totalPrice = 0.0;
  List<Cart> list = [];

  int get counter => _counter;
  int get quantity => _quantity;
  double get totaPrice => _totalPrice;

  //將ＤＢ裏頭的cart.db 資料query出來。
  Future<List<Cart>> getData() async {
    list = await dbHelper.getCartList();
    notifyListeners();
    return list;
  }

  //將資料寫進sharePrefference
  void _setPreferenceItems() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setInt('cart_item', _counter);
    sharedPreferences.setInt('item_quantity', _quantity);
    sharedPreferences.setDouble('total_price', _totalPrice);
    notifyListeners();
  }

  //從sharePre取資料出來。
  void _getPreferenceItems() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    _counter = sharedPreferences.getInt(CART_ITEM) ?? 0;
    _quantity = sharedPreferences.getInt(ITEM_QUANTITY) ?? 0;
    _totalPrice = sharedPreferences.getDouble(TOTAL_PRICE) ?? 0.0;
    notifyListeners();
  }

  //當產品增加或減少的時候
  void addCounter() {
    _counter++;
    _setPreferenceItems();
    notifyListeners();
  }

  void removeCounter() {
    _counter--;
    _setPreferenceItems();
    notifyListeners();
  }

  //取得產品
  int getCounter() {
    _getPreferenceItems();
    return _counter;
  }

  //增加產品數量。
  void addQuantity(int id) {
    //找到產品在cart list中的index。
    //更新數量。
    final index = list.indexWhere((element) => element.id == id);
    list[index].quantity!.value = list[index].quantity!.value + 1;
    _setPreferenceItems();
    notifyListeners();
  }

  void deleteQuantity(int id) {
    final index = list.indexWhere((element) => element.id == id);
    final currentQuantity = list[index].quantity!.value;
    if (currentQuantity <= 1) {
      currentQuantity == 1;
    } else {
      list[index].quantity!.value = currentQuantity - 1;
    }
    _setPreferenceItems();
    notifyListeners();
  }

  void removeItem(int id) {
    final index = list.indexWhere((element) => element.id == id);
    list.removeAt(index);
    _setPreferenceItems();
    notifyListeners();
  }

  int getQuantity() {
    _getPreferenceItems();
    return _quantity;
  }

  void addTotalPrice(double productPrice) {
    _totalPrice = _totalPrice + productPrice;
    _setPreferenceItems();
    notifyListeners();
  }

  void removeTotalPrice(double productPrice) {
    _totalPrice = _totalPrice - productPrice;
    _setPreferenceItems();
    notifyListeners();
  }

  double getTotalPrice() {
    _setPreferenceItems();
    return _totalPrice;
  }
}
