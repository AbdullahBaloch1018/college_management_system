import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rise_college/viewModel/auth_view_model.dart';

class PendingApprovalView extends StatelessWidget {
  const PendingApprovalView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.orange, width: 2),
                ),
                child: const Icon(
                  Icons.hourglass_empty_rounded,
                  size: 60,
                  color: Colors.orange,
                ),
              ),
              const SizedBox(height: 32),

              // Title
              const Text(
                'Account Pending Approval',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // Message
              Text(
                'Your account has been created successfully. '
                    'Please wait while the Admin reviews and approves your account.\n\n'
                    'You will be able to access all features once approved.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey[600],
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 40),

              // Info box
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue[700]),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'If you have already been approved, '
                            'try logging in again below.',
                        style: TextStyle(
                            color: Colors.blue[700], fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // Try logging in again button
              // In case Admin approved while student was on this screen
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.refresh),
                  label: const Text('Check Approval Status'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () async {
                    // Sign out and go back to login
                    // Student logs in again — if approved they'll be routed to navMenu
                    await context.read<AuthViewModel>().logout(context);
                  },
                ),
              ),
              const SizedBox(height: 12),

              // Sign out link
              TextButton(
                onPressed: () async {
                  await context.read<AuthViewModel>().logout(context);
                },
                child: Text(
                  'Sign Out',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}