class Appointment {
  int id;
  String date;
  String time;
  String doctorName;
  String specialty;
  String reason;
  String status; // Can be "pending", "confirmed", "cancelled"

  Appointment({
    required this.id,
    required this.date,
    required this.time,
    required this.doctorName,
    required this.specialty,
    required this.reason,
    required this.status,
  });

  // Methods to update appointment status
  void confirmAppointment() {
    status = "confirmed";
  }

  void cancelAppointment() {
    status = "cancelled";
  }
}
