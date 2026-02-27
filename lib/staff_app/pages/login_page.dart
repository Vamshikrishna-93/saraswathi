import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:student_app/staff_app/controllers/auth_controller.dart';
import 'package:student_app/staff_app/widgets/skeleton.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController userCtrl = TextEditingController();
  final TextEditingController passCtrl = TextEditingController();
  bool obscure = true;
  bool isStaffLogin = true;

  late final AuthController auth;

  @override
  void initState() {
    super.initState();
    auth = Get.isRegistered<AuthController>()
        ? Get.find<AuthController>()
        : Get.put(AuthController());
    userCtrl.clear();
    passCtrl.clear();
  }

  @override
  void dispose() {
    userCtrl.dispose();
    passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // ---------------- BACKGROUND BLOBS ----------------
          Positioned(
            top: -100,
            left: -100,
            child: _buildBlob(300, [
              const Color(0xFF8B5CF6),
              const Color(0xFFC084FC),
            ]),
          ),
          Positioned(
            top: -50,
            right: -150,
            child: _buildBlob(400, [
              const Color(0xFF7C3AED).withOpacity(0.8),
              const Color(0xFFA78BFA).withOpacity(0.5),
            ]),
          ),
          Positioned(
            bottom: -150,
            right: -100,
            child: _buildBlob(450, [
              const Color(0xFF8B5CF6),
              const Color(0xFFC084FC),
            ]),
          ),
          Positioned(
            bottom: 100,
            left: 50,
            child: _buildBlob(80, [
              const Color(0xFF8B5CF6).withOpacity(0.8),
              const Color(0xFFDDD6FE),
            ]),
          ),

          // ---------------- CONTENT ----------------
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    // CARD CONTAINER
                    Container(
                      padding: const EdgeInsets.all(30),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(35),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 30,
                            offset: const Offset(0, 10),
                          ),
                        ],
                        border: Border.all(
                          color: Colors.grey.shade100,
                          width: 1.5,
                        ),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            "Welcome to SSJC!",
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w900,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 30),

                          // TOGGLE BUTTON
                          _buildLoginToggle(),

                          const SizedBox(height: 30),

                          // USERNAME FIELD
                          _buildInputLabel("Username"),
                          const SizedBox(height: 8),
                          _buildInputField(
                            controller: userCtrl,
                            hintText: "Enter your email address",
                          ),

                          const SizedBox(height: 20),

                          // PASSWORD FIELD
                          _buildInputLabel("Password"),
                          const SizedBox(height: 8),
                          _buildInputField(
                            controller: passCtrl,
                            hintText: "Enter your password",
                            isPassword: true,
                          ),

                          const SizedBox(height: 12),

                          // FORGOT PASSWORD
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {},
                              child: const Text(
                                "Forgot Password",
                                style: TextStyle(
                                  color: Color(0xFFF87171),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          // SIGN IN BUTTON
                          _buildSignInButton(),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBlob(double size, List<Color> colors) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    );
  }

  Widget _buildLoginToggle() {
    return Container(
      height: 55,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => isStaffLogin = true),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: isStaffLogin
                      ? const LinearGradient(
                          colors: [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
                        )
                      : null,
                ),
                alignment: Alignment.center,
                child: Text(
                  "Staff Login",
                  style: TextStyle(
                    color: isStaffLogin ? Colors.white : Colors.black54,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => isStaffLogin = false),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: !isStaffLogin
                      ? const LinearGradient(
                          colors: [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
                        )
                      : null,
                ),
                alignment: Alignment.center,
                child: Text(
                  "Student Login",
                  style: TextStyle(
                    color: !isStaffLogin ? Colors.white : Colors.black54,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputLabel(String label) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hintText,
    bool isPassword = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword ? obscure : false,
        style: const TextStyle(fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    obscure ? Icons.visibility_off : Icons.visibility,
                    color: Colors.black87,
                    size: 20,
                  ),
                  onPressed: () => setState(() => obscure = !obscure),
                )
              : null,
        ),
      ),
    );
  }

  Widget _buildSignInButton() {
    return Obx(
      () => GestureDetector(
        onTap: auth.isLoading.value
            ? null
            : () async {
                FocusScope.of(context).unfocus();
                final username = userCtrl.text.trim();
                final password = passCtrl.text.trim();
                if (username.isEmpty || password.isEmpty) {
                  Get.snackbar(
                    "Error",
                    "Enter credentials",
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                  return;
                }
                await auth.login(username, password);
              },
        child: Container(
          width: double.infinity,
          height: 55,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF9333EA), Color(0xFFC084FC)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF9333EA).withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Center(
            child: auth.isLoading.value
                ? const StaffLoadingAnimation()
                : const Text(
                    "Sign In",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
