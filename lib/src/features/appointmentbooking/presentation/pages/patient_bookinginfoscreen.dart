import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:healthai/extensions/textstyleext.dart';
import 'package:healthai/src/features/appointmentbooking/domain/repositories/userrepository.dart';
import 'package:healthai/src/features/home/presentation/pages/homepage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../../styles/apptextstyles.dart';
import '../../../../../theme/appcolors.dart';
import '../../../onboarding/presentation/pages/onboardingscreen.dart';

class BookingInfoScreen extends ConsumerWidget {
  const BookingInfoScreen({super.key, required this.appointmentData});
  static String id = 'BookingInfoScreen';
  final Map appointmentData;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var appointment = appointmentData['appointment'];
    DateTime date = appointment.dates.first.toDate();
    var specialist = appointmentData['specialist'];

    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        context.goNamed(HomePage.id);
      },
      child: Scaffold(
        bottomNavigationBar: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton.icon(
                statesController: WidgetStatesController(),
                icon: const Icon(Icons.chat_outlined),
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(getScreenSize(context).width / 2.2, 30),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                ),
                onPressed: null,
                label: const Text('Chat Doctor')),
            ElevatedButton.icon(
                icon: const Icon(Icons.phone_outlined),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.green,
                  fixedSize: Size(getScreenSize(context).width / 2.2, 30),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                ),
                onPressed: () {},
                label: const Text('Call Doctor'))
          ],
        ),
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                context.goNamed(HomePage.id);
              },
              icon: const Icon(Icons.arrow_back)),
          bottom: const PreferredSize(
              preferredSize: Size(
                double.maxFinite,
                1,
              ),
              child: Divider()),
          title: const Text('Booking'),
          centerTitle: true,
        ),
        body: SizedBox(
          width: getScreenSize(context).width,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  width: getScreenSize(context).width,
                  height: 60,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: AppColors.deepPurple,
                      )),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Appointment',
                        style: Apptextstyles.normaltextStyle17.purple,
                      ),
                      Text(
                        '${date.hour}hr : ${date.minute}min : ${date.second}sec',
                        style: Apptextstyles.normaltextStyle17,
                      ),
                    ],
                  ),
                ),
                ListTile(
                  trailing: Card(
                    elevation: 0,
                    color: AppColors.lightgreen,
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Paid'),
                    ),
                  ),
                  minLeadingWidth: 0,
                  contentPadding: EdgeInsets.zero,
                  leading: CachedNetworkImage(
                    imageUrl: specialist.profileImageUrl,
                    imageBuilder: (context, imageProvider) => Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                              image: imageProvider, fit: BoxFit.cover)),
                    ),
                    errorWidget: (context, url, error) => Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey,
                        )),
                    fit: BoxFit.cover,
                    height: 50,
                    width: 50,
                  ),
                  title: Text(appointmentData['specialist'].name),
                  subtitle: Text(appointmentData['specialist'].specialty),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Text(
                        'Date',
                        style: Apptextstyles.normaltextStyle17,
                      ),
                    ),
                    Text(
                      DateFormat('MMMM dd, yyyy').format(date),
                      style: Apptextstyles.mediumtextStyle20.w500,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Text(
                        'Time',
                        style: Apptextstyles.normaltextStyle17,
                      ),
                    ),
                    Text(
                      DateFormat('hh:mm a')
                          .format(appointment.dates.first.toDate()),
                      style: Apptextstyles.mediumtextStyle20.bold,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
