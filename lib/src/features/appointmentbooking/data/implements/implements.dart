import 'package:healthai/src/features/appointmentbooking/data/models/appointments.dart';

import '../sources/sources.dart';
import '../../domain/repositories/repositories.dart';

class AppointmentbookingRepositoryImp extends AppointmentbookingRepository {
  final AppointmentbookingRemoteDataSource remoteDataSource;
  AppointmentbookingRepositoryImp({required this.remoteDataSource});

  @override
  Future<Appointment> getUser(String userId) {
    // TODO: implement getUser
    throw UnimplementedError();
  }
}
