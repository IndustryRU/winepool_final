import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
      {
        'name': 'Вино',
        'icon': Icons.local_drink,
        'image': 'assets/icons/WP_ico3.png',
        'route': '/wines-catalog',
      },
      {
        'name': 'Бренди',
        'icon': Icons.local_drink,
        'image': 'assets/icons/WP_ico1.png',
        'route': '/brandy-catalog',
      },
      {
        'name': 'Винодельни',
        'icon': Icons.local_drink,
        'image': 'assets/icons/WP_ico2.png',
        'route': '/wineries-catalog',
      },
      {
        'name': 'Аксессуары',
        'icon': Icons.shopping_bag,
        'image': 'assets/images/WP_Logo1.png',
        'route': '/accessories-catalog', // Пока что не реализовано, но можно будет использовать позже
      },
    ];

    return WillPopScope(
      onWillPop: () async {
        context.go('/buyer-home');
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Категории'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              context.go('/buyer-home');
            },
          ),
        ),
        body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0,
            childAspectRatio: 1.0,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            final route = category['route'] as String;
            
            VoidCallback? onPressed;
            if (route == '/accessories-catalog' ||
                route == '/brandy-catalog' ||
                route == '/wineries-catalog') {
              onPressed = () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Раздел в разработке'),
                  ),
                );
              };
            } else {
              onPressed = () {
                context.go(route);
              };
            }

            return ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[200], // Изменяем цвет фона
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: Stack(
                children: [
                  // Картинка внизу
                  Positioned(
                    bottom: 5,
                    left: 0,
                    right: 0,
                    child: Image.asset(
                      category['image'] as String,
                      fit: BoxFit.contain,
                      height: 120, // Масштабируем картинку
                    ),
                  ),
                  // Название вверху слева
                  Positioned(
                    top: 5,
                    left: 0,
                    child: Text(
                      category['name'] as String,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black, // Цвет текста для контраста
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    ),
  );
  }
}