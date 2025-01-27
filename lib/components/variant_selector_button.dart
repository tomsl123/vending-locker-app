import 'package:flutter/material.dart';

class VariantSelectorButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  final bool isDisabled;
  final VoidCallback onTap;

  const VariantSelectorButton({
    super.key,
    required this.text,
    required this.isSelected,
    this.isDisabled = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isDisabled ? null : onTap,
        borderRadius: BorderRadius.circular(100),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isDisabled 
              ? const Color(0xFFE5E5E5)
              : isSelected 
                ? const Color(0xFFFF404E) 
                : const Color(0xFFF5F5F4),
            borderRadius: BorderRadius.circular(100),
          ),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: isDisabled
                ? const Color(0xFFADADAD)
                : isSelected 
                  ? Colors.white 
                  : const Color(0xFF242424),
            ),
          ),
        ),
      ),
    );
  }
}
