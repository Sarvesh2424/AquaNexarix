import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WaterScannerPage extends StatefulWidget {
  const WaterScannerPage({super.key});

  @override
  State<WaterScannerPage> createState() => _WaterScannerPageState();
}

class _WaterScannerPageState extends State<WaterScannerPage>
    with TickerProviderStateMixin {
  bool _isScanning = false;
  bool _hasResult = false;
  String _result = '';
  late AnimationController _pulseController;
  late AnimationController _fadeController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_fadeController);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _startScanning() async {
    setState(() {
      _isScanning = true;
      _hasResult = false;
    });

    // Start the pulsing animation
    _pulseController.repeat(reverse: true);

    // Simulate ML model processing time
    await Future.delayed(const Duration(seconds: 3));

    // Stop animations and show result
    _pulseController.stop();
    _pulseController.reset();

    // Simulate ML result (you'll replace this with actual ML model call)
    final potable = DateTime.now().millisecond % 2 == 0;
    _result = potable ? 'Safe to Drink' : 'Not Safe to Drink';

    setState(() {
      _isScanning = false;
      _hasResult = true;
    });

    _fadeController.forward();
  }

  void _resetScan() {
    setState(() {
      _hasResult = false;
      _result = '';
    });
    _fadeController.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AquaNexarix')),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF000000),
              const Color(0xFF0D47A1).withOpacity(0.1),
            ],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // App Icon/Logo Area
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1E88E5), Color(0xFF42A5F5)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF1E88E5).withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.water_drop,
                    size: 60,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 60),

                // Status Text
                if (!_isScanning && !_hasResult)
                  Text(
                    'Tap to analyze water quality',
                    style: GoogleFonts.figtree(
                      fontSize: 18,
                      color: Colors.white70,
                      letterSpacing: 0.5,
                    ),
                  ),

                if (_isScanning)
                  Text(
                    'Analyzing water sample...',
                    style: GoogleFonts.figtree(
                      fontSize: 18,
                      color: Colors.white70,
                      letterSpacing: 0.5,
                    ),
                  ),

                const SizedBox(height: 40),

                // Scanning Animation or Result
                if (_isScanning)
                  AnimatedBuilder(
                    animation: _pulseAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _pulseAnimation.value,
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFF1E88E5),
                              width: 2,
                            ),
                          ),
                          child: const CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Color(0xFF1E88E5),
                            ),
                            strokeWidth: 3,
                          ),
                        ),
                      );
                    },
                  ),

                if (_hasResult)
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color:
                            _result.contains('Not Safe')
                                ? const Color(0xFFE57373).withOpacity(0.1)
                                : const Color(0xFF4CAF50).withOpacity(0.1),
                        border: Border.all(
                          color:
                              _result.contains('Not Safe')
                                  ? const Color(0xFFE57373)
                                  : const Color(0xFF4CAF50),
                          width: 2,
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            _result.contains('Not Safe')
                                ? Icons.warning_amber_outlined
                                : Icons.check_circle_outline,
                            size: 48,
                            color:
                                _result.contains('Safe')
                                    ? const Color(0xFFE57373)
                                    : const Color(0xFF4CAF50),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _result,
                            style: GoogleFonts.figtree(
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                              color:
                                  _result.contains('Not Safe')
                                      ? const Color(0xFFE57373)
                                      : const Color(0xFF4CAF50),
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                const SizedBox(height: 60),

                // Action Button
                if (!_isScanning && !_hasResult)
                  ElevatedButton(
                    onPressed: _startScanning,
                    child: Text(
                      'START SCANNING',
                      style: GoogleFonts.figtree(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),

                if (_hasResult)
                  ElevatedButton(
                    onPressed: _resetScan,
                    child: Text(
                      'SCAN AGAIN',
                      style: GoogleFonts.figtree(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
