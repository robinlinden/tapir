import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  static const String title = 'Tapir';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: title),
    );
  }
}

class Drink {
  final String name;
  final double volume; // litres
  final double abv; // alcohol %, [0-1]

  Drink({
    required this.name,
    required this.volume,
    required this.abv,
  });

  factory Drink.random(int id) {
    var random = Random(id);
    return Drink(
      // 33 is ascii !, 126 (33+93) is ascii ~.
      name: String.fromCharCodes(List.generate(
          3 + random.nextInt(14), (_) => 33 + random.nextInt(94))),
      volume: random.nextDouble(),
      abv: random.nextDouble(),
    );
  }

  double get units => abv * volume * 1000 / 10;
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Drink> _drinks = [];

  void _addDrink() {
    setState(() {
      _drinks.add(Drink.random(_drinks.length));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.builder(
        itemCount: _drinks.length,
        itemBuilder: ((context, index) {
          final drink = _drinks[index];
          return Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Text(drink.name),
                const Spacer(),
                Text('${(drink.volume * 100).round()}cl, '
                    '${(drink.abv * 100).round()}% '
                    '(${drink.units.toStringAsFixed(1)} units)'),
              ],
            ),
          );
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addDrink,
        tooltip: 'Drink!',
        child: const Icon(Icons.add),
      ),
    );
  }
}
