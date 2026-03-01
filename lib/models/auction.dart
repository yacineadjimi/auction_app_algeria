enum AuctionStatus {
  pending,      // في انتظار الموافقة
  approved,     // تمت الموافقة
  active,       // نشط
  ended,        // انتهى
  cancelled,    // ملغي
  rejected      // مرفوض
}

enum AuctionCategory {
  realEstate,       // عقارات
  vehicles,         // مركبات
  equipment,        // معدات
  electronics,      // إلكترونيات
  furniture,        // أثاث
  industrial,       // صناعية
  agriculture,      // زراعية
  other            // أخرى
}

class Auction {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final double startingPrice;  // السعر الابتدائي
  final double currentBid;     // السعر الحالي
  final double? reservePrice;  // السعر الاحتياطي (أقل سعر مقبول)
  final DateTime startTime;    // وقت البداية
  final DateTime endTime;      // وقت النهاية
  final int totalBids;
  final AuctionStatus status;
  final AuctionCategory category;
  
  // معلومات البائع
  final String auctioneerId;
  final String auctioneerName;
  final String? auctioneerCompany;
  
  // معلومات المزايد الفائز
  final String? winnerId;
  final String? winnerName;
  final double? winningBid;
  
  // معلومات الإدارة
  final String? managerId;      // مدير المزاد المسؤول
  final String? approvalNotes;  // ملاحظات الموافقة
  final DateTime? approvalDate; // تاريخ الموافقة
  
  // تفاصيل إضافية
  final String? location;       // موقع العنصر
  final String? condition;      // حالة العنصر
  final List<String>? documents; // المستندات المرفقة
  
  Auction({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.startingPrice,
    required this.currentBid,
    this.reservePrice,
    required this.startTime,
    required this.endTime,
    required this.totalBids,
    required this.status,
    required this.category,
    required this.auctioneerId,
    required this.auctioneerName,
    this.auctioneerCompany,
    this.winnerId,
    this.winnerName,
    this.winningBid,
    this.managerId,
    this.approvalNotes,
    this.approvalDate,
    this.location,
    this.condition,
    this.documents,
  });
  
  bool get isActive => status == AuctionStatus.active && 
                       DateTime.now().isBefore(endTime);
  
  bool get hasEnded => DateTime.now().isAfter(endTime) || 
                       status == AuctionStatus.ended;
  
  bool get needsApproval => status == AuctionStatus.pending;
  
  String get statusNameAr {
    switch (status) {
      case AuctionStatus.pending:
        return 'في انتظار الموافقة';
      case AuctionStatus.approved:
        return 'تمت الموافقة';
      case AuctionStatus.active:
        return 'نشط';
      case AuctionStatus.ended:
        return 'انتهى';
      case AuctionStatus.cancelled:
        return 'ملغي';
      case AuctionStatus.rejected:
        return 'مرفوض';
    }
  }
  
  String get categoryNameAr {
    switch (category) {
      case AuctionCategory.realEstate:
        return 'عقارات';
      case AuctionCategory.vehicles:
        return 'مركبات';
      case AuctionCategory.equipment:
        return 'معدات';
      case AuctionCategory.electronics:
        return 'إلكترونيات';
      case AuctionCategory.furniture:
        return 'أثاث';
      case AuctionCategory.industrial:
        return 'صناعية';
      case AuctionCategory.agriculture:
        return 'زراعية';
      case AuctionCategory.other:
        return 'أخرى';
    }
  }
}
