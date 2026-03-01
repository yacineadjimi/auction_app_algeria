import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auction_provider.dart';
import '../models/auction.dart';

class CreateAuctionScreen extends StatefulWidget {
  const CreateAuctionScreen({super.key});

  @override
  State<CreateAuctionScreen> createState() => _CreateAuctionScreenState();
}

class _CreateAuctionScreenState extends State<CreateAuctionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _startingPriceController = TextEditingController();
  final _reservePriceController = TextEditingController();
  final _locationController = TextEditingController();
  final _conditionController = TextEditingController();
  
  AuctionCategory? _selectedCategory;
  DateTime? _endDate;
  TimeOfDay? _endTime;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _startingPriceController.dispose();
    _reservePriceController.dispose();
    _locationController.dispose();
    _conditionController.dispose();
    super.dispose();
  }

  void _selectEndDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 7)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    
    if (date != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: const TimeOfDay(hour: 18, minute: 0),
      );
      
      if (time != null) {
        setState(() {
          _endDate = date;
          _endTime = time;
        });
      }
    }
  }

  void _submitAuction() {
    if (_formKey.currentState!.validate()) {
      if (_endDate == null || _endTime == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('يرجى تحديد تاريخ ووقت انتهاء المزاد'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final endDateTime = DateTime(
        _endDate!.year,
        _endDate!.month,
        _endDate!.day,
        _endTime!.hour,
        _endTime!.minute,
      );

      context.read<AuctionProvider>().createAuction(
        title: _titleController.text,
        description: _descriptionController.text,
        startingPrice: double.parse(_startingPriceController.text),
        endTime: endDateTime,
        category: _selectedCategory!,
        location: _locationController.text.isEmpty ? null : _locationController.text,
        condition: _conditionController.text.isEmpty ? null : _conditionController.text,
        reservePrice: _reservePriceController.text.isEmpty 
            ? null 
            : double.parse(_reservePriceController.text),
      );

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('تم إرسال المزاد'),
          content: const Text(
            'تم إرسال مزادك للمراجعة. سيتم نشره بعد موافقة الإدارة.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
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
      appBar: AppBar(
        title: const Text('إنشاء مزاد جديد'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // العنوان
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'عنوان المزاد',
                hintText: 'مثال: مقر تجاري في موقع استراتيجي',
                prefixIcon: Icon(Icons.title),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'يرجى إدخال العنوان';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            // الوصف
            TextFormField(
              controller: _descriptionController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'الوصف',
                hintText: 'وصف تفصيلي للعنصر المعروض',
                alignLabelWithHint: true,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'يرجى إدخال الوصف';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            // الفئة
            DropdownButtonFormField<AuctionCategory>(
              initialValue: _selectedCategory,
              decoration: const InputDecoration(
                labelText: 'الفئة',
                prefixIcon: Icon(Icons.category),
              ),
              items: AuctionCategory.values.map((category) {
                String label = '';
                switch (category) {
                  case AuctionCategory.realEstate:
                    label = 'عقارات';
                    break;
                  case AuctionCategory.vehicles:
                    label = 'مركبات';
                    break;
                  case AuctionCategory.equipment:
                    label = 'معدات';
                    break;
                  case AuctionCategory.electronics:
                    label = 'إلكترونيات';
                    break;
                  case AuctionCategory.furniture:
                    label = 'أثاث';
                    break;
                  case AuctionCategory.industrial:
                    label = 'صناعية';
                    break;
                  case AuctionCategory.agriculture:
                    label = 'زراعية';
                    break;
                  case AuctionCategory.other:
                    label = 'أخرى';
                    break;
                }
                return DropdownMenuItem(
                  value: category,
                  child: Text(label),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value;
                });
              },
              validator: (value) {
                if (value == null) {
                  return 'يرجى اختيار الفئة';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            // السعر الابتدائي
            TextFormField(
              controller: _startingPriceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'السعر الابتدائي (دج)',
                prefixIcon: Icon(Icons.attach_money),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'يرجى إدخال السعر الابتدائي';
                }
                if (double.tryParse(value) == null) {
                  return 'يرجى إدخال رقم صحيح';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            // السعر الاحتياطي
            TextFormField(
              controller: _reservePriceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'السعر الاحتياطي (اختياري)',
                hintText: 'أقل سعر تقبل به',
                prefixIcon: Icon(Icons.price_change),
              ),
            ),
            const SizedBox(height: 16),
            
            // الموقع
            TextFormField(
              controller: _locationController,
              decoration: const InputDecoration(
                labelText: 'الموقع',
                hintText: 'المدينة أو الولاية',
                prefixIcon: Icon(Icons.location_on),
              ),
            ),
            const SizedBox(height: 16),
            
            // الحالة
            TextFormField(
              controller: _conditionController,
              decoration: const InputDecoration(
                labelText: 'الحالة',
                hintText: 'جديد، مستعمل، ممتاز، إلخ',
                prefixIcon: Icon(Icons.info),
              ),
            ),
            const SizedBox(height: 16),
            
            // تاريخ ووقت الانتهاء
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.calendar_today),
              title: Text(
                _endDate == null && _endTime == null
                    ? 'تحديد تاريخ ووقت الانتهاء'
                    : 'ينتهي في: ${_endDate!.day}/${_endDate!.month}/${_endDate!.year} - ${_endTime!.format(context)}',
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: _selectEndDateTime,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.grey.shade300),
              ),
            ),
            const SizedBox(height: 24),
            
            // ملاحظة
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.orange.shade200),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info_outline, color: Colors.orange.shade700),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'سيتم مراجعة مزادك من قبل الإدارة قبل نشره. قد تستغرق المراجعة من 24 إلى 48 ساعة.',
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // زر الإرسال
            ElevatedButton(
              onPressed: _submitAuction,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 56),
              ),
              child: const Text('إرسال للمراجعة'),
            ),
          ],
        ),
      ),
    );
  }
}
