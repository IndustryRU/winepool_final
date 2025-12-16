import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:winepool_final/features/wines/application/wineries_controller.dart';
import 'package:winepool_final/features/wines/domain/winery.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../common/widgets/shimmer_loading_indicator.dart';

class WineryDetailsScreen extends ConsumerWidget {
  final Winery winery;

  const WineryDetailsScreen({super.key, required this.winery});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Получаем актуальные данные винодельни по ID
    final wineryAsync = ref.watch(wineriesControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(winery.name ?? 'Винодельня'),
      ),
      body: wineryAsync.when(
        data: (wineries) {
          final wineryData = wineries.firstWhere(
            (w) => w.id == winery.id,
            orElse: () => winery, // Если не найдена, используем переданный объект
          );

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (wineryData.bannerUrl != null) ...[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        wineryData.bannerUrl!,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            height: 200,
                            width: double.infinity,
                            color: Colors.grey[300],
                            child: const Center(child: ShimmerLoadingIndicator()),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 200,
                            width: double.infinity,
                            color: Colors.grey[300],
                            child: const Icon(
                              Icons.image_not_supported,
                              size: 50,
                              color: Colors.grey,
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  if (wineryData.logoUrl != null) ...[
                    Center(
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(wineryData.logoUrl!),
                        backgroundColor: Colors.grey[200],
                        onBackgroundImageError: (exception, stackTrace) {
                          // Показываем иконку, если не удалось загрузить логотип
                        },
                        child: wineryData.logoUrl == null
                            ? const Icon(Icons.store, size: 50, color: Colors.grey)
                            : null,
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  Text(
                    wineryData.name ?? 'Без названия',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  if (wineryData.description != null) ...[
                    Text(
                      wineryData.description!,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 16),
                  ],
                  if (wineryData.winemaker != null || wineryData.locationText != null || wineryData.website != null) ...[
                    if (wineryData.winemaker != null) ...[
                      _buildDetailCard(
                        context,
                        Icons.person,
                        'Винодел',
                        wineryData.winemaker ?? '',
                      ),
                    ],
                    if (wineryData.countryCode != null || wineryData.region != null) ...[
                      _buildDetailCard(
                        context,
                        Icons.location_on,
                        'Регион',
                        '${wineryData.countryCode ?? ''}${wineryData.countryCode != null && wineryData.region != null ? ', ' : ''}${wineryData.region ?? ''}',
                      ),
                    ],
                    if (wineryData.locationText != null) ...[
                      _buildDetailCard(
                        context,
                        Icons.place,
                        'Местоположение',
                        wineryData.locationText ?? '',
                      ),
                    ],
                    if (wineryData.website != null) ...[
                      _buildWebsiteCard(context, wineryData.website ?? ''),
                    ],
                  ],
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      GoRouter.of(context).go('/wineries/${winery.id}/wines');
                    },
                    child: const Text('Список вин'),
                  ),
                ],
              ),
            ),
          );
        },
        loading: () => const Center(child: ShimmerLoadingIndicator()),
        error: (error, stack) => SelectableText.rich(
          TextSpan(
            text: 'Ошибка загрузки данных: $error',
            style: const TextStyle(color: Colors.red),
          ),
        ),
      ),
    );
 }

  Widget _buildDetailCard(
    BuildContext context,
    IconData icon,
    String title,
    String value,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Icon(icon, color: Theme.of(context).primaryColor),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context).hintColor,
                        ),
                  ),
                  Text(
                    value,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

 Widget _buildWebsiteCard(BuildContext context, String website) {
    final Uri url = Uri.parse(website.startsWith('http') ? website : 'https://$website');
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Icon(Icons.public, color: Theme.of(context).primaryColor),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Веб-сайт',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context).hintColor,
                        ),
                  ),
                  InkWell(
                    onTap: () async {
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url);
                      }
                    },
                    child: Text(
                      website,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Theme.of(context).primaryColor,
                            decoration: TextDecoration.underline,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}