import 'package:reserva_ya/global.dart';
import 'package:reserva_ya/model/app_constants.dart';
import 'package:reserva_ya/model/posting_model.dart';
import 'package:reserva_ya/view/widgets/calender_ui.dart';
import 'package:reserva_ya/view/widgets/posting_grid_tile_ui.dart';
import 'package:reserva_ya/view/widgets/view_posting_screen.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BookListingScreen extends StatefulWidget {

  PostingModel? posting;
  



  BookListingScreen({super.key, this.posting});

  @override
  State<BookListingScreen> createState() => _BookListingScreenState();
}

class _BookListingScreenState extends State<BookListingScreen> {
  PostingModel? posting;
  List<DateTime> bookedDates = [];
  List<DateTime> selectedDates = [];
  List<CalenderUI> calendarWidgets = [];

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

          ],
        ),
        
      ),
    );
  }
}