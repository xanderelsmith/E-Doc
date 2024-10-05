import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:healthai/src/features/authentication/data/models/patient.dart';
import 'package:healthai/src/features/authentication/data/models/specialist.dart';
import 'package:healthai/src/features/authentication/data/models/user.dart';
import 'package:healthai/src/features/authentication/presentation/pages/loginscreen.dart';
import 'package:healthai/src/features/authentication/presentation/pages/signup.dart';
import 'package:healthai/src/features/profilepage/presentation/pages/patient/edit_patient_profilepage.dart';
import 'package:healthai/src/features/profilepage/presentation/pages/specialist/edit_specialist_profilePage.dart';

import '../src/features/appointmentbooking/presentation/pages/bookappointmentscreen.dart';
import '../src/features/appointmentbooking/presentation/pages/patient_bookinginfoscreen.dart';
import '../src/features/appointmentbooking/presentation/pages/bookingsubmissionscreen.dart';
import '../src/features/appointmentbooking/presentation/pages/previewappointmentscreen.dart';
import '../src/features/appointmentbooking/presentation/pages/specialist_viewbookinginfo.dart';
import '../src/features/callfeature/presentation/pages/callscreen.dart';
import '../src/features/home/presentation/pages/appointmentsdetailsscreen.dart';
import '../src/features/home/presentation/pages/homepage.dart';
import '../src/features/home/presentation/pages/setdatetimescreen.dart';
import '../src/features/home/presentation/widgets/patienthomepagebody.dart';
import '../src/features/onboarding/presentation/pages/onboardingscreen.dart';
import '../src/features/payment/presentation/pages/makepayment_screen.dart';
import '../src/features/profilepage/data/sources/enums/temperature.dart';
import '../src/features/profilepage/presentation/pages/profile_page.dart';

GoRouter router(bool isLoggedin) => GoRouter(
      // redirect: (context, state) => '/',
      initialLocation: isLoggedin == true ? '/${HomePage.id}' : '/',
      routes: <GoRoute>[
        GoRoute(
          name: OnboardingPage.id,
          path: '/',
          builder: (BuildContext context, GoRouterState state) =>
              const OnboardingPage(),
          routes: [
            GoRoute(
              name: SignUpScreen.id,
              // redirect: (context, state) {
              //   print(state.error);
              //   return isLoggedin == true ? state.path : '/${LogIn.id}';
              // },
              path: SignUpScreen.id,
              builder: (BuildContext context, GoRouterState state) =>
                  const SignUpScreen(),
              routes: const <GoRoute>[],
            ),
            GoRoute(
              name: LoginScreen.id,
              // redirect: (context, state) {
              //   print(state.error);
              //   return isLoggedin == true ? state.path : '/${LogIn.id}';
              // },
              path: LoginScreen.id,
              builder: (BuildContext context, GoRouterState state) =>
                  const LoginScreen(),
              routes: const <GoRoute>[],
            ),
          ],
        ),
        GoRoute(
          name: HomePage.id,
          // redirect: (context, state) {
          //   print(state.error);
          //   return isLoggedin == true ? state.path : '/${LogIn.id}';
          // },
          path: '/${HomePage.id}',
          builder: (BuildContext context, GoRouterState state) =>
              const HomePage(),
          routes: <GoRoute>[
            GoRoute(
              name: SpecialistViewbookinginfo.id,
              path: SpecialistViewbookinginfo.id,
              builder: (BuildContext context, GoRouterState state) {
                return SpecialistViewbookinginfo(
                    appointmentData: state.extra as Map);
              },
              routes: <GoRoute>[],
            ),
            GoRoute(
              name: BookingInfoScreen.id,
              path: BookingInfoScreen.id,
              builder: (BuildContext context, GoRouterState state) {
                return BookingInfoScreen(appointmentData: state.extra as Map);
              },
              routes: <GoRoute>[],
            ),
            GoRoute(
              name: SetDateTimeBookingScreen.id,
              path: SetDateTimeBookingScreen.id,
              builder: (BuildContext context, GoRouterState state) {
                return SetDateTimeBookingScreen(
                    appointmentData: state.extra as Map);
              },
              routes: const <GoRoute>[],
            ),
            GoRoute(
              name: AppointmentDetailsScreen.id,
              path: AppointmentDetailsScreen.id,
              builder: (BuildContext context, GoRouterState state) {
                return AppointmentDetailsScreen(
                    appointmentData: state.extra as Map);
              },
              routes: <GoRoute>[
                GoRoute(
                  name: MakePaymentScreen.id,
                  path: MakePaymentScreen.id,
                  builder: (BuildContext context, GoRouterState state) {
                    return MakePaymentScreen(
                        appointmentData: state.extra as Map);
                  },
                  routes: const <GoRoute>[],
                ),
              ],
            ),
            GoRoute(
                name: CallScreen.id,
                path: CallScreen.id,
                builder: (BuildContext context, GoRouterState state) {
                  log(state.extra.toString());
                  return CallScreen(
                    endCall: (state.extra as Map)['endCall'],
                    isVideoCall: true,
                    sendMessage: (state.extra as Map)['sendMessage'],
                    otheruser: (state.extra as Map)['otherUser'],
                  );
                },
                routes: const <GoRoute>[]),
            GoRoute(
              name: BookAppointmentScreen.id,
              path: BookAppointmentScreen.id,
              builder: (BuildContext context, GoRouterState state) {
                return BookAppointmentScreen(
                  patient: state.extra as Patient,
                );
              },
              routes: <GoRoute>[
                GoRoute(
                  name: PreviewAppointmentReport.id,
                  path: PreviewAppointmentReport.id,
                  builder: (BuildContext context, GoRouterState state) {
                    return PreviewAppointmentReport(
                        complaintData: state.extra as ({
                      Patient user,
                      String complaint,
                      Temperature temp,
                      List<String> allergies,
                    }));
                  },
                  routes: <GoRoute>[
                    GoRoute(
                        name: BookingSubmissionScreen.id,
                        path: BookingSubmissionScreen.id,
                        builder: (BuildContext context, GoRouterState state) {
                          return BookingSubmissionScreen(
                              data: state.extra as Map);
                        },
                        routes: const <GoRoute>[]),
                  ],
                ),
              ],
            ),
            GoRoute(
              name: ProfilePage.id,
              path: ProfilePage.id,
              builder: (BuildContext context, GoRouterState state) {
                return ProfilePage(
                  baseUser: state.extra as CustomUserData,
                );
              },
              routes: <GoRoute>[
                GoRoute(
                  name: EditPatientProfilePage.id,
                  path: EditPatientProfilePage.id,
                  builder: (BuildContext context, GoRouterState state) {
                    return EditPatientProfilePage(
                      baseUser: state.extra as Patient,
                    );
                  },
                  routes: const <GoRoute>[],
                ),
                GoRoute(
                  name: EditSpecialistProfilePage.id,
                  path: EditSpecialistProfilePage.id,
                  builder: (BuildContext context, GoRouterState state) {
                    return EditSpecialistProfilePage(
                      baseUser: state.extra as Specialist,
                    );
                  },
                  routes: const <GoRoute>[],
                ),
              ],
            ),
            GoRoute(
              name: SpecialDetailsPage.id,
              // redirect: (context, state) {
              //   print(state.error);
              //   return isLoggedin == true ? state.path : '/${LogIn.id}';
              // },
              path: SpecialDetailsPage.id,
              builder: (BuildContext context, GoRouterState state) =>
                  const SpecialDetailsPage(),
              routes: const <GoRoute>[],
            ),
          ],
        ),
      ],
    );
