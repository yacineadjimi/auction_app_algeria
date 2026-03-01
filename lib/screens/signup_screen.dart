import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auction_provider.dart';
import '../models/user.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  // معلومات الشركة/التاجر
  final _commercialRegisterController = TextEditingController();
  final _taxIdController = TextEditingController();
  final _companyNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  
  UserRole _selectedRole = UserRole.bidder;
  CompanyType? _selectedCompanyType;
  bool _agreeToTerms = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  final List<String> algerianStates = [
    'الجزائر', 'وهران', 'قسنطينة', 'عنابة', 'بات', 'سطيف',
    'تيزي وزو', 'بجاية', 'تلمسان', 'مستغانم'
  ];

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _commercialRegisterController.dispose();
    _taxIdController.dispose();
    _companyNameController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    super.dispose();
  }

  void _handleSignup() {
    if (_formKey.currentState!.validate()) {
      if (!_agreeToTerms) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('يرجى الموافقة على الشروط والأحكام'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      context.read<AuctionProvider>().signup(
            fullName: _fullNameController.text,
            email: _emailController.text,
            phoneNumber: _phoneController.text,
            password: _passwordController.text,
            role: _selectedRole,
            commercialRegister: _commercialRegisterController.text.isEmpty 
                ? null 
                : _commercialRegisterController.text,
            taxId: _taxIdController.text.isEmpty 
                ? null 
                : _taxIdController.text,
            companyName: _companyNameController.text.isEmpty 
                ? null 
                : _companyNameController.text,
            companyType: _selectedCompanyType,
            address: _addressController.text.isEmpty 
                ? null 
                : _addressController.text,
            city: _cityController.text.isEmpty 
                ? null 
                : _cityController.text,
            state: _stateController.text.isEmpty 
                ? null 
                : _stateController.text,
          );
      
      // عرض رسالة النجاح
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('تم التسجيل بنجاح'),
          content: const Text(
            'تم إرسال طلبك للمراجعة. سيتم إعلامك عند الموافقة على حسابك من قبل الإدارة.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/home');
              },
              child: const Text('حسناً'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.teal.shade200.withOpacity(0.3),
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Back Button
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const SizedBox(height: 10),
                  
                  // Title
                  const Text(
                    'إنشاء حساب',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.right,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'انضم إلى منصة المزادات الوطنية المعتمدة',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.right,
                  ),
                  const SizedBox(height: 30),
                  
                  // Role Selection
                  Text(
                    'نوع الحساب',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[700],
                    ),
                    textAlign: TextAlign.right,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        RadioListTile<UserRole>(
                          title: const Text('مزايد (تاجر أو شركة)', 
                            textAlign: TextAlign.right),
                          subtitle: const Text(
                            'للمشاركة في المزادات والمزايدة على السلع',
                            textAlign: TextAlign.right,
                            style: TextStyle(fontSize: 12),
                          ),
                          value: UserRole.bidder,
                          groupValue: _selectedRole,
                          onChanged: (value) {
                            setState(() {
                              _selectedRole = value!;
                            });
                          },
                        ),
                        const Divider(height: 1),
                        RadioListTile<UserRole>(
                          title: const Text('بائع', textAlign: TextAlign.right),
                          subtitle: const Text(
                            'لعرض السلع والمنتجات للمزاد',
                            textAlign: TextAlign.right,
                            style: TextStyle(fontSize: 12),
                          ),
                          value: UserRole.auctioneer,
                          groupValue: _selectedRole,
                          onChanged: (value) {
                            setState(() {
                              _selectedRole = value!;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Personal Information
                  _buildSectionTitle('المعلومات الشخصية'),
                  _buildTextField(
                    controller: _fullNameController,
                    label: 'الاسم الكامل',
                    hint: 'أحمد بن علي',
                    icon: Icons.person_outlined,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'يرجى إدخال الاسم الكامل';
                      }
                      return null;
                    },
                  ),
                  _buildTextField(
                    controller: _emailController,
                    label: 'البريد الإلكتروني',
                    hint: 'example@domain.com',
                    icon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'يرجى إدخال البريد الإلكتروني';
                      }
                      if (!value.contains('@')) {
                        return 'يرجى إدخال بريد إلكتروني صحيح';
                      }
                      return null;
                    },
                  ),
                  _buildTextField(
                    controller: _phoneController,
                    label: 'رقم الهاتف',
                    hint: '+213 555 123 456',
                    icon: Icons.phone_outlined,
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'يرجى إدخال رقم الهاتف';
                      }
                      return null;
                    },
                  ),
                  
                  // Company Information
                  const SizedBox(height: 20),
                  _buildSectionTitle('معلومات الشركة/المؤسسة'),
                  
                  _buildTextField(
                    controller: _companyNameController,
                    label: 'اسم الشركة/المؤسسة',
                    hint: 'مؤسسة التجارة الحديثة',
                    icon: Icons.business_outlined,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'يرجى إدخال اسم الشركة';
                      }
                      return null;
                    },
                  ),
                  
                  // Company Type
                  Text(
                    'نوع الشركة',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[700],
                    ),
                    textAlign: TextAlign.right,
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<CompanyType>(
                    initialValue: _selectedCompanyType,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: const Icon(Icons.category_outlined),
                    ),
                    hint: const Text('اختر نوع الشركة', textAlign: TextAlign.right),
                    items: CompanyType.values.map((type) {
                      String label = '';
                      switch (type) {
                        case CompanyType.individual:
                          label = 'تاجر فردي';
                          break;
                        case CompanyType.llc:
                          label = 'شركة ذات مسؤولية محدودة (SARL)';
                          break;
                        case CompanyType.corporation:
                          label = 'شركة مساهمة (SPA)';
                          break;
                        case CompanyType.other:
                          label = 'أخرى';
                          break;
                      }
                      return DropdownMenuItem(
                        value: type,
                        child: Text(label, textAlign: TextAlign.right),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedCompanyType = value;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'يرجى اختيار نوع الشركة';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  _buildTextField(
                    controller: _commercialRegisterController,
                    label: 'رقم السجل التجاري',
                    hint: '20/00123456',
                    icon: Icons.description_outlined,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'يرجى إدخال رقم السجل التجاري';
                      }
                      return null;
                    },
                  ),
                  
                  _buildTextField(
                    controller: _taxIdController,
                    label: 'رقم التعريف الضريبي (NIF)',
                    hint: '123456789012345',
                    icon: Icons.numbers_outlined,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'يرجى إدخال رقم التعريف الضريبي';
                      }
                      if (value.length != 15) {
                        return 'رقم التعريف الضريبي يجب أن يتكون من 15 رقم';
                      }
                      return null;
                    },
                  ),
                  
                  // Address
                  const SizedBox(height: 20),
                  _buildSectionTitle('العنوان'),
                  
                  _buildTextField(
                    controller: _addressController,
                    label: 'العنوان',
                    hint: 'شارع ديدوش مراد، رقم 25',
                    icon: Icons.location_on_outlined,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'يرجى إدخال العنوان';
                      }
                      return null;
                    },
                  ),
                  
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          controller: _cityController,
                          label: 'المدينة',
                          hint: 'الجزائر',
                          icon: Icons.location_city_outlined,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'يرجى إدخال المدينة';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'الولاية',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[700],
                              ),
                            ),
                            const SizedBox(height: 8),
                            DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.grey[100],
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                prefixIcon: const Icon(Icons.map_outlined),
                              ),
                              hint: const Text('اختر'),
                              items: algerianStates.map((state) {
                                return DropdownMenuItem(
                                  value: state,
                                  child: Text(state),
                                );
                              }).toList(),
                              onChanged: (value) {
                                _stateController.text = value ?? '';
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'يرجى اختيار الولاية';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  // Password
                  const SizedBox(height: 20),
                  _buildSectionTitle('كلمة المرور'),
                  
                  _buildPasswordField(
                    controller: _passwordController,
                    label: 'كلمة المرور',
                    obscure: _obscurePassword,
                    onToggle: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                  
                  _buildPasswordField(
                    controller: _confirmPasswordController,
                    label: 'تأكيد كلمة المرور',
                    obscure: _obscureConfirmPassword,
                    onToggle: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                    validator: (value) {
                      if (value != _passwordController.text) {
                        return 'كلمة المرور غير متطابقة';
                      }
                      return null;
                    },
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Terms and Conditions
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 24,
                        width: 24,
                        child: Checkbox(
                          value: _agreeToTerms,
                          onChanged: (value) {
                            setState(() {
                              _agreeToTerms = value ?? false;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'أوافق على الشروط والأحكام وسياسة الخصوصية الخاصة بمنصة المزادات الوطنية',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Submit Button
                  ElevatedButton(
                    onPressed: _handleSignup,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 56),
                    ),
                    child: const Text('إنشاء حساب'),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.teal,
        ),
        textAlign: TextAlign.right,
      ),
    );
  }
  
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          textAlign: TextAlign.right,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon),
          ),
          validator: validator,
        ),
        const SizedBox(height: 16),
      ],
    );
  }
  
  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool obscure,
    required VoidCallback onToggle,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: obscure,
          textAlign: TextAlign.right,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.lock_outlined),
            suffixIcon: IconButton(
              icon: Icon(
                obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
              ),
              onPressed: onToggle,
            ),
          ),
          validator: validator ?? (value) {
            if (value == null || value.isEmpty) {
              return 'يرجى إدخال كلمة المرور';
            }
            if (value.length < 6) {
              return 'كلمة المرور يجب أن تتكون من 6 أحرف على الأقل';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
