import 'package:flutter/material.dart';
import 'package:pay/pay.dart';

class TopUp extends StatefulWidget {
  const TopUp({Key? key}) : super(key: key);

  @override
  State<TopUp> createState() => _TopUpState();
}

class _TopUpState extends State<TopUp> {
  @override
  Widget build(BuildContext context) {
    final _paymentItems = [
      PaymentItem(
        label: 'Total',
        amount: '99.99',
        status: PaymentItemStatus.final_price,
      )
    ];
    void onGooglePayResult(paymentResult) {
      debugPrint(paymentResult.toString());
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Top Up',
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('Top up here'),
          GooglePayButton(
            paymentConfigurationAsset: 'gpay.json',
            paymentItems: _paymentItems,
            style: GooglePayButtonStyle.black,
            type: GooglePayButtonType.pay,
            margin: const EdgeInsets.only(top: 15.0),
            onPaymentResult: onGooglePayResult,
            loadingIndicator: const Center(
              child: CircularProgressIndicator(),
            ),
            height: 50,
            width: 200,
          ),
        ],
      ),
    );
  }
}
