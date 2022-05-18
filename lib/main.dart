import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});
  static const String title = 'Tapir';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(title: title),
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

class DrinkListItem extends StatelessWidget {
  const DrinkListItem({super.key, required this.drink});

  final Drink drink;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(drink.name),
        subtitle: Text('${(drink.volume * 100).round()}cl, '
            '${(drink.abv * 100).round()}% '
            '(${drink.units.toStringAsFixed(1)} units)'),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

String? Function(String?) doubleValidator(String validates) {
  return (String? value) {
    value = value ?? '';
    if (value.isEmpty) {
      return "$validates can't be empty";
    }

    if (double.tryParse(value) == null) {
      return '$validates must be a number';
    }

    return null;
  };
}

class _HomePageState extends State<HomePage> {
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
          return DrinkListItem(drink: drink);
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
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: doubleValidator('Volume'),
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
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: doubleValidator('Abv'),
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
