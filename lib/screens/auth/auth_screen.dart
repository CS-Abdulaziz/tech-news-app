import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:techpluse/screens/interesting_screen.dart';
import 'package:techpluse/screens/main_layout.dart';
import 'package:techpluse/widgets/animated_aurora_background.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final supabase = Supabase.instance.client;

  int tabIndex = 0;
  bool _isLoading = false;

  final loginEmailController = TextEditingController();
  final loginPassController = TextEditingController();
  bool rememberMe = false;
  bool hideLoginPass = true;

  final regNameController = TextEditingController();
  final regEmailController = TextEditingController();
  final regPassController = TextEditingController();
  final regConfirmController = TextEditingController();
  bool hideRegPass = true;
  bool hideRegConfirm = true;
  bool agreeToTerms = false;

  static const brand = Color(0xFF7FAF8B);

  @override
  void dispose() {
    loginEmailController.dispose();
    loginPassController.dispose();
    regNameController.dispose();
    regEmailController.dispose();
    regPassController.dispose();
    regConfirmController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await supabase.auth.signInWithPassword(
        email: loginEmailController.text.trim(),
        password: loginPassController.text.trim(),
      );
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MainLayout()),
        );
      }
    } on AuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Unexcpected Error'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _signUp() async {
    if (regPassController.text != regConfirmController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Passwords are not matched'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await supabase.auth.signUp(
        email: regEmailController.text.trim(),
        password: regPassController.text.trim(),
        data: {'full_name': regNameController.text.trim()},
      );
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const InterestsScreen()),
        );
      }
    } on AuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('An error has been occured'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                SizedBox(
                  height: h * 0.45,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      const AuroraHeaderBackground(),
                      SafeArea(
                        bottom: false,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 22),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 60),
                              AnimatedSwitcher(
                                duration: const Duration(milliseconds: 400),
                                child: Text(
                                  tabIndex == 0
                                      ? "Go ahead and set up\nyour TechPulse"
                                      : "Create your\nTechPulse account",
                                  key: ValueKey<int>(tabIndex),
                                  style: const TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.w800,
                                    height: 1.15,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                tabIndex == 0
                                    ? "Sign in to access your personalized tech news feed."
                                    : "Sign up to personalize your tech news experience.",
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                  height: 1.35,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF5F6F6),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(28),
                    ),
                  ),
                  padding: const EdgeInsets.fromLTRB(18, 18, 18, 22),
                  child: Column(
                    children: [
                      _tabs(),
                      const SizedBox(height: 20),
                      if (tabIndex == 0)
                        _buildLoginView()
                      else
                        _buildRegisterView(),
                      const SizedBox(height: 18),
                      Row(
                        children: const [
                          Expanded(child: Divider(color: Colors.black12)),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              "Or continue with",
                              style: TextStyle(color: Colors.black54),
                            ),
                          ),
                          Expanded(child: Divider(color: Colors.black12)),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: _socialButton(
                              label: "Google",
                              icon: Icons.g_mobiledata,
                              onTap: () {},
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _socialButton(
                              label: "Facebook",
                              icon: Icons.facebook,
                              onTap: () {},
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(left: 14, top: 6),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: _circleIconButton(
                    icon: Icons.arrow_back,
                    onTap: () => Navigator.pop(context),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginView() {
    return Column(
      children: [
        _inputTile(
          icon: Icons.email_outlined,
          label: "Email Address",
          controller: loginEmailController,
          hint: "you@techpulse.com",
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 12),
        _inputTile(
          icon: Icons.lock_outline,
          label: "Password",
          controller: loginPassController,
          hint: "••••••••",
          obscure: hideLoginPass,
          suffix: IconButton(
            onPressed: () => setState(() => hideLoginPass = !hideLoginPass),
            icon: Icon(
              hideLoginPass
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              color: Colors.black54,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Checkbox(
              value: rememberMe,
              onChanged: (v) => setState(() => rememberMe = v ?? false),
              activeColor: brand,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const Text("Remember me", style: TextStyle(color: Colors.black87)),
            const Spacer(),
            TextButton(
              onPressed: () {},
              child: const Text(
                "Forgot Password?",
                style: TextStyle(color: brand),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: brand,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
              elevation: 0,
            ),
            onPressed: _isLoading ? null : _signIn,
            child: _isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text(
                    "Login",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildRegisterView() {
    return Column(
      children: [
        _inputTile(
          label: "Full Name",
          controller: regNameController,
          icon: Icons.person_outline,
          hint: "Abdulaziz Khamis",
        ),
        const SizedBox(height: 12),
        _inputTile(
          label: "Email Address",
          controller: regEmailController,
          icon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
          hint: "you@example.com",
        ),
        const SizedBox(height: 12),
        _inputTile(
          label: "Password",
          controller: regPassController,
          icon: Icons.lock_outline,
          hint: "••••••••",
          obscure: hideRegPass,
          suffix: IconButton(
            icon: Icon(
              hideRegPass
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              color: Colors.black54,
            ),
            onPressed: () => setState(() => hideRegPass = !hideRegPass),
          ),
        ),
        const SizedBox(height: 12),
        _inputTile(
          label: "Confirm Password",
          controller: regConfirmController,
          icon: Icons.lock_outline,
          hint: "••••••••",
          obscure: hideRegConfirm,
          suffix: IconButton(
            icon: Icon(
              hideRegConfirm
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              color: Colors.black54,
            ),
            onPressed: () => setState(() => hideRegConfirm = !hideRegConfirm),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Checkbox(
              value: agreeToTerms,
              activeColor: brand,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              onChanged: (value) {
                setState(() {
                  agreeToTerms = value ?? false;
                });
              },
            ),
            const Expanded(
              child: Text(
                "I agree to the Terms & Privacy Policy",
                style: TextStyle(fontSize: 13, color: Colors.black87),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: brand,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
              elevation: 0,
            ),
            onPressed: _isLoading ? null : _signUp,
            child: _isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text(
                    "Create Account",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
          ),
        ),
      ],
    );
  }

  Widget _tabs() {
    return Container(
      height: 44,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFE9ECEB),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          Expanded(
            child: _tabChip(
              selected: tabIndex == 0,
              text: "Login",
              onTap: () => setState(() => tabIndex = 0),
            ),
          ),
          Expanded(
            child: _tabChip(
              selected: tabIndex == 1,
              text: "Register",
              onTap: () => setState(() => tabIndex = 1),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tabChip({
    required bool selected,
    required String text,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        decoration: BoxDecoration(
          color: selected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(18),
          boxShadow: selected
              ? const [
                  BoxShadow(
                    blurRadius: 10,
                    offset: Offset(0, 4),
                    color: Color(0x14000000),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: selected ? Colors.black : Colors.black54,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _inputTile({
    required IconData icon,
    required String label,
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    bool obscure = false,
    Widget? suffix,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF0F0F0)),
      ),
      child: Row(
        children: [
          Icon(icon, color: brand),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 4),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.black45,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextField(
                  controller: controller,
                  keyboardType: keyboardType,
                  obscureText: obscure,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    hintText: hint,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 4),
                    border: InputBorder.none,
                    hintStyle: const TextStyle(color: Colors.black38),
                  ),
                  style: const TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
              ],
            ),
          ),
          if (suffix != null) suffix,
        ],
      ),
    );
  }

  Widget _socialButton({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFF0F0F0)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.black54),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _circleIconButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.25),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white12),
        ),
        child: Icon(icon, color: Colors.white),
      ),
    );
  }
}