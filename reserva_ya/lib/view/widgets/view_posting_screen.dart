import 'package:reserva_ya/model/app_constants.dart';
import 'package:reserva_ya/model/posting_model.dart';
import 'package:reserva_ya/view/guestScreens/book_listing_screen.dart';
import 'package:reserva_ya/view/widgets/posting_info_tile_ui.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ViewPostingScreen extends StatefulWidget {
  final PostingModel? posting;

  ViewPostingScreen({super.key, this.posting});

  @override
  State<ViewPostingScreen> createState() => _ViewPostingScreenState();
}

class _ViewPostingScreenState extends State<ViewPostingScreen> {
  PostingModel? posting;

  @override
  void initState() {
    super.initState();
    posting = widget.posting;
    GetRequiredInfo();
  }

  GetRequiredInfo() async {
    await posting!.getAllImagesFromStorage();
    await posting!.getHostFromFirestore();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (posting!.displayImages == null || posting!.displayImages!.isEmpty) {
      print("La lista de imágenes está vacía");
    } else {
      print("La lista de imágenes tiene ${posting!.displayImages!.length} imágenes");
    }

    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.pinkAccent, Colors.amber],
              begin: FractionalOffset(0.0, 0.0),
              end: FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp,
            ),
          ),
        ),
        title: const Text(
          "informacion",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save, color: Colors.white),
            onPressed: () {
              AppConstants.currentUser.addSavedPosting(posting!);
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          AspectRatio(
            aspectRatio: 3 / 2,
            child: PageView.builder(
              itemCount: posting!.displayImages!.length,
              itemBuilder: (context, index) {
                MemoryImage currentImage = posting!.displayImages![index];
                return Image(
                  image: currentImage,
                  fit: BoxFit.fill,
                );
              },
            ),
          ),

          // Botones de posteo
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Posteos
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 1.55,
                      child: Text(
                        posting!.name!.toUpperCase(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        maxLines: 3,
                      ),
                    ),
                    //boton de reserva
                    Column(
                      children: <Widget>[
                        Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.pinkAccent, Colors.amber],
                              begin: FractionalOffset(0.0, 0.0),
                              end: FractionalOffset(1.0, 0.0),
                              stops: [0.0, 1.0],
                              tileMode: TileMode.clamp,
                            ),
                          ),
                          child: MaterialButton(
                            onPressed: () {
                              Get.to(BookListingScreen(posting: posting,));
                            },
                            child: const Text(
                              'Reservar',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        Text(
                          '\$${posting!.price} / noche',
                          style: const TextStyle(
                            fontSize: 14.0,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                // Descripción
                Padding(
                  padding: const EdgeInsets.only(top: 25, bottom: 25),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 1.75,
                        child: Text(
                          posting!.description!,
                          textAlign: TextAlign.justify,
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                          maxLines: 5,
                        ),
                      ),
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () {},
                            child: CircleAvatar(
                              radius: MediaQuery.of(context).size.width / 12.5,
                              backgroundColor: Colors.black,
                              child: CircleAvatar(
                                backgroundImage: posting!.host!.displayImage,
                                radius: MediaQuery.of(context).size.width / 13,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Text(
                              posting!.host!.GetFullNameOfUser(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Apartamentos
                Padding(
                  padding: EdgeInsets.only(bottom: 25),
                  child: Column(
                    children: [
                      PostingInfoTileUi(
                        iconData: Icons.home,
                        category: posting!.type!,
                        categoryInfo: '${posting!.getGuestNumber()} personas',
                      ),
                      PostingInfoTileUi(
                        iconData: Icons.bed,
                        category: 'camas',
                        categoryInfo: posting!.getBedroomText(),
                      ),
                      PostingInfoTileUi(
                        iconData: Icons.bathtub,
                        category: 'baños',
                        categoryInfo: posting!.getBathroomText(),
                      ),
                    ],
                  ),
                ),

                // Comodidades
                const Text(
                  'comodidades',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5, bottom: 25),
                  child: GridView.count(
                    shrinkWrap: true,
                    crossAxisCount: 2,
                    childAspectRatio: 3.6,
                    physics: const NeverScrollableScrollPhysics(), // Evita scroll en GridView
                    children: List.generate(
                      posting!.amenities!.length,
                      (index) {
                        String currentAmenity = posting!.amenities![index];
                        return Chip(
                          label: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              currentAmenity,
                              style: const TextStyle(
                                color: Colors.black45,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          backgroundColor: Colors.white10,
                        );
                      },
                    ),
                  ),
                ),

                // Lugar
                const Text(
                  'lugar',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 2, bottom: 0),
                  child: Text(
                    posting!.getFullAdress(),
                    style: const TextStyle(
                      color: Colors.black45,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
