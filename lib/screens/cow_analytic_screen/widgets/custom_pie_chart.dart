import 'package:flutter/material.dart';

class CustomPieChart extends StatelessWidget {
  final List<PieChartSection> sections;
  
  const CustomPieChart({
    Key? key,
    required this.sections,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.maxWidth < constraints.maxHeight
            ? constraints.maxWidth
            : constraints.maxHeight;
        
        return SizedBox(
          width: size,
          height: size,
          child: CustomPaint(
            painter: PieChartPainter(sections: sections),
          ),
        );
      },
    );
  }
}

class PieChartSection {
  final double value;
  final Color color;
  final String label;
  
  PieChartSection({
    required this.value,
    required this.color,
    required this.label,
  });
}
class PieChartPainter extends CustomPainter {
  final List<PieChartSection> sections;
  
  PieChartPainter({required this.sections});
  
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width < size.height ? size.width / 2 : size.height / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);
    
    double startAngle = -90 * (3.14159265359 / 180); // Start from the top (in radians)
    
    for (final section in sections) {
      final sweepAngle = section.value * 2 * 3.14159265359; // Full circle is 2π radians
      
      final paint = Paint()
        ..color = section.color
        ..style = PaintingStyle.fill;
      
      canvas.drawArc(rect, startAngle, sweepAngle, true, paint);
      
      startAngle += sweepAngle;
    }
    
    // Draw a white circle in the center for a donut effect
    final centerPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(center, radius * 0.5, centerPaint);
  }
  
  @override
  bool shouldRepaint(PieChartPainter oldDelegate) => true;
}