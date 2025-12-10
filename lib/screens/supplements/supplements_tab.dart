import 'package:flutter/material.dart';
import '../../services/supplement_service.dart';
import '../../models/supplement_model.dart';
import 'supplement_detail_screen.dart';

class SupplementsTab extends StatefulWidget {
  const SupplementsTab({super.key});

  @override
  State<SupplementsTab> createState() => _SupplementsTabState();
}

class _SupplementsTabState extends State<SupplementsTab> {
  String? _selectedCategory;
  String? _selectedGoal;

  List<SupplementModel> get _filteredSupplements {
    List<SupplementModel> supplements = SupplementService.getAllSupplements();

    if (_selectedCategory != null) {
      supplements = supplements
          .where((s) => s.category.toLowerCase() == _selectedCategory!.toLowerCase())
          .toList();
    }

    if (_selectedGoal != null) {
      supplements = supplements
          .where((s) =>
              s.targetGoals?.any((g) =>
                  g.toLowerCase() == _selectedGoal!.toLowerCase()) ??
              false)
          .toList();
    }

    return supplements;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Supplementation Recommendations'),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey[200],
            child: Column(
              children: [
                DropdownButtonFormField<String>(
                  initialValue: _selectedCategory,
                  decoration: const InputDecoration(
                    labelText: 'Filter by Category',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  items: [
                    const DropdownMenuItem<String>(
                      value: null,
                      child: Text('All Categories'),
                    ),
                    const DropdownMenuItem(
                      value: 'pre-workout',
                      child: Text('Pre-Workout'),
                    ),
                    const DropdownMenuItem(
                      value: 'post-workout',
                      child: Text('Post-Workout'),
                    ),
                    const DropdownMenuItem(
                      value: 'daily',
                      child: Text('Daily'),
                    ),
                    const DropdownMenuItem(
                      value: 'during-workout',
                      child: Text('During Workout'),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() => _selectedCategory = value);
                  },
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: _selectedGoal,
                  decoration: const InputDecoration(
                    labelText: 'Filter by Goal',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  items: [
                    const DropdownMenuItem<String>(
                      value: null,
                      child: Text('All Goals'),
                    ),
                    const DropdownMenuItem(
                      value: 'muscle gain',
                      child: Text('Muscle Gain'),
                    ),
                    const DropdownMenuItem(
                      value: 'weight loss',
                      child: Text('Weight Loss'),
                    ),
                    const DropdownMenuItem(
                      value: 'endurance',
                      child: Text('Endurance'),
                    ),
                    const DropdownMenuItem(
                      value: 'recovery',
                      child: Text('Recovery'),
                    ),
                    const DropdownMenuItem(
                      value: 'strength',
                      child: Text('Strength'),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() => _selectedGoal = value);
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _filteredSupplements.length,
              itemBuilder: (context, index) {
                final supplement = _filteredSupplements[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 2,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.purple.withOpacity(0.2),
                      child: const Icon(Icons.medication, color: Colors.purple),
                    ),
                    title: Text(
                      supplement.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(
                          supplement.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 4,
                          children: [
                            Chip(
                              label: Text(supplement.category),
                              backgroundColor: Colors.purple.withOpacity(0.2),
                            ),
                            if (supplement.timing != null)
                              Chip(
                                label: Text(supplement.timing!),
                                backgroundColor: Colors.blue.withOpacity(0.2),
                              ),
                          ],
                        ),
                      ],
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              SupplementDetailScreen(supplement: supplement),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

