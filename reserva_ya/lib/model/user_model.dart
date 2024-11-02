import 'package:reserva_ya/model/Contact_Model.dart';
import 'package:reserva_ya/model/app_constants.dart';
import 'package:reserva_ya/model/booking_model.dart';
import 'package:reserva_ya/model/conversation_model.dart';
import 'package:reserva_ya/model/posting_model.dart';
import 'package:reserva_ya/model/review_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class UserModel extends ContactModel{
  String? email;
  String? contrasena;
  String? bio;
  String? ciudad;
  String? pais;
  bool? isHost;
  bool? isCurrentlyHosting;
  DocumentSnapshot? snapshot;

  List<BookingModel>? bookings;
  List<ReviewModel>? reviews;
  List<PostingModel>? savedPostings;

  List<PostingModel>? myPostings;

  UserModel({
    String id = "", 
    String apellido = "", 
    String nombre = "", 
    MemoryImage? displayImage, 
    this.email,
    this.contrasena,
    this.ciudad,
    this.bio,
    this.pais,
    this.snapshot,
  }) : super(id: id, nombre: nombre, apellido: apellido, displayImage: displayImage) {
    isHost = false;
    isCurrentlyHosting = false;
    bookings = [];
    reviews = [];
    myPostings = [];
    savedPostings = [];
  }

  Future <void> saveUserToFirestore() async{
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

  createContactFromUser(){
    return ContactModel(
      id: id,
      nombre: nombre,
      apellido: apellido,
      displayImage: displayImage
    );

  }

  addPostingToMyPostings(PostingModel posting) async {
    myPostings!.add(posting);

    List<String> myPostingIDsList = [];

    myPostings!.forEach((element){
      myPostingIDsList.add(element.id!);

    });

    await FirebaseFirestore.instance.collection("users").doc(id).update({
      "myPostingsIDs": myPostingIDsList,

    });

  }

  ContactModel createContactFromUserModel() {
    return ContactModel(
      id: this.id,
      nombre: this.nombre,
      apellido: this.apellido,
      displayImage: this.displayImage,
    );
  }

  getMyPostingsFromFirestore() async {
    List<String> myPostingsIDs = List<String>.from(snapshot!["myPostingsIDs"])?? [];
    
    for (String postingID in myPostingsIDs) {
          PostingModel posting = PostingModel(id: postingID);
          await posting.getPostingInfoFromFirestore(); // Recupera la info desde Firestore
          await posting.getAllImagesFromStorage();
          await posting.getAllBookingsFromFirestore();
          myPostings!.add(posting);
    }
  }

  addSavedPosting(PostingModel posting) async {
    for(var savedPosting in savedPostings!){
      if (savedPosting.id == posting.id) {
        return;
        
      }

    }
    savedPostings!.add(posting);
    List<String> savedPostingIDs = [];
    savedPostings!.forEach((savedPosting){
      savedPostingIDs.add(savedPosting.id!);
    });
    await FirebaseFirestore.instance.collection("users").doc(id).update({
      'savedPostingIDs' : savedPostingIDs,
    });
    Get.snackbar("marcado como favorito", "agregado a la lista de favoritos");

  }

  removeSavedPosting(PostingModel posting) async{
    for(int i=0; i < savedPostings!.length; i++){
      if(savedPostings![i].id == posting.id){
        savedPostings!.removeAt(i);
        break;

      }
    }
    List<String> savedPostingIDs = [];
    savedPostings!.forEach((savedPosting){
      savedPostingIDs.add(savedPosting.id!);
    });
    await FirebaseFirestore.instance.collection("users").doc(id).update({
      'savedPostingIDs' : savedPostingIDs,
    });
    Get.snackbar("Eliminar favorito", "eliminado de la lista de favoritos");
  }

  //aqui no me guarda la informacion
  Future<void> addBookingToFirestore(BookingModel booking, double totalPriceForAllNights, String hostID) async {
      try {

          Map<String, dynamic> data = {
              'dates': booking.dates,
              'postingID': booking.posting!.id
          };
          
          await FirebaseFirestore.instance.doc('users/$id/bookings/${booking.id}').set(data);

          //actualizar ganancias totales
          String earningsOld = "";
          await FirebaseFirestore.instance.collection("users").doc(hostID).get().then((dataSnap){
            earningsOld = dataSnap["earnings"].toString();
          });
          

          await FirebaseFirestore.instance.collection("users").doc(hostID).update({
              "earnings": totalPriceForAllNights + double.parse(earningsOld),
          });
          
          bookings!.add(booking);
          await addBookingConversation(booking, hostID);
      } catch (e) {
          print("Error al guardar la reserva: $e");
      }
  }

  addBookingConversation(BookingModel booking, String hostID) async {
    ConversationModel conversation = ConversationModel();
    conversation.addConversationToFirestore(booking.posting!.host!, hostID);
    String textMessage = "Hola mi nombre es ${AppConstants.currentUser!.nombre}"
    "y reserve ${booking.posting!.name}"
    "desde ${booking.dates!.first} hasta ${booking.dates!.last}";
    await conversation.addMessageToFirestore(textMessage);
  }

  List<DateTime> getAllBookedDates(){
    List<DateTime> allBookedDates = [];

    myPostings!.forEach((posting){
      posting.bookings!.forEach((booking){
        allBookedDates.addAll(booking.dates!);
      });
    });
    return allBookedDates;
  }


}
