import 'package:flutter/material.dart';

class LevelSelectionScreen extends StatelessWidget {
  const LevelSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seviye Seçimi'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Başlık
            const Text(
              'Hangi Seviyedeki Kelimeleri Çalışmak İstiyorsunuz?',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Seviyenizi seçin ve o seviyedeki kelimelerden rastgele çalışın',
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).hintColor,
              ),
            ),
            const SizedBox(height: 24),
            
            // Seviye kartları
            Expanded(
              child: Column(
                children: [
                  // İlk satır
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildLevelCard(
                            context: context,
                            level: 'A1',
                            title: 'Başlangıç',
                            description: 'Temel kelimeler',
                            color: Colors.green,
                            onTap: () => _navigateToStudy(context, 'A1'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildLevelCard(
                            context: context,
                            level: 'A2',
                            title: 'Temel',
                            description: 'Günlük kelimeler',
                            color: Colors.lightGreen,
                            onTap: () => _navigateToStudy(context, 'A2'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  // İkinci satır
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildLevelCard(
                            context: context,
                            level: 'B1',
                            title: 'Orta',
                            description: 'İş ve sosyal',
                            color: Colors.orange,
                            onTap: () => _navigateToStudy(context, 'B1'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildLevelCard(
                            context: context,
                            level: 'B2',
                            title: 'Orta Üst',
                            description: 'Akademik temel',
                            color: Colors.deepOrange,
                            onTap: () => _navigateToStudy(context, 'B2'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Tüm Seviyeler Butonu
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _navigateToStudy(context, null),
                icon: const Icon(Icons.all_inclusive),
                label: const Text('Tüm Seviyeler'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: BorderSide(color: Theme.of(context).primaryColor),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLevelCard({
    required BuildContext context,
    required String level,
    required String title,
    required String description,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withValues(alpha: 0.1),
                color.withValues(alpha: 0.05),
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Seviye ikonu
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  level,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              
              // Başlık
              Flexible(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 4),
              
              // Açıklama
              Flexible(
                child: Text(
                  description,
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).hintColor,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToStudy(BuildContext context, String? level) {
    Navigator.pushNamed(context, '/study', arguments: {
      'mode': 'random',
      'level': level,
    });
  }
}
