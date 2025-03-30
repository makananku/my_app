import 'package:flutter/material.dart';
import 'package:my_app/screens/seller_home.dart';
import 'package:my_app/models/payment_method.dart';
import 'package:my_app/data/payment_methods_data.dart';
import 'package:my_app/widgets/payment_method_card.dart';
import 'package:my_app/widgets/seller_custom_bottom_navigation.dart';

class SellerBalanceScreen extends StatefulWidget {
  const SellerBalanceScreen({super.key});

  @override
  State<SellerBalanceScreen> createState() => _SellerBalanceScreenState();
}

class _SellerBalanceScreenState extends State<SellerBalanceScreen> {
  PaymentMethod? _selectedMethod;
  final String _userGopayNumber = '0812-3456-7890';

  @override
  void initState() {
    super.initState();
    _selectedMethod = paymentMethods.firstWhere(
      (method) => method.id == 'gopay',
      orElse: () => paymentMethods.first,
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SellerHomeScreen()),
        );
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            'My Balance',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const SellerHomeScreen()),
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.print, color: Colors.black),
              onPressed: _printBalanceSummary,
            ),
          ],
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 200), 
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Balance Card with shadow
                  Card(
                    elevation: 2, // Added shadow
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Balance Available',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Rp35.000',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _selectedMethod != null 
                                ? () => _withdrawFunds(context)
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              minimumSize: const Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Withdraw',
                              style: TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Payment Methods Section
                  const Text(
                    'Withdrawal Method',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // List of Payment Methods
                  Column(
                    children: paymentMethods.map((method) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: PaymentMethodCard(
                          method: method,
                          isSelected: _selectedMethod?.id == method.id,
                          onTap: () => setState(() => _selectedMethod = method),
                        ),
                      );
                    }).toList(),
                  ),

                  // Current Gopay Account
                  if (_selectedMethod?.id == 'gopay')
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        'Related to number: $_userGopayNumber',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ),
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    onPressed: _addNewPaymentMethod,
                    icon: const Icon(Icons.add, color: Colors.blue),
                    label: const Text(
                      'Add Withdrawal Method',
                      style: TextStyle(color: Colors.blue),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.blue),
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 8,
              left: 0,
              right: 0,
              child: SellerCustomBottomNavigation(
                selectedIndex: NavIndices.balance,
                context: context,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _printBalanceSummary() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Printing balance summary...')),
    );
  }

  void _withdrawFunds(BuildContext context) {
    if (_selectedMethod == null) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text('Withdraw to ${_selectedMethod!.name}'),
        content: Text(
          'You will withdraw funds to the ${_selectedMethod!.name} account ' 
          '$_userGopayNumber',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.black)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'proccesing withdrawal to ${_selectedMethod!.name}',
                  ),
                ),
              );
            },
            child: const Text('Confirm', style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
    );
  }

  void _addNewPaymentMethod() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Adding new payment method...')),
    );
  }
}