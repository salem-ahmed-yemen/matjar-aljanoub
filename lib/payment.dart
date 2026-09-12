import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'cart.dart';

class PaymentPage extends StatefulWidget {
  final double total;
  final String name;
  final String phone;
  final String address;

  const PaymentPage({
    super.key,
    required this.total,
    required this.name,
    required this.phone,
    required this.address,
  });

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final ImagePicker _picker = ImagePicker();

  XFile? receiptImage;
  bool uploading = false;

  Future<void> uploadReceipt() async {
    final image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (image != null) {
      setState(() {
        receiptImage = image;
      });
    }
  }

  Future<void> confirmPayment() async {
    if (receiptImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('يرجى رفع صورة سند التحويل أولاً'),
        ),
      );
      return;
    }

    setState(() {
      uploading = true;
    });

    try {
      // رفع سند التحويل إلى Firebase Storage
      final file = File(receiptImage!.path);

      final fileName =
          'receipts/${DateTime.now().millisecondsSinceEpoch}.jpg';

      final storageRef =
          FirebaseStorage.instance.ref().child(fileName);

      await storageRef.putFile(file);

      final receiptUrl =
          await storageRef.getDownloadURL();

      // تجهيز المنتجات الموجودة في السلة
      final orderItems = Cart.items.map((item) {
        return {
          'name': item.product.name,
          'category': item.product.category,
          'price': item.product.price,
          'quantity': item.quantity,
        };
      }).toList();

      // حفظ الطلب في Firestore
      await FirebaseFirestore.instance
          .collection('orders')
          .add({
        'customerName': widget.name,
        'phone': widget.phone,
        'address': widget.address,
        'total': widget.total,
        'paymentMethod': 'تحويل بنكي',
        'receiptUrl': receiptUrl,
        'status': 'بانتظار مراجعة التحويل',
        'items': orderItems,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // تفريغ السلة بعد نجاح حفظ الطلب
      Cart.clear();

      if (!mounted) return;

      setState(() {
        uploading = false;
      });

      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('تم إرسال الطلب'),
            content: const Text(
              'تم حفظ طلبك بنجاح، وسيتم مراجعة سند التحويل.',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('حسنًا'),
              ),
            ],
          );
        },
      );

      if (!mounted) return;

      Navigator.of(context).popUntil(
        (route) => route.isFirst,
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        uploading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('حدث خطأ أثناء إرسال الطلب: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('الدفع'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'طريقة الدفع',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 16),

              Card(
                child: RadioListTile<String>(
                  value: 'تحويل بنكي',
                  groupValue: 'تحويل بنكي',
                  onChanged: null,
                  title: const Text(
                    'تحويل بنكي',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: const Text(
                    'قم بالتحويل ثم ارفع سند التحويل',
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'بيانات الطلب',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text('الاسم: ${widget.name}'),
                      const SizedBox(height: 6),
                      Text('الهاتف: ${widget.phone}'),
                      const SizedBox(height: 6),
                      Text('العنوان: ${widget.address}'),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'إجمالي الطلب',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${widget.total.toStringAsFixed(0)} ريال يمني',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'رسوم التوصيل غير مشمولة، '
                        'وتُدفع نقدًا عند الاستلام.',
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'سند التحويل',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 10),

                      const Text(
                        'بعد إجراء التحويل البنكي، '
                        'ارفع صورة سند التحويل هنا.',
                      ),

                      const SizedBox(height: 16),

                      OutlinedButton.icon(
                        onPressed:
                            uploading ? null : uploadReceipt,
                        icon: const Icon(
                          Icons.upload_file,
                        ),
                        label: Text(
                          receiptImage == null
                              ? 'رفع سند التحويل'
                              : 'تم اختيار السند ✓',
                        ),
                      ),

                      if (receiptImage != null) ...[
                        const SizedBox(height: 12),
                        Text(
                          receiptImage!.name,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              SizedBox(
                height: 54,
                child: ElevatedButton.icon(
                  onPressed:
                      uploading ? null : confirmPayment,
                  icon: uploading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child:
                              CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(
                          Icons.check_circle,
                        ),
                  label: Text(
                    uploading
                        ? 'جارٍ إرسال الطلب...'
                        : 'تأكيد الدفع وإرسال الطلب',
                    style: const TextStyle(
                      fontSize: 17,
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
}
