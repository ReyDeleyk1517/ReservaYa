import 'package:reserva_ya/global.dart';
import 'package:reserva_ya/model/app_constants.dart';
import 'package:reserva_ya/model/posting_model.dart';
import 'package:reserva_ya/view/widgets/posting_grid_tile_ui.dart';
import 'package:reserva_ya/view/widgets/view_posting_screen.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SavedListingsScreen extends StatefulWidget {
  const SavedListingsScreen({super.key});

  @override
  State<SavedListingsScreen> createState() => _SavedListingsScreenState();
}

class _SavedListingsScreenState extends State<SavedListingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(25, 15, 25, 0),
      child: GridView.builder(
        physics: const ScrollPhysics(),
        shrinkWrap: true,
        itemCount: AppConstants.currentUser.savedPostings!.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
          childAspectRatio: 3/4
        ),
        itemBuilder: (context, index) {
          PostingModel currentPosting = AppConstants.currentUser.savedPostings![index];
          return Stack(
            children: [
              InkResponse(
                enableFeedback: true,
                child: PostingGridTileUI(posting: currentPosting,),
                onTap: () {
                  Get.to(ViewPostingScreen(posting: currentPosting,));
                  
                },
                
              ),
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Container(
                    width: 30,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white
                    ),
                    child: IconButton(
                      onPressed: () {
                        AppConstants.currentUser.removeSavedPosting(currentPosting);
                        setState(() {
                          
                        });
                        
                      },
                      padding: const EdgeInsets.all(0),
                      icon: const Icon(
                        Icons.clear,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),

              ),
            ],
          );
        },
      ),
    );
  }
}