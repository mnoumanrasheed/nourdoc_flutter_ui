import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import '../core/theme/app_colors.dart';

class FieldLabel extends StatelessWidget {
  const FieldLabel(this.label, {this.requiredField = false, super.key});
  final String label;
  final bool requiredField;
  @override
  Widget build(BuildContext context) => RichText(
    text: TextSpan(
      style: const TextStyle(
        color: AppColors.text,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      children: [
        TextSpan(text: label),
        if (requiredField)
          const TextSpan(
            text: ' *',
            style: TextStyle(color: AppColors.brand),
          ),
      ],
    ),
  );
}

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    required this.label,
    required this.hint,
    required this.controller,
    this.requiredField = false,
    this.keyboardType,
    this.validator,
    this.prefix,
    this.leadingIcon,
    super.key,
  });
  final String label, hint;
  final TextEditingController controller;
  final bool requiredField;
  final TextInputType? keyboardType;
  final FormFieldValidator<String>? validator;
  final Widget? prefix;
  final IconData? leadingIcon;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      FieldLabel(label, requiredField: requiredField),
      const SizedBox(height: 8),
      TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon:
              prefix ??
              (leadingIcon == null
                  ? null
                  : Icon(leadingIcon, color: AppColors.mutedText)),
        ),
      ),
    ],
  );
}

class CustomDropdown extends StatelessWidget {
  const CustomDropdown({
    required this.label,
    required this.hint,
    required this.items,
    required this.value,
    required this.onChanged,
    this.requiredField = false,
    this.validator,
    this.leadingIcon,
    super.key,
  });
  final String label, hint;
  final List<String> items;
  final String? value;
  final ValueChanged<String?> onChanged;
  final bool requiredField;
  final FormFieldValidator<String>? validator;
  final IconData? leadingIcon;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      FieldLabel(label, requiredField: requiredField),
      const SizedBox(height: 8),
      DropdownButtonFormField<String>(
        value: value,
        isExpanded: true,
        validator: validator,
        hint: Text(hint),
        icon: const Icon(Icons.keyboard_arrow_down_rounded),
        decoration: InputDecoration(
          prefixIcon: leadingIcon == null
              ? null
              : Icon(leadingIcon, color: AppColors.mutedText),
        ),
        items: items
            .map(
              (item) => DropdownMenuItem(
                value: item,
                child: Text(item, overflow: TextOverflow.ellipsis),
              ),
            )
            .toList(),
        onChanged: onChanged,
      ),
    ],
  );
}

class CountryPickerField extends StatelessWidget {
  const CountryPickerField({
    required this.value,
    required this.onChanged,
    this.validator,
    super.key,
  });

  final String? value;
  final ValueChanged<String?> onChanged;
  final FormFieldValidator<String>? validator;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const FieldLabel('Country', requiredField: true),
      const SizedBox(height: 8),
      FormField<String>(
        key: ValueKey(value),
        initialValue: value,
        validator: validator,
        builder: (state) => InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _showPicker(context, state),
          child: InputDecorator(
            isEmpty: state.value == null || state.value!.isEmpty,
            decoration: InputDecoration(
              hintText: 'Select your country',
              errorText: state.errorText,
              prefixIcon: const Icon(
                Icons.public_rounded,
                color: AppColors.mutedText,
              ),
              suffixIcon: const Icon(Icons.keyboard_arrow_down_rounded),
            ),
            child: Text(
              state.value ?? 'Select your country',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: state.value == null
                    ? AppColors.mutedText
                    : AppColors.text,
              ),
            ),
          ),
        ),
      ),
    ],
  );

  Future<void> _showPicker(
    BuildContext context,
    FormFieldState<String> state,
  ) async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const _CountryPickerSheet(),
    );
    if (selected != null) {
      state.didChange(selected);
      onChanged(selected);
    }
  }
}

class _CountryPickerSheet extends StatefulWidget {
  const _CountryPickerSheet();

  @override
  State<_CountryPickerSheet> createState() => _CountryPickerSheetState();
}

