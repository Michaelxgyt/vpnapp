import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../controller/vpn_controller.dart';
import '../../utils/app_constant.dart';
import '../../widget/custom_clipper.dart';
import '../location/location_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  dynamic serverName = "";
  dynamic config = "";

  loadConfigData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      serverName = prefs.getString('serverName');
      config = prefs.getString('config');
    });
    if (kDebugMode) {
      print(serverName);
      print(config);
    }

  }

  List<String>? enabledApps;

  getEnableAppList() async{
    // Initialize app switch states from SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      enabledApps = prefs.getStringList('enabled_apps') ?? [];
      if (kDebugMode) {
        print("check enable app list $enabledApps");
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getEnableAppList();
      loadConfigData();
    });
  }

  List<String> bypassSubnets = [];
  final bypassSubnetController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: bgColor,
        body: ListView(
          children: <Widget>[
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.topCenter,
              children: <Widget>[
                ClipPath(
                  clipper: MyCustomClipper(),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
                    height: 180,
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                        gradient: RadialGradient(
                          colors: <Color>[
                            Color(0xffF57D1F),
                            Color(0xffF57D1F),
                          ],
                          focalRadius: 16,
                        )
                    ),
                  ),
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ValueListenableBuilder(
                        valueListenable: v2rayStatus,
                        builder: (context, value, child) {
                          return Column(
                            children: [
                              GestureDetector(
                                onTap: () async{
                                 if(config!=null){
                                   if (value.state == "DISCONNECTED") {
                                     V2RayURL parser = V2ray.parseFromURL(config!);
                                     if(await flutterV2ray.requestPermission()){
                                  flutterV2ray.startV2Ray(
                                      remark: parser.remark,
                                      config: parser.getFullConfiguration(),
                                      proxyOnly: false,
                                      bypassSubnets: bypassSubnets,
                                      blockedApps: enabledApps
                                  );
                                  setState(() {

                                  });
                                  }
                                   } else {
                                     flutterV2ray.stopV2Ray();
                                   }
                                 }
                                 else{
                                   Fluttertoast.showToast(
                                       msg: "please_select_location".tr,
                                       toastLength: Toast.LENGTH_SHORT,
                                       gravity: ToastGravity.BOTTOM,
                                       timeInSecForIosWeb: 1,
                                       backgroundColor: Colors.red,
                                       textColor: Colors.white,
                                       fontSize: 16.0
                                   );
                                 }

                                },
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: <Widget>[
                                    Container(
                                      height: width * 0.51,
                                      width: width * 0.51,
                                      decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          gradient: RadialGradient(
                                            colors: <Color>[
                                              Color(0xffF57D1F),
                                              Color(0xffF57D1F),
                                            ],
                                            focalRadius: 16,
                                          )
                                        // color: Colors.red,
                                      ),
                                      child: Center(
                                        child: Container(
                                          height: width * 0.5,
                                          width: width * 0.5,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: bgColor,
                                          ),
                                          child: Center(
                                            child: Container(
                                              height: width * 0.43,
                                              width: width * 0.43,
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  gradient:
                                                  value.state == "DISCONNECTED"
                                                      ? const LinearGradient(
                                                    colors: <Color>[
                                                      Colors.red,
                                                      Colors.blue,
                                                    ],
                                                  )
                                                      : const LinearGradient(
                                                    colors: <Color>[
                                                      Color(0XFFFFB534),
                                                      Color(0XFF00C2A0),
                                                    ],
                                                  ),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: const Color(0XFF00D58D)
                                                          .withValues(alpha: .2),
                                                      spreadRadius: 15,
                                                      blurRadius: 15,
                                                    ),
                                                  ]),
                                              child:  Center(
                                                child:
                                                value.state == "DISCONNECTED"
                                                    ?
                                                const Icon(Icons.power_settings_new,
                                                    color: Colors.white, size: 50):
                                                AvatarGlow(
                                                  child: Material(     // Replace this child with your own
                                                    elevation: 8.0,
                                                    shape: const CircleBorder(),
                                                    child: CircleAvatar(
                                                      backgroundColor: Colors.grey[100],
                                                      radius: 30.0,
                                                      child: const Icon(
                                                          Icons.stop_circle,
                                                          color: Color(0xffF57D1F),
                                                          size: 50),
                                                    ),
                                                  ),
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
                              const SizedBox(
                                height: 24,
                              ),
                              Text(
                                value.state,
                                style: GoogleFonts.aBeeZee(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'duration'.tr,
                                    style: GoogleFonts.aBeeZee(fontSize: 16),
                                  ),
                                  Text(
                                    value.duration,
                                    style: GoogleFonts.aBeeZee(fontSize: 16),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                   Text(
                                    'traffic'.tr,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    '${value.upload}↑ ${value.download}↓',
                                    style: GoogleFonts.aBeeZee(fontSize: 16),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 34),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 24),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Column(
                                      children: [
                                        const Icon(
                                          Icons.upload_outlined,
                                          color: Colors.yellow,
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              'upload'.tr,
                                              style: txtSpeedStyle,
                                              textAlign: TextAlign.center,
                                            ),
                                            Text(
                                              '${value.uploadSpeed}',
                                              style: txtSpeedStyle,
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        const Icon(
                                          Icons.download_outlined,
                                          color: Colors.green,
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              'download'.tr,
                                              style: txtSpeedStyle,
                                              textAlign: TextAlign.center,
                                            ),
                                            Text(
                                              '${value.downloadSpeed}',
                                              style: txtSpeedStyle,
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 30,),

                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30
                                ),
                                child: GestureDetector(
                                  onTap: (){
                                    Get.to(()=>const LocationScreen(),transition: Transition.rightToLeft);
                                  },
                                  child: Container(
                                    height: 60,
                                    width: 300,
                                    decoration: BoxDecoration(
                                        color: const Color(0xffF57D1F),
                                        borderRadius: BorderRadius.circular(10)
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 16),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Row(
                                              children: [
                                                 Icon(Icons.location_pin,size: 30,color: Colors.white.withValues(alpha: 0.95),),
                                                const SizedBox(width: 12,),
                                                serverName!=null?
                                                Expanded(
                                                  child: Text("$serverName",style: GoogleFonts.aBeeZee(color: Colors.white,
                                                      fontSize: 16,
                                                    fontWeight: FontWeight.w500
                                                  ),
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ):
                                                 Text("select_location".tr,style: GoogleFonts.martelSans(color: Colors.white,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500
                                                ),)
                                            
                                              ],
                                            ),
                                          ),
                                          const Icon(Icons.arrow_forward_ios_rounded,color: Colors.white,size: 24,)
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 20,),

                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),

          ],
        ));
  }
}
