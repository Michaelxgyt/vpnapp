import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controller/auth_controller.dart';
import '../../utils/app_colors.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController tokenController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isLoading = false; // Loading state variable


  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
        builder: (authController) {
          return Scaffold(
            backgroundColor: AppColors.appBgColor,
            appBar: AppBar(
              backgroundColor: AppColors.appButtonColor,
              automaticallyImplyLeading: false,
              centerTitle: true,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Get.back(),
              ),
              title: Text(
                'reset_pass'.tr,
                style: GoogleFonts.aBeeZee(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
            body: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [

                      //  Token Field
                      _buildInputField(
                        controller: tokenController,
                        hintText: "token".tr,
                        icon: Icons.verified,
                        validatorText: "enter_token".tr,
                      ),

                      const SizedBox(height: 20),

                      //  Email
                      _buildInputField(
                        controller: emailController,
                        hintText: "email".tr,
                        icon: Icons.email,
                        validatorText: "enter_email".tr,
                      ),

                      const SizedBox(height: 20),

                      //  Password
                      _buildInputField(
                        controller: passwordController,
                        hintText: "password".tr,
                        icon: Icons.lock,
                        validatorText: "enter_password".tr,
                        obscureText: true,
                      ),

                      const SizedBox(height: 20),

                      //  Confirm Password
                      _buildInputField(
                        controller: confirmPasswordController,
                        hintText: "confirm_pass".tr,
                        icon: Icons.lock_outline,
                        validatorText: "enter_confirm_pass".tr,
                        obscureText: true,
                      ),

                      const SizedBox(height: 40),

                      // Reset Button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          onPressed: () {
                            if (_formKey.currentState?.validate() ?? false) {
                              authController.resetPassword(
                                token: tokenController.text.trim(),
                                email: emailController.text.trim(),
                                password: passwordController.text.trim(),
                                confirmPassword: confirmPasswordController.text.trim(),
                              );
                            }
                          },
                          child: Ink(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xffF57D1F), Color(0xff007CF0)],
                              ),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                child: authController.isLoadingReset
                                    ? const SizedBox(
                                  height: 25,
                                  width: 25,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                                    : Text(
                                  'reset'.tr,
                                  style: GoogleFonts.outfit(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
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
    );
  }
  Widget _buildInputField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    required String validatorText,
    bool obscureText = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(14),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) =>
        value == null || value.isEmpty ? validatorText : null,
        style: GoogleFonts.outfit(color: Colors.white),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.white70),
          hintText: hintText,
          hintStyle: GoogleFonts.outfit(color: Colors.white70),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
        ),
      ),
    );
  }

}
