import 'dart:async';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:vibration/vibration.dart';
import 'dart:math' as math;
import 'package:google_fonts/google_fonts.dart';

class GhostTouchScreen extends StatefulWidget {
  const GhostTouchScreen({super.key});

  @override
  State<GhostTouchScreen> createState() => _GhostTouchScreenState();
}

class _GhostTouchScreenState extends State<GhostTouchScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isScanning = false;
  double _intensity = 0.0;
  String _status = 'Standby';
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _startScan() {
    setState(() {
      _isScanning = true;
      _status = 'Searching for spectral energy...';
      _intensity = 0.1;
    });

    _timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (!mounted) return;
      setState(() {
        _intensity += 0.05;
        if (_intensity < 0.3) {
          _status = 'Weak resonance detected...';
        } else if (_intensity < 0.6) {
          _status = 'Signal strengthening...';
          Vibration.vibrate(duration: 100);
        } else if (_intensity < 0.9) {
          _status = 'CRITICAL: Entity detected nearby!';
          Vibration.vibrate(duration: 200, intensities: [0, 100, 200, 255]);
        } else {
          _status = 'GHOST DETECTED BEHIND YOU!';
          Vibration.vibrate(duration: 1000);
          timer.cancel();
          _showGhostAlert();
        }
      });
    });
  }

  void _showGhostAlert() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => FadeIn(
        duration: const Duration(milliseconds: 100),
        child: AlertDialog(
          backgroundColor: Colors.black,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.warning, color: Colors.red, size: 80),
              const SizedBox(height: 20),
              const Text(
                'SENSORS OVERLOADED',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Spectral presence confirmed within 1 meter. Stay calm.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {
                    _isScanning = false;
                    _intensity = 0;
                    _status = 'Standby';
                  });
                },
                child: const Text('DISMISS'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Ghost Radar'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return CustomPaint(
                      painter: RadarPainter(_controller.value, _intensity),
                      size: const Size(300, 300),
                    );
                  },
                ),
                if (_isScanning)
                  Pulse(
                    infinite: true,
                    child: const Icon(
                      Icons.location_searching,
                      color: Colors.greenAccent,
                      size: 40,
                    ),
                  )
                else
                  IconButton(
                    iconSize: 80,
                    icon: const Icon(
                      Icons.power_settings_new,
                      color: Colors.greenAccent,
                    ),
                    onPressed: _startScan,
                  ),
              ],
            ),
            const SizedBox(height: 50),
            FadeIn(
              key: ValueKey(_status),
              child: Text(
                _status,
                style: GoogleFonts.shareTechMono(
                  color: _intensity > 0.8 ? Colors.red : Colors.greenAccent,
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              width: 200,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white10,
                borderRadius: BorderRadius.circular(2),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: _intensity.clamp(0.0, 1.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: _intensity > 0.8 ? Colors.red : Colors.greenAccent,
                    borderRadius: BorderRadius.circular(2),
                    boxShadow: [
                      BoxShadow(
                        color:
                            (_intensity > 0.8 ? Colors.red : Colors.greenAccent)
                                .withOpacity(0.5),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RadarPainter extends CustomPainter {
  final double animationValue;
  final double intensity;

  RadarPainter(this.animationValue, this.intensity);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final paint = Paint()
      ..color = (intensity > 0.8 ? Colors.red : Colors.greenAccent).withOpacity(
        0.2,
      )
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // Draw circles
    for (int i = 1; i <= 4; i++) {
      canvas.drawCircle(center, radius * (i / 4), paint);
    }

    // Draw sweep
    final sweepPaint = Paint()
      ..shader = SweepGradient(
        center: Alignment.center,
        startAngle: 0.0,
        endAngle: math.pi * 2,
        colors: [
          Colors.transparent,
          (intensity > 0.8 ? Colors.red : Colors.greenAccent).withOpacity(0.5),
          (intensity > 0.8 ? Colors.red : Colors.greenAccent).withOpacity(0.01),
        ],
        stops: const [0.0, 0.1, 1.0],
        transform: GradientRotation(animationValue * math.pi * 2),
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    canvas.drawCircle(center, radius, sweepPaint);

    // Draw dots randomly if intensity is high
    if (intensity > 0.4) {
      final dotPaint = Paint()
        ..color = (intensity > 0.8 ? Colors.red : Colors.greenAccent);
      final random = math.Random(42);
      for (int i = 0; i < (intensity * 10).toInt(); i++) {
        final dist = random.nextDouble() * radius;
        final angle = random.nextDouble() * math.pi * 2;
        canvas.drawCircle(
          Offset(
            center.dx + dist * math.cos(angle),
            center.dy + dist * math.sin(angle),
          ),
          2,
          dotPaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant RadarPainter oldDelegate) => true;
}
