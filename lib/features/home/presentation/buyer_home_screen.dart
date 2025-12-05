import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:winepool_final/features/auth/application/auth_controller.dart';
import 'package:winepool_final/features/wines/application/wines_controller.dart';
import 'package:winepool_final/features/wines/domain/wine.dart';
import 'package:winepool_final/features/wines/presentation/widgets/wine_characteristic_icons.dart';

class BuyerHomeScreen extends ConsumerWidget {
  const BuyerHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WinePool'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => context.push('/search'),
            tooltip: 'Поиск',
          ),
          IconButton(
            icon: const Icon(Icons.receipt_long),
            onPressed: () => context.push('/my-orders'),
            tooltip: 'Мои заказы',
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () => context.push('/cart'),
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => context.push('/profile'),
            tooltip: 'Профиль',
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              ref.read(authControllerProvider.notifier).signOut();
            },
            tooltip: 'Выйти',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Слайдер с баннерами
            _buildBannerSlider(),
            
            const SizedBox(height: 16),
            
            // Слайдер категорий
            _buildCategorySlider(context),
            
            const SizedBox(height: 16),
            
            // Поле поиска
            _buildSearchField(context),
            
            const SizedBox(height: 16),
            
            // Подборка "Популярные вина"
            _buildSectionHeader('Популярные вина'),
            _buildPopularWineList(ref),
            
            const SizedBox(height: 16),
            
            // Подборка "Новинки"
            _buildSectionHeader('Новинки'),
            _buildNewWineList(ref),
            
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  // Виджет слайдера с баннерами
  Widget _buildBannerSlider() {
    return Container(
      height: 200,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/massandra_banner.png',
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }

  // Поле поиска
  Widget _buildSearchField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Поиск вина, винодельни или сорта...',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.grey[200],
        ),
        onTap: () => context.push('/search'),
      ),
    );
  }

  // Слайдер категорий
  Widget _buildCategorySlider(BuildContext context) {
    final categories = [
      {'name': 'Каталог', 'icon': Icons.category},
      {'name': 'Акции', 'icon': Icons.local_offer},
      {'name': 'Подборки', 'icon': Icons.collections},
      {'name': 'Бренды', 'icon': Icons.business},
      {'name': 'Помощь', 'icon': Icons.help},
    ];

    return SizedBox(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return GestureDetector(
            onTap: () {
              if (category['name'] == 'Каталог') {
                context.go('/catalog');
              }
            },
            child: Container(
              width: 100,
              margin: const EdgeInsets.only(left: 16),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    category['icon'] as IconData,
                    size: 32,
                    color: Colors.grey[700],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    category['name'] as String,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[700],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // Заголовок секции
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextButton(
            onPressed: () {},
            child: const Text('Показать все'),
          ),
        ],
      ),
    );
  }

  // Горизонтальный список вин
  Widget _buildHorizontalWineList() {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        itemBuilder: (context, index) {
          return Container(
            width: 150,
            margin: const EdgeInsets.only(left: 16),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.wine_bar,
                    size: 40,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Вино $index',
                  style: TextStyle(fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
                Text(
                  'Винодельня',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                Text(
                  '1000 ₽',
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Горизонтальный список популярных вин
  Widget _buildPopularWineList(WidgetRef ref) {
    final popularWinesAsync = ref.watch(popularWinesProvider);
    return SizedBox(
      height: 220,
      child: popularWinesAsync.when(
        data: (wines) {
          if (wines.isEmpty) {
            return const Center(child: Text('Нет популярных вин'));
          }
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: wines.length,
            itemBuilder: (context, index) {
              final wine = wines[index];
              return Container(
                width: 140,
                margin: const EdgeInsets.only(left: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (wine.imageUrl != null && wine.imageUrl!.isNotEmpty)
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(wine.imageUrl!),
                          ),
                        ),
                      )
                    else
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          color: Colors.grey[400],
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.wine_bar,
                          size: 35,
                          color: Colors.grey,
                        ),
                      ),
                    const SizedBox(height: 6),
                    Text(
                      wine.name,
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      wine.winery?.name ?? 'Нет данных', // Используем название винодельни из связанной таблицы
                      style: TextStyle(fontSize: 10, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      '${wine.averageRating ?? 0.0} ★', // Показываем рейтинг вместо цены
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
                    ),
                    const SizedBox(height: 2),
                    WineCharacteristicIconsColumn(
                      wine: wine,
                      iconSize: 14.0,
                    ),
                  ],
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Ошибка: $error')),
      ),
    );
  }

  // Горизонтальный список новинок вин
  Widget _buildNewWineList(WidgetRef ref) {
    final newWinesAsync = ref.watch(newWinesProvider);
    return SizedBox(
      height: 220,
      child: newWinesAsync.when(
        data: (wines) {
          if (wines.isEmpty) {
            return const Center(child: Text('Нет новинок'));
          }
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: wines.length,
            itemBuilder: (context, index) {
              final wine = wines[index];
              return Container(
                width: 140,
                margin: const EdgeInsets.only(left: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (wine.imageUrl != null && wine.imageUrl!.isNotEmpty)
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(wine.imageUrl!),
                          ),
                        ),
                      )
                    else
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          color: Colors.grey[400],
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.wine_bar,
                          size: 35,
                          color: Colors.grey,
                        ),
                      ),
                    const SizedBox(height: 6),
                    Text(
                      wine.name,
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      wine.winery?.name ?? 'Нет данных', // Используем название винодельни из связанной таблицы
                      style: TextStyle(fontSize: 10, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      '${wine.averageRating ?? 0.0} ★', // Показываем рейтинг вместо цены
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
                    ),
                    const SizedBox(height: 2),
                    WineCharacteristicIconsColumn(
                      wine: wine,
                      iconSize: 14.0,
                    ),
                  ],
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Ошибка: $error')),
      ),
    );
  }
}