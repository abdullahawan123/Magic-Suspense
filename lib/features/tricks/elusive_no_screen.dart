import 'dart:math';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:vibration/vibration.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ElusiveNoScreen extends StatefulWidget {
  const ElusiveNoScreen({super.key});

  @override
  State<ElusiveNoScreen> createState() => _ElusiveNoScreenState();
}

class _ElusiveNoScreenState extends State<ElusiveNoScreen> {
  double _noTop = 0;
  double _noLeft = 0;
  bool _initialized = false;
  int _attempts = 0;

  void _moveNo() {
    setState(() {
      final random = Random();
      // Keep it within screen bounds roughly
      _noTop =
          random.nextDouble() * (MediaQuery.of(context).size.height - 200) +
          100;
      _noLeft =
          random.nextDouble() * (MediaQuery.of(context).size.width - 150) + 25;
      _attempts++;
    });
    Vibration.vibrate(duration: 50);
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      // Initial position
      _noTop = MediaQuery.of(context).size.height * 0.6;
      _noLeft = MediaQuery.of(context).size.width * 0.55;
      _initialized = true;
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('The Love Test'),
      ),
      body: Stack(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FadeInDown(
                    child:
                        Icon(Icons.favorite, color: Colors.redAccent, size: 100)
                            .animate(
                              onPlay: (controller) =>
                                  controller.repeat(reverse: true),
                            )
                            .scale(
                              duration: 1000.ms,
                              begin: const Offset(0.8, 0.8),
                              end: const Offset(1.2, 1.2),
                            ),
                  ),
                  const SizedBox(height: 32),
                  FadeIn(
                    child: Text(
                      'Do you think this app is magical?',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                  ),
                  const SizedBox(height: 100), // Space for buttons
                ],
              ),
            ),
          ),

          // The YES button (Fixed)
          Positioned(
            top: MediaQuery.of(context).size.height * 0.6,
            left: MediaQuery.of(context).size.width * 0.15,
            child: FadeInLeft(
              child: ElevatedButton(
                onPressed: () {
                  _showSuccess();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.greenAccent.shade700,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'YES',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
            ),
          ),

          // The NO button (Jumping)
          AnimatedPositioned(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOutBack,
            top: _noTop,
            left: _noLeft,
            child: GestureDetector(
              onPanStart: (_) => _moveNo(),
              onTapDown: (_) => _moveNo(),
              child: ElevatedButton(
                onPressed: () {
                  // This will almost never be called because onTapDown moves it
                  _moveNo();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'NO',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
            ),
          ),

          if (_attempts > 5)
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: FadeInUp(
                child: Center(
                  child: Text(
                    'Give up? You know the answer is YES! 😉',
                    style: TextStyle(
                      color: Colors.white54,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _showSuccess() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Color(0xFF24243E),
        title: const Text('Magical!'),
        content: const Text(
          'I knew you had an eye for magic. The mystery has only just begun...',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('CONTINUE'),
          ),
        ],
      ),
    );
  }
}
