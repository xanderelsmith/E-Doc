class OnboardingModel {
  final String title;
  final String message;
  final String imagesrc;

  OnboardingModel({
    required this.title,
    required this.message,
    required this.imagesrc,
  });
}

List<OnboardingModel> onboardinglist = [
  OnboardingModel(
      title: 'Book Appointments with Ease',
      message:
          'Schedule appointments with your preferred\n healthcare providers anytime, anywhere.',
      imagesrc: 'images/image1.png'),
  OnboardingModel(
      title: 'Get Personalized Healthcare',
      message:
          'Store and manage your health\n documents securely in one place.',
      imagesrc: 'images/image2.png'),
  OnboardingModel(
      title: 'Get Expert Advice',
      message:
          'Ask questions, get answersm, and receive\n personalized recommendations.',
      imagesrc: 'images/image3.png'),
];
