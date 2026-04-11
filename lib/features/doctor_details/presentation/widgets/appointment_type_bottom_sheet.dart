import 'package:flutter/material.dart';
import 'package:alagy/core/theme/app_color.dart';
import 'package:alagy/core/helpers/extensions.dart';
import 'package:alagy/features/doctor_details/data/models/doctor_model.dart';
import 'package:alagy/features/doctor_details/data/models/doctor_appointment.dart';

class AppointmentTypeBottomSheet extends StatelessWidget {
  final DoctorModel doctor;
  final Function(AppointmentType, double) onTypeSelected;

  const AppointmentTypeBottomSheet({
    super.key,
    required this.doctor,
    required this.onTypeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          
          // Title
          Text(
            context.l10n.selectAppointmentType,
            style: context.theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            context.l10n.chooseAppointmentTypeDescription,
            style: context.theme.textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),
          
          // Consultation Option
          _buildAppointmentOption(
            context,
            title: context.l10n.consultation,
            description: context.l10n.consultationDescription,
            price: doctor.consultationFee ?? 0,
            icon: Icons.medical_services_outlined,
            onTap: () {
              Navigator.pop(context);
              onTypeSelected(AppointmentType.consultation, doctor.consultationFee ?? 0);
            },
          ),
          
          const SizedBox(height: 16),
          
          // Returning Option
          if (doctor.returningFees != null)
            _buildAppointmentOption(
              context,
              title: context.l10n.returning,
              description: context.l10n.returningDescription,
              price: doctor.returningFees!,
              icon: Icons.refresh_outlined,
              onTap: () {
                Navigator.pop(context);
                onTypeSelected(AppointmentType.returning, doctor.returningFees!);
              },
            ),
          
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildAppointmentOption(
    BuildContext context, {
    required String title,
    required String description,
    required double price,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColor.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: AppColor.primaryColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: context.theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: context.theme.textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'EGP ${price.toStringAsFixed(0)}',
                  style: context.theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColor.primaryColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}