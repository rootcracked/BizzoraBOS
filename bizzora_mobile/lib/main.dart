import 'package:bizzora_mobile/admin/presentation/screens/manage_menu.dart';
import 'package:bizzora_mobile/features/auth/presentation/screens/LoginScreen.dart';
import 'package:bizzora_mobile/features/auth/presentation/screens/RegisterScreen.dart';
import 'package:bizzora_mobile/features/auth/presentation/screens/role_Selector.dart';
import 'package:bizzora_mobile/features/layout/layout.dart';
import 'package:bizzora_mobile/features/layout/worker_layout.dart';
import 'package:bizzora_mobile/features/product/Presentation/Screens/product_screen.dart';
import 'package:bizzora_mobile/effects/splash_screen.dart';
import 'package:bizzora_mobile/features/workers/presentations/screens/add_worker.dart';
import 'package:bizzora_mobile/features/workers/presentations/screens/manage_workers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bizzora_mobile/features/product/Presentation/Screens/manage_products.dart';
import 'package:bizzora_mobile/features/workers/presentations/screens/worker_login.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final GoRouter router = GoRouter(
      initialLocation: '/main',

      routes: [
        GoRoute(
          path: '/splash',
          builder: (context, state) => const SplashScreen(),
        ),
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/worker-login',
          builder: (context, state) => const WorkerLoginScreen(),
        ),
        GoRoute(
          path: "/role-selector",
          builder: (context, state) => const RoleSelectionScreen(),
        ),

        GoRoute(
          path: '/register',
          builder: (context, state) => const RegisterScreen(),
        ),
        GoRoute(path: '/main', builder: (context, state) => const MainScreen()),
        GoRoute(
          path: '/worker-main',
          builder: (context, state) => const WorkermainScreen(),
        ),
        GoRoute(
          path: '/add-product',
          builder: (context, state) => const ProductScreen(),
        ),
        GoRoute(
          path: "/add-worker",
          builder: (context, state) => const AddworkerScreen(),
        ),
        GoRoute(
          path: "/manage-products",
          builder: (context, state) => const AllProductsScreen(),
        ),
        GoRoute(
          path: "/manage-workers",
          builder: (context, state) => const AllWorkersScreen(),
        ),
        GoRoute(
          path: "/main-menu",
          builder: (context, state) => const ManageMenu(),
        ),
      ],
    );

    return ScreenUtilInit(
      designSize: const Size(375, 812), //  good default for phones
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,

          theme: ThemeData(
            useMaterial3: true,
            textTheme: GoogleFonts.interTextTheme(),

            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          ),
          routerConfig: router,
        );
      },
    );
  }
}
