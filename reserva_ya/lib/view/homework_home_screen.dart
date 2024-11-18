// Página para ver las tareas
import 'package:reserva_ya/view/guestScreens/account_screen.dart';
import 'package:flutter/material.dart';
import 'package:reserva_ya/view/homeworkScreens/add_homework_screen.dart';
import 'package:reserva_ya/view/homeworkScreens/homework_screen.dart';

class HomeworkHomeScreen extends StatefulWidget {
  const HomeworkHomeScreen({super.key});

  @override
  State<HomeworkHomeScreen> createState() => _HomeworkHomeScreenState();
}

class _HomeworkHomeScreenState extends State<HomeworkHomeScreen> {
  int selectedIndex = 0;

  final List<String> stringTitles = [
    'Agregar',
    'Tareas',
    'Perfil',
  ];

  final List<Widget> screens = [
    AddHomeworkScreen(),
    HomeworkScreen(), // Reemplazamos con HomeworkScreen.
    AccountScreen(),
  ];

  BottomNavigationBarItem customNavigationBarItem(int index, IconData iconData, String title) {
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
  Widget build(BuildContext context) {
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
          style: const TextStyle(fontSize: 18, color: Colors.white),
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: screens[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: (i) {
          setState(() {
            selectedIndex = i;
          });
        },
        currentIndex: selectedIndex,
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          customNavigationBarItem(0, Icons.add, stringTitles[0]),
          customNavigationBarItem(1, Icons.dashboard, stringTitles[1]),
          customNavigationBarItem(2, Icons.person_outline, stringTitles[2]),
        ],
      ),
    );
  }
}
