import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../widgets/form_components.dart';
import '../../widgets/nourdoc_brand_header.dart';
import '../../widgets/review_information_card.dart';
import '../../widgets/signup_form_card.dart';
import '../../widgets/signup_progress_indicator.dart';

class DoctorSignupScreen extends StatefulWidget {
  const DoctorSignupScreen({super.key});

  @override
  State<DoctorSignupScreen> createState() => _DoctorSignupScreenState();
}

class _DoctorSignupScreenState extends State<DoctorSignupScreen> {
  final form = GlobalKey<FormState>();
  final name = TextEditingController();
  final email = TextEditingController();
  final phone = TextEditingController();
  final license = TextEditingController();
  final cityController = TextEditingController();
  final customCountryController = TextEditingController();
  final customSpecialtyController = TextEditingController();
  int step = 1;
  int _transitionDirection = 1;
  String? country = 'Pakistan';
  String? specialty;
  String? experience;
  String _phoneCountry = 'Pakistan';
  String _countryIsoCode = 'PK';
  String _dialCode = '+92';
  String _fullPhoneNumber = '';

  String? requiredValue(String? value, String label) =>
      value == null || value.trim().isEmpty ? '$label is required' : null;

  @override
  void dispose() {
    name.dispose();
    email.dispose();
    phone.dispose();
    license.dispose();
    cityController.dispose();
    customCountryController.dispose();
    customSpecialtyController.dispose();
    super.dispose();
  }

  void next() {
    if (form.currentState!.validate() && step < 3) {
      FocusScope.of(context).unfocus();
      setState(() {
        _transitionDirection = 1;
        step++;
      });
    }
  }

  void back() {
    FocusScope.of(context).unfocus();
    setState(() {
      _transitionDirection = -1;
      step--;
    });
  }

  Map<String, String> get review => {
    'Name': name.text,
    'Email': email.text,
    'Phone': _fullPhoneNumber.isEmpty
        ? '$_dialCode${phone.text}'
        : _fullPhoneNumber,
    'Country': selectedCountry,
    'Phone country': _phoneCountry,
    'Country code': _countryIsoCode,
    'Dial code': _dialCode,
    'Local number': phone.text,
    'City': cityController.text,
    'Specialty': selectedSpecialty,
    'Experience': experience ?? '',
    'PMDC License': license.text,
  };

  String get selectedCountry =>
      country == 'Other' ? customCountryController.text : country ?? '';

  String get selectedSpecialty =>
      specialty == 'Other' ? customSpecialtyController.text : specialty ?? '';

