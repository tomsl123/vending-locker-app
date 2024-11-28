import 'package:flutter/material.dart';

enum SegmentSize { sm, md }

class CustomSegmentedButton extends StatelessWidget {
  final List<String> options;
  final String selectedOption;
  final Function(String) onOptionSelected;
  final SegmentSize size;

  const CustomSegmentedButton({
    super.key,
    required this.options,
    required this.selectedOption,
    required this.onOptionSelected,
    this.size = SegmentSize.md,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F4),
        borderRadius: size == SegmentSize.md
            ? BorderRadius.circular(15)
            : BorderRadius.circular(10),
      ),
      child: Row(
        children: options.asMap().entries.map((entry) {
          final option = entry.value;
          final isSelected = option == selectedOption;
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                left: entry.key == 0 ? 0 : 2,
                right: entry.key == options.length - 1 ? 0 : 2,
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => onOptionSelected(option),
                  borderRadius: size == SegmentSize.md
                      ? BorderRadius.circular(15)
                      : BorderRadius.circular(10),
                  child: Container(
                    height: size == SegmentSize.md ? 43 : 35,
                    decoration: isSelected
                        ? BoxDecoration(
                            borderRadius: size == SegmentSize.md
                                ? BorderRadius.circular(15)
                                : BorderRadius.circular(10),
                            gradient: const LinearGradient(
                              begin: Alignment(-0.7914, 0),
                              end: Alignment(1.2966, 0),
                              colors: [Color(0xFFFFBD59), Color(0xFFFFE1B3)],
                            ),
                            boxShadow: const [
                              BoxShadow(
                                offset: Offset(2, 2),
                                blurRadius: 10,
                                color: Color(0x0D000000),
                              ),
                            ],
                          )
                        : null,
                    child: Center(
                      child: Text(
                        option,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: size == SegmentSize.md ? 16 : 11,
                          fontWeight: FontWeight.w600,
                          height: size == SegmentSize.md ? 1 : 14 / 11,
                          letterSpacing: size == SegmentSize.md ? 1 : 0.4,
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
