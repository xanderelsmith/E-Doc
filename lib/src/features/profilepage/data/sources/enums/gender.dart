enum Gender {
  male(name: 'Male'),
  female(name: 'Female');

  const Gender({required this.name});
  final String name;
}
