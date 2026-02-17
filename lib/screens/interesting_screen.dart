import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'main_layout.dart';

class InterestsScreen extends StatefulWidget {
  const InterestsScreen({super.key});

  @override
  State<InterestsScreen> createState() => _InterestsScreenState();
}

class _InterestsScreenState extends State<InterestsScreen> {
  final supabase = Supabase.instance.client;
  bool _isLoading = false;

  final List<Map<String, dynamic>> _categories = [
    {"name": "Artificial Intelligence", "icon": "🤖"},
    {"name": "Mobile App", "icon": "📱"},
    {"name": "Cybersecurity", "icon": "🔒"},
    {"name": "Web Development", "icon": "🌐"},
    {"name": "Cloud Computing", "icon": "☁️"},
    {"name": "Gaming Tech", "icon": "🎮"},
    {"name": "Robotics", "icon": "🦾"},
    {"name": "Data Science", "icon": "📊"},
  ];

  final List<String> _selectedInterests = [];

  Future<void> _saveInterests() async {
    if (_selectedInterests.isEmpty) return;

    setState(() => _isLoading = true);
    final user = supabase.auth.currentUser;

    try {
      final inserts = _selectedInterests.map((interest) {
        return {
          'user_id': user?.id,
          'keyword': interest,
        };
      }).toList();

      await supabase.from('user_interests').insert(inserts);

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MainLayout()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error on saving: $e"), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F6),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(24, 80, 24, 40),
            decoration: const BoxDecoration(
              color: Color(0xFF1c1c1c),
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(40)),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Customize Your\nFeed",
                  style: TextStyle(
                    color: Colors.white, 
                    fontSize: 32, 
                    fontWeight: FontWeight.bold, 
                    height: 1.1
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  "Select the topics you're interested in to personalize your tech news experience.",
                  style: TextStyle(color: Colors.white70, fontSize: 15),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children: _categories.map((cat) {
                  final isSelected = _selectedInterests.contains(cat['name']);
                  return FilterChip(
                    label: Text("${cat['icon']}  ${cat['name']}"),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        selected 
                          ? _selectedInterests.add(cat['name']) 
                          : _selectedInterests.remove(cat['name']);
                      });
                    },
                    selectedColor: const Color(0xFF7FAF8B).withOpacity(0.3),
                    checkmarkColor: const Color(0xFF7FAF8B),
                    labelStyle: TextStyle(
                      color: isSelected ? const Color(0xFF4A6A54) : Colors.black87,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: isSelected ? const Color(0xFF7FAF8B) : Colors.black12
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7FAF8B),
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.grey.shade300,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                onPressed: (_selectedInterests.isNotEmpty && !_isLoading) ? _saveInterests : null,
                child: _isLoading 
                  ? const CircularProgressIndicator(color: Colors.white) 
                  : const Text(
                      "Finish & Explore", 
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}