import '../../data/models/appointments.dart';

abstract class AppointmentbookingRepository {
  Future<Appointment> getUser(String userId);
}
