import 'package:flutter/material.dart';

class RFSpectrumWidget extends StatelessWidget {
  final List<double> amplitudes;
  final double minFreq;
  final double maxFreq;
  final double currentFreq;

  const RFSpectrumWidget({
    super.key,
    required this.amplitudes,
    this.minFreq = 300,
    this.maxFreq = 928,
    this.currentFreq = 433.92,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1a1a2e),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFF667eea).withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'ESPECTRO RF',
                style: TextStyle(
                  color: Color(0xFF667eea),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              Text(
                '${currentFreq.toStringAsFixed(2)} MHz',
                style: const TextStyle(
                  color: Color(0xFF00ff00),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: CustomPaint(
              size: const Size(double.infinity, double.infinity),
              painter: _SpectrumPainter(amplitudes),
            ),
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${minFreq.toInt()} MHz', style: const TextStyle(color: Colors.white38, fontSize: 10)),
              Text('${((minFreq + maxFreq) / 2).toInt()} MHz', style: const TextStyle(color: Colors.white38, fontSize: 10)),
              Text('${maxFreq.toInt()} MHz', style: const TextStyle(color: Colors.white38, fontSize: 10)),
            ],
          ),
        ],
      ),
    );
  }
}

class _SpectrumPainter extends CustomPainter {
  final List<double> amplitudes;

  _SpectrumPainter(this.amplitudes);

  @override
  void paint(Canvas canvas, Size size) {
    if (amplitudes.isEmpty) return;

    final paint = Paint()
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final gradient = LinearGradient(
      colors: [
        const Color(0xFF667eea),
        const Color(0xFF00ff00),
        const Color(0xFFf093fb),
        const Color(0xFFff416c),
      ],
    );

    final path = Path();
    final stepX = size.width / (amplitudes.length - 1);

    path.moveTo(0, size.height);

    for (int i = 0; i < amplitudes.length; i++) {
      final x = i * stepX;
      final y = size.height - (amplitudes[i] * size.height);
      path.lineTo(x, y);
    }

    path.lineTo(size.width, size.height);
    path.close();

    final shader = gradient.createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    paint.shader = shader;
    paint.style = PaintingStyle.fill;

    canvas.drawPath(path, paint);

    // Grid lines
    final gridPaint = Paint()
      ..color = Colors.white.withOpacity(0.05)
      ..strokeWidth = 1;

    for (int i = 1; i < 5; i++) {
      final y = size.height * (i / 5);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
