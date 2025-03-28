import 'package:financial_dashboard/features/auth/presentation/pages/auth_page.dart';
import 'package:go_router/go_router.dart';

class AuthPageRouter {
  final String path;

  AuthPageRouter({required this.path});

  GoRoute get route =>
      GoRoute(path: path, builder: (context, state) => const AuthPage());
}
