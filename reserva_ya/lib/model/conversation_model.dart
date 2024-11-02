import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:reserva_ya/model/app_constants.dart';
import 'package:reserva_ya/model/contact_model.dart';
import 'package:reserva_ya/model/message_model.dart';

class ConversationModel {
  String? id;
  //String hostName='';
  ContactModel? otherContact;
  List<MessageModel>? messages;
  MessageModel? lastMessage;

  ConversationModel(){
    messages = [];
  }

  addConversationToFirestore(ContactModel otherContact, String hostID) async{
    
    List<String> userNames=[
      AppConstants.currentUser.GetFullNameOfUser(),
      otherContact.GetFullNameOfUser()
    ];

    List<String> userIDs=[
      AppConstants.currentUser.id!,
      hostID
    ];

    Map<String,dynamic> ConversationDataMap = {
      'lastMessageDateTime': DateTime.now(),
      'lastMessageText': "",
      'userNames': userNames,
      'userIDs': userIDs,
    };
    DocumentReference reference = await FirebaseFirestore.instance.collection('conversations').add(ConversationDataMap);
    id = reference.id;
  }

  addMessageToFirestore(String messageText) async {
    Map<String,dynamic> messageData= {
      'dateTime': DateTime.now(),
      'senderID': AppConstants.currentUser!.id,
      'text': messageText
    };

    await FirebaseFirestore.instance.collection('conversations/${id}/messages').add(messageData);

    Map<String,dynamic> conversationData= {
      'lastMessageDateTime': DateTime.now(),
      'lastMessageText': messageText,
    };
    await FirebaseFirestore.instance.doc('conversations/${id}').update(conversationData);

  }
  getConversationInfoFromFirestore(DocumentSnapshot snapshot){
    id: snapshot.id;
    String lastMessageText = snapshot['lastMessageText']?? "";
    Timestamp lastMessageDateTimeStamp = snapshot['lastMessageDateTime'] ?? Timestamp.now();
    DateTime lastMessageDateTime = lastMessageDateTimeStamp.toDate();

    lastMessage = MessageModel();
    lastMessage!.dateTime = lastMessageDateTime;
    lastMessage!.text = lastMessageText;

    List<String> userIDs = List<String>.from(snapshot['userIDs']) ?? [];
    List<String> userNames = List<String>.from(snapshot['userNames']) ?? [];
    otherContact = ContactModel();
    for (String userID in userIDs) {
      if (userID != AppConstants.currentUser.id) {
        otherContact!.id = userID;
        break;
        
      }
      
    }
    
    for (String name in userNames) {
      if (name != AppConstants.currentUser.GetFullNameOfUser()) {
        otherContact!.nombre = name.split(" ")[0];
        otherContact!.apellido = name.split(" ")[1];
        
      }
      
    }
    


  }
}