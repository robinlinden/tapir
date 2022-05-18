import 'package:flutter/material.dart';

import 'drink.dart';

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
