import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_app/auth/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import '../../models/payment_method.dart';
import '../../data/payment_methods_data.dart';
import '../../widgets/payment_method_card.dart';
import '../../widgets/time_picker_widget.dart';
import '../../widgets/notes_field.dart';
import 'payment_success_screen.dart';
import '../../providers/cart_provider.dart';
import '../../providers/order_provider.dart';
import '../../models/cart_item.dart';
import '../../models/order_model.dart';

class PaymentScreen extends StatefulWidget {
  final List<CartItem> items;
  final int totalPrice;

  const PaymentScreen({Key? key, required this.items, required this.totalPrice})
    : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String? selectedPaymentMethod;
  DateTime deliveryTime = DateTime.now().add(const Duration(hours: 1));
  String notes = '';
  String phoneNumber = '';
  bool isProcessing = false;
  bool showPhoneInput = false;
  final NumberFormat currencyFormat = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );
  final _formKey = GlobalKey<FormState>();

  Color _getBorderColor() {
    if (selectedPaymentMethod == null) return Colors.grey;

    final method = paymentMethods.firstWhere(
      (m) => m.id == selectedPaymentMethod,
      orElse:
          () => PaymentMethod(id: '', name: '', iconPath: '', description: ''),
    );

    return method.primaryColor ?? Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    // Get merchant name from first item's subtitle
    final merchantName =
        widget.items.isNotEmpty
            ? widget.items.first.subtitle
            : 'Unknown Merchant';
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Payment'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildOrderSummary(merchantName),
                const SizedBox(height: 24),
                TimePickerWidget(
                  onTimeSelected: (time) => setState(() => deliveryTime = time),
                ),
                const SizedBox(height: 24),
                _buildPaymentMethodSelector(),
                const SizedBox(height: 24),
                NotesField(
                  onNotesChanged: (value) => setState(() => notes = value),
                ),
                const SizedBox(height: 32),
                _buildPlaceOrderButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOrderSummary(String merchantName) {
    return Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              merchantName,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.access_time, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                const Text('Order for', style: TextStyle(color: Colors.grey)),
                const SizedBox(width: 4),
                Text(
                  'Today, ${DateFormat('HH:mm').format(deliveryTime)}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Divider(height: 24),
            ...widget.items
                .map(
                  (item) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            '${item.name} (${item.quantity}x)',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ),
                        Text(
                          '${currencyFormat.format(item.price)} x ${item.quantity}',
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Subtotal',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  currencyFormat.format(widget.totalPrice),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethodSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Payment Method',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        ...paymentMethods
            .map(
              (method) => Column(
                children: [
                  PaymentMethodCard(
                    method: method,
                    isSelected: selectedPaymentMethod == method.id,
                    onTap: () {
                      setState(() {
                        selectedPaymentMethod = method.id;
                        showPhoneInput = method.requiresPhoneNumber;
                        if (!method.requiresPhoneNumber) phoneNumber = '';
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            )
            .toList(),
        if (showPhoneInput) _buildPhoneNumberInput(),
      ],
    );
  }

  Widget _buildPhoneNumberInput() {
    final borderColor = _getBorderColor();
    final methodName = selectedPaymentMethod == 'ovo' ? 'OVO' : 'GoPay';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Text(
          'Enter your $methodName registered phone number',
          style: TextStyle(fontSize: 14, color: borderColor.withOpacity(0.8)),
        ),
        const SizedBox(height: 8),
        TextFormField(
          keyboardType: TextInputType.phone,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: InputDecoration(
            hintText: 'e.g. 08123456789',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: borderColor, width: 1.5),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: borderColor, width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: borderColor, width: 2.0),
            ),
            filled: true,
            fillColor: borderColor.withOpacity(0.05),
            prefixIcon: Icon(Icons.phone, color: borderColor),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 14,
              horizontal: 16,
            ),
          ),
          validator: (value) {
            if (showPhoneInput && (value == null || value.isEmpty)) {
              return 'Please enter your phone number';
            }
            if (value != null && value.length < 10) {
              return 'Phone number must be at least 10 digits';
            }
            return null;
          },
          onChanged: (value) => setState(() => phoneNumber = value),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildPlaceOrderButton(BuildContext context) {
    return SizedBox(
  width: double.infinity,
  child: ElevatedButton(
    onPressed: isProcessing ? null : () => _processPayment(context),
    style: ElevatedButton.styleFrom(
      backgroundColor: isProcessing
          ? Colors.grey[400]
          : (selectedPaymentMethod != null ? _getBorderColor() : Colors.blue),
      padding: const EdgeInsets.symmetric(vertical: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    child: Stack(
      alignment: Alignment.center,
      children: [
        AnimatedOpacity(
          opacity: isProcessing ? 0 : 1,
          duration: const Duration(milliseconds: 200),
          child: const Text(
            'Place Order',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        if (isProcessing)
          const SizedBox(
            height: 24,
            width: 24,
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 3,
            ),
          ),
      ],
    ),
  ),
);
  }

  // In payment_screen.dart, update the _processPayment method:
Future<void> _processPayment(BuildContext context) async {
  if (!_formKey.currentState!.validate()) return;
  if (selectedPaymentMethod == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Please select a payment method')),
    );
    return;
  }

  setState(() => isProcessing = true);

  try {
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    final merchantName = widget.items.isNotEmpty 
        ? widget.items.first.subtitle 
        : 'Unknown Merchant';
    final customerName = authProvider.user?.name ?? 'Customer';

    final newOrder = Order(
      id: _generateOrderId(),
      orderTime: DateTime.now(),
      pickupTime: deliveryTime,
      items: widget.items.map((item) => OrderItem(
        name: item.name,
        image: item.image,
        subtitle: item.subtitle,
        price: item.price,
        quantity: item.quantity,
      )).toList(),
      paymentMethod: paymentMethods
          .firstWhere((m) => m.id == selectedPaymentMethod)
          .name,
      merchantName: merchantName,
      customerName: customerName, // Added customer name
    );

    orderProvider.addOrder(newOrder);
    cartProvider.removeItems(widget.items);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentSuccessScreen(order: newOrder),
      ),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: ${e.toString()}')),
    );
  } finally {
    if (mounted) setState(() => isProcessing = false);
  }
}

  String _generateOrderId() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    return List.generate(
      6,
      (index) => chars[random.nextInt(chars.length)],
    ).join();
  }
}
