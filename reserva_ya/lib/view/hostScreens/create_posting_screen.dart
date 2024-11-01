import 'dart:io';
import 'package:reserva_ya/global.dart';
import 'package:reserva_ya/model/app_constants.dart';
import 'package:reserva_ya/model/contact_model.dart';
import 'package:reserva_ya/model/posting_model.dart';
import 'package:reserva_ya/view/host_home_screen.dart';
import 'package:reserva_ya/view/widgets/amenities_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class CreatePostingScreen extends StatefulWidget {

  PostingModel? posting; 
  CreatePostingScreen({super.key, this.posting});

  @override
  State<CreatePostingScreen> createState() => _CreatePostingScreenState();
}

class _CreatePostingScreenState extends State<CreatePostingScreen> {
  final formKey = GlobalKey<FormState>();
  TextEditingController _nameTextEditingController = TextEditingController();
  TextEditingController _priceTextEditingController = TextEditingController();
  TextEditingController _descriptionTextEditingController = TextEditingController();
  TextEditingController _addressTextEditingController = TextEditingController();
  TextEditingController _amenitiesTextEditingController = TextEditingController();
  TextEditingController _cityTextEditingController = TextEditingController();
  TextEditingController _countryTextEditingController = TextEditingController();

  final List<String> residenceTypes = [
    'Casa',
    'Villa',
    'Apartamento',
    'Condominio',
    'Flat',
    'Vecindario',
    'Estudio'
  ];

  String? residenceTypeSelected;  // Set as null initially

  Map<String, int>? _beds;
  Map<String, int>? _bathrooms;
  List<MemoryImage> _imagesList = [];

  Future<void> _selectImageFromGallery(int index) async {
    var imagePickedFromGallery = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (imagePickedFromGallery != null) {
      MemoryImage imageFileInBytesForm = MemoryImage(await File(imagePickedFromGallery.path).readAsBytes());

      setState(() {
        if (index < 0) {
          _imagesList.add(imageFileInBytesForm);
        } else {
          _imagesList[index] = imageFileInBytesForm;
        }
      });
    }
  }

  void initializeValues() {
    if(widget.posting==null){
      _nameTextEditingController = TextEditingController(text: "");
      _priceTextEditingController = TextEditingController(text: "");
      _descriptionTextEditingController = TextEditingController(text: "");
      _addressTextEditingController = TextEditingController(text: "");
      _cityTextEditingController = TextEditingController(text: "");
      _countryTextEditingController = TextEditingController(text: "");
      _amenitiesTextEditingController = TextEditingController(text: "");
      residenceTypeSelected = residenceTypes.first;

      _beds = {
        'pequena': 0,
        'mediana': 0,
        'grande': 0,
      };

      _bathrooms = {
        'completo': 0,
        'parcial': 0,
      };

      _imagesList = [];

    }
    else{
      _nameTextEditingController = TextEditingController(text: widget.posting!.name);
      _priceTextEditingController = TextEditingController(text: widget.posting!.price.toString());
      _descriptionTextEditingController = TextEditingController(text: widget.posting!.description);
      _addressTextEditingController = TextEditingController(text: widget.posting!.address);
      _cityTextEditingController = TextEditingController(text: widget.posting!.city);
      _countryTextEditingController = TextEditingController(text: widget.posting!.country);
      _amenitiesTextEditingController = TextEditingController(text: widget.posting!.getAmenitiesString());
      _beds = widget.posting!.beds;
      _bathrooms = widget.posting!.bathrooms;
      _imagesList =widget.posting!.displayImages!;
      residenceTypeSelected = widget.posting!.type;
    }

    setState(() {
      
    });
    
  }