  void done() {
    if (!form.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => const _SignupSuccessSheet(),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Form(
        key: form,
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Column(
            children: [
              SignupHeroHeader(
                step: step,
                assetPath: currentHeaderAsset,
                title: stepTitle,
                subtitle: stepSubtitle,
                direction: _transitionDirection,
                onBack: step == 1 ? null : back,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(22, 18, 22, 24),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  reverseDuration: const Duration(milliseconds: 260),
                  transitionBuilder: (child, animation) {
                    final offset =
                        Tween<Offset>(
                          begin: Offset(_transitionDirection * 0.06, 0),
                          end: Offset.zero,
                        ).animate(
                          CurvedAnimation(
                            parent: animation,
                            curve: Curves.easeOutCubic,
                          ),
                        );
                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(position: offset, child: child),
                    );
                  },
                  child: Column(
                    key: ValueKey(step),
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SignupProgressIndicator(currentStep: step),
                      const SizedBox(height: 16),
                      AnimatedSignupContent(children: content()),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );

  String get stepTitle => switch (step) {
    1 => 'Doctor Signup',
    2 => 'Your Practice Details',
    _ => 'License & Review',
  };

  String get currentHeaderAsset => switch (step) {
    1 => 'assets/images/nourdoc_header_step1.png',
    2 => 'assets/images/nourdoc_header_step2.png',
    _ => 'assets/images/nourdoc_header_step3.png',
  };

  String get stepSubtitle => switch (step) {
    1 => "Let's start with your basic information",
    2 => 'Tell us about your location and professional experience',
    _ => 'Verify your professional details',
  };

  List<Widget> content() => switch (step) {
    1 => personal(),
    2 => professional(),
    _ => licenseStep(),
  };

  List<Widget> personal() => [
    SignupFormCard(
      child: Column(
        children: [
          CustomTextField(
            label: 'Full Name',
            hint: 'Enter your full name',
            controller: name,
            leadingIcon: Icons.person_outline_rounded,
            requiredField: true,
            validator: (value) => requiredValue(value, 'Full name'),
          ),
          const SizedBox(height: 18),
          CustomTextField(
            label: 'Email Address',
            hint: 'Enter your email address',
            controller: email,
            leadingIcon: Icons.mail_outline_rounded,
            keyboardType: TextInputType.emailAddress,
            validator: (value) =>
                value != null &&
                    value.isNotEmpty &&
                    !RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value)
                ? 'Enter a valid email address'
                : null,
          ),
          const SizedBox(height: 18),
          InternationalPhoneField(
            controller: phone,
            onChanged: (value) => setState(() {
              _dialCode = '+${value.countryCode}';
              _countryIsoCode = value.countryISOCode;
              _fullPhoneNumber = '+${value.completeNumber}';
            }),
            onCountryChanged: (value) => setState(() {
              _phoneCountry = value.name;
              _countryIsoCode = value.code;
              _dialCode = '+${value.dialCode}';
              _fullPhoneNumber = phone.text.isEmpty
                  ? ''
                  : '$_dialCode${phone.text}';
            }),
          ),
        ],
      ),
    ),
    const SizedBox(height: 28),
    PrimaryButton(label: 'Continue  →', onPressed: next),
  ];

  List<Widget> professional() => [
    SignupFormCard(
      child: Column(
        children: [
          CountryPickerField(
            value: country,
            validator: (selected) => requiredValue(selected, 'Country'),
            onChanged: (selected) => setState(() {
              country = selected;
              if (selected != 'Other') customCountryController.clear();
            }),
          ),
          if (country == 'Other') ...[
            const SizedBox(height: 20),
            CustomTextField(
              label: 'Enter your country',
              hint: 'Type your country name',
              controller: customCountryController,
              requiredField: true,
              validator: (value) => requiredValue(value, 'Country'),
            ),
          ],
          const SizedBox(height: 20),
          CustomTextField(
            label: 'City',
            hint: 'Enter your city',
            controller: cityController,
            leadingIcon: Icons.location_on_outlined,
            requiredField: true,
            validator: (value) => requiredValue(value, 'City'),
          ),
          const SizedBox(height: 20),
          drop(
            'Specialty',
            const [
              'General Practice',
              'Cardiology',
              'Dermatology',
              'Pediatrics',
              'Gynecology',
              'Neurology',
              'Orthopedics',
              'Psychiatry',
              'ENT',
              'Ophthalmology',
              'Other',
            ],
            specialty,
            (value) => specialty = value,
            Icons.medical_services_outlined,
          ),
          if (specialty == 'Other') ...[
            const SizedBox(height: 20),
            CustomTextField(
              label: 'Enter your specialty',
              hint: 'Type your specialty',
              controller: customSpecialtyController,
              requiredField: true,
              validator: (value) => requiredValue(value, 'Specialty'),
            ),
          ],
          const SizedBox(height: 20),
          drop(
            'Experience',
            const [
              'Less than 1 year',
              '1 Year',
              '2 Years',
              '3 Years',
              '4 Years',
              '5 Years',
              '6-10 Years',
              '10+ Years',
            ],
            experience,
            (value) => experience = value,
            Icons.business_center_outlined,
          ),
        ],
      ),
    ),
    const SizedBox(height: 28),
    actions('Continue  →', next),
  ];

  Widget drop(
    String label,
    List<String> items,
    String? value,
    ValueChanged<String?> change, [
    IconData? icon,
  ]) => CustomDropdown(
    label: label,
    hint: 'Select $label',
    items: items,
    value: value,
    requiredField: true,
    leadingIcon: icon,
    validator: (selected) => requiredValue(selected, label),
    onChanged: (selected) => setState(() => change(selected)),
  );

  List<Widget> licenseStep() => [
    SignupFormCard(
      child: CustomTextField(
        label: 'PMDC License Number',
        hint: 'Enter license number',
        controller: license,
        leadingIcon: Icons.description_outlined,
        requiredField: true,
        validator: (value) => requiredValue(value, 'PMDC license number'),
      ),
    ),
    const SizedBox(height: 18),
    ReviewInformationCard(
      data: review,
      onEditPersonal: () => setState(() {
        _transitionDirection = -1;
        step = 1;
      }),
      onEditProfessional: () => setState(() {
        _transitionDirection = -1;
        step = 2;
      }),
    ),
    const SizedBox(height: 28),
    actions('Create Account  →', done),
  ];

  Widget actions(String label, VoidCallback action) => Row(
    children: [
      Expanded(
        child: SizedBox(
          height: 54,
          child: OutlinedButton.icon(
            onPressed: back,
            icon: const Icon(Icons.arrow_back_rounded, size: 19),
            label: const Text(
              'Back',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.brand,
              side: const BorderSide(color: AppColors.brand),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
      ),
      const SizedBox(width: 14),
      Expanded(
        flex: 2,
        child: PrimaryButton(label: label, onPressed: action),
      ),
    ],
  );
}

class AnimatedSignupContent extends StatefulWidget {
  const AnimatedSignupContent({required this.children, super.key});
  final List<Widget> children;
  @override
  State<AnimatedSignupContent> createState() => _AnimatedSignupContentState();
}

class _AnimatedSignupContentState extends State<AnimatedSignupContent>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 340),
  )..forward();
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: List.generate(widget.children.length, (index) {
      final start = (index * 0.055).clamp(0.0, 0.45).toDouble();
      final animation = CurvedAnimation(
        parent: _controller,
        curve: Interval(start, 1, curve: Curves.easeOutCubic),
      );
      return FadeTransition(
        opacity: animation,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.035),
            end: Offset.zero,
          ).animate(animation),
          child: widget.children[index],
        ),
      );
    }),
  );
}

class _SignupSuccessSheet extends StatefulWidget {
  const _SignupSuccessSheet();
  @override
  State<_SignupSuccessSheet> createState() => _SignupSuccessSheetState();
}

class _SignupSuccessSheetState extends State<_SignupSuccessSheet>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 360),
  )..forward();
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final curve = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );
    return FadeTransition(
      opacity: _controller,
      child: ScaleTransition(
        scale: Tween<double>(begin: 0.96, end: 1).animate(curve),
        child: Container(
          padding: const EdgeInsets.all(28),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ScaleTransition(
                scale: Tween<double>(begin: 0.5, end: 1).animate(curve),
                child: const CircleAvatar(
                  radius: 30,
                  backgroundColor: AppColors.successSurface,
                  child: Icon(
                    Icons.check_rounded,
                    color: AppColors.brand,
                    size: 32,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'You are all set',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              const Text(
                'Account information completed successfully',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.mutedText),
              ),
              const SizedBox(height: 24),
              PrimaryButton(
                label: 'Done',
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
