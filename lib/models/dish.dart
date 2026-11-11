class Dish {
  Dish({
    required this.name,
    required this.restaurant,
    required this.category,
    required this.price,
    required this.rating,
    required this.votes,
    required this.imageUrl,
    required this.description,
    this.area = 'Islamabad',
    this.branchArea = 'F-7 Markaz',
  });

  final String name;
  final String restaurant;
  final String category;
  final int price;
  double rating;
  int votes;
  final String imageUrl;
  final String description;
  final String area;
  final String branchArea;
}

final sampleDishes = <Dish>[
  Dish(
    name: 'Smash Beef Burger',
    restaurant: 'Howdy',
    category: 'Burgers',
    price: 1290,
    rating: 4.9,
    votes: 284,
    imageUrl: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?auto=format&fit=crop&w=1000&q=85',
    description: 'A juicy double smash patty layered with melted cheddar, crisp lettuce and our signature house sauce.',
    branchArea: 'F-7 Markaz',
  ),
  Dish(
    name: 'Chicken Karahi',
    restaurant: 'Tandoori',
    category: 'Desi',
    price: 1890,
    rating: 4.8,
    votes: 218,
    imageUrl: 'https://images.unsplash.com/photo-1603894584373-5ac82b2ae398?auto=format&fit=crop&w=1000&q=85',
    description: 'Traditional karahi, cooked fresh with tomatoes, green chillies, ginger and fragrant spices.',
    branchArea: 'F-6 Super Market',
  ),
  Dish(
    name: 'Truffle Alfredo Pasta',
    restaurant: 'Café Aylanto',
    category: 'Pasta',
    price: 2250,
    rating: 4.8,
    votes: 176,
    imageUrl: 'https://images.unsplash.com/photo-1473093295043-cdd812d0e601?auto=format&fit=crop&w=1000&q=85',
    description: 'Silky parmesan cream sauce, perfectly cooked pasta and a delicate drizzle of truffle oil.',
    branchArea: 'F-6 Kohsar Market',
  ),
  Dish(
    name: 'Chicken Shawarma Wrap',
    restaurant: 'Shawarma Station',
    category: 'Shawarma',
    price: 790,
    rating: 4.5,
    votes: 88,
    imageUrl: 'https://images.unsplash.com/photo-1529006557810-274b9b2fc783?auto=format&fit=crop&w=1000&q=85',
    description: 'A generously filled wrap with grilled chicken, pickled vegetables and creamy garlic sauce.',
    branchArea: 'G-9 Markaz',
  ),
  Dish(
    name: 'Molten Chocolate Cake',
    restaurant: 'Burning Brownie',
    category: 'Desserts',
    price: 890,
    rating: 4.7,
    votes: 153,
    imageUrl: 'https://images.unsplash.com/photo-1606313564200-e75d5e30476c?auto=format&fit=crop&w=1000&q=85',
    description: 'Warm chocolate cake with a gooey centre, served with a scoop of vanilla bean ice cream.',
    branchArea: 'F-7 Markaz',
  ),
  Dish(
    name: 'Smoky BBQ Pizza',
    restaurant: '14th Street Pizza',
    category: 'Pizza',
    price: 1990,
    rating: 4.6,
    votes: 141,
    imageUrl: 'https://images.unsplash.com/photo-1579751626657-72bc17010498?auto=format&fit=crop&w=1000&q=85',
    description: 'A hand-stretched crust topped with smoky barbecue chicken, red onion and mozzarella.',
    branchArea: 'F-11 Markaz',
  ),
  Dish(
    name: 'Chicken Chow Mein',
    restaurant: 'Kim Mun',
    category: 'Chinese',
    price: 1490,
    rating: 4.6,
    votes: 127,
    imageUrl: 'https://images.unsplash.com/photo-1585032226651-759b368d7246?auto=format&fit=crop&w=1000&q=85',
    description: 'Wok-tossed noodles with tender chicken, seasonal vegetables and a savoury soy dressing.',
    branchArea: 'Blue Area',
  ),
  Dish(
    name: 'Classic Beef Steak',
    restaurant: 'Texas Steak House',
    category: 'BBQ',
    price: 3290,
    rating: 4.5,
    votes: 103,
    imageUrl: 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=1000&q=85',
    description: 'A flame-grilled cut, cooked to order and served with pepper sauce and golden fries.',
    branchArea: 'F-6 Super Market',
  ),
  Dish(
    name: 'Mango Cheesecake',
    restaurant: 'Loafology',
    category: 'Desserts',
    price: 750,
    rating: 4.5,
    votes: 96,
    imageUrl: 'https://images.unsplash.com/photo-1533134242443-d4fd215305ad?auto=format&fit=crop&w=1000&q=85',
    description: 'Creamy baked cheesecake finished with a bright, seasonal mango topping.',
    branchArea: 'F-6 Kohsar Market',
  ),
];

const foodCategories = <String>[
  'Burgers',
  'Desi',
  'Pasta',
  'Shawarma',
  'Desserts',
  'Pizza',
  'Chinese',
  'BBQ',
];
