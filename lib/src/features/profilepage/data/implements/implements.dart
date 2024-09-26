
    import '../sources/sources.dart';
    import '../../domain/repositories/repositories.dart';
    
    class ProfilepageRepositoryImp implements ProfilepageRepository{

        final ProfilepageRemoteDataSource remoteDataSource;
        ProfilepageRepositoryImp({required this.remoteDataSource});
      
        // ... example ...
        //
        // Future<User> getUser(String userId) async {
        //     return remoteDataSource.getUser(userId);
        //   }
        // ...
    }
    