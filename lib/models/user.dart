enum UserRole {
  auctioneer,    // البائع/صاحب المزاد
  bidder,        // المزايد (تاجر أو شركة)
  manager        // مدير المزاد
}

enum CompanyType {
  individual,    // تاجر فردي
  llc,          // شركة ذات مسؤولية محدودة (SARL)
  corporation,   // شركة مساهمة (SPA)
  other
}

class User {
  final String id;
  final String fullName;
  final String email;
  final String phoneNumber;
  final UserRole role;
  
  // معلومات التحقق للتجار والشركات
  final String? commercialRegister; // السجل التجاري
  final String? taxId;              // رقم التعريف الضريبي (NIF)
  final String? companyName;        // اسم الشركة
  final CompanyType? companyType;   // نوع الشركة
  final bool isVerified;            // تم التحقق من قبل الإدارة
  final DateTime? verificationDate; // تاريخ التحقق
  
  // عنوان الشركة/التاجر
  final String? address;
  final String? city;
  final String? state;              // الولاية
  
  User({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.role,
    this.commercialRegister,
    this.taxId,
    this.companyName,
    this.companyType,
    this.isVerified = false,
    this.verificationDate,
    this.address,
    this.city,
    this.state,
  });
  
  bool get canBid => role == UserRole.bidder && isVerified;
  bool get canCreateAuction => role == UserRole.auctioneer && isVerified;
  bool get canManage => role == UserRole.manager;
  
  String get roleNameAr {
    switch (role) {
      case UserRole.auctioneer:
        return 'بائع';
      case UserRole.bidder:
        return 'مزايد';
      case UserRole.manager:
        return 'مدير';
    }
  }
  
  String get companyTypeNameAr {
    if (companyType == null) return '';
    switch (companyType!) {
      case CompanyType.individual:
        return 'تاجر فردي';
      case CompanyType.llc:
        return 'شركة ذات مسؤولية محدودة (SARL)';
      case CompanyType.corporation:
        return 'شركة مساهمة (SPA)';
      case CompanyType.other:
        return 'أخرى';
    }
  }
}
