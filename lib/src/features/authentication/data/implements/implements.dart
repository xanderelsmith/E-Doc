
    import '../sources/sources.dart';
    import '../../domain/repositories/repositories.dart';
    
    class AuthenticationRepositoryImp implements AuthenticationRepository{

        final AuthenticationRemoteDataSource remoteDataSource;
        AuthenticationRepositoryImp({required this.remoteDataSource});
      
        // ... example ...
        //
        // Future<User> getUser(String userId) async {
        //     return remoteDataSource.getUser(userId);
        //   }
        // ...
    }
    