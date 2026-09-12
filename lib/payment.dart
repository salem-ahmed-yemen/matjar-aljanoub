import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class PaymentPage extends StatefulWidget {
  final double total;

  const PaymentPage({
    super.key,
    required this.total,
  });

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final ImagePicker _picker = ImagePicker();

  XFile? receiptImage;
  bool uploading = false;

  Future<void> uploadReceipt() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (image == null) return;

      setState(() {
        receiptImage = image;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم اختيار صورة سند التحويل'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('حدث خطأ أثناء اختيار الصورة'),
        ),
      );
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
      final file = File(receiptImage!.path);

      final fileName =
          'receipts/${DateTime.now().millisecondsSinceEpoch}.jpg';

      final storageRef =
          FirebaseStorage.instance.ref().child(fileName);

      await storageRef.putFile(file);

      if (!mounted) return;

      setState(() {
        uploading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'تم رفع سند التحويل بنجاح',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        uploading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'تعذر رفع سند التحويل. تحقق من إعدادات Firebase Storage.',
          ),
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
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 16),

              Card(
                child: ListTile(
                  leading: const Icon(Icons.account_balance),
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

                      SizedBox(
                        height: 52,
                        child: OutlinedButton.icon(
                          onPressed:
                              uploading ? null : uploadReceipt,
                          icon: const Icon(
                            Icons.upload_file,
                          ),
                          label: const Text(
                            'اختيار سند التحويل',
                            style: TextStyle(
                              fontSize: 17,
                            ),
                          ),
                        ),
                      ),

                      if (receiptImage != null) ...[
                        const SizedBox(height: 16),

                        ClipRRect(
                          borderRadius:
                              BorderRadius.circular(12),
                          child: Image.file(
                            File(receiptImage!.path),
                            height: 250,
                            fit: BoxFit.contain,
                          ),
                        ),

                        const SizedBox(height: 8),

                        const Center(
                          child: Text(
                            'تم اختيار سند التحويل',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              SizedBox(
                height: 52,
                child: ElevatedButton.icon(
                  onPressed:
                      uploading ? null : confirmPayment,
                  icon: uploading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child:
                              CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(
                          Icons.cloud_upload,
                        ),
                  label: Text(
                    uploading
                        ? 'جاري رفع السند...'
                        : 'رفع السند وتأكيد الدفع',
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
