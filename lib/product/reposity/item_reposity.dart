




import '../../features/product/model/item_model.dart';

class ItemReposity {
  static List<Item> getProduct(){
    List<Item> products = [
 Item(
     name: 'Apple', unit: 'Kg', price: 20, image: 'assets/images/apple.png'),
 Item(
     name: 'Mango',
     unit: 'Doz',
     price: 30,
     image: 'assets/images/mango.png'),
 Item(
     name: 'Banana',
     unit: 'Doz',
     price: 10,
     image: 'assets/images/banana.png'),
 Item(
     name: 'Grapes',
     unit: 'Kg',
     price: 8,
     image: 'assets/images/grapes.png'),
 Item(
     name: 'Water Melon',
     unit: 'Kg',
     price: 25,
     image: 'assets/images/watermelon.png'),
 Item(name: 'Kiwi', unit: 'Pc', price: 40, image: 'assets/images/kiwi.png'),
 Item(
     name: 'Orange',
     unit: 'Doz',
     price: 15,
     image: 'assets/images/orange.png'),
 Item(name: 'Peach', unit: 'Pc', price: 8, image: 'assets/images/peach.png'),
 Item(
     name: 'Strawberry',
     unit: 'Box',
     price: 12,
     image: 'assets/images/strawberry.png'),
 Item(
     name: 'Fruit Basket',
     unit: 'Kg',
     price: 55,
     image: 'assets/images/fruitBasket.png'),
];
    return products;
  }
  
}
