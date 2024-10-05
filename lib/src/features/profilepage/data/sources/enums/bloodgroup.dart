enum BloodGroup {
  a(name: 'A'),
  b(name: 'B'),
  ab(name: 'AB'),
  o(name: 'O');

  const BloodGroup({required this.name});
  final String name;
}
