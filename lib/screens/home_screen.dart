import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/auction_provider.dart';
import '../models/auction.dart';
import '../models/user.dart';
import 'manager_dashboard.dart';
import 'create_auction_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.teal.shade700,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.gavel,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'المزادات الوطنية',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'منصة معتمدة من الدولة',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          // عرض أيقونات مختلفة حسب دور المستخدم
          Consumer<AuctionProvider>(
            builder: (context, provider, child) {
              if (provider.currentUser == null) return const SizedBox();
              
              final user = provider.currentUser!;
              
              // للمديرين: زر لوحة التحكم
              if (user.role == UserRole.manager) {
                return IconButton(
                  icon: const Icon(Icons.admin_panel_settings, color: Colors.teal),
                  tooltip: 'لوحة التحكم',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ManagerDashboard(),
                      ),
                    );
                  },
                );
              }
              
              // للبائعين: زر إنشاء مزاد
              if (user.role == UserRole.auctioneer && user.isVerified) {
                return IconButton(
                  icon: const Icon(Icons.add_circle_outline, color: Colors.teal),
                  tooltip: 'إنشاء مزاد',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CreateAuctionScreen(),
                      ),
                    );
                  },
                );
              }
              
              return const SizedBox();
            },
          ),
          IconButton(
            icon: const Icon(Icons.person_outline, color: Colors.teal),
            onPressed: () {
              _showUserProfile(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Stats Cards
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Consumer<AuctionProvider>(
              builder: (context, provider, child) {
                return Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        'Active Auctions',
                        provider.activeAuctions.length.toString(),
                        Icons.gavel,
                        Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        'Total Bids',
                        provider.totalBids.toString(),
                        Icons.trending_up,
                        Colors.green,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        'Total Value',
                        '${NumberFormat('#,###').format(provider.totalValue)} DA',
                        Icons.attach_money,
                        Colors.orange,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search auctions by title or description',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          // Category Filter
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text(
                  'All Categories',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(width: 8),
                Icon(Icons.arrow_drop_down, size: 20),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Tabs
          Container(
            color: Colors.white,
            child: Row(
              children: [
                _buildTab('Active Auctions', 0, true),
                _buildTab('Ended Auctions', 1, false),
                _buildTab('All Auctions', 2, false),
              ],
            ),
          ),
          // Auctions List
          Expanded(
            child: Consumer<AuctionProvider>(
              builder: (context, provider, child) {
                final auctions = provider.activeAuctions;
                if (auctions.isEmpty) {
                  return const Center(
                    child: Text('No active auctions'),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: auctions.length,
                  itemBuilder: (context, index) {
                    return _buildAuctionCard(auctions[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String label, int index, bool hasCount) {
    final isSelected = _selectedTab == index;
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedTab = index;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected ? Colors.teal : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? Colors.teal : Colors.grey[600],
                ),
              ),
              if (hasCount) ...[
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.teal,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Consumer<AuctionProvider>(
                    builder: (context, provider, child) {
                      return Text(
                        provider.activeAuctions.length.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAuctionCard(Auction auction) {
    final timeLeft = auction.endTime.difference(DateTime.now());
    final hoursLeft = timeLeft.inHours;
    final minutesLeft = timeLeft.inMinutes % 60;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Container(
              height: 180,
              width: double.infinity,
              color: Colors.grey[300],
              child: Icon(
                Icons.image,
                size: 64,
                color: Colors.grey[400],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  auction.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  auction.description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 16),
                // Bid info
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Current Bid',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${NumberFormat('#,###').format(auction.currentBid)} DA',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 16,
                            color: Colors.orange.shade700,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${hoursLeft}h ${minutesLeft}m left',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      Icons.people_outline,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${auction.totalBids} bids',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Place Bid Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      _showBidDialog(context, auction);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text('Place Bid'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showUserProfile(BuildContext context) {
    final user = context.read<AuctionProvider>().currentUser;
    if (user == null) return;
    
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.teal,
                  child: Text(
                    user.fullName[0],
                    style: const TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.fullName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        user.roleNameAr,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      if (user.companyName != null)
                        Text(
                          user.companyName!,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[500],
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: user.isVerified ? Colors.green.shade50 : Colors.orange.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: user.isVerified ? Colors.green.shade200 : Colors.orange.shade200,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    user.isVerified ? Icons.verified : Icons.pending,
                    color: user.isVerified ? Colors.green : Colors.orange,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    user.isVerified ? 'حساب موثق' : 'في انتظار التحقق',
                    style: TextStyle(
                      color: user.isVerified ? Colors.green.shade700 : Colors.orange.shade700,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('تسجيل الخروج'),
              onTap: () {
                context.read<AuctionProvider>().logout();
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/');
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showBidDialog(BuildContext context, Auction auction) {
    final bidController = TextEditingController();
    final user = context.read<AuctionProvider>().currentUser;
    
    // التحقق من صلاحية المزايدة
    if (user == null || !user.canBid) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('غير مصرح'),
          content: Text(
            user == null
                ? 'يجب تسجيل الدخول أولاً'
                : user.isVerified
                    ? 'فقط المزايدين المعتمدين يمكنهم المزايدة'
                    : 'حسابك في انتظار التحقق. سيتم إعلامك عند الموافقة.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('حسناً'),
            ),
          ],
        ),
      );
      return;
    }
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('المزايدة على ${auction.title}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'السعر الحالي: ${NumberFormat('#,###').format(auction.currentBid)} دج',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: bidController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'مبلغ المزايدة (دج)',
                hintText: 'أدخل مبلغاً أعلى من السعر الحالي',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              final amount = double.tryParse(bidController.text);
              if (amount != null && amount > auction.currentBid) {
                context.read<AuctionProvider>().placeBid(auction.id, amount);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('تم تقديم مزايدتك بنجاح!'),
                    backgroundColor: Colors.green,
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('يجب أن يكون المبلغ أعلى من السعر الحالي'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: const Text('تقديم المزايدة'),
          ),
        ],
      ),
    );
  }
}
