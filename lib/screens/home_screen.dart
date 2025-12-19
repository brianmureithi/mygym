import 'package:flutter/material.dart';
import '../widgets/membership_status_widget.dart';
import '../widgets/renew_membership_section.dart';
import '../widgets/workout_videos_section.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          MembershipStatusWidget(),
          SizedBox(height: 16),
          RenewMembershipSection(),
          SizedBox(height: 16),
          WorkoutVideosSection(),
        ],
      ),
    );
  }
}
