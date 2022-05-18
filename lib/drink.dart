import 'dart:math';

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
