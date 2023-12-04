import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'screens.dart';

class OrderProvider with ChangeNotifier {
  late final DatabaseProvider databaseProvider;

  OrderProvider({required this.databaseProvider});

  Future<void> addOrder(int userId, int productId) async {
    final db = await databaseProvider.database;
    await db.insert(
      'orders',
      {
        'uid': userId,
        'pid': productId,
        'created_at': DateTime.now().toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    notifyListeners();
  }
}

class HomePage extends StatelessWidget {
  final String userName;

  const HomePage({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    // Show welcome dialog
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Welcome'),
            content: Text('Welcome $userName'),
            actions: <Widget>[
              TextButton(
                child: const Text('Close'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          );
        },
      );
    });

    final List<Map<String, dynamic>> products = [
      {
        'id': 1,
        'name': 'Tropical Bouquet',
        'price': 29.99,
        'image': 'https://images.unsplash.com/photo-1572454591674-2739f30d8c40',
        'description':
            'A beautiful arrangement of tropical flowers to brighten any room.'
      },
      {
        'id': 2,
        'name': 'Rose Delight',
        'price': 19.99,
        'image': 'https://images.unsplash.com/photo-1567696153798-9111f9cd3d0d',
        'description':
            'Classic red roses with delicate foliage for your loved one.'
      },
      {
        'id': 3,
        'name': 'Spring Medley',
        'price': 24.99,
        'image': 'https://images.unsplash.com/photo-1563241527-3004b7be0ffd',
        'description':
            'A colorful mix of seasonal flowers to represent the spring spirit.'
      },
      {
        'id': 4,
        'name': 'Orchid Obsession',
        'price': 34.99,
        'image': 'https://images.unsplash.com/photo-1567418938902-aa650a3eb346',
        'description':
            'Elegant orchids perfect for an office or home environment.'
      },
      {
        'id': 5,
        'name': 'Sunflower Sunshine',
        'price': 15.99,
        'image': 'https://images.unsplash.com/photo-1596438459194-f275f413d6ff',
        'description':
            'Bright sunflowers to bring joy and sunshine into your space.'
      },
      {
        'id': 6,
        'name': 'Lavender Bliss',
        'price': 18.99,
        'image':
            'https://images.unsplash.com/photo-1603178455924-ef33372953bb?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTZ8fGZsb3dlciUyMGJvdXF1ZXR8ZW58MHx8MHx8fDA%3D',
        'description':
            'Soothing lavender bunch to calm and add a fragrance to any room.'
      },
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Consumer<OrderProvider>(
        builder: (context, orderProvider, child) {
          // Here you can safely use orderProvider to interact with the orders data
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.6,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return Card(
                clipBehavior: Clip.antiAlias, // Add this line
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    AspectRatio(
                      aspectRatio: 1, // This gives a square shape to your image
                      child: Image.network(
                        product['image'],
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product['name'],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text('\$${product['price'].toStringAsFixed(2)}',
                              style: const TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ),
                    const Spacer(), // Use a Spacer to push the button to the end of the card
                    ButtonBar(
                      alignment: MainAxisAlignment.start,
                      children: [
                        TextButton(
                          onPressed: () async {
                            final userProvider = Provider.of<UserProvider>(
                                context,
                                listen: false);
                            final orderProvider = Provider.of<OrderProvider>(
                                context,
                                listen: false);

                            // Check if the user is logged in
                            if (userProvider.userId == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'You need to be logged in to make a purchase.'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }

                            // Add the order to the database
                            try {
                              await orderProvider.addOrder(
                                  userProvider.userId!, product['id']);
                              // ignore: use_build_context_synchronously
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      '${product['name']} purchased successfully!'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'Failed to purchase ${product['name']}. Error: $e'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          },
                          child: const Text('Buy Now'),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
