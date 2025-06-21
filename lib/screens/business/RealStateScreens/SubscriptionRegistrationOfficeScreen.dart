import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:saba2v2/components/UI/image_picker_row.dart';
import 'package:saba2v2/components/UI/section_title.dart';
import 'package:saba2v2/providers/auth_provider.dart';
import 'package:saba2v2/services/strapi_service.dart';

class SubscriptionRegistrationOfficeScreen extends StatefulWidget {
  const SubscriptionRegistrationOfficeScreen({super.key});

  @override
  State<SubscriptionRegistrationOfficeScreen> createState() =>
      _SubscriptionRegistrationOfficeScreenState();
}

class _SubscriptionRegistrationOfficeScreenState
    extends State<SubscriptionRegistrationOfficeScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _includesVat = false;

  // Controllers for text fields
  final TextEditingController _officeNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _ConfirmPasswordController = TextEditingController();
  // State for image paths
  String? _officeLogoPath;
  String? _ownerIdFrontPath;
  String? _ownerIdBackPath;
  String? _officePhotoFrontPath;
  String? _crPhotoFrontPath;
  String? _crPhotoBackPath;

  Future<void> _pickFile(String fieldName) async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null && result.files.isNotEmpty) {
      final path = result.files.single.path;
      if (path == null) return;
      setState(() {
        switch (fieldName) {
          case 'officeLogo':
            _officeLogoPath = path;
            break;
          case 'ownerIdFront':
            _ownerIdFrontPath = path;
            break;
          case 'ownerIdBack':
            _ownerIdBackPath = path;
            break;
          case 'officePhotoFront':
            _officePhotoFrontPath = path;
            break;
          case 'crPhotoFront':
            _crPhotoFrontPath = path;
            break;
          case 'crPhotoBack':
            _crPhotoBackPath = path;
            break;
        }
      });
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    if (_passwordController.text != _ConfirmPasswordController.text) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('كلمتا السر غير متطابقتين')));
      return;
    }

    if ([
          _officeLogoPath,
          _ownerIdFrontPath,
          _ownerIdBackPath,
          _officePhotoFrontPath,
          _crPhotoFrontPath,
          _crPhotoBackPath
        ].any((p) => p == null)) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('الرجاء اختيار جميع الصور')));
      return;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final step1 = await authProvider.registerStep1(
      _officeNameController.text.trim(),
      _emailController.text.trim(),
      _passwordController.text,
    );

    if (!step1['success']) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(step1['message'])));
      return;
    }

    final token = authProvider.token;
    if (token == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('خطأ في الجلسة')));
      return;
    }

    final strapiService = StrapiService();

    final officeLogoUrl = await strapiService.uploadFile(_officeLogoPath!, token);
    final ownerIdFrontUrl = await strapiService.uploadFile(_ownerIdFrontPath!, token);
    final ownerIdBackUrl = await strapiService.uploadFile(_ownerIdBackPath!, token);
    final officePhotoUrl = await strapiService.uploadFile(_officePhotoFrontPath!, token);
    final crFrontUrl = await strapiService.uploadFile(_crPhotoFrontPath!, token);
    final crBackUrl = await strapiService.uploadFile(_crPhotoBackPath!, token);

    if ([
          officeLogoUrl,
          ownerIdFrontUrl,
          ownerIdBackUrl,
          officePhotoUrl,
          crFrontUrl,
          crBackUrl
        ].any((u) => u == null)) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('فشل رفع الملفات')));
      return;
    }

    final step2 = await authProvider.registerRealstateOfficeStep2(
      phone: _phoneController.text.trim(),
      address: _addressController.text.trim(),
      officeLogo: officeLogoUrl!,
      ownerIdFront: ownerIdFrontUrl!,
      ownerIdBack: ownerIdBackUrl!,
      officeImage: officePhotoUrl!,
      commercialCardFront: crFrontUrl!,
      commercialCardBack: crBackUrl!,
      vat: _includesVat,
    );

    if (step2['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم انشاء الحساب بنجاح'), backgroundColor: Colors.green));
      if (mounted) {
        context.go('/RealStateHomeScreen');
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(step2['message'])));
    }
  }

  Widget _buildFormField({
    required String hintText,
    required TextEditingController controller,
    bool obscureText = false,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      textAlign: TextAlign.right,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 15.0,
          horizontal: 20.0,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'هذا الحقل مطلوب';
        }
        return null;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('المستندات المطلوبة'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section 1: Office Identity
              Container(
                width: double.infinity,
                child: const SectionTitle(title: 'هوية المكتب'),
              ),
              const SizedBox(height: 16),
              _buildFormField(
                hintText: 'اسم المكتب',
                controller: _officeNameController,
              ),
              const SizedBox(height: 16),
              _buildFormField(
                hintText: 'عنوان المكتب',
                controller: _addressController,
              ),
              const SizedBox(height: 16),
              _buildFormField(
                hintText: 'رقم الهاتف',
                controller: _phoneController,
              ),
              const SizedBox(height: 16),
              _buildFormField(
                hintText: 'البريد الإلكتروني',
                controller: _emailController,
              ),
              const SizedBox(height: 16),
              _buildFormField(
                hintText: 'كلمة السر',
                controller: _passwordController,
                obscureText: true,
              ),
              _buildFormField(
                hintText: 'تأكيد كلمة السر',
                controller: _ConfirmPasswordController,
                obscureText: true,
              ),
              const SizedBox(height: 24),
              ImagePickerRow(
                label: 'اختيار شعار المكتب',
                icon: Icons.image_outlined,
                fieldIdentifier: 'officeLogo',
                onTap: () => _pickFile('officeLogo'),
              ),

              // Section 2: Owner ID
              Container(
                width: double.infinity,
                child: const SectionTitle(title: 'صور هوية المالك'),
              ),
              const SizedBox(height: 16),
              ImagePickerRow(
                label: 'صورة أمامية',
                icon: Icons.image_outlined,
                fieldIdentifier: 'ownerIdFront',
                onTap: () => _pickFile('ownerIdFront'),
              ),
              const SizedBox(height: 12),
              ImagePickerRow(
                label: 'صورة خلفية',
                icon: Icons.image_outlined,
                fieldIdentifier: 'ownerIdBack',
                onTap: () => _pickFile('ownerIdBack'),
              ),

              // Section 3: Office Photos
              Container(
                width: double.infinity,
                child: const SectionTitle(title: 'صورة المكتب'),
              ),
              const SizedBox(height: 16),
              ImagePickerRow(
                label: 'صورة أمامية',
                icon: Icons.image_outlined,
                fieldIdentifier: 'officePhotoFront',
                onTap: () => _pickFile('officePhotoFront'),
              ),

              // Section 4: Commercial Register
              Container(
                width: double.infinity,
                child: const SectionTitle(title: 'صور السجل التجاري'),
              ),
              const SizedBox(height: 16),
              ImagePickerRow(
                label: 'صورة أمامية',
                icon: Icons.image_outlined,
                fieldIdentifier: 'crPhotoFront',
                onTap: () => _pickFile('crPhotoFront'),
              ),
              const SizedBox(height: 12),
              ImagePickerRow(
                label: 'صورة خلفية',
                icon: Icons.image_outlined,
                fieldIdentifier: 'crPhotoBack',
                onTap: () => _pickFile('crPhotoBack'),
              ),

              // Section 5: VAT
              Container(
                width: double.infinity,
                child: const SectionTitle(title: 'الضريبة'),
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('هل تشمل الأسعار ضريبة القيمة المضافة؟'),
                value: _includesVat,
                onChanged: (value) => setState(() => _includesVat = value),
                activeColor: Colors.orange,
                contentPadding: EdgeInsets.zero,
              ),

              // Submit Button
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text(
                    'التالي',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
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

  @override
  void dispose() {
    _officeNameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _ConfirmPasswordController.dispose();
    super.dispose();
  }
}