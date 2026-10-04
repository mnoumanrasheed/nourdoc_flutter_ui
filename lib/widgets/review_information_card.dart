import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

class ReviewInformationCard extends StatelessWidget {
  const ReviewInformationCard({
    required this.data,
    required this.onEditPersonal,
    required this.onEditProfessional,
    super.key,
  });
  final Map<String, String> data;
  final VoidCallback onEditPersonal, onEditProfessional;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: AppColors.border),
      boxShadow: const [
        BoxShadow(
          color: Color(0x0A18201E),
          blurRadius: 16,
          offset: Offset(0, 5),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.fact_check_outlined, color: AppColors.brand, size: 21),
            SizedBox(width: 9),
            Text(
              'Review your information',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
            ),
          ],
        ),
        const SizedBox(height: 18),
        _group('Personal Information', [
          'Name',
          'Email',
          'Phone',
        ], onEditPersonal),
        const Divider(height: 30, color: AppColors.border),
        _group('Professional Information', [
          'Country',
          'City',
          'Specialty',
          'Experience',
        ], onEditProfessional),
        const Divider(height: 30, color: AppColors.border),
        _line('PMDC License', data['PMDC License'] ?? '—'),
      ],
    ),
  );
  Widget _group(String heading, List<String> keys, VoidCallback edit) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Text(
            heading,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
          ),
          const Spacer(),
          TextButton(
            onPressed: edit,
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              foregroundColor: AppColors.brand,
            ),
            child: const Text('Edit'),
          ),
        ],
      ),
      const SizedBox(height: 7),
      ...keys.map(
        (key) => Padding(
          padding: const EdgeInsets.only(top: 5),
          child: _line(key, data[key] ?? '—'),
        ),
      ),
    ],
  );
  Widget _line(String label, String value) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Icon(_iconFor(label), size: 17, color: AppColors.mutedText),
      const SizedBox(width: 8),
      SizedBox(
        width: 82,
        child: Text(
          label,
          style: const TextStyle(color: AppColors.mutedText, fontSize: 12),
        ),
      ),
      Expanded(
        child: Text(
          value.isEmpty ? '—' : value,
          style: const TextStyle(
            color: AppColors.text,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.right,
        ),
      ),
    ],
  );

  IconData _iconFor(String label) => switch (label) {
    'Name' => Icons.person_outline_rounded,
    'Email' => Icons.mail_outline_rounded,
    'Phone' => Icons.phone_outlined,
    'Country' => Icons.public_rounded,
    'City' => Icons.location_on_outlined,
    'Specialty' => Icons.medical_services_outlined,
    'Experience' => Icons.business_center_outlined,
    _ => Icons.description_outlined,
  };
}
