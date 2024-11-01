import 'dart:io';

import 'package:pay/pay.dart';
import 'package:reserva_ya/global.dart';
import 'package:reserva_ya/model/app_constants.dart';
import 'package:reserva_ya/model/posting_model.dart';
import 'package:reserva_ya/payment_gateway/payment_config.dart';
import 'package:reserva_ya/view/guest_home_screen.dart';
import 'package:reserva_ya/view/widgets/calender_ui.dart';
import 'package:reserva_ya/view/widgets/posting_grid_tile_ui.dart';
import 'package:reserva_ya/view/widgets/view_posting_screen.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BookListingScreen extends StatefulWidget {

  PostingModel? posting;
  String? hostID;
  
  BookListingScreen({super.key, this.posting, this.hostID});

  @override
  State<BookListingScreen> createState() => _BookListingScreenState();
}

class _BookListingScreenState extends State<BookListingScreen> {
  PostingModel? posting;
  List<DateTime> bookedDates = [];
  List<DateTime> selectedDates = [];
  List<CalenderUI> calendarWidgets = [];
  bool isBookingButtonVisible = true;

  _buildCalendarWidgets(){
    for (int i = 0; i < 12; i++) {
      calendarWidgets.add(
        CalenderUI(
          monthIndex: i,
          bookedDates: bookedDates,
          selectDate: _selectDate,
          getSelectedDates: _getSelectedDates,
        )
      );
      setState(() {
        
      });
      
    }
  }

  List<DateTime> _getSelectedDates(){
    return selectedDates;
  }

  _selectDate(DateTime date){
    if (selectedDates.contains(date)) {
      selectedDates.remove(date);
    }
    else{
      selectedDates.add(date);
    }
    selectedDates.sort();
    setState(() {
      
    });

  }

  _loadBookDates(){
    posting!.getAllBookingsFromFirestore().whenComplete((){
      bookedDates = posting!.getAllBookedDates();
      _buildCalendarWidgets();
    });
  }

  _makeBooking(){
    if(selectedDates.isEmpty){
      return;
    }
    posting!.makeNewBooking(selectedDates, context, widget.hostID).whenComplete((){
      //Get.back();
    });
  }

  calculateAmountOverAllStay(){
    if (selectedDates!.isEmpty) {
      return;
    }
    double totalPriceForAllNights = selectedDates.length * posting!.price!;
    setState(() {
      bookingPrice = totalPriceForAllNights;
    });
  }

  @override
  void initState() {
    super.initState();
    posting = widget.posting;
    _loadBookDates();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.pink,
                Colors.amber,
              ],
              begin: FractionalOffset(0, 0),
              end: FractionalOffset(1, 0),
              stops: [0 , 1],
              tileMode: TileMode.clamp
            )
          ),
        ),

        title: Text(
          "Reservar ${posting!.name}",
          style: const TextStyle(color: Colors.white, fontSize: 13),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(25, 25, 25, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text('Dom'),
                Text('Lun'),
                Text('Mar'),
                Text('Mie'),
                Text('Jue'),
                Text('Vie'),
                Text('Sab'),
              ],

            ),

            SizedBox(
              height: MediaQuery.of(context).size.height / 2,
              child: (calendarWidgets.isEmpty)
              ? Container()
              : PageView.builder(
                itemCount: calendarWidgets.length,
                itemBuilder: (context, index) {
                  return calendarWidgets[index];
                },
              ),

            ),

            bookingPrice==0.0 
              ? MaterialButton(
                onPressed: (){
                  calculateAmountOverAllStay();
                },
                minWidth: double.infinity,
                height: MediaQuery.of(context).size.height/14,
                color: Colors.green,
                child: const Text('Proceder', style: TextStyle(color: Colors.white)),
              )
              : Container(),

            paymentResult != ""
            ? MaterialButton(
                onPressed: (){
                  Get.to(GuestHomeScreen());
                  setState(() {
                    paymentResult = "";
                    bookingPrice = 0;
                    isBookingButtonVisible = true;
                  });
                },
                minWidth: double.infinity,
                height: MediaQuery.of(context).size.height / 14,
                color: Colors.green,
                child: const Text('Pago realizado con exito presione aqui para regresar', style: TextStyle(color: Colors.white),),
              ) 
            : Container(),

            //boton para reservar
            bookingPrice == 0.0
            ? Container()
            : isBookingButtonVisible // Verifica la visibilidad
                ? MaterialButton(
                    onPressed: () {
                      setState(() {
                        isBookingButtonVisible = false; // Oculta el botón
                        paymentResult = bookingPrice.toString();
                      });
                      _makeBooking(); // Llama a la función de reserva directamente
                    },
                    minWidth: double.infinity,
                    height: MediaQuery.of(context).size.height / 14,
                    color: Colors.blue,
                    child: const Text(
                      'Reservar sin pago',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                : Container(), // Deja este contenedor vacío si el botón está oculto

            /* Platform.isIOS
              ? ApplePayButton(
                  paymentConfiguration: PaymentConfiguration.fromJsonString(defaultApplePay),
                  paymentItems: [
                    PaymentItem(
                      label: 'Monto total',
                      amount: bookingPrice.toString(),
                      status: PaymentItemStatus.final_price,
                    )
                  ],
                  style: ApplePayButtonStyle.black,
                  width: double.infinity,
                  height: 50,
                  type: ApplePayButtonType.buy,
                  margin: EdgeInsets.only(top: 15.0),
                  onPaymentResult: (result){
                    print("Pago total = $result");

                    setState(() {
                      paymentResult = result.toString();                    
                      
                    });
                    _makeBooking();
                  },
                  loadingIndicator: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ) 
              : GooglePayButton(
                  paymentConfiguration: PaymentConfiguration.fromJsonString(defaultGooglePay),
                  paymentItems: [
                    PaymentItem(
                      label: 'Monto total',
                      amount: bookingPrice.toString(),
                      status: PaymentItemStatus.final_price,
                    )
                  ],
                  type: GooglePayButtonType.pay,
                  margin: const EdgeInsets.only(top: 15.0),
                  onPaymentResult: (result){
                    print("Pago total = $result");

                    setState(() {
                      paymentResult = result.toString();                    
                    });
                    _makeBooking();
                  },
                  loadingIndicator: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ), */

          ],
        ),
        
      ),
    );
  }
}