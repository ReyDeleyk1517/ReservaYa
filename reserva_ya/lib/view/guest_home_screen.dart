import 'package:reserva_ya/view/guestScreens/account_screen.dart';
import 'package:reserva_ya/view/guestScreens/explore_screen.dart';
import 'package:reserva_ya/view/guestScreens/inbox_screen.dart';
import 'package:reserva_ya/view/guestScreens/save_listings_screen.dart';
import 'package:reserva_ya/view/guestScreens/trips_screen.dart';
import 'package:flutter/material.dart';


class GuestHomeScreen extends StatefulWidget {
  const GuestHomeScreen({super.key});

  @override
  State<GuestHomeScreen> createState() => _GuestHomeScreenState();
}

class _GuestHomeScreenState extends State<GuestHomeScreen>{

  int selectedIndex = 0;

  final List<String> stringTitles = [
    'Explorar',
    'Guardar',
    'Rutas',
    'Inbox',
    'Perfil',
  ];

  final List<Widget> screens = [
    ExploreScreen(),
    SavedListingsScreen(),
    TripsScreen(),
    InboxScreen(),
    AccountScreen(),
  ];

  BottomNavigationBarItem customNavigationBarItem(int index, IconData iconData, String title){
    return BottomNavigationBarItem(
      icon: Icon(
        iconData,
        color: Colors.black,
      ),
      activeIcon: Icon(
        iconData,
        color: Colors.deepPurple,
      ),
      label: title,

    );
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.blueAccent,
                Colors.lightBlueAccent,
              ],
              begin: FractionalOffset(0, 0),
              end: FractionalOffset(1, 0),
              stops: [0, 1],
              tileMode: TileMode.clamp,
            ),
          ),
        ),
        title: Text(
          stringTitles[selectedIndex],
          style: const TextStyle(
            fontSize: 18,
            color: Colors.white
          ),
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: screens[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: (i){
          setState(() {
            selectedIndex=i;
          });
        },
        currentIndex: selectedIndex,
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          customNavigationBarItem(0, Icons.search, stringTitles[0]),
          customNavigationBarItem(1, Icons.favorite_outline, stringTitles[1]),
          customNavigationBarItem(2, Icons.train, stringTitles[2]),
          customNavigationBarItem(3, Icons.message, stringTitles[3]),
          customNavigationBarItem(4, Icons.person_outline, stringTitles[4]),
        ],
      ),
    );
  }
}
