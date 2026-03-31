import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg_flower.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(Colors.white70, BlendMode.lighten),
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Container(
                width: 420,
                height: 950,
                padding: const EdgeInsets.all(10),

                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                    color: const Color.fromARGB(
                      255,
                      255,
                      255,
                      252,
                    ).withValues(alpha: .4),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 36,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/keys_logo_title.png',
                          width: 240,
                        ),
                        const SizedBox(height: 170),

                        SizedBox(
                          width: 220,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/test');
                            },
                            style: ElevatedButton.styleFrom(
                              elevation: 4,
                              backgroundColor: Colors.white,
                              foregroundColor: const Color(0xFF7A5A68),
                              side: const BorderSide(
                                color: Color(0xFFC98AA6),
                                width: 4,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: Text(
                              'START',
                              style: GoogleFonts.figtree(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF7A5A68),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 18),

                        SizedBox(
                          width: 220,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/history');
                            },
                            style: ElevatedButton.styleFrom(
                              elevation: 4,
                              backgroundColor: const Color(0xFFC683A5),
                              foregroundColor: Colors.white,
                              side: const BorderSide(
                                color: Color.fromARGB(255, 241, 208, 223),
                                width: 4,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: Text(
                              'VIEW SCORES',
                              style: GoogleFonts.figtree(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
