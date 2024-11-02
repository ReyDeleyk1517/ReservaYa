import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:reserva_ya/model/app_constants.dart';
import 'package:reserva_ya/model/message_model.dart';

class MessageListTileUi extends StatelessWidget {

  MessageModel? message;
  MessageListTileUi({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    if (message!.sender!.nombre == AppConstants.currentUser.nombre) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 36, 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(left: 11),
                child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Colors.blueAccent,
                        Colors.lightBlueAccent,
                      ],
                      begin: FractionalOffset(0.0, 0.0),
                      end: FractionalOffset(1.0, 0.0),
                      stops: [0.0, 1.0],
                      tileMode: TileMode.clamp
                    ),
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Text(
                          message!.text!,
                          style: const TextStyle(
                            fontSize: 20
                          ),
                          textWidthBasis: TextWidthBasis.parent,
                        ),
                      ),

                      Align(
                        alignment: Alignment.bottomRight,
                        child: Text(
                          message!.getMessageDateTime(),
                          style: const TextStyle(
                            fontSize: 15
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: (){

              },
              child: CircleAvatar(
                backgroundImage: AppConstants.currentUser.displayImage,
                radius: MediaQuery.of(context).size.width / 20,
              ),
            )

          ],
        ),

      );
    }
    else{
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 36, 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: (){

              },
              child: CircleAvatar(
                backgroundImage: message!.sender!.displayImage,
                radius: MediaQuery.of(context).size.width / 20,
              ),
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(left: 11),
                child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color.fromARGB(255, 255, 169, 89),
                        Color.fromARGB(255, 201, 158, 39)
                      ],
                      begin: FractionalOffset(0.0, 0.0),
                      end: FractionalOffset(1.0, 0.0),
                      stops: [0.0, 1.0],
                      tileMode: TileMode.clamp
                    ),
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Text(
                          message!.text!,
                          style: const TextStyle(
                            fontSize: 20
                          ),
                          textWidthBasis: TextWidthBasis.parent,
                        ),
                      ),

                      Align(
                        alignment: Alignment.bottomRight,
                        child: Text(
                          message!.getMessageDateTime(),
                          style: const TextStyle(
                            fontSize: 15
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),

      );
    }
    
  }
}