import 'package:reserva_ya/model/app_constants.dart';
import 'package:reserva_ya/view/finances_home_screen.dart';
import 'package:reserva_ya/view/guest_home_screen.dart';
import 'package:reserva_ya/view/homework_home_screen.dart';
import 'package:reserva_ya/view/host_home_screen.dart';
import 'package:reserva_ya/view_model/user_view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  String _hostingTitle = "Muestra el dashboard de host";

  modifyHostingMode() async {
    if (AppConstants.currentUser.isHost!) {
      if (AppConstants.currentUser.isCurrentlyHosting!) {
        AppConstants.currentUser.isCurrentlyHosting = false;
        Get.to(GuestHomeScreen());
      } else {
        AppConstants.currentUser.isCurrentlyHosting = true;
        Get.to(HostHomeScreen(index: 1));
      }
    } else {
      await UserViewModel().BecomeHost(FirebaseAuth.instance.currentUser!.uid);
      AppConstants.currentUser.isCurrentlyHosting = true;
      Get.to(HostHomeScreen(index: 1));
    }
  }

  getToFinanceScreen() async {
    //error parameter index is not defined
    Get.to(FinancesHomeScreen());
  }

  getToHomeworkScreen() async {
    //error parameter index is not defined
    Get.to(HomeworkHomeScreen());
  }

  @override
  void initState() {
    super.initState();

    if (AppConstants.currentUser.isHost!) {
      _hostingTitle = AppConstants.currentUser.isCurrentlyHosting!
          ? "Modo huesped"
          : "Modo hospedador";
    } else {
      _hostingTitle = "Vuelvete un hospedador";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(25, 50, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Info de usuario
            Padding(
              padding: const EdgeInsets.only(bottom: 30.0),
              child: Center(
                child: Column(
                  children: [
                    MaterialButton(
                      onPressed: () {},
                      child: CircleAvatar(
                        backgroundColor: Colors.black,
                        radius: MediaQuery.of(context).size.width / 4.5,
                        child: CircleAvatar(
                          backgroundImage: AppConstants.currentUser.displayImage,
                          radius: MediaQuery.of(context).size.width / 4.6,
                        ),
                      ),
                    ),
                    const SizedBox(height: 60),
                    // Nombre y email
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          AppConstants.currentUser.GetFullNameOfUser(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          AppConstants.currentUser.email.toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Botones
            _buildButton("informacion personal", Icons.person_2, () {}),
            const SizedBox(height: 10),
            _buildButton(_hostingTitle, Icons.hotel_outlined, modifyHostingMode),
            const SizedBox(height: 10),
            _buildButton("Asistente de finanzas", Icons.currency_exchange, getToFinanceScreen),
            const SizedBox(height: 10),
            _buildButton("Agenda de tareas", Icons.book, getToHomeworkScreen),
            const SizedBox(height: 10),
            _buildButton("Cerrar sesion", Icons.login_outlined, () {}),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(String title, IconData icon, VoidCallback onPressed) {
    return Container(
      width: double.infinity,
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
      child: MaterialButton(
        height: 70,
        onPressed: onPressed,
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Text(
            title,
            style: const TextStyle(
              fontSize: 18.5,
              fontWeight: FontWeight.normal,
            ),
          ),
          trailing: Icon(icon, size: 24),
        ),
      ),
    );
  }
}
