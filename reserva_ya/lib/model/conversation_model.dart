import 'package:reserva_ya/model/app_constants.dart';
import 'package:reserva_ya/model/contact_model.dart';
import 'package:reserva_ya/model/message_model.dart';

class ConversationModel {
  String? id;
  ContactModel? otherContact;
  List<MessageModel>? messages;
  MessageModel? message;

  ConversationModel(){
    messages = [];
  }

  addConversationToFirestore(ContactModel otherContact, String hostID) async{
    List<String> userNames=[
      AppConstants.currentUser.GetFullNameOfUser(),
    ];

    List<String> userIDs=[
      AppConstants.currentUser.id!,
      hostID
    ];


  }
}