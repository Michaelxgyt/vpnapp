import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../controller/profile_controller.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_constant.dart';
import '../drawer/animated_drawer.dart';

class ProfileScreen extends StatefulWidget {
  final bool isLogin;
  const ProfileScreen({super.key,required this.isLogin});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((_) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.find<ProfileController>().getProfileData().then((value) {
          if (value == 200) {
            final profile = Get.find<ProfileController>().profileData;

            final isPremium = profile["isPremium"].toString() == "1";

            // Parse expired_date into DateTime
            final expiredDate = DateTime.tryParse(profile["expired_date"].toString());

            // Get today's date/time
            final now = DateTime.now();

            if (isPremium && expiredDate != null && expiredDate.isAfter(now)) {
              //User is premium and subscription is still valid
              log("Premium valid until: $expiredDate");
            } else {
              //Either not premium or expired
              if(isPremium){
                Get.find<ProfileController>().cancelSubscriptionData();
              }
              log("Premium expired or not active");
            }

            log("log data>>>$profile");
          }
        });
      });
    });

    super.initState();
  }

  String formatDate(String dateString) {
    DateTime date = DateTime.parse(dateString);  // Parse the API date
    return DateFormat('dd MMM, yyyy').format(date);  // Format it as '10 Jan, 2025'
  }


  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      builder: (profileController) {
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) async {
            if (didPop) {
              return;
            }
            if(widget.isLogin==true){
              Get.offAll(()=> const AnimatedDrawerScreen(),transition: Transition.leftToRight);
            }
            else{
              Get.back();
            }
          },
          child: Scaffold(
            backgroundColor: bgColor,
            appBar: AppBar(
              backgroundColor: AppColors.appBgColor,
              elevation: 10,
              automaticallyImplyLeading: false,
              leading: IconButton(
                onPressed: () {
                  if(widget.isLogin==true){
                    Get.offAll(()=> const AnimatedDrawerScreen(),transition: Transition.leftToRight);
                  }
                  else{
                    Get.back();
                  }
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
              ),
              title: Text(
                "profile".tr,
                style: GoogleFonts.aBeeZee(color: Colors.white, fontSize: 16,
                fontWeight: FontWeight.w600
                ),
              ),
              centerTitle: true,
            ),
            body:
            profileController.isLoading==false && profileController.profileData!=null?
            Column(
              children: [
                // Profile Info Card
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.appBgColor,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.white10,
                          child: Icon(Icons.person_pin, size: 40, color: Colors.white),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${profileController.profileData["name"]}",
                                style: GoogleFonts.inter(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "${profileController.profileData["email"]}",
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Account Type Info Card
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.appBgColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              "acc_type".tr,
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              profileController.profileData["isPremium"] == 1 ? "premium".tr : "free".tr,
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.calendar_today_outlined, color: Colors.white38, size: 20),
                            const SizedBox(width: 8),
                            Row(
                              children: [
                                Text(
                                  "joined".tr,
                                  style: GoogleFonts.inter(fontSize: 14, color: Colors.white70),
                                ),
                                Text(
                                  formatDate(profileController.profileData["created_at"]),
                                  style: GoogleFonts.inter(fontSize: 14, color: Colors.white70),
                                ),
                              ],
                            ),
                          ],
                        ),
                        if (profileController.profileData["isPremium"] == 1) ...[
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.verified_user_outlined, color: Colors.white38, size: 20),
                              const SizedBox(width: 8),
                              Row(
                                children: [
                                  Text(
                                    "validity".tr,
                                    style: GoogleFonts.inter(fontSize: 14, color: Colors.white70),
                                  ),
                                  Text(
                                    "${profileController.profileData["validity"]} Days",
                                    style: GoogleFonts.inter(fontSize: 14, color: Colors.white70),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ]
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Logout Button
                SizedBox(
                  width: 300,
                  height: 50,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      elevation: 5,
                      backgroundColor: const Color(0xffF57D1F),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () => _showLogoutDialog(context),
                    icon: const Icon(Icons.logout, color: Colors.white),
                    label: Text(
                      "logout".tr,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            )
                :
                const Center(child: SizedBox(
                  height: 25,
                  width: 25,
                  child: CircularProgressIndicator(
                    color: Colors.orange,
                    backgroundColor: Colors.teal,
                  ),
                ),)
          ),
        );
      }
    );
  }
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.appBgColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: Text('logout_confirm'.tr,
              style: GoogleFonts.inter(color: Colors.white, fontSize: 18)),
          content: Text(
            'logout_sure'.tr,
            style: GoogleFonts.inter(color: Colors.white70, fontSize: 14),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('cancel'.tr, style: const TextStyle(color: Colors.redAccent)),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('logout'.tr, style: const TextStyle(color: Colors.white)),
              onPressed: () async {
                SharedPreferences pref = await SharedPreferences.getInstance();
                await pref.clear();
                Get.offAll(() => const AnimatedDrawerScreen(), transition: Transition.leftToRight);
                Fluttertoast.showToast(
                  msg: "logout_success".tr,
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  backgroundColor: AppColors.appButtonColor,
                  textColor: Colors.white,
                  fontSize: 16.0,
                );
              },
            ),
          ],
        );
      },
    );
  }

}
