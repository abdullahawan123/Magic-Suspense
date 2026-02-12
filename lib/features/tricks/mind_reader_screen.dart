import 'dart:math';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_animate/flutter_animate.dart';

class MindReaderScreen extends StatefulWidget {
  const MindReaderScreen({super.key});

  @override
  State<MindReaderScreen> createState() => _MindReaderScreenState();
}

class _MindReaderScreenState extends State<MindReaderScreen> {
  late Map<int, IconData> _symbolMap;
  late IconData _targetSymbol;
  bool _revealed = false;

  final List<IconData> _symbols = [
    FontAwesomeIcons.ghost,
    FontAwesomeIcons.moon,
    FontAwesomeIcons.star,
    FontAwesomeIcons.crow,
    FontAwesomeIcons.skull,
    FontAwesomeIcons.hatWizard,
    FontAwesomeIcons.eye,
    FontAwesomeIcons.bolt,
    FontAwesomeIcons.fire,
    FontAwesomeIcons.dragon,
    FontAwesomeIcons.mask,
  ];

  @override
  void initState() {
    super.initState();
    _generateSymbols();
  }

  void _generateSymbols() {
    final random = Random();
    _targetSymbol = _symbols[random.nextInt(_symbols.length)];
    _symbolMap = {};
    for (int i = 0; i <= 99; i++) {
      if (i % 9 == 0 && i > 0) {
        _symbolMap[i] = _targetSymbol;
      } else {
        IconData randomSymbol;
        do {
          randomSymbol = _symbols[random.nextInt(_symbols.length)];
        } while (randomSymbol == _targetSymbol);
        _symbolMap[i] = randomSymbol;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mind Reader'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: _revealed ? _buildReveal() : _buildChallenge(),
    );
  }

  Widget _buildChallenge() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: FadeInDown(
            child: Card(
              color: Colors.white.withOpacity(0.05),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Text(
                      'How to Play:',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.purpleAccent,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildStep('1. Pick any 2-digit number (e.g., 42)'),
                    _buildStep(
                      '2. Subtract the sum of its digits from it (4+2=6, 42-6=36)',
                    ),
                    _buildStep(
                      '3. Find your number in the table and remember its symbol',
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => setState(() => _revealed = true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 15,
                        ),
                      ),
                      child: const Text('READ MY MIND'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                childAspectRatio: 1,
              ),
              itemCount: 100,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.02),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$index',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white38,
                        ),
                      ),
                      Icon(
                        _symbolMap[index],
                        size: 16,
                        color: Colors.purpleAccent.withOpacity(0.8),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStep(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 14),
      ),
    );
  }

  Widget _buildReveal() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FadeInScale(
            child: Text(
              'Looking into your mind...',
              style: Theme.of(context).textTheme.displayMedium,
            ),
          ),
          const SizedBox(height: 50),
          FadeInUp(
            delay: const Duration(seconds: 2),
            child: Icon(_targetSymbol, size: 150, color: Colors.purpleAccent)
                .animate(onPlay: (c) => c.repeat())
                .shimmer(duration: 2000.ms, color: Colors.white),
          ),
          const SizedBox(height: 50),
          FadeIn(
            delay: const Duration(seconds: 4),
            child: Text(
              'This is the symbol you saw, right?',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          const SizedBox(height: 30),
          TextButton(
            onPressed: () {
              setState(() {
                _revealed = false;
                _generateSymbols();
              });
            },
            child: const Text('TRY AGAIN'),
          ),
        ],
      ),
    );
  }
}

class FadeInScale extends StatelessWidget {
  final Widget child;
  const FadeInScale({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return FadeInDown(child: ZoomIn(child: child));
  }
}
