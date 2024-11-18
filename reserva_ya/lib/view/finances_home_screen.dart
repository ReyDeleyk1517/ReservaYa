//pagina para ver las finanzas personales
import 'package:reserva_ya/view/financesScreens/add_transaction_screen.dart';
import 'package:reserva_ya/view/financesScreens/dashboard_screen.dart';
import 'package:reserva_ya/view/financesScreens/stadistics_screen.dart';
import 'package:reserva_ya/view/guestScreens/account_screen.dart';
import 'package:flutter/material.dart';


class FinancesHomeScreen extends StatefulWidget {
  const FinancesHomeScreen({super.key});

  @override
  State<FinancesHomeScreen> createState() => _FinancesHomeScreenState();
}

class _FinancesHomeScreenState extends State<FinancesHomeScreen>{

  int selectedIndex = 0;

  final List<String> stringTitles = [
    'Transaccion',
    'Tablero',
    'Estadisticas',
    'Perfil',
  ];

  final List<Widget> screens = [
    AddTransactionScreen(),
    DashboardScreen(),
    StadisticsScreen(),
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
          customNavigationBarItem(0, Icons.add, stringTitles[0]),
          customNavigationBarItem(1, Icons.currency_exchange, stringTitles[1]),
          customNavigationBarItem(2, Icons.dashboard, stringTitles[2]),
          customNavigationBarItem(3, Icons.person_outline, stringTitles[3]),
        ],
      ),
    );
  }
}
