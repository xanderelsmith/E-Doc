enum Genotype {
  genotypeA(name: 'A'),
  genotypeB(name: 'B'),
  genotypeAB(name: 'AB'),
  genotypeO(name: 'O');

  const Genotype({required this.name});
  final String name;
}
