import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:homefix_test/generated/l10n.dart';
import 'package:homefix_test/src/application/task/task_bloc.dart';
import 'package:homefix_test/src/bottom_navigation/curved_navigation_bar.dart';
import 'package:homefix_test/src/infrastructure/repositories/task_repository.dart';
import 'package:homefix_test/src/presentation/pages/empty_pages.dart';
import 'package:homefix_test/src/presentation/pages/task_list_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              TaskBloc(TaskRepository())..add(const TaskEvent.loadTasks()),
        ),
      ],
      child: MaterialApp(
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate, 
        ],
        supportedLocales: const [
          Locale('en', 'EN'),
          Locale('ru', 'RU'),
        ],
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.teal,
        ),
        home: const NavigationController(),
      ),
    );
  }
}

class NavigationController extends StatefulWidget {
  const NavigationController({super.key});

  @override
  _NavigationControllerState createState() => _NavigationControllerState();
}
class _NavigationControllerState extends State<NavigationController> {
  int _selectedIndex = 1;
  
  final List<Widget> _pages = [
    const EmptyPage(title: 'Home'),
    const TaskListPage(),
    const EmptyPage(title: 'Chat'),
    const EmptyPage(title: 'Profile'),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: CurvedNavigationBar(
        buttonBackgroundColor: Colors.white,
        backgroundColor: Colors.transparent,
        color: const Color(0xff26BDBE),
        items: <Widget>[
          SvgPicture.asset(
            _selectedIndex == 0
                ? "assets/icons/home_active.svg"
                : "assets/icons/home.svg",
          ),
          SvgPicture.asset(
            _selectedIndex == 1
                ? "assets/icons/calendar_active.svg"
                : "assets/icons/calendar.svg",
          ),
          SvgPicture.asset(
            _selectedIndex == 2
                ? "assets/icons/chat_active.svg"
                : "assets/icons/chat.svg",
          ),
          SvgPicture.asset(
            _selectedIndex == 3
                ? "assets/icons/profile_active.svg"
                : "assets/icons/profile.svg",
          ),
        ],
        onTap: _onItemTapped, // Simplified callback
      ),
    );
  }
}
