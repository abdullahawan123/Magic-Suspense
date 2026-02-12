import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:magic_suspense/features/tricks/elusive_no_screen.dart';
import 'package:magic_suspense/features/tricks/mind_reader_screen.dart';
import 'package:magic_suspense/features/tricks/ghost_touch_screen.dart';
import 'package:magic_suspense/features/home/subscription_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.stars, color: Colors.amber),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SubscriptionScreen(),
              ),
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0F0C29), Color(0xFF302B63), Color(0xFF24243E)],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: FadeInDown(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Magic',
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                      Text(
                        'Suspense',
                        style: Theme.of(context).textTheme.displayLarge
                            ?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Unveil the impossible...',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: GridView.count(
                  padding: const EdgeInsets.all(16),
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  children: [
                    _buildTrickCard(
                      context,
                      'The Elusive No',
                      Icons.not_interested,
                      Colors.orange,
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ElusiveNoScreen(),
                        ),
                      ),
                      0,
                    ),
                    _buildTrickCard(
                      context,
                      'Mind Reader',
                      Icons.psychology,
                      Colors.purple,
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MindReaderScreen(),
                        ),
                      ),
                      200,
                    ),
                    _buildTrickCard(
                      context,
                      'Ghost Touch',
                      Icons.vibration,
                      Colors.cyan,
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const GhostTouchScreen(),
                        ),
                      ),
                      400,
                    ),
                    _buildTrickCard(
                      context,
                      'Coming Soon',
                      Icons.auto_fix_high,
                      Colors.grey,
                      () {},
                      600,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTrickCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
    int delay,
  ) {
    return FadeInUp(
      delay: Duration(milliseconds: delay),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: .05),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: color.withValues(alpha: .3), width: 1),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: .1),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: color),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
