import 'package:flutter/material.dart';
import 'screens.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<DatabaseProvider>(
          create: (context) => DatabaseProvider(),
        ),
        ChangeNotifierProxyProvider<DatabaseProvider, UserProvider>(
          create: (_) =>
              UserProvider(Provider.of<DatabaseProvider>(_, listen: false)),
          update: (context, dbProvider, currentUserProvider) =>
              currentUserProvider ?? UserProvider(dbProvider),
        ),

        ChangeNotifierProxyProvider<DatabaseProvider, OrderProvider>(
          create: (context) =>
              OrderProvider(databaseProvider: context.read<DatabaseProvider>()),
          update: (context, db, previous) =>
              previous ?? OrderProvider(databaseProvider: db),
        ),

        // ... other providers
      ],
      child: MaterialApp(
        home: SignUpPage(),
        // Define the routes if you are using named routes
        routes: {
          '/login': (context) =>
              LoginPage(), // Replace with your LoginPage widget
          // ... other routes
        },
      ),
    );
  }
}





//  child: MaterialApp(
//         title: 'Flutter Demo',
       