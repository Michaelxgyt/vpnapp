import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../controller/auth_controller.dart';
import '../../utils/app_constant.dart';
import '../../widget/local_widget.dart';
import '../apps/allowed_application_screen.dart';
import '../home/home_screen.dart';
import '../profile/profile_screen.dart';
import '../speed_test/speed_test_screen.dart';

class AnimatedDrawerScreen extends StatefulWidget {
  const AnimatedDrawerScreen({super.key});

  @override
  createState() => _AnimatedDrawerScreenState();
}

class _AnimatedDrawerScreenState extends State<AnimatedDrawerScreen> {
  final ZoomDrawerController zoomDrawerController = ZoomDrawerController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF57D1F),
      appBar: AppBar(
        backgroundColor: const Color(0xffF57D1F),
        leading: GestureDetector(
          onTap: () {
            zoomDrawerController.toggle!();
          },
          child: Align(
            alignment: Alignment.topLeft,
            child: Container(
              height: 50,
              width: 80,
              decoration: const BoxDecoration(
                color: bgColor,
              ),
              child: const Icon(
                Icons.menu_outlined,
                size: 26,
                color: Colors.white,
              ),
            ),
          ),
        ),
        actions: [
          Get.find<AuthController>().getAuthToken().isNotEmpty?
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 8),
            child: Container(
              decoration: const BoxDecoration(
                color: bgColor
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: (){
                      Get.to(()=> const ProfileScreen(isLogin: false,),transition: Transition.leftToRight);
                    },
                    child: const CircleAvatar(
                        radius: 20,
                        backgroundColor: bgColor,
                        child: Icon(Icons.person,color: Colors.white,size: 26,)),
                  ),
                  const SizedBox(width: 12,),
                  ReusableLanguageBottomSheetButton()
                ],
              ),
            ),
          ):
          const SizedBox()
        ],
      ),
      body: ZoomDrawer(
        shadowLayer1Color: Colors.deepOrange.withValues(alpha: 0.3),
        controller: zoomDrawerController,
        menuScreen: const MenuScreen(),
        mainScreen: const HomeScreen(),
        borderRadius: 12.0,
        showShadow: true,
        menuBackgroundColor: const Color(0xffF57D1F),
        angle: -8.0,
        slideWidth: MediaQuery.of(context).size.width * 0.60,
      ),
    );
  }
}

final ZoomDrawerController zoomDrawerController = ZoomDrawerController();

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xffF57D1F),
      child: ListView(
        padding: const EdgeInsets.only(top: 10),
        children: [
          ListTile(
            leading: const CircleAvatar(
                backgroundColor: Colors.black54,
                child: Icon(
                  Icons.home,
                  color: Colors.white,
                )),
            title: Text(
              'home'.tr,
              style: GoogleFonts.aBeeZee(color: Colors.white, fontSize: 16,
                  fontWeight: FontWeight.w500
              ),
            ),
            onTap: () {
              ZoomDrawer.of(context)?.close();
            },
          ),
          const SizedBox(
            height: 4,
          ),
          ListTile(
            leading: const CircleAvatar(
                backgroundColor: Colors.black54,
                child: Icon(
                  Icons.home,
                  color: Colors.white,
                )),
            title:  Text(
              'split_tunnel'.tr,
              style: GoogleFonts.aBeeZee(color: Colors.white, fontSize: 16,
              fontWeight: FontWeight.w500
              ),
            ),
            onTap: () {
              Get.to(() => const SplitTunnelScreen(),
                  transition: Transition.rightToLeft);
            },
          ),
          const SizedBox(
            height: 4,
          ),
          ListTile(
            leading: const CircleAvatar(
                backgroundColor: Colors.black54,
                child: Icon(
                  Icons.telegram,
                  color: Colors.white,
                )),
            title:  Text(
              'join_tg'.tr,
              style:GoogleFonts.aBeeZee(color: Colors.white, fontSize: 16,
                  fontWeight: FontWeight.w500
              ),
            ),
            onTap: () async {
              String url =
                  "https://t.me/hbayazid29";
              if (kDebugMode) {
                print("launchingUrl: $url");
              }
              if (await canLaunchUrl(Uri.parse(url))) {
                await launchUrl(Uri.parse(url));
              }
            },
          ),
          const SizedBox(
            height: 4,
          ),
          ListTile(
            leading: const CircleAvatar(
                backgroundColor: Colors.black54,
                child: Icon(
                  Icons.speed,
                  color: Colors.white,
                )),
            title: Text(
              'speed_test'.tr,
              style: GoogleFonts.aBeeZee(color: Colors.white, fontSize: 16,
                  fontWeight: FontWeight.w500
              ),
            ),
            onTap: () {
              Get.to(() => const SpeedTestScreen(),
                  transition: Transition.rightToLeft);
            },
          ),
          const SizedBox(
            height: 4,
          ),
          ListTile(
            leading: const CircleAvatar(
                backgroundColor: Colors.black54,
                child: Icon(
                  Icons.star_rate_outlined,
                  color: Colors.white,
                )),
            title:  Text(
              'rate_us'.tr,
              style: GoogleFonts.aBeeZee(color: Colors.white, fontSize: 16,
                  fontWeight: FontWeight.w500
              ),
            ),
            onTap: () async {
              Uri url = Uri.parse(
                  'https://play.google.com/store/apps/details?id=com.app.gamersshieldvpn'); // Replace with your desired YouTube URL
              if (await canLaunchUrl(url)) {
                await launchUrl(url);
              } else {
                throw 'Could not launch $url';
              }
            },
          ),
          const SizedBox(
            height: 4,
          ),
          ListTile(
            leading: const CircleAvatar(
                backgroundColor: Colors.black54,
                child: Icon(
                  Icons.share_outlined,
                  color: Colors.white,
                )),
            title: Text(
              'share'.tr,
              style: GoogleFonts.aBeeZee(color: Colors.white, fontSize: 16,
                  fontWeight: FontWeight.w500
              ),
            ),
            onTap: () {
              String textToShare =
                  'https://play.google.com/store/apps/details?id=com.app.gamersshieldvpn'; // Replace with the text you want to share
              Share.share(textToShare);
            },
          ),
          const SizedBox(
            height: 4,
          ),
          ListTile(
            leading: const CircleAvatar(
                backgroundColor: Colors.black54,
                child: Icon(
                  Icons.category_outlined,
                  color: Colors.white,
                )),
            title: Text(
              'more_apps'.tr,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
            onTap: () async {
              Uri url = Uri.parse(
                  "https://play.google.com/store/apps/developer?id=MBH&hl=en"); // Replace with your desired YouTube URL
              if (await canLaunchUrl(url)) {
                await launchUrl(url);
              } else {
                throw 'Could not launch $url';
              }
            },
          ),
        ],
      ),
    );
  }
}
