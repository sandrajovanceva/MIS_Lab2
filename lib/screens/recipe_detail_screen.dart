import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/recipe.dart';

class RecipeDetailScreen extends StatelessWidget {
  final Recipe recipe;

  const RecipeDetailScreen({
    super.key,
    required this.recipe,
  });

  Future<void> _launchURL(String url) async {
    if (url.isEmpty) return;
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ingredients = recipe.ingredients.entries.toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo[900],
        title: Text(
          recipe.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.indigo[50]!,
              Colors.white,
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.network(
                recipe.thumbnail,
                height: 260,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 260,
                    color: Colors.grey[200],
                    child: const Center(
                      child: Icon(Icons.image_not_supported, size: 48, color: Colors.indigo),
                    ),
                  );
                },
              ),

              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (recipe.category.isNotEmpty || recipe.area.isNotEmpty)
                      Row(
                        children: [
                          if (recipe.category.isNotEmpty)
                            Chip(
                              label: Text(recipe.category),
                              backgroundColor: Colors.purple[100],
                            ),
                          if (recipe.category.isNotEmpty &&
                              recipe.area.isNotEmpty)
                            const SizedBox(width: 8),
                          if (recipe.area.isNotEmpty)
                            Chip(
                              label: Text(recipe.area),
                              backgroundColor: Colors.orange[100],
                            ),
                        ],
                      ),

                    const SizedBox(height: 16),

                    Text(
                      'Состојки',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo[900],
                      ),
                    ),

                    const SizedBox(height: 8),

                    if (ingredients.isEmpty)
                      const Text(
                        'Нема достапни состојки.',
                        style: TextStyle(fontSize: 16),
                      )
                    else
                      ...ingredients.map((entry) {
                        final ingredient = entry.key;
                        final measure = entry.value;
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.check_circle_outline,
                                color: Colors.indigo,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  '$ingredient${measure.isNotEmpty ? ' - $measure' : ''}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),

                    const SizedBox(height: 24),

                    Text(
                      'Инструкции',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo[900],
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      recipe.instructions.isNotEmpty
                          ? recipe.instructions
                          : 'Нема достапни инструкции.',
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.5,
                      ),
                    ),

                    if (recipe.youtube.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      Center(
                        child: ElevatedButton.icon(
                          onPressed: () => _launchURL(recipe.youtube),
                          icon: const Icon(Icons.play_circle_outline),
                          label: const Text('Гледај на YouTube'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
