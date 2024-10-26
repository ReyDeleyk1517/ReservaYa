import 'package:reserva_ya/view/signup_screen.dart';
import 'package:reserva_ya/view_model/user_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailTextEditingController = TextEditingController();
  final TextEditingController _passwordTextEditingController = TextEditingController();
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
        
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            Image.asset(
              "images/logo.png",
            ),
            const SizedBox(height: 20),
            const Text(
              "Bienvenido a ReservaYa",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
                color: const Color.fromARGB(255, 6, 84, 148),
              ),
            ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 26.0),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: "Email",
                          border: OutlineInputBorder(),
                        ),
                        style: const TextStyle(
                          fontSize: 24,
                        ),
                        controller: _emailTextEditingController,
                        validator: (value) {
                          if (value == null || !value.contains("@")) {
                            return "Por favor ingresa un email válido";
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 21.0),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: "Contraseña",
                          border: OutlineInputBorder(),
                        ),
                        style: const TextStyle(
                          fontSize: 24,
                        ),
                        controller: _passwordTextEditingController,
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.length < 6) {
                            return "Por favor ingresa una contraseña de al menos 6 caracteres";
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 30),

                    // boton login
                    
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          await UserViewModel().login(
                            _emailTextEditingController.text.trim(),
                            _passwordTextEditingController.text.trim(),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 6, 84, 148),
                        padding: const EdgeInsets.symmetric(horizontal: 90),
                      ),
                      child: const Text(
                        'Iniciar sesión',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22.0,
                          color: Colors.white,
                        ),
                      ),
                    ),


                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: () {
                        Get.to(SignupScreen());
                      },
                      child: const Text(
                        "¿No tienes una cuenta? Crear una",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 60,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
