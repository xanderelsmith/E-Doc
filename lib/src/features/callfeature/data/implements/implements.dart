
    import '../sources/sources.dart';
    import '../../domain/repositories/repositories.dart';
    
    class CallfeatureRepositoryImp implements CallfeatureRepository{

        final CallfeatureRemoteDataSource remoteDataSource;
        CallfeatureRepositoryImp({required this.remoteDataSource});
      
        // ... example ...
        //
        // Future<User> getUser(String userId) async {
        //     return remoteDataSource.getUser(userId);
        //   }
        // ...
    }
    