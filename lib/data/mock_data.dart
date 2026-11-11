class FoodDish {
  FoodDish({
    required this.id,
    required this.dishName,
    required this.restaurantName,
    required this.category,
    required this.price,
    required this.rating,
    required this.rank,
    required this.imageUrl,
    required this.branchArea,
    required this.googleMapsUrl,
    required this.directDishUrl,
    required this.officialWebsite,
    required this.description,
    this.ratingCount = 100,
  });

  final String id;
  final String dishName;
  final String restaurantName;
  final String category;
  final int price;
  double rating;
  final int rank;
  final String imageUrl;
  final String branchArea;
  final String googleMapsUrl;
  final String directDishUrl;
  final String officialWebsite;
  final String description;
  int ratingCount;
}

FoodDish _dish({
  required String id,
  required String dishName,
  required String restaurantName,
  required String category,
  required int price,
  required double rating,
  required int rank,
  required String imageUrl,
  required String branchArea,
  required String officialWebsite,
  required String description,
  String? directDishUrl,
}) {
  final location = Uri.encodeComponent('$restaurantName $branchArea Islamabad');
  final dishQuery = Uri.encodeQueryComponent(
    '$restaurantName Islamabad $dishName',
  );
  return FoodDish(
    id: id,
    dishName: dishName,
    restaurantName: restaurantName,
    category: category,
    price: price,
    rating: rating,
    rank: rank,
    imageUrl: imageUrl,
    branchArea: branchArea,
    googleMapsUrl: 'https://maps.google.com/?q=$location',
    directDishUrl:
        directDishUrl ?? 'https://www.google.com/search?q=$dishQuery',
    officialWebsite: officialWebsite,
    description: description,
  );
}

const foodDishCategories = [
  'Pizza',
  'Burgers',
  'Pasta',
  'Shawarma',
  'BBQ',
  'Desserts',
];

