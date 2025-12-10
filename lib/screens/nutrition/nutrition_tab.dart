import 'package:flutter/material.dart';
import '../../services/nutrition_service.dart';
import '../../models/meal_model.dart';
import 'meal_detail_screen.dart';
import 'macro_filter_screen.dart';

class NutritionTab extends StatefulWidget {
  const NutritionTab({super.key});

  @override
  State<NutritionTab> createState() => _NutritionTabState();
}

class _NutritionTabState extends State<NutritionTab> {
  String? _selectedMealType;
  List<MealModel> _meals = [];

  @override
  void initState() {
    super.initState();
    _meals = NutritionService.getAllMeals();
  }

  void _filterByMealType(String? mealType) {
    setState(() {
      _selectedMealType = mealType;
      if (mealType == null) {
        _meals = NutritionService.getAllMeals();
      } else {
        _meals = NutritionService.getMealsByType(mealType);
      }
    });
  }

  Future<void> _openMacroFilter() async {
    final result = await Navigator.push<Map<String, double?>>(
      context,
      MaterialPageRoute(
        builder: (_) => const MacroFilterScreen(),
      ),
    );

    if (result != null) {
      setState(() {
        _meals = NutritionService.filterMealsByMacros(
          minProtein: result['minProtein'],
          maxProtein: result['maxProtein'],
          minCarbs: result['minCarbs'],
          maxCarbs: result['maxCarbs'],
          minFats: result['minFats'],
          maxFats: result['maxFats'],
          maxCalories: result['maxCalories'],
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Personalized Nutrition Planning'),
        backgroundColor: Colors.orange,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _openMacroFilter,
            tooltip: 'Filter by Macros',
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey[200],
            child: Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: _selectedMealType,
                    decoration: const InputDecoration(
                      labelText: 'Filter by Meal Type',
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    items: [
                      const DropdownMenuItem<String>(
                        value: null,
                        child: Text('All Meals'),
                      ),
                      const DropdownMenuItem(
                        value: 'breakfast',
                        child: Text('Breakfast'),
                      ),
                      const DropdownMenuItem(
                        value: 'lunch',
                        child: Text('Lunch'),
                      ),
                      const DropdownMenuItem(
                        value: 'dinner',
                        child: Text('Dinner'),
                      ),
                      const DropdownMenuItem(
                        value: 'snack',
                        child: Text('Snack'),
                      ),
                    ],
                    onChanged: _filterByMealType,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _meals.length,
              itemBuilder: (context, index) {
                final meal = _meals[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 2,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MealDetailScreen(meal: meal),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: Colors.orange.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.restaurant,
                              size: 40,
                              color: Colors.orange,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  meal.name,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  meal.description,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    _buildMacroChip('${meal.calories.toStringAsFixed(0)} kcal', Colors.orange),
                                    const SizedBox(width: 8),
                                    _buildMacroChip('P: ${meal.protein.toStringAsFixed(1)}g', Colors.blue),
                                    const SizedBox(width: 8),
                                    _buildMacroChip('C: ${meal.carbs.toStringAsFixed(1)}g', Colors.green),
                                    const SizedBox(width: 8),
                                    _buildMacroChip('F: ${meal.fats.toStringAsFixed(1)}g', Colors.red),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios, size: 20),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMacroChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

