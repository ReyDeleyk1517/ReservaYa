import 'package:reserva_ya/model/app_constants.dart';
import 'package:reserva_ya/view/hostScreens/create_posting_screen.dart';
import 'package:reserva_ya/view/widgets/posting_list_tile.dart';
import 'package:reserva_ya/view/widgets/posting_listing_ui.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyPostingsScreen extends StatefulWidget {
  const MyPostingsScreen({super.key});

  @override
  State<MyPostingsScreen> createState() => _MyPostingsScreenState();
}

class _MyPostingsScreenState extends State<MyPostingsScreen> {
  // Ejemplo de cantidad de elementos
  

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 25),
      child: ListView.builder(
        itemCount: AppConstants.currentUser.myPostings!.length + 1, 
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(26, 0, 26, 26),
            child: InkResponse(
              onTap: () {
                Get.to(CreatePostingScreen(
                  posting: (index == AppConstants.currentUser.myPostings!.length) ? null: 
                  AppConstants.currentUser.myPostings![index],
                ));
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                    width: 1.2,
                  ),
                ),
                child: (index == AppConstants.currentUser.myPostings!.length) 
                ? PostingListTile() 
                : PostingListTileUI(posting: AppConstants.currentUser.myPostings![index]),
              ),
            ),
          );
        },
      ),
    );
  }
}