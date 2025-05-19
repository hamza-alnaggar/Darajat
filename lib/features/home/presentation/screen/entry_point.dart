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

  final Set<int> _tabHistory = {};

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
        return Routes.instructionView;
      case 3:
        return Routes.courseDetailsScreen;
      default:
        return Routes.homeScreen;
    }
  }

  // When a new tab is selected, update the selected index and maintain tab history.
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


  Widget _buildTransformedContent() {
    return WillPopScope(
              onWillPop: () async {
                final currentNavigator =
                    _navigatorKeys[_currentIndex].currentState;
                if (currentNavigator != null && currentNavigator.canPop()) {
                  currentNavigator.pop();
                  return false;
                }
                if (_tabHistory.isNotEmpty) {
                  setState(() {
                    _currentIndex = _tabHistory.last;
                    _tabHistory.remove(_currentIndex);
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

  @override
  Widget build(BuildContext context) {
    BottomAppBarSize().init(context);
    return Scaffold(
      bottomNavigationBar: bottomNav(),
      appBar: AppBar(
        title: Text('درجات',style: TextStyle(letterSpacing: 1.3)),
      ),
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            _buildTransformedContent(),
          ],
        ),
      ),
    );
  }

  Widget bottomNav() {
        final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.fromLTRB(BottomAppBarSize.blockSizeHorizontal * 4.5, 0,
          BottomAppBarSize.blockSizeHorizontal * 4.5, 0),
      child: Material(
        borderRadius: BorderRadius.circular(30),
        elevation: 6,
        child: Container(
            height: BottomAppBarSize.blockSizeHorizontal * 18,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
            
              color:
              // Color(0xffcfebf7),
              isDark ?CustomColors.secondary.withOpacity(0.9): CustomColors.white,
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
                        icon: IconlyLight.search,
                        currentIndex: _currentIndex,
                        index: 1,
                      ),
                      BottomNavBTN(
                        onPressed: _onItemTapped,
                        icon: IconlyLight.category,
                        currentIndex: _currentIndex,
                        index: 2,
                      ),
                      BottomNavBTN(
                        onPressed:_onItemTapped,
                        icon: IconlyLight.setting,
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
                    left: animatedPositionedLEftValue(_currentIndex),
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
                            )),
                          ),
                        ),
                      ],
                    ))
              ],
            )),
      ),
    );
  }
}