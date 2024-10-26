import 'dart:typed_data';
import 'package:reserva_ya/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class ContactModel {
  String? id;
  String? apellido;
  String? nombre;
  String? nombreCompleto;
  MemoryImage? displayImage;

  ContactModel({
    this.id = "",
    this.apellido = "",
    this.nombre = "",
    this.displayImage,
  });

  String GetFullNameOfUser(){
    return (nombre ?? "") + " " + (apellido ?? "");
  }


  UserModel CreateUserFromContact(){
    return UserModel(
      id: id!,
      nombre: nombre!,
      apellido: apellido!,
      displayImage: displayImage!,
    );
  }

  GetContactInfoFromFirestore() async{
    DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('users').doc(id).get();
    nombre = snapshot['nombre'] ?? "";
    apellido = snapshot['apellido'] ?? "";
  }

  Future<MemoryImage?> getImageFromStorage() async {
  // Verificar si ya hay una imagen cargada
  if (displayImage != null) {
    print("No se encontró la imagen");
    return displayImage;
  }

  try {
    // Obtener los datos de la imagen desde Firebase Storage
    final imageData = await FirebaseStorage.instance
        .ref()
        .child("userImages")
        .child(id!)
        .child("$id.png")
        .getData(1024 * 1024);

    // Comprobar si se obtuvieron datos de imagen
    if (imageData != null) {
      displayImage = MemoryImage(imageData);
      return displayImage;
    } else {
      // Manejar el caso donde no se encuentra la imagen
      print("No se encontro una imagen");
      return null;
    }
  } catch (e) {
    // Manejar errores de manera adecuada
    print("Error al obtener la imagen: $e");
    return null;
  }
}


  getImagenPerfil(){
    return displayImage;
  }

}
