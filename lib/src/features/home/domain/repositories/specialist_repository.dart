import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healthai/extensions/listextension.dart';
import 'package:healthai/src/features/authentication/data/models/specialist.dart';

class FetchSpecialistRepository {
  Stream<QuerySnapshot<Map<String, dynamic>>> getSpecialists() {
    var snapshots = FirebaseFirestore.instance
        .collection('users')
        .where('isSpecialist', isEqualTo: true)
        .snapshots();
    return snapshots;
  }

  Future<void> getGroupedSpecialist() async {
    QuerySnapshot<Map<String, dynamic>> data = await FirebaseFirestore.instance
        .collection('users')
        .where('isSpecialist', isEqualTo: true)
        .get();

    sortedSpecialists = List<MapEntry<String, List<Specialist>>>.from(
        getSortedByTitle(data.docs));
  }

  List<MapEntry<String, List<Specialist>>> sortedSpecialists = [];

  List<MapEntry<String, List<Specialist>>> getSortedByTitle(
          List<QueryDocumentSnapshot<Map<String, dynamic>>> specialists) =>
      specialists
          .map(
            (e) => Specialist.fromMap(e.data()),
          )
          .groupBy((specialist) => specialist.specialty)
          .entries
          .toList()
        ..sort((a, b) => b.key.compareTo(a.key));
}
// In Clean Architecture, you should separate concerns into layers. Here's a suggested arrangement for your Flutter code:

// *Domain Layer (Entities and Use Cases)*

// - specialist.dart (Entity)
// ```
// class Specialist {
//   final String id;
//   final String specialty;
//   // Other properties...
// }
// ```

// *Data Layer (Repositories and Data Sources)*

// - specialist_repository.dart
// ```
// abstract class SpecialistRepository {
//   Stream<List<Specialist>> getSpecialists();
// }
// ```

// - firebase_specialist_repository.dart (Implementation)
// ```
// class FirebaseSpecialistRepository implements SpecialistRepository {
//   final FirebaseFirestore _firebaseFirestore;

//   FirebaseSpecialistRepository(this._firebaseFirestore);

//   @override
//   Stream<List<Specialist>> getSpecialists() async* {
//     yield* _firebaseFirestore
//         .collection('users')
//         .where('isSpecialist', isEqualTo: true)
//         .snapshots()
//         .map((querySnapshot) => querySnapshot.docs
//             .map((doc) => Specialist.fromJson(doc.data()))
//             .toList());
//   }
// }
// ```

// *Application Layer (Use Cases and Interactors)*

// - get_specialists_use_case.dart
// ```
// class GetSpecialistsUseCase {
//   final SpecialistRepository _repository;

//   GetSpecialistsUseCase(this._repository);

//   Stream<List<Specialist>> execute() {
//     return _repository.getSpecialists();
//   }
// }
// ```

// *Presentation Layer (Widgets and Blocs/Cubits)*

// - specialist_list_cubit.dart (using Bloc/Cubit)
// ```
// class SpecialistListCubit extends Cubit<List<Specialist>> {
//   final GetSpecialistsUseCase _getSpecialistsUseCase;

//   SpecialistListCubit(this._getSpecialistsUseCase) : super([]) {
//     _getSpecialistsUseCase.execute().listen((specialists) {
//       emit(specialists);
//     });
//   }

//   List<MapEntry<String, List<Specialist>>> get getSortedByTitle {
//     final specialists = state;
//     return specialists
//         .groupBy((specialist) => specialist.specialty)
//         .entries
//         .toList()
//       ..sort((a, b) => b.key.compareTo(a.key));
//   }
// }
// ```

// *Widget*
// ```
// class SpecialistList extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<SpecialistListCubit, List<Specialist>>(
//       builder: (context, specialists) {
//         return ListView.builder(
//           itemCount: specialists.length,
//           itemBuilder: (context, index) {
//             // Display specialist info...
//           },
//         );
//       },
//     );
//   }
// }
// ```

// By separating concerns into layers, you achieve:

// 1. Decoupling: Each layer is independent.
// 2. Testability: Easier to test individual layers.
// 3. Maintainability: Easier to modify or replace layers.

// Would you like to:

// 1. Explore more Clean Architecture concepts
// 2. Discuss Flutter-specific architecture patterns
// 3. Learn about Dependency Injection
// 4. Implement a similar architecture for another feature

// Please let me know!