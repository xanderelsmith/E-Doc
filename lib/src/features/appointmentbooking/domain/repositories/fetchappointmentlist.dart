import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../authentication/data/models/user.dart';

Stream<QuerySnapshot<Object?>> getmyAppointmentList(CustomUserData patient) {
  try {
    // Get a reference to the Firestore collection where appointments are stored
    final CollectionReference appointmentsCollection =
        FirebaseFirestore.instance.collection('appointments')
          ..orderBy('createdAt', descending: false);

    DocumentReference userRef =
        FirebaseFirestore.instance.collection('users').doc(patient.email);
    // Query the collection based on the patient's email
    return appointmentsCollection
        .where('patient', isEqualTo: userRef)
        .snapshots();
  } catch (e) {
    print('Error fetching appointments: $e');
    throw e; // Re-throw the error for further handling
  }
}
