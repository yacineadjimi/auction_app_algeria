import 'package:flutter/foundation.dart';
import '../models/auction.dart';
import '../models/user.dart';
import '../models/bid.dart';

class AuctionProvider with ChangeNotifier {
  User? _currentUser;
  final List<Auction> _auctions = [];
  final List<Bid> _bids = [];
  final List<User> _pendingVerifications = [];

  User? get currentUser => _currentUser;
  List<Auction> get auctions => _auctions;
  List<Bid> get bids => _bids;
  
  // للمزايدين: المزادات النشطة فقط
  List<Auction> get activeAuctions => 
      _auctions.where((a) => a.status == AuctionStatus.active && a.isActive).toList();
  
  // للمديرين: المزادات المعلقة
  List<Auction> get pendingAuctions =>
      _auctions.where((a) => a.status == AuctionStatus.pending).toList();
  
  // للبائعين: مزاداتهم الخاصة
  List<Auction> getUserAuctions(String userId) =>
      _auctions.where((a) => a.auctioneerId == userId).toList();
  
  // المستخدمين المعلقين للتحقق
  List<User> get pendingVerifications => _pendingVerifications;
  
  int get totalBids => _bids.length;
  
  double get totalValue => 
      _auctions.where((a) => a.status == AuctionStatus.active)
          .fold(0, (sum, auction) => sum + auction.currentBid);

  AuctionProvider() {
    _loadDummyData();
  }

  void _loadDummyData() {
    // إضافة بعض المزادات التجريبية
    _auctions.addAll([
      Auction(
        id: '1',
        title: 'مقر تجاري - وسط المدينة',
        description: 'محل تجاري بمساحة 150 متر مربع في موقع استراتيجي',
        imageUrl: 'https://via.placeholder.com/300x200',
        startingPrice: 5000000,
        currentBid: 5500000,
        reservePrice: 5000000,
        startTime: DateTime.now().subtract(const Duration(days: 2)),
        endTime: DateTime.now().add(const Duration(hours: 12)),
        totalBids: 8,
        status: AuctionStatus.active,
        category: AuctionCategory.realEstate,
        auctioneerId: 'auc1',
        auctioneerName: 'شركة العقارات الذهبية',
        auctioneerCompany: 'Golden Real Estate SARL',
        location: 'الجزائر العاصمة',
        condition: 'ممتاز',
        managerId: 'mgr1',
        approvalDate: DateTime.now().subtract(const Duration(days: 3)),
      ),
      Auction(
        id: '2',
        title: 'شاحنة نقل ثقيل - Mercedes',
        description: 'شاحنة مرسيدس أكتروس 2020، حالة ممتازة',
        imageUrl: 'https://via.placeholder.com/300x200',
        startingPrice: 8000000,
        currentBid: 8500000,
        startTime: DateTime.now().subtract(const Duration(days: 1)),
        endTime: DateTime.now().add(const Duration(hours: 8)),
        totalBids: 5,
        status: AuctionStatus.active,
        category: AuctionCategory.vehicles,
        auctioneerId: 'auc2',
        auctioneerName: 'مؤسسة النقل الوطني',
        location: 'وهران',
        condition: 'جيد جداً',
        managerId: 'mgr1',
        approvalDate: DateTime.now().subtract(const Duration(days: 2)),
      ),
      Auction(
        id: '3',
        title: 'معدات مطعم كاملة',
        description: 'معدات مطبخ صناعي شاملة من علامات تجارية عالمية',
        imageUrl: 'https://via.placeholder.com/300x200',
        startingPrice: 2000000,
        currentBid: 2000000,
        startTime: DateTime.now(),
        endTime: DateTime.now().add(const Duration(days: 2)),
        totalBids: 0,
        status: AuctionStatus.pending,
        category: AuctionCategory.equipment,
        auctioneerId: 'auc3',
        auctioneerName: 'محمد بن علي',
        auctioneerCompany: 'مطاعم الأصالة',
        location: 'قسنطينة',
        condition: 'مستعمل - حالة جيدة',
      ),
      Auction(
        id: '4',
        title: 'آلات طباعة صناعية',
        description: 'مجموعة آلات طباعة حديثة للاستخدام الصناعي',
        imageUrl: 'https://via.placeholder.com/300x200',
        startingPrice: 15000000,
        currentBid: 16000000,
        startTime: DateTime.now().subtract(const Duration(hours: 5)),
        endTime: DateTime.now().add(const Duration(hours: 18)),
        totalBids: 12,
        status: AuctionStatus.active,
        category: AuctionCategory.industrial,
        auctioneerId: 'auc1',
        auctioneerName: 'شركة الطباعة المتقدمة',
        location: 'عنابة',
        condition: 'جديد',
        managerId: 'mgr1',
        approvalDate: DateTime.now().subtract(const Duration(hours: 6)),
      ),
    ]);
    
    // إضافة مستخدمين معلقين للتحقق
    _pendingVerifications.addAll([
      User(
        id: 'pend1',
        fullName: 'أحمد بن سعيد',
        email: 'ahmed@example.com',
        phoneNumber: '+213 555 123 456',
        role: UserRole.bidder,
        commercialRegister: '20/00123456',
        taxId: '123456789012345',
        companyName: 'مؤسسة التجارة الحديثة',
        companyType: CompanyType.llc,
        address: 'شارع ديدوش مراد',
        city: 'الجزائر',
        state: 'الجزائر',
        isVerified: false,
      ),
      User(
        id: 'pend2',
        fullName: 'فاطمة زهراء',
        email: 'fatima@example.com',
        phoneNumber: '+213 555 987 654',
        role: UserRole.auctioneer,
        commercialRegister: '31/00654321',
        taxId: '987654321098765',
        companyName: 'شركة العقارات المتطورة',
        companyType: CompanyType.corporation,
        address: 'حي النصر',
        city: 'وهران',
        state: 'وهران',
        isVerified: false,
      ),
    ]);
  }

