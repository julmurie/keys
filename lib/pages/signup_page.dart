import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> signUp() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      await FirebaseAuth.instance.signOut();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Account created. Please log in.')),
      );
      Navigator.pushReplacementNamed(context, '/');
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Sign up failed.')),
      );
    }
  }

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

                        const SizedBox(height: 100),

                        SizedBox(
                          width: 220,
                          child: TextField(
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            style: GoogleFonts.figtree(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF7A5A68),
                            ),
                            decoration: InputDecoration(
                              hintText: 'Email',
                              hintStyle: GoogleFonts.figtree(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: const Color.fromARGB(255, 221, 176, 195),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 16,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Color(0xFFC98AA6),
                                  width: 4,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Color(0xFFC98AA6),
                                  width: 4,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),

                        SizedBox(
                          width: 220,
                          child: TextField(
                            controller: passwordController,
                            obscureText: true,
                            style: GoogleFonts.figtree(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF7A5A68),
                            ),
                            decoration: InputDecoration(
                              hintText: 'Password',
                              hintStyle: GoogleFonts.figtree(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: const Color.fromARGB(255, 221, 176, 195),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 16,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Color(0xFFC98AA6),
                                  width: 4,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Color(0xFFC98AA6),
                                  width: 4,
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 70),

                        SizedBox(
                          width: 180,
                          child: ElevatedButton(
                            onPressed: signUp,
                            style: ElevatedButton.styleFrom(
                              elevation: 4,
                              backgroundColor: const Color(0xFFC683A5),
                              foregroundColor: Colors.white,
                              side: const BorderSide(
                                color: Color.fromARGB(255, 241, 208, 223),
                                width: 4,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 20),
                            ),
                            child: Text(
                              'Sign Up',
                              style: GoogleFonts.figtree(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        Center(
                          child: TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              'Already have an account? Login',
                              style: GoogleFonts.figtree(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: const Color.fromRGBO(130, 99, 109, 1),
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
