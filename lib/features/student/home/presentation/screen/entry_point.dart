import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:learning_management_system/core/helper/constant.dart';
import 'package:learning_management_system/core/routing/app_router.dart';
import 'package:learning_management_system/core/routing/routes.dart';
import 'package:learning_management_system/core/theme/widget_themes/bottom_nav_bar.dart';
import 'package:learning_management_system/core/theming/bottom_app_bar_size.dart';
import 'package:learning_management_system/core/theming/colors.dart';
import 'package:learning_management_system/core/widgets/custom_clipper.dart';

class EntryPoint extends StatefulWidget {
  const EntryPoint({super.key});

  @override
  FinalViewState createState() => FinalViewState();
}

class FinalViewState extends State<EntryPoint> {
  int _currentIndex = 0;

  final List<int> _tabHistory = []; // changed to List for predictable last()
  // Navigator keys for each tab.
  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  final List<Widget?> _navigatorWidgets = List.filled(4, null, growable: false);

  String _getInitialRouteForIndex(int index) {
    switch (index) {
      case 0:
        return Routes.homeScreen;
      case 1:
        return Routes.profileScreen;
      case 2:
        return Routes.followedCourses;
      case 3:
        return Routes.searchScreen;
      default:
        return Routes.homeScreen;
    }
  }

  void _onItemTapped(int index) {
    if (index != _currentIndex) {
      _tabHistory.add(_currentIndex);
    }
    setState(() {
      _currentIndex = index;
    });
  }

  Widget _buildOffstageNavigator(int index) {
    if (index != _currentIndex && _navigatorWidgets[index] == null) {
      return Container();
    }
    if (_navigatorWidgets[index] == null) {
      _navigatorWidgets[index] = Navigator(
        key: _navigatorKeys[index],
        observers: [],
        initialRoute: _getInitialRouteForIndex(index),
        onGenerateRoute: AppRouter().generateRoute,
      );
    }
    return Offstage(
      offstage: _currentIndex != index,
      child: TickerMode(
        enabled: _currentIndex == index,
        child: _navigatorWidgets[index]!,
      ),
    );
  }

  void _pushRouteFromDrawer(String routeName) {
    Navigator.of(context).pop(); 
    final currentNavigator = _navigatorKeys[_currentIndex].currentState;
    if (currentNavigator != null) {
      currentNavigator.pushNamed(routeName);
    } else {
      Navigator.of(context).pushNamed(routeName);
    }
  }

  

  Widget _buildTransformedContent() {
    return WillPopScope(
      onWillPop: () async {
        final currentNavigator = _navigatorKeys[_currentIndex].currentState;
        if (currentNavigator != null && currentNavigator.canPop()) {
          currentNavigator.pop();
          return false;
        }
        if (_tabHistory.isNotEmpty) {
          setState(() {
            _currentIndex = _tabHistory.last;
            _tabHistory.removeLast();
          });
          return false;
        }
        return true;
      },
      child: Stack(
        children: List.generate(
          _navigatorKeys.length,
          (index) => _buildOffstageNavigator(index),
        ),
      ),
    );
  }

  /// Beautiful Drawer
  Widget _buildDrawer() {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Drawer(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(24)),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [CustomColors.secondary.withOpacity(0.06), Colors.transparent]
                : [Colors.white, Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
                    Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  children: [
                    DrawerItem(
                      icon: IconlyLight.home,
                      title: 'Home',
                      subtitle: 'Go to home',
                      onTap: () => _pushRouteFromDrawer(Routes.homeScreen),
                    ),
                    DrawerItem(
                      icon: Icons.whatshot,
                      title: 'Flame Enthusiasm',
                      subtitle: 'Show your Enthusiasm',
                      onTap: () => _pushRouteFromDrawer(Routes.flameOfEnthusiasm),
                    ),
                    DrawerItem(
                      icon: IconlyLight.profile,
                      title: 'Statistics',
                      subtitle: 'View your Statistics',
                      onTap: () => _pushRouteFromDrawer(Routes.staticsScreen),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'v1.0.0',
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                    ),
                  
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    BottomAppBarSize().init(context);
    final Widget? bottomNavWidget = bottomNav();

    final double navHeight = bottomNavWidget != null
        ? BottomAppBarSize.blockSizeHorizontal * 18
        : 0.0;
        final double bottomInset = navHeight + MediaQuery.of(context).padding.bottom;
    return Scaffold(
      extendBody: true,
      drawer: _buildDrawer(),
      bottomNavigationBar: bottomNav(),
      body: Padding(
        padding: EdgeInsets.only(bottom: bottomInset),
        child: _buildTransformedContent(),
      ),
    );
  }

  bottomNav() {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      return SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            BottomAppBarSize.blockSizeHorizontal * 4.5,
            0,
            BottomAppBarSize.blockSizeHorizontal * 4.5,
            0,
          ),
          child: Material(
            borderRadius: BorderRadius.circular(30),
            elevation: 6,
            child: Container(
              height: BottomAppBarSize.blockSizeHorizontal * 18,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: isDark ? CustomColors.secondary.withOpacity(0.9) : CustomColors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    bottom: 0,
                    left: BottomAppBarSize.blockSizeHorizontal * 3,
                    right: BottomAppBarSize.blockSizeHorizontal * 3,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        BottomNavBTN(
                          onPressed: _onItemTapped,
                          icon: IconlyLight.home,
                          currentIndex: _currentIndex,
                          index: 0,
                        ),
                        BottomNavBTN(
                          onPressed: _onItemTapped,
                          icon: IconlyLight.profile,
                          currentIndex: _currentIndex,
                          index: 1,
                        ),
                        BottomNavBTN(
                          onPressed: _onItemTapped,
                          icon: Icons.school,
                          currentIndex: _currentIndex,
                          index: 2,
                        ),
                        BottomNavBTN(
                          onPressed: _onItemTapped,
                          icon: IconlyLight.search,
                          currentIndex: _currentIndex,
                          index: 3,
                        ),
                      ],
                    ),
                  ),
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.decelerate,
                    top: 0,
                    left: animatedPositionedLeftValue(_currentIndex, context),
                    child: Column(
                      children: [
                        Container(
                          height: BottomAppBarSize.blockSizeHorizontal * 1.0,
                          width: BottomAppBarSize.blockSizeHorizontal * 12,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [
                              CustomColors.primary,
                              CustomColors.primary2,
                            ]),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        ClipPath(
                          clipper: MyCustomClipper(),
                          child: Container(
                            height: BottomAppBarSize.blockSizeHorizontal * 15,
                            width: BottomAppBarSize.blockSizeHorizontal * 12,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: gradient,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      );
    }
    return null;
  }
}

class DrawerItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  const DrawerItem({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return ListTile(
      leading: Icon(icon, size: 22, color: isDark ? Colors.white70 : Colors.black87),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.w600)),
      subtitle: subtitle != null ? Text(subtitle!, style: TextStyle(fontSize: 12)) : null,
      trailing: Icon(Icons.chevron_right),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      hoverColor: Colors.grey.shade100,
    );
  }
}
