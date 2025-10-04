import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../controller/auth_controller.dart';
import '../../controller/premium_list_controller.dart';
import '../../controller/profile_controller.dart';
import '../../controller/server_list_controller.dart';
import '../../utils/app_colors.dart';
import '../authentication/login_screen.dart';
import '../drawer/animated_drawer.dart';
import '../in_app_purchase/in_app_purchase_screen.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {

  // Function to save server data to SharedPreferences
  Future<dynamic> saveServerData(
      dynamic serverName,
      dynamic config,
      dynamic image
      ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString('serverName', serverName);
    prefs.setString('config', config);
    prefs.setString('image', image);

  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    Get.find<ServerListController>().getServerList(page: 1);
    if(Get.find<AuthController>().getAuthToken().isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.find<PremiumListController>().getServerList();
        Get.find<ProfileController>().getProfileData().then((value) {
          if (value == 200) {
            final profile = Get.find<ProfileController>().profileData;

            final isPremium = profile["isPremium"].toString() == "1";

            // Parse expired_date into DateTime
            final expiredDate = DateTime.tryParse(profile["expired_date"].toString());

            // Get today's date/time
            final now = DateTime.now();

            if (isPremium && expiredDate != null && expiredDate.isAfter(now)) {
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: GetBuilder<ProfileController>(
        builder: (profileController) {
          return Scaffold(
            backgroundColor: AppColors.appBgColor,
            appBar: AppBar(
              backgroundColor: AppColors.appBgColor,
              elevation: 8,
              automaticallyImplyLeading: false,
              leading: IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: const Icon(Icons.arrow_back, color: Colors.white),
              ),
              title: Text(
                "vpn_location".tr,
                style:GoogleFonts.aBeeZee(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600
                ),),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(50),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: TabBar(
                    indicatorColor: const Color(0xffF57D1F),
                    labelStyle: GoogleFonts.martelSans(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                    labelColor: const Color(0xffF57D1F),
                    unselectedLabelColor: Colors.white70,

                    tabs: [
                      Tab(text: 'free_server'.tr),
                      Tab(text: 'premium_server'.tr),
                    ],
                  ),
                ),
              ),
            ),

            resizeToAvoidBottomInset: false,

            body: TabBarView(
              children: [
                ///Free
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: GetBuilder<ServerListController>(
                    builder: (serverListController) {
                      final serverList = serverListController.freeServerData;

                      if (serverListController.isLoading == true &&
                          serverList==null) {
                        return const Center(
                            child: SizedBox(
                              height: 25,
                              width: 25,
                              child: CircularProgressIndicator(
                                color: Colors.orange,
                                backgroundColor: Colors.teal,
                              ),
                            ));
                      }  else {
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: serverList.length,
                          itemBuilder: (context, index) {
                            if (index < serverListController.freeServerData!.length) {
                              final item = serverListController.freeServerData![index];
                              return Padding(
                                padding:
                                const EdgeInsets.only(left: 16, right: 16, bottom: 12),
                                child: Column(
                                  children: [
                                    const SizedBox(height: 4,),
                                    GestureDetector(
                                      onTap: (){
                                        saveServerData(
                                          item['name'],
                                          item['link'],
                                          item['country_code'],
                                        );
                                        Get.offAll(()=> const AnimatedDrawerScreen(),transition: Transition.leftToRight);
                                      },
                                      child: Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                            color: Colors.white.withValues(alpha: 0.15),
                                            borderRadius: BorderRadius.circular(10)
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 16),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 10),
                                            child: Row(
                                              children: [
                                                ClipOval(
                                                  child: Image.asset(
                                                    "assets/flags/${item["country_code"].toString().toLowerCase()}.png",
                                                    height: 40,
                                                    width: 40,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                const SizedBox(width: 10,),
                                                Expanded(
                                                  child: Text("${item['name']}",style: GoogleFonts.roboto(
                                                      color: Colors.white,
                                                      fontSize: 15,
                                                      fontWeight: FontWeight.w400
                                                  ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              // Display loading indicator only if isLoading is true
                              if (serverListController.isLoading) {
                                return const SizedBox.shrink();
                              } else {
                                // Return an empty container if isLoading is false (no more data)
                                return Container();
                              }
                            }
                          },
                        );
                      }
                    },
                  ),
                ),

                ///paid
                Get.find<AuthController>().getAuthToken().isEmpty?
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppColors.appBgColor,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          )
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.lock_person, size: 50, color: Colors.white70),
                          const SizedBox(height: 16),
                          Text(
                            "login_required".tr,
                            style: GoogleFonts.martelSans(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            "access_premium".tr,
                            style: GoogleFonts.martelSans(
                              fontSize: 16,
                              color: Colors.white70,
                              height: 1.4,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),
                          GestureDetector(
                            onTap: () {
                              Get.to(() => const LoginScreen(), transition: Transition.rightToLeft);
                            },
                            child: Container(
                              height: 55,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xffF57D1F), Color(0xffFF9F45)],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.login, color: Colors.white, size: 24),
                                  const SizedBox(width: 10),
                                  Text(
                                    "login_to_acc".tr,
                                    style: GoogleFonts.inter(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 18),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )
                    :
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: GetBuilder<PremiumListController>(
                    builder: (premiumListController) {
                      final serverList = premiumListController.premiumServerData;

                      if (premiumListController.isLoading == true && serverList == null) {
                        return const Center(
                          child: SizedBox(
                            height: 25,
                            width: 25,
                            child: CircularProgressIndicator(
                              color: Colors.orange,
                              backgroundColor: Colors.teal,
                            ),
                          ),
                        );
                      } else {
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: serverList.length,
                          itemBuilder: (context, index) {
                            if (index < premiumListController.premiumServerData!.length) {
                              final item = premiumListController.premiumServerData![index];

                              bool isPremiumUser =
                                  profileController.profileData?["isPremium"] == 1;

                              return Padding(
                                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
                                child: GestureDetector(
                                  onTap: (){
                                    bool isPremiumUser =
                                        profileController.profileData?["isPremium"] == 1;

                                    if (isPremiumUser) {
                                      // Premium user: normal connect
                                      saveServerData(
                                        item['name'],
                                        item['link'],
                                        item['country_code'],
                                      );
                                      Get.offAll(
                                            () => const AnimatedDrawerScreen(),
                                        transition: Transition.leftToRight,
                                      );
                                    } else {
                                      // Non-premium: redirect to purchase screen
                                      Get.to(
                                            () => const InAppPurchaseScreen(),
                                        transition: Transition.rightToLeft,
                                      );
                                    }
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: isPremiumUser
                                            ? Colors.transparent
                                            : Colors.orangeAccent,
                                        width: 1.2,
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 10),
                                      child: Row(
                                        children: [
                                          ClipOval(
                                            child: Image.asset(
                                              "assets/flags/${item["country_code"].toString().toLowerCase()}.png",
                                              height: 40,
                                              width: 40,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Text(
                                              "${item['name']}",
                                              style: GoogleFonts.roboto(
                                                color: Colors.white,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ),
                                          if (profileController.profileData?["isPremium"] != 1 )
                                            const Icon(Icons.lock,
                                                color: Colors.orangeAccent, size: 20),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            } else {
                              return const SizedBox.shrink();
                            }
                          },
                        );
                      }
                    },
                  ),
                )


              ],
            ),
          );
        }
      ),
    );
  }
}

