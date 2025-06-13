import 'package:flutter/material.dart';
import 'package:saba2v2/components/UI/image_picker_row.dart';
import 'package:saba2v2/components/UI/section_title.dart';
import 'package:go_router/go_router.dart';

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
    // TODO: Implement actual file picking logic
    print('Picking file for: $fieldName');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('File picker for $fieldName will be implemented soon')),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Collect all data for backend
      final formData = {
        'officeName': _officeNameController.text,
        'address': _addressController.text,
        'phone': _phoneController.text,
        'email': _emailController.text,
        'password': _passwordController.text,
        'includesVat': _includesVat,
        // Add image paths here when implemented
      };

      // TODO: Send formData to backend
      print(formData);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم انشاء الحساب بنجاح'),
          backgroundColor: Colors.green,
        ),
      );
    }
     context.go('/RealStateHomeScreen');
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
    super.dispose();
  }
}