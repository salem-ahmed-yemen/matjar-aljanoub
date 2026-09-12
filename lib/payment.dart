import 'package:flutter/material.dart';

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
  String selectedMethod = 'تحويل بنكي';

  void uploadReceipt() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'سيتم تفعيل رفع سند التحويل في الخطوة التالية',
        ),
      ),
    );
  }

  void confirmPayment() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'يرجى رفع سند التحويل أولاً',
        ),
      ),
    );
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
                child: RadioListTile<String>(
                  value: 'تحويل بنكي',
                  groupValue: selectedMethod,
                  onChanged: (value) {
                    setState(() {
                      selectedMethod = value!;
                    });
                  },
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
                          onPressed: uploadReceipt,
                          icon: const Icon(
                            Icons.upload_file,
                          ),
                          label: const Text(
                            'رفع سند التحويل',
                            style: TextStyle(
                              fontSize: 17,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              SizedBox(
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: confirmPayment,
                  icon: const Icon(
                    Icons.check_circle,
                  ),
                  label: const Text(
                    'تأكيد الدفع وإرسال الطلب',
                    style: TextStyle(
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
