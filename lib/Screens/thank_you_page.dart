import 'dart:math';

import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';

class ThankYouPage extends StatefulWidget {
  const ThankYouPage({super.key});
  @override
  State<ThankYouPage> createState() => _ThankYouPageState();
}

class _ThankYouPageState extends State<ThankYouPage>
    with SingleTickerProviderStateMixin {
  late ConfettiController _controllerCenterLeft;
  late ConfettiController _controllerCenterRight;
  late AnimationController _iconController;
  late Animation<double> _iconAnimation;

  @override
  void initState() {
    super.initState();
    _controllerCenterLeft = ConfettiController(duration: const Duration(seconds: 1));
    _controllerCenterRight = ConfettiController(duration: const Duration(seconds: 1));
    // start animation after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) => _playConfetti());


    // Icon animation
    _iconController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _iconAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _iconController,
        curve: Curves.easeInOut,
      ),
    );
  }

  void _playConfetti() {
    _controllerCenterLeft.play();
    _controllerCenterRight.play();
    _iconController.forward();
  }

  @override
  void dispose() {
    _controllerCenterLeft.dispose();
    _controllerCenterRight.dispose();
    _iconController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: _playConfetti,
        child: Stack(
          children: <Widget>[
            // Background image
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/thank-you-bg.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      // Celebration icon
                      const SizedBox(height: 20),
                      AnimatedBuilder(
                        animation: _iconAnimation,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _iconAnimation.value,
                            child: const Icon(
                              Icons.celebration_rounded,
                              color: Colors.white,
                              size: 120,
                            )
                          );
                        }
                      ),
                      // Text
                      SizedBox(height: 30,),
                      const Text(
                        textAlign: TextAlign.center,
                        'Thank You!',

                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 10),
                      const SizedBox(
                        width: 310,
                        child: Text(
                          textAlign: TextAlign.center,
                          'You’re all set! Enjoy your items and have a fantastic day! See you next time!',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Color(0x90FFFFFF),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ),
            ),

            // Confetti
            // CenterLeft confetti - Emit right
            Align(
              alignment: const Alignment(-1, -0.7),
              child: ConfettiWidget(
                confettiController: _controllerCenterLeft,
                blastDirection: 0, // radial value - RIGHT
                blastDirectionality: BlastDirectionality
                    .explosive, // don't specify a direction, blast randomly
                emissionFrequency: 0.6,
                // set the minimum potential size for the confetti (width, height)
                minimumSize: const Size(5, 5),
                // set the maximum potential size for the confetti (width, height)
                maximumSize: const Size(15, 10),
                numberOfParticles: 10,
                gravity: 0.8,
                colors: const [
                  Color(0xFFFFD885),
                  Color(0xFF9BFF4F),
                  Color(0xFFFF9C9E),
                  Color(0xFFFD9FFD),
                  Color(0xFF7DD8FF)
                ],
              )
            ),
            // Right side confetti
            Align(
              alignment: const Alignment(1, -0.7),
              child: ConfettiWidget(
                confettiController: _controllerCenterRight,
                blastDirection: pi, // radial value - LEFT
                blastDirectionality: BlastDirectionality
                    .explosive,
                // particleDrag: 0.05, // apply drag to the confetti
                emissionFrequency: 0.6, // how often it should emit
                minimumSize: const Size(5, 5),
                maximumSize: const Size(15, 10),
                numberOfParticles: 10, // number of particles to emit
                gravity: 0.8, // gravity - or fall speed
                colors: const [
                  Color(0xFFFFD885),
                  Color(0xFF9BFF4F),
                  Color(0xFFFF9C9E),
                  Color(0xFFFD9FFD),
                  Color(0xFF7DD8FF)
                ], // manually specify the colors to be used
              )
            ),
          ],
        )
      )
    );
  }
}
