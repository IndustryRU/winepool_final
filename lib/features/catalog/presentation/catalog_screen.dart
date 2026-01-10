//import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
//import 'package:badges/badges.dart' as badges;
//import 'package:winepool_final/features/wines/domain/wine.dart';
import 'package:winepool_final/features/wines/presentation/wine_tile.dart';
import 'package:winepool_final/features/wines/application/wines_controller.dart';
//import 'package:winepool_final/features/wines/domain/wine_characteristics.dart';
//import 'package:winepool_final/features/catalog/application/catalog_controller.dart' as old_controller;
//import 'package:winepool_final/features/catalog/application/catalog_filters_provider.dart' as new_provider;
//import 'package:winepool_final/features/catalog/application/catalog_controller.dart';
//import 'package:winepool_final/features/catalog/presentation/widgets/filter_helpers.dart';
//import 'package:winepool_final/features/catalog/presentation/widgets/price_filter_widget.dart';
//import 'package:winepool_final/features/catalog/presentation/widgets/color_filter_widget.dart';
//import 'package:winepool_final/features/catalog/presentation/widgets/type_filter_widget.dart';
//import 'package:winepool_final/features/catalog/presentation/widgets/sugar_filter_widget.dart';
//import 'package:winepool_final/features/catalog/presentation/widgets/country_filter_widget.dart';
//import 'package:winepool_final/features/catalog/presentation/widgets/region_filter_widget.dart';
//import 'package:winepool_final/features/catalog/presentation/widgets/grape_filter_widget.dart';
//import 'package:winepool_final/features/catalog/presentation/widgets/rating_filter_widget.dart';
//import 'package:winepool_final/features/catalog/presentation/widgets/year_filter_widget.dart';
//import 'package:winepool_final/features/catalog/presentation/widgets/bottle_size_filter_widget.dart';
// import 'package:winepool_final/features/catalog/presentation/widgets/winery_filter_widget.dart'; // Больше не нужен напрямую
import 'package:winepool_final/features/catalog/presentation/widgets/catalog_filters_panel.dart';
import 'package:winepool_final/common/widgets/shimmer_loading_indicator.dart';

// Провайдер для фильтров

// Используем сгенерированный провайдер напрямую
// final filteredWinesProvider = FutureProvider.autoDispose.family<List<Wine>, Map<String, dynamic>>((ref, filters) async {
//   return await ref.watch(winesWithFiltersProvider(filters));
// });

class CatalogScreen extends HookConsumerWidget {
  const CatalogScreen({super.key});

  @override
Widget build(BuildContext context, WidgetRef ref) {
   final winesAsync = ref.watch(winesWithActiveFiltersProvider);
   final scale = useState<double>(1.0);
   final alignment = useState<Alignment>(Alignment.center);
   final controller = useAnimationController(duration: const Duration(milliseconds: 100));
   final curvedAnimation = CurvedAnimation(parent: controller, curve: Curves.easeOut);
   final animation = Tween<double>(begin: 1.0, end: 1.4).animate(curvedAnimation);

   useEffect(() {
     void listener() {
       scale.value = animation.value;
     }

     animation.addListener(listener);
     return () => animation.removeListener(listener);
   }, [animation]);

   return PopScope(
     canPop: false,
     onPopInvoked: (bool didPop) async {
       // Используем GoRouter для навигации назад
       context.go('/catalog'); // Предполагаем, что каталог открывается из buyer-home
     },
     child: GestureDetector(
       onLongPressStart: (LongPressStartDetails details) {
         // Convert local position to alignment
         final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
         if (renderBox == null) return; // Проверяем, что RenderBox не null
         
         Offset localPosition = details.localPosition;
         Size size = renderBox.size;
         double dx = (localPosition.dx / size.width - 0.5) * 2; // Convert to range [-1, 1]
         double dy = (localPosition.dy / size.height - 0.5) * 2; // Convert to range [-1, 1]
         alignment.value = Alignment(dx, dy);
         
         controller
           ..duration = const Duration(milliseconds: 100);
         controller.forward();
       },
       onLongPressEnd: (LongPressEndDetails details) {
         // Проверяем, что контроллер все еще активен и не завершил анимацию в обратном направлении
         if (controller.status != AnimationStatus.dismissed) {
           controller
             ..duration = const Duration(milliseconds: 10);
           try {
             controller.reverse();
           } catch (e) {
             // Игнорируем ошибку, если контроллер уже уничтожен
           }
         }
       },
       child: Transform.scale(
         scale: scale.value,
         alignment: alignment.value,
         child: Scaffold(
       appBar: AppBar(
         title: const Text('Каталог вин'),
         leading: IconButton(
           icon: const Icon(Icons.arrow_back),
           onPressed: () {
             context.go('/catalog');
           },
         ),
       ),
       body: Column(
         children: [
           // Панель фильтров
           const CatalogFiltersPanel(),
           const SizedBox(height: 16),
           // Список вин
           Expanded(
             child: winesAsync.when(
               data: (wines) => wines.isEmpty
                   ? const Center(
                       child: Text('Ничего не найдено'),
                     )
                   : ListView.builder(
                       itemCount: wines.length,
                       itemBuilder: (context, index) {
                         return GestureDetector(
                           onTap: () {
                             GoRouter.of(context).push('/wine/${wines[index].id}', extra: wines[index]);
                           },
                           child: WineTile(wine: wines[index]),
                         );
                       },
                     ),
               loading: () => const ShimmerLoadingIndicator(),
               error: (error, stack) => Center(
                 child: SelectableText.rich(
                   TextSpan(
                     text: 'Ошибка: ${error.toString()}',
                     style: const TextStyle(color: Colors.red),
                   ),
                 ),
               ),
             ),
           ),
         ],
       ),
     ),
   ),
 ),
);
 }

}

// Удалено: старая логика FilterSlider, FilterButton, _showFilterModal, _buildFilterContent, _buildFilterContentWithCallbacks, _showSortModal, _isFilterActive, getFilterTitle, filterKeys
