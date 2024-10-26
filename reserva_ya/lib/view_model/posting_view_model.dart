import 'dart:typed_data';
import 'dart:io';
import 'package:reserva_ya/model/app_constants.dart';
import 'package:reserva_ya/model/posting_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:reserva_ya/global.dart';
import 'package:flutter/material.dart';

class PostingViewModel {
  addListingInfoToFirestore() async {
    
    postingModel.setImagesNames();

    Map<String, dynamic> dataMap = {
      "hostID": AppConstants.currentUser.id,
      "name": postingModel.name,
      "type": postingModel.type,
      "price": postingModel.price,
      "description": postingModel.description,
      "address": postingModel.address,
      "city": postingModel.city,
      "country": postingModel.country,
      "rating": 3.5,
      
      "imageNames": postingModel.imageNames,
      "amenities": postingModel.amenities,
      "beds": postingModel.beds,
      "bathrooms": postingModel.bathrooms,
    };

    // Guardar dataMap en Firestore
    DocumentReference ref = await FirebaseFirestore.instance.collection("postings").add(dataMap);
    postingModel.id = ref.id;
    await AppConstants.currentUser.addPostingToMyPostings(postingModel);
  }

  updatePostingInfoToFirestore() async {
    
    postingModel.setImagesNames();

    Map<String, dynamic> dataMap = {
      "hostID": AppConstants.currentUser.id,
      "name": postingModel.name,
      "type": postingModel.type,
      "price": postingModel.price,
      "description": postingModel.description,
      "address": postingModel.address,
      "city": postingModel.city,
      "country": postingModel.country,
      "rating": 3.5,
      
      "imageNames": postingModel.imageNames,
      "amenities": postingModel.amenities,
      "beds": postingModel.beds,
      "bathrooms": postingModel.bathrooms,
    };

    
    await FirebaseFirestore.instance.collection("postings").doc(postingModel.id).update(dataMap);

  }


  addImagesToFirebaseStorage() async {
    
    for (int i = 0; i < postingModel.displayImages!.length; i++) {
      Reference ref = FirebaseStorage.instance.ref()
      .child("postingImages")
      .child(postingModel.id!)
      .child(postingModel.imageNames![i]);

      await ref.putData(postingModel.displayImages![i].bytes).whenComplete(() {});
      
    }
  }
}
