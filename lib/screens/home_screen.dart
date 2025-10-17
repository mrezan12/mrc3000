import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Oxford 3000 - Flashcards')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Ana başlık
            const Text(
              'Çalışma Modunu Seçin',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            
            // Sıralı Mod
            _buildModeCard(
              context: context,
              title: 'Kelimeler (Sıralı)',
              subtitle: 'Oxford 3000 kelimelerini sırayla çalış',
              icon: Icons.list_alt,
              color: Colors.blue,
              onTap: () => Navigator.pushNamed(context, '/study', arguments: {
                'mode': 'sequential',
                'level': null,
              }),
            ),
            
            const SizedBox(height: 16),
            
            // Genel Rastgele Mod
            _buildModeCard(
              context: context,
              title: 'Genel Rastgele',
              subtitle: 'Tüm kelimelerden rastgele seçim',
              icon: Icons.shuffle,
              color: Colors.green,
              onTap: () => Navigator.pushNamed(context, '/study', arguments: {
                'mode': 'random',
                'level': null,
              }),
            ),
            
            const SizedBox(height: 16),
            
            // Seviye Bazlı Rastgele Mod
            _buildModeCard(
              context: context,
              title: 'Seviye Bazlı Rastgele',
              subtitle: 'Belirli seviyedeki kelimelerden rastgele',
              icon: Icons.filter_list,
              color: Colors.orange,
              onTap: () => Navigator.pushNamed(context, '/level-selection'),
            ),
            
            const SizedBox(height: 16),
            
            // Tekrar Listesi
            _buildModeCard(
              context: context,
              title: 'Tekrar Listesi',
              subtitle: 'Bilinmeyen kelimeleri tekrar et',
              icon: Icons.refresh,
              color: Colors.red,
              onTap: () => Navigator.pushNamed(context, '/review'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModeCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).hintColor,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Theme.of(context).hintColor,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
