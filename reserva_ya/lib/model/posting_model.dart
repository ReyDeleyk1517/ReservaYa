import "package:get/get.dart";
import "package:reserva_ya/global.dart";
import "package:reserva_ya/model/app_constants.dart";
import "package:reserva_ya/model/booking_model.dart";
import "package:reserva_ya/model/contact_model.dart";
import "package:reserva_ya/model/review_model.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_storage/firebase_storage.dart";
import "package:flutter/cupertino.dart";

class PostingModel {
  String? id;
  String? name;
  String? type;
  double? price;
  String? description;
  String? address;
  String? city;
  String? country;
  double? rating;

  ContactModel? host;

  List<String>? imageNames;
  List<MemoryImage>? displayImages;
  List<String>? amenities;

  Map<String, int>? beds;
  Map<String, int>? bathrooms;

  List<BookingModel>? bookings;
  List<ReviewModel>? reviews;

  PostingModel({this.id = "", this.name = "", this.type = "", this.price = 0, this.description = "",
   this.address = "", this.city = "", this.country = ""}){
    displayImages = [];
    amenities = [];

    beds = {};
    bathrooms = {};
    rating = 0;

    bookings = [];
    reviews = [];

  }

  setImagesNames(){
    imageNames = [];
    for(int i = 0; i < displayImages!.length; i++){
      imageNames!.add("image${i}.png");
    }
  }


  getPostingInfoFromFirestore() async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('postings').doc(id).get();
    getPostingInfoFromSnapshot(snapshot);
  }

  getPostingInfoFromSnapshot(DocumentSnapshot snapshot) async {
    address = snapshot['address'] ?? "";

    amenities = List<String>.from(snapshot['amenities'] ?? []);

    bathrooms = Map<String, int>.from(snapshot['bathrooms'] ?? {});

    beds = Map<String, int>.from(snapshot['beds'] ?? {});

    city = snapshot['city'] ?? "";

    country = snapshot['country'] ?? "";

    description = snapshot['description'] ?? "";

    String hostID = snapshot['hostID'] ?? "";

    host = ContactModel(id: hostID);

    imageNames = List<String>.from(snapshot['imageNames'] ?? []);

    name = snapshot['name'] ?? "";

    price = (snapshot['price'] as num?)?.toDouble() ?? 0.0;

    rating = (snapshot['rating'] as num?)?.toDouble() ?? 2.5;

    type = snapshot['type'] ?? "";
  }


  getAllImagesFromStorage() async {
    displayImages = [];
    for (int i = 0; i < imageNames!.length; i++ ){
      final imageData = await FirebaseStorage.instance.ref()
      .child("postingImages").child(id!)
      .child(imageNames![i])
      .getData(1024*1024);
      displayImages!.add(MemoryImage(imageData!));

    }
    return displayImages;

  }

  getFirstImageFromStorage() async {
    if(displayImages!.isNotEmpty){
      return displayImages!.first;
    }

    final imageData = await FirebaseStorage.instance.ref()
      .child("postingImages").child(id!)
      .child(imageNames!.first)
      .getData(1024*1024);
      displayImages!.add(MemoryImage(imageData!));

    displayImages!.add(MemoryImage(imageData!));
    return displayImages!.first;

  }

  getAmenitiesString() {
    if(amenities!.isEmpty){
      return "";
    }
    String amenitiesString = amenities.toString();
    return amenitiesString.substring(1, amenitiesString.length-1);

  }

  double getCurrentRating(){

    if(reviews!.length == 0){
      return 4;
    }

    double rating = 0;

    reviews!.forEach((review){
      rating = rating + review.rating!;
    });

    rating = rating / reviews!.length;

    return rating;

  }

  getHostFromFirestore() async{
    await host!.GetContactInfoFromFirestore();
    await host!.getImageFromStorage();
  }

  int getGuestNumber(){
    int? numGuest = 0;
    numGuest = numGuest + beds!['pequena']!;
    numGuest = numGuest + beds!['mediana']! *2;
    numGuest = numGuest + beds!['grande']! *2;
    return numGuest;

  }

  String getBedroomText(){
    String text = "";

    if(beds!['pequena'] != 0){
      text = text + beds!['pequena'].toString() + " individual";

    }
    if(beds!['mediana'] != 0){
      text = text + beds!['mediana'].toString() + " doble";

    }
    if(beds!['grande'] != 0){
      text = text + beds!['grande'].toString() + " king";

    }

    return text;
  }

  String getBathroomText(){
    String text = "";

    if(bathrooms!['completo'] != 0){
      text = text + bathrooms!['completo'].toString() + " completo ";

    }
    if(bathrooms!['parcial'] != 0){
      text = text + bathrooms!['parcial'].toString() + " parcial ";

    }


    return text;
  }

  String getFullAdress(){
    return address! + ", " + city! + ", " + country!;
  }

  getAllBookingsFromFirestore() async{
    bookings = [];
    QuerySnapshot snapshots = await FirebaseFirestore.instance.collection('postings').doc(id).collection('bookings').get();
    for (var snapshot in snapshots.docs) {
      BookingModel newBooking = BookingModel();
      await newBooking.getBookingInfoFromFirestoreFromPosting(this, snapshot);
      bookings!.add(newBooking);
      
    }
  }

  List<DateTime> getAllBookedDates(){
    List<DateTime> dates = [];

    bookings!.forEach((booking){
      dates.addAll(booking.dates!);

    });
    return dates;
  }

  Future<void> makeNewBooking(List<DateTime> dates, context, hostID) async{
    
    Map<String, dynamic> bookingData = {
      'dates': dates,
      'name': AppConstants.currentUser.GetFullNameOfUser(),
      'userID': AppConstants.currentUser.id,
      'payment': bookingPrice,
    };
    DocumentReference reference = await FirebaseFirestore.instance.collection('postings')
      .doc(id).collection('bookings').add(bookingData);

    BookingModel newBooking = BookingModel();
    //aqui
    newBooking.createBooking(this, dates);
    newBooking.id = reference.id;

    bookings!.add(newBooking);
    //aqui
    await AppConstants.currentUser.addBookingToFirestore(newBooking, bookingPrice!, hostID);

    //Get.snackbar("Guardando", "Reservado con exito.");
  }

  


}