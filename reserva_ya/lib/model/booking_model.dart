import 'package:reserva_ya/model/contact_model.dart';
import 'package:reserva_ya/model/posting_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BookingModel {
  String id = "id";
  PostingModel? posting;
  ContactModel? contact;
  List<DateTime>? dates;

  BookingModel();

  getBookingInfoFromFirestoreFromPosting(PostingModel posting, DocumentSnapshot snapshot) async{
    posting = posting;
    List<Timestamp> timestamps = List<Timestamp>.from(snapshot['dates']) ?? [];

    dates = [];
    timestamps.forEach((timestamp){
      dates!.add((timestamp.toDate()));
    });

    String contactID = snapshot['userID'] ?? "";
    String FullName = snapshot['name'] ?? "";
    _loadContactInfo(id, FullName);
    contact = ContactModel(id: contactID);
    
  }

  _loadContactInfo(String id, String fullName) async{
    String firstName = "";
    String lastName = "";
    firstName = fullName.split(" ")[0];
    lastName = fullName.split(" ")[0];

    contact = ContactModel(id: id, nombre: firstName, apellido: lastName);

  }
}