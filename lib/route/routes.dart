import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:healthai/src/features/authentication/presentation/pages/loginscreen.dart';
import 'package:healthai/src/features/authentication/presentation/pages/signup.dart';

import '../src/features/home/presentation/pages/homepage.dart';
import '../src/features/onboarding/presentation/pages/onboardingscreen.dart';

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
          routes: const <GoRoute>[],
        ),
      ],
    );

// Stack Overflow
// Products
// Kal Xander's user avatar
// Kal Xander
// Flutter: go_router how to pass multiple parameters to other screen?
// Asked 1 year, 2 months ago
// Modified 2 months ago
// Viewed 41k times
// 27

// In a vanilla flutter I use to pass multiple parameters to other screen like this:

//     Navigator.of(context).push(MaterialPageRoute(
//                                     builder: (_) => CatalogFilterPage(
//                                           list: list,
//                                           bloc: bloc,
//                                         )))
// Pretty simple and easy. I can pass 2 needed parameters, list and bloc. After use it in CatalogFilterPage.

// Now after switching to go_router and looking through documentation I can't seem to find how to pass multiple data. Even passing single object seems not that good:

//     onTap: () =>
//               context.pushNamed('SelectedCatalogItem', extra: list[index]),
// And in router I have to use casting to set correct type:

//     builder: (context, state) => SelectedCatalogItem(
//                     item: state.extra as ListItemsModel,
//                   ),
// It was fine for single parameter. But now I don't have an idea how to pass multiple parameters. How can I do it? Is even passing parameters, like models, as an extra is right way?

// P.S. I know that you can pass parameters as context.pushNamed('CatalogFilterPage', params: ___), but params has type of Map<String, String> witch not let me pass model's

// flutterdartroutesnavigationflutter-go-router
// Share
// Edit
// Follow
// edited Apr 30 at 4:47
// krishnaacharyaa's user avatar
// krishnaacharyaa
// 15.9k44 gold badges5454 silver badges9797 bronze badges
// asked Jul 14, 2022 at 6:20
// IBlackVikingl's user avatar
// IBlackVikingl
// 69322 gold badges88 silver badges2020 bronze badges
// you can refer to this doc - docs.flutter.dev/cookbook/navigation/navigate-with-arguments –
// Sparsh Jain
//  Jul 14, 2022 at 6:31
// Add a comment

// Report this ad
// 5 Answers
// Sorted by:

// Highest score (default)
// 114

// Edit: Breaking changes in Go_router 7.0.0
// enter image description here

// In NutShell
// Below Go Router 7 i.e < 7.0.0 use `params`, `queryParams`
// Above Go Router 7 i.e >=7.0.0 use `pathParameters`, `queryParameters`
// Summary:
// There are three ways: pathParameters, queryParameters, extra

// Using pathParameters
// When you know the number of parameters beforehand
// Usage : path = '/routeName/:id1/:id2'
// Using queryParameters
// When you are not sure about the number of parameters
// Usage : path = '/routeName'
// Using extra
// When you want to pass object
// Explanation:
// 1. Using pathParameters
// When you know number of params beforehand use pathParameters prop in context.goNamed()

// Define it as:
// GoRoute(
//   path: '/sample/:id1/:id2',  // 👈 Defination of params in the path is important
//   name: 'sample',
//   builder: (context, state) => SampleWidget(
//     id1: state.pathParameters['id1'],
//     id2: state.pathParameters['id2'],
//   ),
// ),
// Call it as:
// ElevatedButton(
//   onPressed: () {
//     var param1 = "param1";
//     var param2 = "param2";
//     context.goNamed("sample", pathParameters: {'id1': param1, 'id2': param2});
//   },
//   child: const Text("Hello"),
// ),
// Receive it as:
// class SampleWidget extends StatelessWidget {
//   String? id1;
//   String? id2;
//   SampleWidget({super.key, this.id1, this.id2});

//   @override
//   Widget build(BuildContext context) {
//      ...
//   }
// }
// 2. Using queryParameters
// You have access to queryParameters in the context.goNamed() function. The best thing about queryParameters is that you don't have to explicitly define them in your route path and can easily access them using the state.queryParameters method. You can add miscellaneous user-related data as a query parameter.

// Define it as :
// GoRoute(
//   name: "sample",
//   path: "/sample",
//   builder: (context, state) => SampleWidget(
//       id1: state.queryParameters['id1'],
//       id2: state.queryParameters['id2'],
//   ),
// )
// Call it as:
// ElevatedButton(
//   onPressed: () {
//     var param1 = "param1";
//     var param2 = "param2";
//     context.goNamed("sample", queryParameters: {'id1': param1, 'id2': param2});
//   },
//   child: const Text("Hello"),
// ),
// Receive it as:
// class SampleWidget extends StatelessWidget {
//   String? id1;
//   String? id2;
//   SampleWidget({super.key, this.id1, this.id2});

