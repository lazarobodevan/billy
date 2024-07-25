import 'package:billy/screens/nav_pages/categories/categories.dart';
import 'package:billy/screens/nav_pages/home/home.dart';
import 'package:billy/screens/nav_pages/insights/insights.dart';
import 'package:billy/theme/colors.dart';
import 'package:flutter/material.dart';

class NavigationPage extends StatefulWidget {
  const NavigationPage({super.key});

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  List pages = [Home(), Insights(), Categories(), Home()];
  List barItems = [
    {"text": "Home", "icon": Icons.home_outlined},
    {"text": "Insights", "icon": Icons.pie_chart_outline},
    {"text": "Categorias", "icon": Icons.category_outlined},
    {"text": "Mais", "icon": Icons.more_vert_outlined}
  ];

  void _onIndexChanged(int newIndex) {
    setState(() {
      currentIndex = newIndex;
    });
  }


  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: new Theme(
        data: Theme.of(context).copyWith(
          canvasColor: ThemeColors.primary1
        ),
        child: BottomNavigationBar(
            currentIndex: currentIndex,
            showUnselectedLabels: true,
            type: BottomNavigationBarType.fixed,
            unselectedItemColor: Colors.white54,
            onTap: _onIndexChanged,
            selectedItemColor: ThemeColors.primary3,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.pie_chart_outline),
                label: 'Insights',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.category_outlined),
                label: 'Categorias',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.more_vert_outlined),
                label: 'Mais',
              ),
            ],
        ),
      ),
    );
  }
}