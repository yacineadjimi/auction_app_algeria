import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/auction_provider.dart';
import '../models/user.dart';
import '../models/auction.dart';

class ManagerDashboard extends StatelessWidget {
  const ManagerDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('لوحة تحكم المدير'),
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            tabs: [
              Tab(text: 'طلبات التحقق من المستخدمين'),
              Tab(text: 'طلبات الموافقة على المزادات'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            UserVerificationTab(),
            AuctionApprovalTab(),
          ],
        ),
      ),
    );
  }
}

class UserVerificationTab extends StatelessWidget {
  const UserVerificationTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuctionProvider>(
      builder: (context, provider, child) {
        final pendingUsers = provider.pendingVerifications;
        
        if (pendingUsers.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_circle_outline, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text('لا توجد طلبات معلقة'),
              ],
            ),
          );
        }
        
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: pendingUsers.length,
          itemBuilder: (context, index) {
            return _UserVerificationCard(user: pendingUsers[index]);
          },
        );
      },
    );
  }
}

class _UserVerificationCard extends StatelessWidget {
  final User user;
  
  const _UserVerificationCard({required this.user});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: Colors.teal,
          child: Text(
            user.fullName[0],
            style: const TextStyle(color: Colors.white),
          ),
        ),
        title: Text(
          user.fullName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '${user.roleNameAr} - ${user.companyName ?? ""}',
          style: const TextStyle(fontSize: 12),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow('البريد الإلكتروني', user.email),
                _buildInfoRow('رقم الهاتف', user.phoneNumber),
                if (user.companyName != null)
                  _buildInfoRow('اسم الشركة', user.companyName!),
                if (user.companyType != null)
                  _buildInfoRow('نوع الشركة', user.companyTypeNameAr),
                if (user.commercialRegister != null)
                  _buildInfoRow('السجل التجاري', user.commercialRegister!),
                if (user.taxId != null)
                  _buildInfoRow('الرقم الضريبي', user.taxId!),
                if (user.address != null)
                  _buildInfoRow('العنوان', user.address!),
                if (user.city != null && user.state != null)
                  _buildInfoRow('المدينة/الولاية', '${user.city}, ${user.state}'),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          _showApprovalDialog(context, user.id);
                        },
                        icon: const Icon(Icons.check),
                        label: const Text('قبول'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          _showRejectionDialog(context, user.id);
                        },
                        icon: const Icon(Icons.close),
                        label: const Text('رفض'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
  
  void _showApprovalDialog(BuildContext context, String userId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تأكيد الموافقة'),
        content: const Text('هل أنت متأكد من الموافقة على هذا المستخدم؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<AuctionProvider>().approveUser(userId);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('تمت الموافقة على المستخدم بنجاح'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('موافق'),
          ),
        ],
      ),
    );
  }
  
  void _showRejectionDialog(BuildContext context, String userId) {
    final reasonController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('رفض الطلب'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('يرجى إدخال سبب الرفض:'),
            const SizedBox(height: 12),
            TextField(
              controller: reasonController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'سبب الرفض...',
                border: OutlineInputBorder(),
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
              if (reasonController.text.isNotEmpty) {
                context.read<AuctionProvider>().rejectUser(
                  userId,
                  reasonController.text,
                );
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('تم رفض الطلب'),
                    backgroundColor: Colors.orange,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('رفض'),
          ),
        ],
      ),
    );
  }
}

class AuctionApprovalTab extends StatelessWidget {
  const AuctionApprovalTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuctionProvider>(
      builder: (context, provider, child) {
        final pendingAuctions = provider.pendingAuctions;
        
        if (pendingAuctions.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_circle_outline, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text('لا توجد مزادات معلقة'),
              ],
            ),
          );
        }
        
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: pendingAuctions.length,
          itemBuilder: (context, index) {
            return _AuctionApprovalCard(auction: pendingAuctions[index]);
          },
        );
      },
    );
  }
}

class _AuctionApprovalCard extends StatelessWidget {
  final Auction auction;
  
  const _AuctionApprovalCard({required this.auction});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ExpansionTile(
        leading: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.image, color: Colors.grey),
        ),
        title: Text(
          auction.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '${auction.categoryNameAr} - ${auction.auctioneerName}',
          style: const TextStyle(fontSize: 12),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow('الوصف', auction.description),
                _buildInfoRow(
                  'السعر الابتدائي',
                  '${NumberFormat('#,###').format(auction.startingPrice)} دج',
                ),
                if (auction.reservePrice != null)
                  _buildInfoRow(
                    'السعر الاحتياطي',
                    '${NumberFormat('#,###').format(auction.reservePrice)} دج',
                  ),
                _buildInfoRow(
                  'البائع',
                  auction.auctioneerCompany ?? auction.auctioneerName,
                ),
                if (auction.location != null)
                  _buildInfoRow('الموقع', auction.location!),
                if (auction.condition != null)
                  _buildInfoRow('الحالة', auction.condition!),
                _buildInfoRow(
                  'تاريخ الانتهاء',
                  DateFormat('yyyy-MM-dd HH:mm').format(auction.endTime),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          _showApprovalDialog(context, auction.id);
                        },
                        icon: const Icon(Icons.check),
                        label: const Text('قبول'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          _showRejectionDialog(context, auction.id);
                        },
                        icon: const Icon(Icons.close),
                        label: const Text('رفض'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
  
  void _showApprovalDialog(BuildContext context, String auctionId) {
    final notesController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('الموافقة على المزاد'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('ملاحظات (اختياري):'),
            const SizedBox(height: 12),
            TextField(
              controller: notesController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'ملاحظات...',
                border: OutlineInputBorder(),
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
              context.read<AuctionProvider>().approveAuction(
                auctionId,
                notesController.text,
              );
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('تمت الموافقة على المزاد وسيبدأ قريباً'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('موافق'),
          ),
        ],
      ),
    );
  }
  
  void _showRejectionDialog(BuildContext context, String auctionId) {
    final reasonController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('رفض المزاد'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('يرجى إدخال سبب الرفض:'),
            const SizedBox(height: 12),
            TextField(
              controller: reasonController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'سبب الرفض...',
                border: OutlineInputBorder(),
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
              if (reasonController.text.isNotEmpty) {
                context.read<AuctionProvider>().rejectAuction(
                  auctionId,
                  reasonController.text,
                );
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('تم رفض المزاد'),
                    backgroundColor: Colors.orange,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('رفض'),
          ),
        ],
      ),
    );
  }
}
