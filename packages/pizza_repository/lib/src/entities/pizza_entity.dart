import 'macros_entity.dart';
import '../models/models.dart';

class PizzaEntity {
  String pizzaId;
  String category;
  String picture;
  bool isVeg;
  int spiceLevel;
  String name;
  String description;
  int price;
  int discount;
  Macros macros;

  PizzaEntity({
    required this.pizzaId,
    required this.category,
    required this.picture,
    required this.isVeg,
    required this.spiceLevel,
    required this.name,
    required this.description,
    required this.price,
    required this.discount,
    required this.macros,
  });

  Map<String, Object?> toDocument() {
    return {
      'pizzaId': pizzaId,
      'category': category,
      'picture': picture,
      'isVeg': isVeg,
      'spiceLevel': spiceLevel,
      'name': name,
      'description': description,
      'price': price,
      'discount': discount,
      'macros': macros.toEntity().toDocument(),
    };
  }

  static PizzaEntity fromDocument(Map<String, dynamic> doc) {
    return PizzaEntity(
      pizzaId: doc['pizzaId'],
      category: doc['category'] as String? ?? 'pizza',
      picture: doc['picture'],
      isVeg: doc['isVeg'],
      spiceLevel: doc['spiceLevel'],
      name: doc['name'],
      description: doc['description'],
      price: doc['price'],
      discount: doc['discount'],
      macros: Macros.fromEntity(MacrosEntity.fromDocument(doc['macros'])),
    );
  }
}