//   @override
//   Widget build(BuildContext context) {
//      ...
//   }
// }
// 3. Using extra
// Use this when you want to pass a model/object between routes

// GoRoute(
//   path: '/sample',
//   builder: (context, state) {
//     Sample sample = state.extra as Sample; // 👈 casting is important
//     return GoToScreen(object: sample);
//   },
// ),
// Refer https://stackoverflow.com/a/74813017/13431819 for passing object between routes

// Share
// Edit
// Follow
// edited Jul 9 at 1:56
// answered Dec 15, 2022 at 15:21
// krishnaacharyaa's user avatar
// krishnaacharyaa
// 15.9k44 gold badges5454 silver badges9797 bronze badges
// 2
// if anyone having issues accessing the extra object in the State then you can do this by using widget getter like this widget.object –
// makki
//  Mar 17 at 10:54
// I'd add something to this answer, maybe it's a good design to parse/extract/cast the parameters in GoRouterWidgetBuilder builder: (context, state) {} but also could access the state inside the screen by calling GoRouterState.of(context) to get params, queryParams and extra –
// Tarek360
//  Apr 25 at 11:53
// Do I need to use namedRoute if I want to use queryParams? I was wondering why I can't simply pass it using standard route. –
// Tom Raganowicz
//  Apr 26 at 10:58
// 2
// For query parameters, GoRouterState no longer has queryParameters accessible directly from state. Instead, use state.uri.queryParameters –
// JaredEzz
//  Sep 15 at 20:25
// Add a comment
// 7

// I am new to Flutter, but here is how I passed multiple parameters/arguments to a route with GoRouter using the extra property of context.push():

// // navigate to /my-path, pass 2 arguments to context.state.extra
// context.push("/my-path", extra: {"arg1": firstArg, "arg2": secondArg});
// Then, inside my route:

// // ...
// // Use arguments in builder of the GoRoute
// GoRoute(
//   path: '/dashboard',
//   builder: (context, state) {
//     Map<String, MyCustomType> args =
//       state.extra as Map<String, MyCustomType>;
//     return MyWidget(arg1: args["arg1"]!, arg2: args["arg2"]!);
//   }
// ),
// // ...
// Share
// Edit
// Follow
// answered Dec 12, 2022 at 21:51
// Shareef Hadid's user avatar
// Shareef Hadid
// 12311 silver badge77 bronze badges
// Add a comment
// 5

// Here is a solution with my own code. In my case, i want to parse MenuModels from HomeScreen to another screen (ItemScreen):

// context.push(
//     '/item-screen',
//     extra: widget.menuModels,
// ),
// And in my route.dart

// GoRoute(
//     path: '/item-screen',
//     builder: (context, state) {
//         MenuModels models = state.extra as MenuModels;
//         return ItemScreen(
//             menuModels: models,
//         );
//     },
// ),
// Share
// Edit
// Follow
// edited May 8 at 5:04
// Fah's user avatar
// Fah
// 21999 bronze badges
// answered Dec 3, 2022 at 8:14
// James Indra's user avatar
// James Indra
// 5111 silver badge22 bronze badges
// what about If we have more than one extraItem? For example, think the itemscreen has both menu models and usermodels? so, how we can push? –
// alperefesahin
//  Dec 12, 2022 at 11:20
// Use List<Object> as your extra and and pass it as extra: [object1, object2]. –
// Roslan Amir
//  Jan 1 at 4:10
// Add a comment
// 3

// From the go_router documentation we can see that:

// The extra object is useful if you'd like to simply pass along a single object to the builder function w/o passing an object identifier via a URI and looking up the object from a store.

// What you can do instead is pass in the id/name of the 'SelectedCatalogItem' as params and form the Object later on (if possible). The 'params' parameter lets us pass in more than one fields

// onTap: () => context.pushNamed('SelectedCatalogItem',
//                   params: {"id":list[index].id.toString(),"name":list[index].name}),
// Then in the builder function of the GoRouter we can do:

// GoRoute(
//         path: 'selectedCatalogItem/view/:id/:name',
//         name: 'SelectedCatalogItem',
//         builder: (context, state){
//           int id = int.parse(state.params['id']!);
//           String name = state.params['name']!;
//           // use id and name to your use...
//         });
// Share
// Edit
// Follow
// edited Aug 21, 2022 at 10:56
// answered Aug 21, 2022 at 9:14
// Nazmu Masood's user avatar
// Nazmu Masood
// 8455 bronze badges
// Hi, I am getting an error when using your code: missing param "id" for /all/:name/:id How to fix this error? –
// My Car
//  Nov 3, 2022 at 12:58
// Add a comment
// 0

// Completing the example above (by @Agni Gari)

// 3. Using extra context.goNamed()

// Use this when you want to pass a model/object between routes

