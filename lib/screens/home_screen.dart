import 'package:flutter/material.dart';
import '../services/theme_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MR3000'),
        actions: [
          // Tema değiştirme butonu
          ValueListenableBuilder<ThemeMode>(
            valueListenable: ThemeService().themeModeNotifier,
            builder: (context, mode, _) {
              return IconButton(
                tooltip: mode == ThemeMode.dark ? 'Açık Tema' : 'Koyu Tema',
                icon: Icon(
                  mode == ThemeMode.dark
                      ? Icons.light_mode
                      : Icons.dark_mode,
                ),
                onPressed: () => ThemeService().toggleTheme(),
              );
            },
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Responsive: Tablet (>= 600px) için 2 sütun
          final isTablet = constraints.maxWidth >= 600;
          
          return SafeArea(
            child: Padding(
              padding: EdgeInsets.all(isTablet ? 24 : 16),
              child: Column(
                children: [
                  // Ana başlık
                  Text(
                    'Çalışma Modunu Seçin',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  
                  // Mod kartları - responsive grid
                  Expanded(
                    child: isTablet
                        ? _buildTabletLayout(context)
                        : _buildMobileLayout(context),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return ListView(
      children: [
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
        const SizedBox(height: 12),
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
        const SizedBox(height: 12),
        _buildModeCard(
          context: context,
          title: 'Seviye Bazlı Rastgele',
          subtitle: 'Belirli seviyedeki kelimelerden rastgele',
          icon: Icons.filter_list,
          color: Colors.orange,
          onTap: () => Navigator.pushNamed(context, '/level-selection'),
        ),
        const SizedBox(height: 12),
        _buildModeCard(
          context: context,
          title: 'Tekrar Listesi',
          subtitle: 'Bilinmeyen kelimeleri tekrar et',
          icon: Icons.refresh,
          color: Colors.red,
          onTap: () => Navigator.pushNamed(context, '/review'),
        ),
      ],
    );
  }

  Widget _buildTabletLayout(BuildContext context) {
    final cards = [
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
      _buildModeCard(
        context: context,
        title: 'Seviye Bazlı Rastgele',
        subtitle: 'Belirli seviyedeki kelimelerden rastgele',
        icon: Icons.filter_list,
        color: Colors.orange,
        onTap: () => Navigator.pushNamed(context, '/level-selection'),
      ),
      _buildModeCard(
        context: context,
        title: 'Tekrar Listesi',
        subtitle: 'Bilinmeyen kelimeleri tekrar et',
        icon: Icons.refresh,
        color: Colors.red,
        onTap: () => Navigator.pushNamed(context, '/review'),
      ),
    ];

    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 2.5,
      children: cards,
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
    final scheme = Theme.of(context).colorScheme;
    
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: scheme.onSurfaceVariant,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

