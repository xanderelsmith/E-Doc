enum Temperature {
  warm(name: 'Warm'),
  hot(name: 'Hot'),
  veryhot(name: 'Very Hot');

  const Temperature({required this.name});
  final String name;
}
