// lib/screens/payment_screen.dart
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
// lib/services/stripe_service.dart
import 'package:http/http.dart' as http;

class PaymentScreen extends StatefulWidget {
  final double amount;

  const PaymentScreen({super.key, required this.amount});

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool _isLoading = false;

  Future<void> _handlePayment() async {
    setState(() => _isLoading = true);

    try {
      final clientSecret = await StripeService.createPaymentIntent(widget.amount);

      // 2. Initialize payment sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: 'Your App Name',
          applePay: const PaymentSheetApplePay(merchantCountryCode: 'US'),
          googlePay: const PaymentSheetGooglePay(merchantCountryCode: 'US'),
          style: ThemeMode.dark,
          customerId: 'current_user_id',
        ),
      );

      await Stripe.instance.presentPaymentSheet();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Payment successful!')),
      );

    } on StripeException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.error.localizedMessage}')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Payment')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Amount: \$${widget.amount.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _handlePayment,
                    child: Text('Pay Now'),
                  ),
          ],
        ),
      ),
    );
  }
}

class StripeService {
  static const String baseUrl = 'https://your-laravel-api.com/api';

  static Future<void> init() async {
    Stripe.publishableKey = 'pk_test_your_publishable_key';
    await Stripe.instance.applySettings();
  }

  static Future<String> createPaymentIntent(double amount) async {
    final response = await http.post(
      Uri.parse('$baseUrl/create-payment-intent'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'amount': amount, 'currency': 'usd'}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['clientSecret'];
    } else {
      throw Exception('Failed to create payment intent');
    }
  }
}

