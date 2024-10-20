import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:book/models/sitter.dart';
import 'package:book/services/sitter_services.dart';
import 'package:book/utils/asset_manager.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  // List of categories available as Services
  final List<Services> categories = [
    Services(id: 1, service_name: 'Car'),
    Services(id: 2, service_name: 'Gym'),
    Services(id: 3, service_name: 'Cooking'),
    Services(id: 4, service_name: 'Luggage'),
  ];

  // List to track selected categories
  List<Services> selectedCategories = [];
  double selectedPriceRange = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: SingleChildScrollView(
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
                      child: const Icon(Icons.close_rounded),
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
                      label: Text(categories[index].service_name ?? ''),
                      selected: selectedCategories.contains(categories[index]),
                      onSelected: (bool selected) {
                        setState(() {
                          if (selected) {
                            selectedCategories.add(categories[index]);
                          } else {
                            selectedCategories.remove(categories[index]);
                          }
                        });
                      },
                      selectedColor: AssetManager.baseTextColor11,
                      backgroundColor: Colors.grey.shade300,
                      labelStyle: TextStyle(
                        color: selectedCategories.contains(categories[index]) ? Colors.white : Colors.black,
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Choose your Price Range',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '\$${selectedPriceRange.toStringAsFixed(2)}',
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
                  activeColor: AssetManager.baseTextColor11,
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
                const SizedBox(height: 16),
                Consumer<SitterServices>(
                  builder: (context, sitterServices, _) {
                    return SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // Apply filters
                          sitterServices.filterSitterListByCategories(
                            selectedCategories,
                            selectedPriceRange,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AssetManager.baseTextColor11,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text(
                          'Apply Filters',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    );
                  },
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
      selectedCategories = [];
      selectedPriceRange = 20;
    });
  }
}
