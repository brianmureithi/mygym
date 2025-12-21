import 'package:flutter/material.dart';
import 'package:my_gym/state/auth_store.dart';
import 'package:provider/provider.dart';

class MembershipStatusWidget extends StatelessWidget {
  const MembershipStatusWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthStore>();
    final user = auth.user;

    final membership = user?['membership'];
    final status = membership?['status'] ?? 'Unknown';
    final expiresAt = membership?['expires_at'] ?? 'N/A';
    final isActive = status == 'active';

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          isActive ? Icons.verified : Icons.error_outline,
          size: 18,
          color: isActive ? Colors.green : Colors.redAccent,
        ),
        const SizedBox(width: 8),
        Text(
          "Membership: $status",
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 15,
                color: isActive ? Colors.green : Colors.redAccent,
              ),
        ),
        const SizedBox(width: 4),
        Text(
          "until $expiresAt",
          style: const TextStyle(fontSize: 12, color: Color(0xFF3D3F3E)),
        ),
      ],
    );
  }
}
