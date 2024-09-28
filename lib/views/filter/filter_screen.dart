import 'package:flutter/material.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  // List of category buttons with selection state
  final List<String> categories = ['Car', 'Gym', 'Cooking', 'Luggage'];

  List<bool> selectedCategories = List.generate(12, (_) => false);
  double selectedPriceRange = 20;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: Container(
          margin: const EdgeInsets.only(left: 16, right: 16),
          height: MediaQuery.of(context).size.height * 0.35,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(
                        Icons.close_rounded,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Categories',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    TextButton(
                      onPressed: _clearSelections,
                      child: const Text('Clear All', style: TextStyle(color: Colors.grey)),
                    ),
                  ],
                ),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: List.generate(categories.length, (index) {
                    return ChoiceChip(
                      label: Text(categories[index]),
                      selected: selectedCategories[index],
                      onSelected: (bool selected) {
                        setState(() {
                          selectedCategories[index] = selected;
                        });
                      },
                      selectedColor: Colors.green,
                      backgroundColor: Colors.grey.shade300,
                      labelStyle: TextStyle(
                        color: selectedCategories[index] ? Colors.white : Colors.black,
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Choose your Price Range',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '\$ $selectedPriceRange',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Slider(
                  value: selectedPriceRange,
                  min: 0,
                  max: 100,
                  divisions: 100,
                  label: '\$${selectedPriceRange.toInt()}',
                  activeColor: Colors.green,
                  inactiveColor: Colors.grey.shade300,
                  onChanged: (double value) {
                    setState(() {
                      selectedPriceRange = double.parse(value.toStringAsFixed(2));
                    });
                  },
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('\$0'),
                    Text('\$100'),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _clearSelections() {
    setState(() {
      selectedCategories = List.generate(categories.length, (_) => false);
      selectedPriceRange = 20;
    });
  }
}