class _CountryPickerSheetState extends State<_CountryPickerSheet> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final query = _query.trim().toLowerCase();
    final matches = countries.where((country) {
      return country.name.toLowerCase().contains(query) ||
          country.dialCode.contains(query.replaceAll('+', ''));
    }).toList();
    return DraggableScrollableSheet(
      initialChildSize: 0.72,
      minChildSize: 0.5,
      maxChildSize: 0.92,
      builder: (context, controller) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(
              width: 42,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.inactive,
                borderRadius: BorderRadius.circular(99),
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(24, 18, 24, 14),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Select country',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                autofocus: true,
                onChanged: (value) => setState(() => _query = value),
                decoration: const InputDecoration(
                  hintText: 'Search country or dial code',
                  prefixIcon: Icon(Icons.search_rounded),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                controller: controller,
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 24),
                itemCount: matches.length + 1,
                itemBuilder: (context, index) {
                  if (index == matches.length) {
                    return ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      leading: const CircleAvatar(
                        backgroundColor: AppColors.successSurface,
                        child: Icon(
                          Icons.edit_outlined,
                          color: AppColors.brand,
                        ),
                      ),
                      title: const Text(
                        'Other',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      subtitle: const Text('Enter your country manually'),
                      onTap: () => Navigator.pop(context, 'Other'),
                    );
                  }
                  final country = matches[index];
                  return ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    leading: Text(
                      country.flag,
                      style: const TextStyle(fontSize: 22),
                    ),
                    title: Text(country.name, overflow: TextOverflow.ellipsis),
                    trailing: Text(
                      '+${country.dialCode}',
                      style: const TextStyle(color: AppColors.mutedText),
                    ),
                    onTap: () => Navigator.pop(context, country.name),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InternationalPhoneField extends StatelessWidget {
  const InternationalPhoneField({
    required this.controller,
    required this.onChanged,
    required this.onCountryChanged,
    super.key,
  });

  final TextEditingController controller;
  final ValueChanged<PhoneNumber> onChanged;
  final ValueChanged<Country> onCountryChanged;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const FieldLabel('Phone Number', requiredField: true),
      const SizedBox(height: 8),
      IntlPhoneField(
        controller: controller,
        initialCountryCode: 'PK',
        disableLengthCheck: false,
        keyboardType: TextInputType.phone,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        textInputAction: TextInputAction.next,
        decoration: const InputDecoration(
          hintText: '3001234567',
          counterText: '',
          prefixIcon: Icon(Icons.phone_outlined, color: AppColors.mutedText),
        ),
        dropdownTextStyle: const TextStyle(
          color: AppColors.text,
          fontWeight: FontWeight.w600,
        ),
        dropdownIcon: const Icon(Icons.keyboard_arrow_down_rounded),
        flagsButtonPadding: const EdgeInsets.only(left: 12),
        showCountryFlag: true,
        onChanged: onChanged,
        onCountryChanged: onCountryChanged,
        validator: (phone) {
          if (phone == null || phone.number.trim().isEmpty) {
            return 'Phone number is required';
          }
          return null;
        },
      ),
    ],
  );
}

class PrimaryButton extends StatefulWidget {
  const PrimaryButton({
    required this.label,
    required this.onPressed,
    super.key,
  });
  final String label;
  final VoidCallback onPressed;

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  bool _pressed = false;

  void _setPressed(bool value) => setState(() => _pressed = value);

  @override
  Widget build(BuildContext context) => AnimatedScale(
    scale: _pressed ? 0.98 : 1,
    duration: const Duration(milliseconds: 100),
    curve: Curves.easeOut,
    child: GestureDetector(
      onTapDown: (_) => _setPressed(true),
      onTapUp: (_) => _setPressed(false),
      onTapCancel: () => _setPressed(false),
      child: SizedBox(
        height: 54,
        width: double.infinity,
        child: FilledButton(
          onPressed: widget.onPressed,
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.brand,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: Text(
            widget.label,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
          ),
        ),
      ),
    ),
  );
}
