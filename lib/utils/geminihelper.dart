import 'package:healthai/src/features/authentication/data/models/user.dart';
import 'package:healthai/src/features/profilepage/data/sources/enums/temperature.dart';

class Geminihelper {
  static Map sample = {
    'specialist': 'Pulmonologist',
    'message': data,
    'symptoms': [
      'shortness of breath',
      'chest tightness',
      'persistent cough',
    ]
  };
  static String data = '''
Dear Jay,

Thank you for using our AI-powered health consultation platform. Based on the information you provided, it seems that you may be experiencing persistent cough, shortness of breath, and chest tightness. Your reported allergies to dust mites and pollen and current Warm temperature (probably around 23°c to 45°c)  also suggest that asthma or allergic bronchitis could be contributing factors.

We recommend consulting with a pulmonologist for further evaluation and diagnosis . They will be able to conduct a more comprehensive examination and prescribe appropriate treatment.''';

  static String prompt(
          {required List<String> alergies,
          required String complaint,
          required CustomUserData user,
          required List<String> specialists,
          required Temperature temperature}) =>
      'generate a json STRICTLY like the where the user named ${user.username},temperature ${temperature.name} has this complaint $complaint and needs to choose strictly among these specialsts here: ${specialists.join(",")} , you can only output a map in this $sample, which from the specialsts list is the specialist best for the case,ONLY make bold and blue the words for emphasis in the map message,your entire response/output is going to consist of a single JSON object {}, and you will NOT wrap it within JSON md markers';

  static String apiKey = 'AIzaSyC-Bzvrs_tto8YJP8_QHCfrYzVvS53n6-4';
  getAnalysis() {}
}
