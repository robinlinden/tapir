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

  final _addDrinkFormKey = GlobalKey<FormState>();
  final _nameInputController = TextEditingController();
  final _volumeInputController = TextEditingController();
  final _abvInputController = TextEditingController();

  void _onAddDrink() {
    setState(() {
      final name = _nameInputController.text;
      final volume = double.tryParse(_volumeInputController.text);
      final abv = double.tryParse(_abvInputController.text);
      if (volume == null || abv == null) {
        return;
      }

      _nameInputController.clear();
      _volumeInputController.clear();
      _abvInputController.clear();
      _drinks.add(Drink(name: name, volume: volume, abv: abv));
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
        onPressed: () => showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return Padding(
              padding: const EdgeInsets.all(8),
              child: Form(
                key: _addDrinkFormKey,
                child: Column(
                  children: [
                    Text(
                      'Add drink',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: TextFormField(
                        key: const Key('name'),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (name) =>
                            (name ?? '').isEmpty ? "Name can't be empty" : null,
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'Name',
                        ),
                        controller: _nameInputController,
                        textInputAction: TextInputAction.next,
                        autofocus: true,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: TextFormField(
                        key: const Key('volume'),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (volume) => (volume ?? '').isEmpty
                            ? "Volume can't be empty"
                            : null,
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'Volume',
                        ),
                        controller: _volumeInputController,
                        textInputAction: TextInputAction.next,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: TextFormField(
                        key: const Key('abv'),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (abv) =>
                            (abv ?? '').isEmpty ? "Abv can't be empty" : null,
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'ABV',
                        ),
                        controller: _abvInputController,
                        textInputAction: TextInputAction.done,
                        onEditingComplete: () {
                          _onAddDrink();
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    ElevatedButton(
                      child: const Text('Add'),
                      onPressed: () {
                        _onAddDrink();
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        tooltip: 'Drink!',
        child: const Icon(Icons.add),
      ),
    );
  }
}
