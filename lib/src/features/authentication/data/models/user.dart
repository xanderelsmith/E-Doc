abstract class CustomUserData {
  String username;
  bool isSpecialist;
  List allergies;
  CustomUserData({
    required this.username,
    required this.isSpecialist,
    required this.allergies,
  });

  @override
  String toString() =>
      'CustomUserData(username: $username, isSpecialist: $isSpecialist, allergies: $allergies)';
}