final mockDishes = <FoodDish>[
  _dish(
    id: 'burger-001',
    dishName: 'Double Smash Burger',
    restaurantName: 'Howdy',
    category: 'Burgers',
    price: 1250,
    rating: 4.9,
    rank: 3,
    imageUrl: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?auto=format&fit=crop&w=1000&q=85',
    branchArea: 'F-7 Markaz',
    officialWebsite: 'https://howdy.pk',
    description: 'A juicy double smash patty layered with melted cheddar, crisp lettuce and signature house sauce.',
  ),
  _dish(
    id: 'pizza-001',
    dishName: 'Cheezious Crown Crust Pizza',
    restaurantName: 'Cheezious',
    category: 'Pizza',
    price: 1890,
    rating: 4.9,
    rank: 1,
    imageUrl: 'https://images.unsplash.com/photo-1579751626657-72bc17010498?auto=format&fit=crop&w=1000&q=85',
    branchArea: 'F-7 Markaz',
    officialWebsite: 'https://www.cheezious.com',
    description:
        'A generously topped, cheesy crown-crust pizza made for sharing.',
  ),
  _dish(
    id: 'pasta-001',
    dishName: 'Creamy Alfredo Pasta',
    restaurantName: 'Loafology',
    category: 'Pasta',
    price: 1590,
    rating: 4.8,
    rank: 4,
    imageUrl: 'https://images.unsplash.com/photo-1473093295043-cdd812d0e601?auto=format&fit=crop&w=1000&q=85',
    branchArea: 'Blue Area',
    officialWebsite: 'https://loafology.com',
    description: 'Tender pasta tossed with silky parmesan cream sauce and freshly cracked pepper.',
  ),
  _dish(
    id: 'shawarma-001',
    dishName: 'Chicken Saj Shawarma',
    restaurantName: 'Wrap Lab',
    category: 'Shawarma',
    price: 790,
    rating: 4.8,
    rank: 5,
    imageUrl: 'https://images.unsplash.com/photo-1529006557810-274b9b2fc783?auto=format&fit=crop&w=1000&q=85',
    branchArea: 'I-8 Markaz',
    officialWebsite: 'https://wraplab.pk',
    description: 'Grilled chicken, pickled vegetables and creamy garlic sauce wrapped in saj bread.',
  ),
  _dish(
    id: 'bbq-001',
    dishName: 'Kababjees Malai Boti',
    restaurantName: 'Kababjees',
    category: 'BBQ',
    price: 1690,
    rating: 4.8,
    rank: 2,
    imageUrl: 'https://images.unsplash.com/photo-1544025162-d76694265947?auto=format&fit=crop&w=1000&q=85',
    branchArea: 'F-8 Markaz',
    officialWebsite: 'https://kababjees.com',
    description: 'Chargrilled chicken morsels marinated in cream, yoghurt and warming spices.',
  ),
  _dish(
    id: 'dessert-001',
    dishName: 'Lotus Biscoff Sundae',
    restaurantName: 'Sweet Creme',
    category: 'Desserts',
    price: 690,
    rating: 4.7,
    rank: 6,
    imageUrl: 'https://images.unsplash.com/photo-1563805042-7684c019e1cb?auto=format&fit=crop&w=1000&q=85',
    branchArea: 'F-7 Markaz',
    officialWebsite: 'https://sweetcreme.pk',
    description: 'Creamy vanilla ice cream layered with Biscoff crumbs and cookie-butter drizzle.',
  ),
  _dish(
    id: 'burger-002',
    dishName: 'Zinger Burger',
    restaurantName: 'KFC',
    category: 'Burgers',
    price: 650,
    rating: 4.7,
    rank: 7,
    imageUrl: 'https://images.unsplash.com/photo-1606755962773-d324e0a13086?auto=format&fit=crop&w=1000&q=85',
    branchArea: 'F-8 Markaz',
    officialWebsite: 'https://kfcpakistan.com',
    description: 'A crunchy seasoned chicken fillet in a soft bun with fresh lettuce and mayo.',
  ),
  _dish(
    id: 'dessert-003',
    dishName: 'Blueberry Cream Cheese Donut',
    restaurantName: 'Crusteez Donuts',
    category: 'Desserts',
    price: 450,
    rating: 4.7,
    rank: 8,
    imageUrl: 'https://images.unsplash.com/photo-1563805042-7684c019e1cb?auto=format&fit=crop&w=1000&q=85',
    branchArea: 'Blue Area',
    officialWebsite: 'https://order.crusteez.pk',
    directDishUrl: 'https://www.google.com/search?q=Crusteez+Donuts+Islamabad+Blueberry+Cream+Cheese',
    description: 'A soft donut filled with smooth cream cheese and finished with sweet blueberry topping.',
  ),
  _dish(
    id: 'pizza-002',
    dishName: 'Chicken Tikka Pizza',
    restaurantName: 'Cheezious',
    category: 'Pizza',
    price: 1690,
    rating: 4.7,
    rank: 9,
    imageUrl: 'https://images.unsplash.com/photo-1513104890138-7c749659a591?auto=format&fit=crop&w=1000&q=85',
    branchArea: 'F-7 Markaz',
    officialWebsite: 'https://www.cheezious.com',
    description: 'A spicy chicken tikka pizza with melted cheese, peppers and a smoky, tangy sauce.',
  ),
  _dish(
    id: 'shawarma-002',
    dishName: 'Beef Shawarma Wrap',
    restaurantName: 'Wrap Lab',
    category: 'Shawarma',
    price: 890,
    rating: 4.6,
    rank: 10,
    imageUrl: 'https://images.unsplash.com/photo-1529006557810-274b9b2fc783?auto=format&fit=crop&w=1000&q=85',
    branchArea: 'I-8 Markaz',
    officialWebsite: 'https://wraplab.pk',
    description: 'Seasoned beef, crunchy pickles and tahini wrapped in freshly toasted flatbread.',
  ),
  _dish(
    id: 'bbq-002',
    dishName: 'Smoky BBQ Ribs',
    restaurantName: 'Howdy',
    category: 'BBQ',
    price: 2690,
    rating: 4.5,
    rank: 11,
    imageUrl: 'https://images.unsplash.com/photo-1544025162-d76694265947?auto=format&fit=crop&w=1000&q=85',
    branchArea: 'F-7 Markaz',
    officialWebsite: 'https://howdy.pk',
    description: 'Slow-cooked ribs glazed with smoky barbecue sauce and chargrilled to finish.',
  ),
  _dish(
    id: 'dessert-002',
    dishName: 'Molten Chocolate Cake',
    restaurantName: 'Sweet Creme',
    category: 'Desserts',
    price: 750,
    rating: 4.5,
    rank: 12,
    imageUrl: 'https://images.unsplash.com/photo-1606313564200-e75d5e30476c?auto=format&fit=crop&w=1000&q=85',
    branchArea: 'I-8 Markaz',
    officialWebsite: 'https://sweetcreme.pk',
    description: 'Warm chocolate cake with a rich molten centre, served with vanilla ice cream.',
  ),
];

FoodDish? get topRankedDish {
  for (final dish in mockDishes) {
    if (dish.rank == 1) return dish;
  }
  return null;
}
