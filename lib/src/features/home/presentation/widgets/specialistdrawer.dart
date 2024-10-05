import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:healthai/route/routes.dart';
import 'package:healthai/src/features/appointmentbooking/domain/repositories/userrepository.dart';
import 'package:healthai/src/features/profilepage/presentation/pages/profile_page.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SpecialistDrawer extends ConsumerWidget {
  const SpecialistDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var user = ref.watch(userDetailsProvider);
    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.close)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    leading: const Icon(Icons.logout),
                    title: const Text('My Profile'),
                    onTap: () {
                      context.pushNamed(ProfilePage.id, extra: user);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.support_agent_outlined),
                    title: const Text('Support'),
                    onTap: () {
                      // Navigate to the settings screen
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
