import 'dart:io';
import 'package:reserva_ya/global.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailTextEditingController = TextEditingController();
  final TextEditingController _passwordTextEditingController = TextEditingController();
  final TextEditingController _firstNameTextEditingController = TextEditingController();
  final TextEditingController _lastNameTextEditingController = TextEditingController();
  final TextEditingController _cityTextEditingController = TextEditingController();
  final TextEditingController _countryTextEditingController = TextEditingController();
  final TextEditingController _bioTextEditingController = TextEditingController();

  File? imageFileOfUser;

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
        title: const Text(
          "Crea una cuenta",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
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
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Image.asset(
                "assets/images/signup.png",
                width: 240,
              ),
            ),
            const Text(
              "Ingresa tus datos",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
                color: const Color.fromARGB(255, 6, 84, 148),
              ),
            ),
            const SizedBox(height: 30),

            //formulario de registro
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Nombre
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: "Nombre",
                        border: OutlineInputBorder(),
                      ),
                      controller: _firstNameTextEditingController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Por favor ingresa tu nombre";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    // Apellido
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: "Apellido",
                        border: OutlineInputBorder(),
                      ),
                      controller: _lastNameTextEditingController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Por favor ingresa tu apellido";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    // Email
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: "Email",
                        border: OutlineInputBorder(),
                      ),
                      controller: _emailTextEditingController,
                      validator: (value) {
                        if (value == null || !value.contains("@")) {
                          return "Por favor ingresa un email válido";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    // Contraseña
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: "Contraseña",
                        border: OutlineInputBorder(),
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
                    const SizedBox(height: 15),
                    // Ciudad
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: "Ciudad",
                        border: OutlineInputBorder(),
                      ),
                      controller: _cityTextEditingController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Por favor ingresa tu ciudad";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    // País
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: "País",
                        border: OutlineInputBorder(),
                      ),
                      controller: _countryTextEditingController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Por favor ingresa tu país";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    // Biografía
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: "Biografía",
                        border: OutlineInputBorder(),
                      ),
                      controller: _bioTextEditingController,
                      maxLines: 3,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Por favor ingresa una breve biografía";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
            
            //agregar foto
            Padding(
              padding: const EdgeInsets.only(top: 25),
              child: MaterialButton(
                onPressed: () async {
                  var imageFile = await ImagePicker().pickImage(source: ImageSource.gallery);

                  if(imageFile != null){
                    imageFileOfUser = File(imageFile.path);

                    setState(() {
                      imageFileOfUser;
                    });
                  }

                },
                child: imageFileOfUser == null
                    ? const Icon(Icons.add_a_photo)
                    : CircleAvatar(
                        backgroundColor: Colors.pink,
                        radius: MediaQuery.of(context).size.width / 5.0,
                        child: CircleAvatar(
                          backgroundImage: FileImage(imageFileOfUser!),
                          radius: MediaQuery.of(context).size.width / 5.0,
                        ),
                      ),
              ),
            ),
            
            //boton para registrarse
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // Perform signup action
                  userViewModel.signUp(
                    _emailTextEditingController.text.trim(),
                    _passwordTextEditingController.text.trim(),
                    _firstNameTextEditingController.text.trim(),
                    _lastNameTextEditingController.text.trim(),
                    _cityTextEditingController.text.trim(),
                    _countryTextEditingController.text.trim(),
                    _bioTextEditingController.text.trim(),
                    imageFileOfUser
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 6, 84, 148),
                padding: const EdgeInsets.symmetric(horizontal: 90),
              ),
              child: const Text(
                'Registrarse',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22.0,
                  color: Colors.white,
                ),
              ),
            ),

            const SizedBox(
              height: 60,
            ),

            
          ],
        ),
      ),
    );
  }
}
