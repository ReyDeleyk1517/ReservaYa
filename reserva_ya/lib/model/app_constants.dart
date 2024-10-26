import 'package:reserva_ya/model/contact_model.dart';
import 'package:reserva_ya/model/user_model.dart';

class AppConstants{
  static UserModel currentUser = UserModel();

  ContactModel createContactFromUserModel(){
    return ContactModel(
      id: currentUser.id,
      nombre: currentUser.nombre,
      apellido: currentUser.apellido,
      displayImage: currentUser.displayImage,
    );
    
  }

  static final Map<int, int> daysInMonths = {
    1: 31,  // Enero
    2: DateTime.now().year % 4 == 0 ? 29 : 28,  // Febrero 
    3: 31,  // Marzo
    4: 30,  // Abril
    5: 31,  // Mayo
    6: 30,  // Junio
    7: 31,  // Julio
    8: 31,  // Agosto
    9: 30,  // Septiembre
    10: 31, // Octubre
    11: 30, // Noviembre
    12: 31  // Diciembre
  };

  static final Map<int, String> monthDict = {
    1: "Enero",
    2: "Febrero",
    3: "Marzo",
    4: "Abril",
    5: "Mayo",
    6: "Junio",
    7: "Julio",
    8: "Agosto",
    9: "Septiembre",
    10: "Octubre",
    11: "Noviembre",
    12: "Diciembre"
  };


}