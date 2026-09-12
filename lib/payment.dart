import 'package:flutter/material.dart';
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
  bool sending = false;

  Future<void> sendOrder() async {
    if (Cart.items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('السلة فارغة'),
        ),
      );
      return;
    }

    setState(() {
      sending = true;
    });

    try {
      final orderItems = Cart.items.map((item) {
        return {
          'name': item.product.name,
          'category': item.product.category,
          'price': item.product.price,
          'quantity': item.quantity,
        };
      }).toList();

      await FirebaseFirestore.instance
          .collection('orders')
          .add({
        'customerName': widget.name,
        'phone': widget.phone,
        'address': widget.address,
        'total': widget.total,
        'paymentMethod': 'تحويل بنكي',
        'status': 'بانتظار مراجعة التحويل',
        'items': orderItems,
        'createdAt': FieldValue.serverTimestamp(),
      });

      Cart.clear();

      if (!mounted) return;

      setState(() {
        sending = false;
      });

      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('تم إرسال الطلب'),
            content: const Text(
              'تم حفظ طلبك بنجاح في النظام.',
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
        sending = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'فشل إرسال الطلب: $e',
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
          title: const Text('تأكيد الطلب'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'مراجعة الطلب',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
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
                        'بيانات العميل',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text('الاسم: ${widget.name}'),
                      const SizedBox(height: 8),
                      Text('الهاتف: ${widget.phone}'),
                      const SizedBox(height: 8),
                      Text('العنوان: ${widget.address}'),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'الدفع',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text('طريقة الدفع: تحويل بنكي'),
                      const SizedBox(height: 10),
                      Text(
                        'الإجمالي: '
                        '${widget.total.toStringAsFixed(0)} '
                        'ريال يمني',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'رسوم التوصيل تُدفع نقدًا عند الاستلام.',
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.receipt_long,
                        size: 60,
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'سيتم حفظ الطلب في Firebase.',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'رفع سند التحويل سنضيفه لاحقًا.',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              SizedBox(
                height: 55,
                child: ElevatedButton.icon(
                  onPressed: sending ? null : sendOrder,
                  icon: sending
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(Icons.send),
                  label: Text(
                    sending
                        ? 'جارٍ إرسال الطلب...'
                        : 'إرسال الطلب',
                    style: const TextStyle(
                      fontSize: 18,
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
