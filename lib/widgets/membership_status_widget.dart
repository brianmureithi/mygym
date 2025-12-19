import 'package:flutter/material.dart';

class MembershipStatusWidget extends StatelessWidget {
  const MembershipStatusWidget({super.key});

  @override
  Widget build(BuildContext context) {
    const membershipStatus = "Active";
    const lastStatusUpdateDate = "Wed, 21 2025";

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          membershipStatus == "Active" ? Icons.verified : Icons.error_outline,
          size: 18,
          color: membershipStatus == "Active" ? Colors.green : Colors.redAccent,
        ),
        const SizedBox(width: 8),
        Text(
          "Membership: $membershipStatus",
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 15,
            color: membershipStatus == "Active"
                ? Colors.green
                : Colors.redAccent,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          "until $lastStatusUpdateDate",
          style: const TextStyle(fontSize: 12, color: Color(0xFF3D3F3E)),
        ),
      ],
    );
  }
}
