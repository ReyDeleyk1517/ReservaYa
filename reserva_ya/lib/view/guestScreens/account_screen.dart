import 'package:reserva_ya/model/app_constants.dart';
import 'package:reserva_ya/view/guest_home_screen.dart';
import 'package:reserva_ya/view/host_home_screen.dart';
import 'package:reserva_ya/view_model/user_view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  String _hostingTitle = "Muestra el dashboard de host";

  modifyHostingMode() async{
    if(AppConstants.currentUser.isHost!){
      if(AppConstants.currentUser.isCurrentlyHosting!){
        AppConstants.currentUser.isCurrentlyHosting = false;
        Get.to(GuestHomeScreen());

      }
      else{
        AppConstants.currentUser.isCurrentlyHosting = true;
        Get.to(HostHomeScreen(index: 1,));

      }
    }
    else{
      await UserViewModel().BecomeHost(FirebaseAuth.instance.currentUser!.uid);
      AppConstants.currentUser.isCurrentlyHosting = true;
      Get.to(HostHomeScreen(index: 1,));

    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if(AppConstants.currentUser.isHost!){
      if(AppConstants.currentUser.isCurrentlyHosting!){
        _hostingTitle = "Muestra el dashboard de guest";

      }
      else{
        _hostingTitle = "Muestra el dashboard de host";

      }
    }
    else{
      _hostingTitle = "Vuelvete un host";

    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(25, 50, 20, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            //info usuario
            Padding(
              padding: const EdgeInsets.only(bottom: 30.0),
              child: Center(
                child: Column(
                  children: [

                    // Foto
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

                    // Falta la coma aquí
                    const SizedBox(
                      height: 60,
                    ),

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
                        // Falta la coma aquí
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
            
            //botones
            ListView(
              shrinkWrap: true,
              children: [

                //boton info personal
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.pinkAccent,
                        Colors.amber,
                      ],
                      begin: FractionalOffset(0, 0),
                      end: FractionalOffset(1, 0),
                      stops: [0, 1],
                      tileMode: TileMode.clamp,
                    ),
                  ),

                  
                  child: MaterialButton(
                    height: MediaQuery.of(context).size.height / 9.1,
                    onPressed: (){
                      
                    },
                    child: const ListTile(
                      contentPadding: const EdgeInsets.all(0.0),
                      leading: Text(
                        "informacion personal",
                        style: const TextStyle(
                          fontSize: 18.5,
                          fontWeight: FontWeight.normal
                        ),
                      ),
                      trailing: Icon(
                        size: 24,
                        Icons.person_2
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10,),

                //boton cambiar informacion host
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.pinkAccent,
                        Colors.amber,
                      ],
                      begin: FractionalOffset(0, 0),
                      end: FractionalOffset(1, 0),
                      stops: [0, 1],
                      tileMode: TileMode.clamp,
                    ),
                  ),

                  
                  child: MaterialButton(
                    height: MediaQuery.of(context).size.height / 9.1,
                    onPressed: (){
                      modifyHostingMode();
                    },
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(0.0),
                      leading: Text(
                        _hostingTitle,
                        style: const TextStyle(
                          fontSize: 18.5,
                          fontWeight: FontWeight.normal
                        ),
                      ),
                      trailing: const Icon(
                        size: 24,
                        Icons.hotel_outlined
                      ),
                    ),
                  ), 
                ),
                const SizedBox(height: 10,),

                //boton logout
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.pinkAccent,
                        Colors.amber,
                      ],
                      begin: FractionalOffset(0, 0),
                      end: FractionalOffset(1, 0),
                      stops: [0, 1],
                      tileMode: TileMode.clamp,
                    ),
                  ),

                  
                  child: MaterialButton(
                    height: MediaQuery.of(context).size.height / 9.1,
                    onPressed: (){
                      
                    },
                    child: const ListTile(
                      contentPadding: const EdgeInsets.all(0.0),
                      leading: Text(
                        "Cerrar secion",
                        style: const TextStyle(
                          fontSize: 18.5,
                          fontWeight: FontWeight.normal
                        ),
                      ),
                      trailing: Icon(
                        size: 24,
                        Icons.login_outlined,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10,),
                

              ],
            )
          ],
        ),
      ),
    );
  }
}
