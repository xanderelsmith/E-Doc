
    import '../sources/sources.dart';
    import '../../domain/repositories/repositories.dart';
    
    class PaymentRepositoryImp implements PaymentRepository{

        final PaymentRemoteDataSource remoteDataSource;
        PaymentRepositoryImp({required this.remoteDataSource});
      
        // ... example ...
        //
        // Future<User> getUser(String userId) async {
        //     return remoteDataSource.getUser(userId);
        //   }
        // ...
    }
    