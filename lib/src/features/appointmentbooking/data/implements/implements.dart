
    import '../sources/sources.dart';
    import '../../domain/repositories/repositories.dart';
    
    class AppointmentbookingRepositoryImp implements AppointmentbookingRepository{

        final AppointmentbookingRemoteDataSource remoteDataSource;
        AppointmentbookingRepositoryImp({required this.remoteDataSource});
      
        // ... example ...
        //
        // Future<User> getUser(String userId) async {
        //     return remoteDataSource.getUser(userId);
        //   }
        // ...
    }
    