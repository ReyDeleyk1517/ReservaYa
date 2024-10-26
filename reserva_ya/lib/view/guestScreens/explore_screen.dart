import 'package:reserva_ya/model/posting_model.dart';
import 'package:reserva_ya/view/widgets/posting_grid_tile_ui.dart';
import 'package:reserva_ya/view/widgets/view_posting_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async'; // Importa Timer

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  Timer? _timer;

  TextEditingController controllerSearch = TextEditingController();
  Stream stream = FirebaseFirestore.instance.collection('postings').snapshots();
  String seartType = "";

  bool isNameButtonSelected = false;
  bool isCityButtonSelected = false;
  bool isTypeButtonSelected = false;

  searchByField() {}

  pressSeachByButton(String seartTypeStr, bool isNameButtonSelectedB, bool isCityButtonSelectedB, bool isTypeButtonSelectedB) {
    setState(() {
      seartType = seartTypeStr;
      isNameButtonSelected = isNameButtonSelectedB;
      isCityButtonSelected = isCityButtonSelectedB;
      isTypeButtonSelected = isTypeButtonSelectedB;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(25, 15, 20, 0),
      child: SingleChildScrollView(
        child: Column(
          children: [

            // Barra de búsqueda
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: TextField(
                decoration: const InputDecoration(
                  hintText: 'Busqueda',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.grey,
                          width: 2.0
                      )
                  ),
                  contentPadding: EdgeInsets.all(5.0),
                ),
                style: const TextStyle(
                  fontSize: 20.0,
                  color: Colors.black,
                ),
                controller: controllerSearch,
                onEditingComplete: searchByField,
              ),
            ),

            // Barra de botones de filtro
            SizedBox(
              height: 48,
              width: MediaQuery.of(context).size.width / 0.5,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                children: [
                  MaterialButton(
                    onPressed: () {
                      pressSeachByButton("nombre", true, false, false);
                    },
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    color: isNameButtonSelected ? Colors.pinkAccent : Colors.white,
                    child: const Text("Nombre"),
                  ),
                  const SizedBox(width: 6,),
                  MaterialButton(
                    onPressed: () {
                      pressSeachByButton("ciudad", false, true, false);
                    },
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    color: isCityButtonSelected ? Colors.pinkAccent : Colors.white,
                    child: const Text("Ciudad"),
                  ),
                  const SizedBox(width: 6,),
                  MaterialButton(
                    onPressed: () {
                      pressSeachByButton("tipo", false, false, true);
                    },
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    color: isTypeButtonSelected ? Colors.pinkAccent : Colors.white,
                    child: const Text("Tipo"),
                  ),
                  const SizedBox(width: 6,),
                  MaterialButton(
                    onPressed: () {
                      pressSeachByButton("", false, false, false);
                    },
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    color: Colors.white,
                    child: const Text("Borrar"),
                  ),
                ],
              ),
            ),

            // StreamBuilder para la lista de postings
            StreamBuilder(
              stream: stream,
              builder: (context, dataSnapshots) {
                if (dataSnapshots.hasData) {
                  return Container(
                    height: MediaQuery.of(context).size.height * 0.6, // Ajusta el tamaño del GridView
                    child: GridView.builder(
                      physics: const ScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: dataSnapshots.data!.docs.length, // Corrección aquí
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 2,
                        mainAxisSpacing: 12,
                        childAspectRatio: 3 / 4,
                      ),
                      itemBuilder: (context, index) {
                        DocumentSnapshot snapshot = dataSnapshots.data!.docs[index];
                        PostingModel cPosting = PostingModel(id: snapshot.id);
                        cPosting.getPostingInfoFromSnapshot(snapshot);
                        return InkResponse(
                          onTap: () {
                            Get.to(ViewPostingScreen(posting: cPosting,));
                          },
                          enableFeedback: true,
                          child: PostingGridTileUI(posting: cPosting),
                        );
                      },
                    ),
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
