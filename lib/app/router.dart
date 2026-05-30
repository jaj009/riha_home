import 'package:go_router/go_router.dart';
import '../core/widgets/coming_soon_screen.dart';
import '../features/birthdays/presentation/screens/add_birthday_screen.dart';
import '../features/birthdays/presentation/screens/birthday_list_screen.dart';
import '../features/home/presentation/screens/home_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/birthdays',
      builder: (context, state) => const BirthdayListScreen(),
      routes: [
        GoRoute(
          path: 'add',
          builder: (context, state) => const AddBirthdayScreen(),
        ),
        GoRoute(
          path: 'edit/:id',
          builder: (context, state) => AddBirthdayScreen(
            birthdayId: int.tryParse(state.pathParameters['id'] ?? ''),
          ),
        ),
      ],
    ),
    GoRoute(
      path: '/health',
      builder: (context, state) => const ComingSoonScreen(title: 'Health'),
    ),
    GoRoute(
      path: '/periods',
      builder: (context, state) => const ComingSoonScreen(title: 'Period Tracker'),
    ),
    GoRoute(
      path: '/memories',
      builder: (context, state) => const ComingSoonScreen(title: 'Memories'),
    ),
    GoRoute(
      path: '/notes',
      builder: (context, state) => const ComingSoonScreen(title: 'Notes'),
    ),
    GoRoute(
      path: '/reminders',
      builder: (context, state) => const ComingSoonScreen(title: 'Reminders'),
    ),
    GoRoute(
      path: '/calculators',
      builder: (context, state) => const ComingSoonScreen(title: 'Calculators'),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const ComingSoonScreen(title: 'Settings'),
    ),
  ],
);
