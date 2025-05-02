import 'package:driver_app/screens/Profile/profile_screen.dart';
import 'package:driver_app/screens/Ride_Request/ride_request.dart';
import 'package:driver_app/screens/Ride_history/ride_history.dart';
import 'package:driver_app/state_classes/localization_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'home_screen.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomeScreen(),
    RideRequestScreen(),
    RideHistoryScreen(),
    ProfileScreen(),
  ];

  Future<bool> _onWillPop() async {
    // Exit the app when back is pressed
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final localization = Provider.of<LocalizationProvider>(context);
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text(localization.translate(
              'app_title'),
              style: TextStyle(
                color: Colors.white,
              ),), // Localization key for "Driver Dashboard"
          backgroundColor: Color(0xFF0E6E2F),
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        body: _pages[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Color(0xFF0E6E2F),
          unselectedItemColor: Colors.grey,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label:
                    localization.translate('bottom_nav_home') // Key for "Home"
                ),
            BottomNavigationBarItem(
                icon: Icon(Icons.request_page),
                label: localization
                    .translate('bottom_nav_requests') // Key for "Earnings"
                ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: localization
                  .translate('bottom_nav_history'), // Key for "Notifications"
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: localization
                  .translate('bottom_nav_profile'), // Key for "Profile"
            ),
          ],
        ),
      ),
    );
  }
}