// Define it as:

// GoRoute(
//     path: '/sample',
//     name: 'sample',
//     builder: (context, state) {
//       Sample sample = state.extra as Sample; // -> casting is important
//       return GoToScreen(object: sample);
//     },
//   ),
// Call it as:

// Sample sample = Sample(attributeA: "True",attributeB: "False",boolValue: false);
// context.goNamed("sample",extra:sample );
// Receive it as:

// class SampleWidget extends StatelessWidget {
// Sample? object;
// SampleWidget({super.key, this.object});

//   @override
//   Widget build(BuildContext context) {
//      ...
//   }
// }
// Share
// Edit
// Follow
// answered Apr 9 at 20:06
// Adnan Khan's user avatar
// Adnan Khan
// 52144 silver badges55 bronze badges
// Add a comment
// Your Answer
// Links Images Styling/Headers Lists Blockquotes Code HTML TablesAdvanced help
// Not the answer you're looking for? Browse other questions tagged flutterdartroutesnavigationflutter-go-router or ask your own question.
// The Overflow Blog
// How an algo raver stays in key(boards)
// sponsored post
// Featured on Meta
// Alpha test for short survey in banner ad slots starting on week of September...
// What should be next for community events?
// Temporary policy: Generative AI (e.g., ChatGPT) is banned
// Expanding Discussions: Let's talk about curation
// Update on Collectives and Discussions
// OverflowAI Search is now available for alpha testing (September 13, 2023)
// Hot Meta Posts
// 10
// What should we do with [google-contacts-api] (deprecated and retired)?
// 33 people chatting
// Linked
// 15
// Go_Router Pass Object to new route
// 3
// Which is the best way of using navigate function to handle the movements from one page to another
// 2
// Which is the best way of Routing in a Flutter App
// 1
// How to pass optional List argument through go_router?
// 0
// Navigate routes not recommended for most applications flutter in flutter docs
// 1
// Passing data in flutter back and fourth
// 0
// " Pass data from one page to another in Flutter "
// 0
// How can you change URL in the web browser without named routes
// 0
// HOW DO I SEND DATA FROM A SCREEN TO ANOTHER SCREEN
// Related
// 0
// How to get params from route to other screen?
// 0
// How to pass argument to route?
// 1
// Passing route as argument in flutter
// 0
// Flutter how to pass parameters to other screen
// 17
// How to pass multiple arguments in named route in flutter
// 0
// I want to pass data from 2nd Screen to 1st Screen in flutter
// 0
// I am trying to pass multiple arguments to a flutter screen by using generateRoute
// 0
// flutter passing array data from one screen to another in flutter using route
// 2
// Equivalent of Navigator Arguments in Flutter Go Router
// 0
// How to push multiple Arguments in Named Routes flutter
// Hot Network Questions
// What is a Heavenly Word™?
// Is every house vote taken one vote at a time?
// What do Libertarians mean when they say that ADA (Americans with Disabilities Act), in the long run, leads to fewer people with disabilities employed?
// A Trivial Pursuit #17 (Science and Nature 3/4): Workaround
// Why is it that the further a galaxy is, the greater is its recessional velocity?
// E Rebus Unum – a picture sequence puzzle
// What does this Peter Sellers sentence mean?
// Compile vs FunctionCompile
// How to respond to "you must be reviewer #X of my paper!"
// What did the Democrats have to gain by ousting Kevin McCarthy?
// Asymptotic behavior of a sequence of integrals of non-analytic functions
// Transpose a multidimensional array
// What is this folded paper in Brand New Cherry Flavor, episode Hair of the Dog?
// Understanding the application of two inequalities?
// Implement the RegPack decompressor
// The reason why Semitic languages are written right to left
// When can a family be forced to go through passport control separately?
// Is there a downside to being in debt?
// How can I make this X-legged table more stable?
// Why it is not possible to create a proprietary fork of GPL?-or-later software?
// Size of packaging of Battery Box 88015
// When did wear leveling in flash storage come up?
// I'm changing PhD programs, and I got a terrible recomendation letter form my advisor. I found out by accident. What do I do now? I'm shocked
// Spectral sequences and short exact sequences
//  Question feed

// STACK OVERFLOW
// Questions
// Help
// PRODUCTS
// Teams
// Advertising
// Collectives
// Talent
// COMPANY
// About
// Press
// Work Here
// Legal
// Privacy Policy
// Terms of Service
// Contact Us
// Cookie Settings
// Cookie Policy
// STACK EXCHANGE NETWORK
// Technology
// Culture & recreation
// Life & arts
// Science
// Professional
// Business
// API
// Data
// Blog
// Facebook
// Twitter
// LinkedIn
// Instagram
// Site design / logo © 2023 Stack Exchange Inc; user contributions licensed under CC BY-SA. rev 2023.10.4.43662
