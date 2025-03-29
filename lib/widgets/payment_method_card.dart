// payment_method_card.dart
import 'package:flutter/material.dart';
import '../../models/payment_method.dart';

class PaymentMethodCard extends StatelessWidget {
  final PaymentMethod method;
  final bool isSelected;
  final VoidCallback onTap;

  const PaymentMethodCard({
    Key? key,
    required this.method,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isSelected ? method.primaryColor?.withOpacity(0.1) : Colors.white,
      elevation: isSelected ? 4 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isSelected
            ? BorderSide(color: method.primaryColor ?? Colors.blue, width: 2)
            : const BorderSide(color: Colors.grey, width: 0.5),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: isSelected ? method.primaryColor?.withOpacity(0.2) : Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Image.asset(method.iconPath, height: 30),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    method.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isSelected ? method.primaryColor : Colors.black,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    method.description,
                    style: TextStyle(
                      color: isSelected 
                          ? method.primaryColor?.withOpacity(0.8) 
                          : Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              if (isSelected)
                Icon(Icons.check_circle, 
                    color: method.primaryColor ?? Colors.blue,
                    size: 28),
            ],
          ),
        ),
      ),
    );
  }
}