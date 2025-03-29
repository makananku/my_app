// payment_methods_data.dart
import '../models/payment_method.dart';
import 'package:flutter/material.dart';

final List<PaymentMethod> paymentMethods = [
  PaymentMethod(
    id: 'gopay',
    name: 'GoPay',
    iconPath: 'assets/payment/gopay.png',
    description: 'Pay using your GoPay account',
    primaryColor: const Color(0xFF00AA13), // GoPay green
    requiresPhoneNumber: true,
    supportsTopUp: true,
  ),
  PaymentMethod(
    id: 'ovo',
    name: 'OVO',
    iconPath: 'assets/payment/ovo.png',
    description: 'Pay using your OVO account',
    primaryColor: const Color(0xFF4C2A86), // OVO purple
    requiresPhoneNumber: true,
    supportsTopUp: true,
  ),
];