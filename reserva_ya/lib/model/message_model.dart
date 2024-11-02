
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reserva_ya/model/contact_model.dart';
import 'package:timeago/timeago.dart' as timeago;

class MessageModel {
  ContactModel? sender;
  String? text;
  DateTime? dateTime;

  MessageModel();

  getMessageDateTime(){
    return timeago.format(dateTime!, locale: 'es');

  }

  getMessageInfoFromFirestore(DocumentSnapshot snapshot){
    Timestamp lastMessageTimeStamp = snapshot['dateTime']?? Timestamp.now();
    dateTime = lastMessageTimeStamp.toDate();
    String senderID = snapshot['senderID'] ?? "";
    sender = ContactModel(id: senderID);
    text = snapshot['text'] ?? "";

  }
  
}