  @override
  void initState() {
    super.initState();
    initializeValues();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.pinkAccent,
                Colors.amber,
              ],
              begin: FractionalOffset(0, 0),
              end: FractionalOffset(1, 0),
              stops: [0, 1],
              tileMode: TileMode.clamp,
            ),
          ),
        ),
        title: const Text(
          'Crea o actualiza una publicacion',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              
              if(!formKey.currentState!.validate()){
                Get.snackbar('Error', 'Por favor completa los campos requeridos.');
                return;
              }
              if (residenceTypeSelected == null || residenceTypeSelected == "") {
                Get.snackbar('Error', 'Selecciona el tipo de residencia.');
                return;
              }
              if(_imagesList.isEmpty){
                Get.snackbar('Error', 'Debes añadir al menos una imagen.');
                return;
              }


              
              postingModel.name = _nameTextEditingController.text;
              postingModel.price = double.parse(_priceTextEditingController.text);
              postingModel.description = _descriptionTextEditingController.text;
              postingModel.address = _addressTextEditingController.text;
              postingModel.city = _cityTextEditingController.text;
              postingModel.country = _countryTextEditingController.text;
              postingModel.amenities = _amenitiesTextEditingController.text.split(",");
              postingModel.type = residenceTypeSelected;
              postingModel.beds = _beds;
              postingModel.bathrooms = _bathrooms;
              postingModel.displayImages = _imagesList;
              //postingModel.host = AppConstants.currentUser.CreateUserFromContact();

              postingModel.rating = 3.5;
              postingModel.bookings = [];
              postingModel.reviews = [];

              if(widget.posting==null){
                try {
                
                  await postingViewModel.addListingInfoToFirestore();
                  await postingViewModel.addImagesToFirebaseStorage();
                  Get.snackbar("Publicacion", "Publicacion creada con exito");
                  
                } catch (e) {
                  print("Error al subir la información: $e");
                }


              }
              else{
                postingModel.rating = widget.posting!.rating;
                postingModel.bookings = widget.posting!.bookings;
                postingModel.reviews = widget.posting!.reviews;
                postingModel.id = widget.posting!.id;

                for (int i = 0; i < AppConstants.currentUser.myPostings!.length; i++ ){
                  if(AppConstants.currentUser.myPostings![i].id == postingModel.id){
                    AppConstants.currentUser.myPostings![i] = postingModel;
                    break;

                  }

                }
                await postingViewModel.updatePostingInfoToFirestore();
                //await AppConstants.currentUser.getMyPostingsFromFirestore();
                Get.snackbar("Publicacion", "Publicacion actualizada con exito");

              }
              //postingModel.setImagesNames();
              postingModel = PostingModel();
              Get.to(HostHomeScreen(index: 1,));


            },
            icon: const Icon(Icons.upload),
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(26, 26, 26, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 1.0),
                        child: TextFormField(
                          decoration: const InputDecoration(labelText: "Nombre de la publicacion"),
                          style: const TextStyle(
                            fontSize: 25,
                          ),
                          controller: _nameTextEditingController,
                          validator: (textInput) {
                            if (textInput!.isEmpty) {
                              return "Inserta un nombre valido";
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 25.0),
                        child: DropdownButton<String>(
                          items: residenceTypes.map((item) {
                            return DropdownMenuItem(
                              value: item,
                              child: Text(
                                item,
                                style: const TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (valueItem) {
                            setState(() {
                              residenceTypeSelected = valueItem;
                            });
                          },
                          isExpanded: true,
                          value: residenceTypeSelected,
                          hint: const Text(
                            "Seleccione el tipo de propiedad",
                            style: TextStyle(
                              fontSize: 20.0,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 21.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Expanded(
                              child: TextFormField(
                                decoration: const InputDecoration(labelText: "Precio"),
                                style: const TextStyle(
                                  fontSize: 25.0,
                                ),
                                keyboardType: TextInputType.number,
                                controller: _priceTextEditingController,
                                validator: (text) {
                                  if (text!.isEmpty) {
                                    return "Por favor ingresa un precio valido";
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: 10, bottom: 10),
                              child: Text(
                                "\$ / noche",
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 21.0),
                        child: TextFormField(
                          decoration: const InputDecoration(labelText: "Descripción"),
                          style: const TextStyle(
                            fontSize: 25.0,
                          ),
                          keyboardType: TextInputType.text,
                          controller: _descriptionTextEditingController,
                          maxLines: 3,
                          minLines: 1,
                          validator: (text) {
                            if (text!.isEmpty) {
                              return "Por favor ingresa una descripción válida";
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 21.0),
                        child: TextFormField(
                          decoration: const InputDecoration(labelText: "Direccion"),
                          maxLines: 3,
                          style: const TextStyle(
                            fontSize: 25.0,
                          ),
                          keyboardType: TextInputType.text,
                          controller: _addressTextEditingController,
                          validator: (text) {
                            if (text!.isEmpty) {
                              return "Por favor ingresa una direccion válida";
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 21.0),
                        child: TextFormField(
                          decoration: const InputDecoration(labelText: "Ciudad"),
                          maxLines: 3,
                          style: const TextStyle(
                            fontSize: 25.0,
                          ),
                          keyboardType: TextInputType.text,
                          controller: _cityTextEditingController,
                          validator: (text) {
                            if (text!.isEmpty) {
                              return "Por favor ingresa una ciudad válida";
                            }
                            return null;
                          },
                        ),
                      ),
                      
                      Padding(
                        padding: const EdgeInsets.only(top: 21.0),
                        child: TextFormField(
                          decoration: const InputDecoration(labelText: "Pais"),
                          style: const TextStyle(
                            fontSize: 25.0,
                          ),
                          keyboardType: TextInputType.text,
                          controller: _countryTextEditingController,
                          maxLines: 3,
                          minLines: 1,
                          validator: (text) {
                            if (text!.isEmpty) {
                              return "Por favor ingresa un pais válida";
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 25.0),
                        child: const Text(
                          'Camas',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 21, left: 14, right: 15),
                        child: Column(
                          children: <Widget>[
                            AmenitiesUi(
                              type: 'Individual',
                              startValue: _beds!['pequena']!,
                              decreaseValue: () {
                                setState(() {
                                  _beds!['pequena'] = (_beds!['pequena']! - 1).clamp(0, 9999);
                                });
                              },
                              increaseValue: () {
                                setState(() {
                                  _beds!['pequena'] = _beds!['pequena']! + 1;
                                });
                              },
                            ),
                            AmenitiesUi(
                              type: 'Doble',
                              startValue: _beds!['mediana']!,
                              decreaseValue: () {
                                setState(() {
                                  _beds!['mediana'] = (_beds!['mediana']! - 1).clamp(0, 9999);
                                });
                              },
                              increaseValue: () {
                                setState(() {
                                  _beds!['mediana'] = _beds!['mediana']! + 1;
                                });
                              },
                            ),
                            AmenitiesUi(
                              type: 'King',
                              startValue: _beds!['grande']!,
                              decreaseValue: () {
                                setState(() {
                                  _beds!['grande'] = (_beds!['grande']! - 1).clamp(0, 9999);
                                });
                              },
                              increaseValue: () {
                                setState(() {
                                  _beds!['grande'] = _beds!['grande']! + 1;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 30.0),
                        child: const Text(
                          'Baños',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 25, 15, 0),
                        child: Column(
                          children: <Widget>[
                            AmenitiesUi(
                              type: 'Completo',
                              startValue: _bathrooms!['completo']!,
                              decreaseValue: () {
                                setState(() {
                                  _bathrooms!['completo'] = (_bathrooms!['completo']! - 1).clamp(0, 9999);
                                });
                              },
                              increaseValue: () {
                                setState(() {
                                  _bathrooms!['completo'] = _bathrooms!['completo']! + 1;
                                });
                              },
                            ),
                            AmenitiesUi(
                              type: 'Parcial',
                              startValue: _bathrooms!['parcial']!,
                              decreaseValue: () {
                                setState(() {
                                  _bathrooms!['parcial'] = (_bathrooms!['parcial']! - 1).clamp(0, 9999);
                                });
                              },
                              increaseValue: () {
                                setState(() {
                                  _bathrooms!['parcial'] = _bathrooms!['parcial']! + 1;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      // Extras
                      Padding(
                        padding: const EdgeInsets.only(top: 21.0),
                        child: TextFormField(
                          decoration: const InputDecoration(
                            labelText: "Comodidades extra",
                          ),
                          style: const TextStyle(
                            fontSize: 25,
                          ),
                          controller: _amenitiesTextEditingController,
                          validator: (text) {
                            if (text!.isEmpty) {
                              return "Por favor ingresa en un formato válido";
                            }
                            return null;
                          },
                          maxLines: 3,
                          minLines: 1,
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Text(
                          'fotos',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(top: 20.0, bottom: 25),
                        child: GridView.builder(
                          shrinkWrap: true,
                          itemCount: _imagesList!.length + 1,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 25,
                            crossAxisSpacing: 25,
                            childAspectRatio: 3/2
                          ),
                          itemBuilder: (context, index){
                            if(index == _imagesList!.length){
                              return IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: (){
                                  _selectImageFromGallery(-1);
                                },
                              );
                            }
                            return MaterialButton(
                              onPressed: (){

                              },
                              child: Image(
                                image: _imagesList![index],
                                fit: BoxFit.fill,
                              ),

                            );
                          },
                        )
                      ),

                      
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
