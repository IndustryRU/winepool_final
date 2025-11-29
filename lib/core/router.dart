
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:winepool_final/features/auth/application/auth_controller.dart';
import 'package:winepool_final/features/auth/presentation/register_screen.dart';
import 'package:winepool_final/screens/login_screen.dart';
import 'package:winepool_final/features/cart/domain/cart_item.dart';
import 'package:winepool_final/features/home/presentation/admin_home_screen.dart';
import 'package:winepool_final/features/home/presentation/buyer_home_screen.dart';
import 'package:winepool_final/features/home/presentation/seller_home_screen.dart';
import 'package:winepool_final/features/offers/domain/offer.dart';
import 'package:winepool_final/features/offers/presentation/add_offer_screen.dart';
import 'package:winepool_final/features/offers/presentation/edit_offer_screen.dart';
import 'package:winepool_final/features/offers/presentation/offer_details_screen.dart';
import 'package:winepool_final/features/cart/presentation/cart_screen.dart';
import 'package:winepool_final/features/wines/domain/wine.dart';
import 'package:winepool_final/features/wines/domain/winery.dart';
import 'package:winepool_final/features/wines/presentation/wine_details_screen.dart';
import 'package:winepool_final/features/wines/presentation/wineries_list_screen.dart';
import 'package:winepool_final/features/wines/presentation/add_edit_winery_screen.dart';
import 'package:winepool_final/features/wines/presentation/winery_details_screen.dart';
import 'package:winepool_final/features/wines/presentation/wines_list_screen.dart';
import 'package:winepool_final/features/wines/presentation/add_edit_wine_screen.dart';
import 'package:winepool_final/features/orders/presentation/checkout_screen.dart';
import 'package:winepool_final/features/orders/presentation/my_orders_screen.dart';
import 'package:winepool_final/features/profile/presentation/profile_screen.dart';
import 'package:winepool_final/features/profile/presentation/ebs_verification_screen.dart';

// Создаем ключ над провайдером
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final goRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authControllerProvider);

  return GoRouter(
    debugLogDiagnostics: true,
    initialLocation: '/login',
    routes: [
      GoRoute(
        path: '/login',
        builder: (_, __) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (_, __) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/buyer-home',
        builder: (_, __) => const BuyerHomeScreen(),
      ),
      GoRoute(
        path: '/seller-home',
        builder: (_, __) => const SellerHomeScreen(),
      ),
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return child;
        },
        routes: [
          GoRoute(
            path: '/admin-home',
            builder: (context, state) => const AdminHomeScreen(),
          ),
          GoRoute(
            path: '/wineries',
            builder: (context, state) => const WineriesListScreen(),
            routes: [
              GoRoute(
                path: 'add',
                builder: (context, state) => const AddEditWineryScreen(),
              ),
              GoRoute(
                path: ':id',
                builder: (context, state) {
                  final wineryId = state.pathParameters['id']!;
                  final winery = state.extra as Winery?;
                  final wineryToPass = winery ?? Winery(id: wineryId);
                  return WineryDetailsScreen(winery: wineryToPass);
                },
                routes: [
                  GoRoute(
                    path: 'edit',
                    builder: (context, state) {
                      final winery = state.extra as Winery?;
                      return AddEditWineryScreen(winery: winery);
                    },
                  ),
                  GoRoute(
                    path: 'wines',
                    builder: (context, state) {
                      final wineryId = state.pathParameters['id']!;
                      return WinesListScreen(wineryId: wineryId);
                    },
                    routes: [
                      GoRoute(
                        path: 'add',
                        builder: (context, state) {
                          final wineryId = state.pathParameters['id']!;
                          return AddEditWineScreen(wineryId: wineryId);
                        },
                      ),
                      GoRoute(
                        path: ':wineId/edit',
                        builder: (context, state) {
                          final wineryId = state.pathParameters['id']!;
                          final wine = state.extra as Wine?;
                          return AddEditWineScreen(wineryId: wineryId, wine: wine);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/wine/:id',
        builder: (context, state) {
          final wine = state.extra as Wine;
          return WineDetailsScreen(wine: wine);
        },
      ),
      GoRoute(
        path: '/add-offer',
        builder: (_, __) => const AddOfferScreen(),
      ),
      GoRoute(
        path: '/offers/:id',
        builder: (context, state) {
          final offer = state.extra as Offer?;
          if (offer == null) return const Text('Ошибка: оффер не найден');
          return OfferDetailsScreen(offer: offer);
        },
      ),
      GoRoute(
        path: '/edit-offer/:id',
        builder: (context, state) {
          final offer = state.extra as Offer;
          return EditOfferScreen(offer: offer);
        },
      ),
      GoRoute(
        path: '/cart',
        builder: (_, __) => const CartScreen(),
      ),
      GoRoute(
        path: '/checkout',
        builder: (context, state) {
          final cartItems = state.extra as List<CartItem>?;
          if (cartItems == null || cartItems.isEmpty) {
            return const Scaffold(
              body: Center(
                child: Text('Ошибка: Корзина пуста или не переданы данные.'),
              ),
            );
          }
          return CheckoutScreen(cartItems: cartItems);
        },
      ),
      GoRoute(
        path: '/my-orders',
        builder: (context, state) => const MyOrdersScreen(),
      ),
      GoRoute(
        path: '/profile',
        builder: (_, __) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/profile/ebs-verification',
        name: 'ebsVerification',
        builder: (context, state) => const EbsVerificationScreen(),
      ),
    ],
    redirect: (context, state) {
      final isLoggedIn = authState.asData?.value != null;
      final isLoggingIn = state.uri.toString() == '/login';
      
      if (authState is AsyncLoading) return null;

      if (!isLoggedIn && !isLoggingIn) return '/login';
      
      if (isLoggedIn && isLoggingIn) {
         final role = authState.asData!.value!.role;
         switch (role) {
           case 'administrator': return '/admin-home';
           case 'seller': return '/seller-home';
           case 'buyer': return '/buyer-home';
           default: return '/buyer-home'; // Редирект на витрину по умолчанию
         }
      }
      return null;
    },
  );
});