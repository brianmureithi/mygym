import 'package:flutter/material.dart';
import 'package:my_gym/state/auth_store.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class RenewMembershipSection extends StatefulWidget {
  const RenewMembershipSection({super.key});

  @override
  State<RenewMembershipSection> createState() => _RenewMembershipSectionState();
}

class _RenewMembershipSectionState extends State<RenewMembershipSection> {
  late TextEditingController _phoneController;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthStore>().user;
    _phoneController = TextEditingController(text: user?['phone_number'] ?? '');
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _renewMembership() async {
    if (_phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a phone number')),
      );
      return;
    }

    setState(() => _loading = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        throw Exception('Not authenticated');
      }

      final response = await http.post(
        Uri.parse('https://f2bfcfc56799.ngrok-free.app/api/payment'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'phone': _phoneController.text}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              data['message'] ?? 'Payment request sent. Check your phone now 📱',
            ),
          ),
        );
      } else {
        final error = jsonDecode(response.body);

        throw Exception(error['message'] ?? 'Payment failed');
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to initiate payment: $e')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final auth = context.watch<AuthStore>();
    final user = auth.user;

    final membership = user?['membership'];
    final status = membership?['status'];

    // 🔒 Only show if NOT active
    if (status == 'active') {
      return const SizedBox.shrink();
    }

    return SizedBox(
      width: double.infinity,
      child: Card(
        color: isDark ? Colors.black : Colors.white,
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Renew Membership",
                style: theme.textTheme.titleMedium?.copyWith(
                  color: Colors.deepOrangeAccent,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Keep your membership active to access all facilities.",
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),

              // 📱 Phone Input
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'M-Pesa Phone Number',
                  hintText: '2547XXXXXXXX',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // 🔘 Button bottom-left
              Align(
                alignment: Alignment.centerLeft,
                child: ElevatedButton.icon(
                  onPressed: _loading ? null : _renewMembership,
                  icon: _loading
                      ? const SizedBox(
                          height: 16,
                          width: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.payment),
                  label: const Text("Renew Now"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrangeAccent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