  void login(String email, String password) {
    // في التطبيق الحقيقي، ستتصل بـ API للمصادقة
    // هنا مثال لتسجيل دخول مدير
    _currentUser = User(
      id: 'mgr1',
      fullName: 'مدير النظام',
      email: email,
      phoneNumber: '+213 555 000 000',
      role: UserRole.manager,
      isVerified: true,
    );
    notifyListeners();
  }

  void signup({
    required String fullName,
    required String email,
    required String phoneNumber,
    required String password,
    required UserRole role,
    String? commercialRegister,
    String? taxId,
    String? companyName,
    CompanyType? companyType,
    String? address,
    String? city,
    String? state,
  }) {
    // في التطبيق الحقيقي، ستتصل بـ API لإنشاء حساب
    final newUser = User(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      fullName: fullName,
      email: email,
      phoneNumber: phoneNumber,
      role: role,
      commercialRegister: commercialRegister,
      taxId: taxId,
      companyName: companyName,
      companyType: companyType,
      address: address,
      city: city,
      state: state,
      isVerified: false, // يحتاج موافقة المدير
    );
    
    // إضافة للقائمة المعلقة
    if (role != UserRole.manager) {
      _pendingVerifications.add(newUser);
    }
    
    _currentUser = newUser;
    notifyListeners();
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }

  // دوال المدير
  void approveUser(String userId) {
    final index = _pendingVerifications.indexWhere((u) => u.id == userId);
    if (index != -1) {
      final user = _pendingVerifications[index];
      // في التطبيق الحقيقي، ستحدث قاعدة البيانات
      _pendingVerifications.removeAt(index);
      notifyListeners();
    }
  }

  void rejectUser(String userId, String reason) {
    final index = _pendingVerifications.indexWhere((u) => u.id == userId);
    if (index != -1) {
      _pendingVerifications.removeAt(index);
      notifyListeners();
    }
  }

  void approveAuction(String auctionId, String notes) {
    final index = _auctions.indexWhere((a) => a.id == auctionId);
    if (index != -1) {
      // في التطبيق الحقيقي، ستحدث قاعدة البيانات
      notifyListeners();
    }
  }

  void rejectAuction(String auctionId, String reason) {
    final index = _auctions.indexWhere((a) => a.id == auctionId);
    if (index != -1) {
      // في التطبيق الحقيقي، ستحدث قاعدة البيانات
      notifyListeners();
    }
  }

  // دوال البائع
  void createAuction({
    required String title,
    required String description,
    required double startingPrice,
    required DateTime endTime,
    required AuctionCategory category,
    String? location,
    String? condition,
    double? reservePrice,
  }) {
    if (_currentUser == null || !_currentUser!.canCreateAuction) {
      return;
    }

    final newAuction = Auction(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      description: description,
      imageUrl: 'https://via.placeholder.com/300x200',
      startingPrice: startingPrice,
      currentBid: startingPrice,
      reservePrice: reservePrice,
      startTime: DateTime.now(),
      endTime: endTime,
      totalBids: 0,
      status: AuctionStatus.pending, // يحتاج موافقة المدير
      category: category,
      auctioneerId: _currentUser!.id,
      auctioneerName: _currentUser!.fullName,
      auctioneerCompany: _currentUser!.companyName,
      location: location,
      condition: condition,
    );

    _auctions.add(newAuction);
    notifyListeners();
  }

  // دوال المزايد
  void placeBid(String auctionId, double amount) {
    if (_currentUser == null || !_currentUser!.canBid) {
      return;
    }

    final auctionIndex = _auctions.indexWhere((a) => a.id == auctionId);
    if (auctionIndex == -1) return;

    final auction = _auctions[auctionIndex];
    if (!auction.isActive) return;

    final newBid = Bid(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      auctionId: auctionId,
      bidderId: _currentUser!.id,
      bidderName: _currentUser!.fullName,
      bidderCompany: _currentUser!.companyName,
      amount: amount,
      timestamp: DateTime.now(),
    );

    _bids.add(newBid);
    // في التطبيق الحقيقي، ستحدث المزاد في قاعدة البيانات
    notifyListeners();
  }

  List<Bid> getAuctionBids(String auctionId) {
    return _bids
        .where((b) => b.auctionId == auctionId)
        .toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }
}
