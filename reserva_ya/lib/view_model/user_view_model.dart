import 'dart:io';
import 'package:reserva_ya/model/app_constants.dart';
import 'package:reserva_ya/model/user_model.dart';
import 'package:reserva_ya/view/guest_home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';


class UserViewModel {

  UserModel userModel = UserModel();

  signUp(email, contrasena, nombre, apellido, ciudad, pais, bio, imageFileOfUser) async{
    Get.snackbar("Espera", "su cuenta se esta creando");
    try{
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: contrasena,
      ).then((result) async {
          String currentUserId = result.user!.uid;

          AppConstants.currentUser.id = currentUserId;
          AppConstants.currentUser.email = email;
          AppConstants.currentUser.contrasena = contrasena;
          AppConstants.currentUser.nombre = nombre;
          AppConstants.currentUser.apellido = apellido;
          AppConstants.currentUser.ciudad = ciudad;
          AppConstants.currentUser.pais = pais;

          await saveUserToFirestore(bio, ciudad, pais, email, nombre, apellido, currentUserId)
          .whenComplete(() async{
            await addImageToFirebaseStorage(imageFileOfUser, currentUserId);
          });
          Get.to(GuestHomeScreen());
          Get.snackbar("Felicidades", "su cuenta ha sido creada");

      });
    }
    catch(e){
      Get.snackbar("Error", e.toString());
    }

  }

  login(email, contrasena) async{
    Get.snackbar("Espere", "Validando informacion");
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: contrasena,
      ).then((result) async {
            String currentUserId = result.user!.uid;
            AppConstants.currentUser.id = currentUserId;
            await getUserInfoFromFirestore(currentUserId);
            await getImageFromStorage(currentUserId);

            await AppConstants.currentUser.getMyPostingsFromFirestore();
            Get.snackbar("Inicio Secion", "Haz iniciado secion satisfactoriamente");
            Get.to(GuestHomeScreen());
          

      });
    }
    catch(e){
      Get.snackbar("Error", e.toString());
    }

  }

  getUserInfoFromFirestore(String userID) async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('users').doc(userID).get();

    AppConstants.currentUser.snapshot = snapshot;
    AppConstants.currentUser.nombre = snapshot["nombre"] ?? "";
    AppConstants.currentUser.apellido = snapshot["apellido"] ?? "";
    AppConstants.currentUser.email = snapshot["email"] ?? "";
    AppConstants.currentUser.bio = snapshot["bio"] ?? "";
    AppConstants.currentUser.ciudad = snapshot["ciudad"] ?? "";
    AppConstants.currentUser.pais = snapshot["pais"] ?? "";
    
    // Ensure this is a boolean value; default to false if null
    AppConstants.currentUser.isHost = snapshot["isHost"] ?? false;
  }


  getImageFromStorage(userID) async {
    if(AppConstants.currentUser.displayImage != null){
      return AppConstants.currentUser.displayImage;
    }
    final imageDataInBytes = await FirebaseStorage.instance.ref()
      .child("userImages")
      .child(userID)
      .child(userID + ".png")
      .getData(1024 * 1024);
    
    AppConstants.currentUser.displayImage = MemoryImage(imageDataInBytes!);

    return AppConstants.currentUser.displayImage;



  }

  Future <void> saveUserToFirestore(bio, ciudad, pais, email, nombre, apellido, id) async{
    Map<String, dynamic> datamap = {
      "bio": bio,
      "ciudad": ciudad,
      "pais": pais,
      "email": email,
      "nombre": nombre,
      "apellido": apellido,
      "isHost": false,
      "myPostingsIDs": [],
      "earnings": 0,
    };

    await FirebaseFirestore.instance.collection("users").doc(id).set(datamap);

  }

  addImageToFirebaseStorage(File imageFileOfUser, currentUserId) async {
    Reference referenceStorage = FirebaseStorage.instance.ref()
      .child("userImages")
      .child(currentUserId)
      .child(currentUserId + ".png");
    await referenceStorage.putFile(imageFileOfUser).whenComplete((){});

    AppConstants.currentUser.displayImage = MemoryImage(imageFileOfUser.readAsBytesSync());

  }

  BecomeHost(String userID) async {
    userModel.isHost = true;

    Map<String, dynamic> dataMap={
      "isHost": true,
    };
    await FirebaseFirestore.instance.collection("users").doc(userID).update(dataMap);
  }

  ModifyCurrentlyHosting(bool isHosting) async {
    
    userModel.isCurrentlyHosting = isHosting;

  }

}