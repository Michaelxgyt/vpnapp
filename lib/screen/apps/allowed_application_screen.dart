import 'package:flutter/material.dart';
import 'package:gamers_shield_vpn/screen/drawer/animated_drawer.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:installed_apps/installed_apps.dart';
import 'package:installed_apps/app_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/app_colors.dart';

class SplitTunnelScreen extends StatefulWidget {
  const SplitTunnelScreen({super.key});

  @override
  State<SplitTunnelScreen> createState() => _SplitTunnelScreenState();
}

class _SplitTunnelScreenState extends State<SplitTunnelScreen> {
  List<AppInfo> _apps = [];
  Set<String> _enabledApps = {};

  @override
  void initState() {
    super.initState();
    _loadApps();
    _loadEnabledApps();
  }

  Future<void> _loadApps() async {
    final apps = await InstalledApps.getInstalledApps(true, true);
    setState(() {
      _apps = apps;
    });
  }

  Future<void> _loadEnabledApps() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> saved = prefs.getStringList('enabled_apps') ?? [];
    setState(() {
      _enabledApps = saved.toSet();
    });
  }

  Future<void> _toggleApp(String packageName, bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      if (enabled) {
        _enabledApps.add(packageName);
      } else {
        _enabledApps.remove(packageName);
      }
    });
    await prefs.setStringList('enabled_apps', _enabledApps.toList());
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (context,result){
        Get.offAll(() => const AnimatedDrawerScreen(), transition: Transition.leftToRight);
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.appTextFieldFillColor,
          elevation: 1,
          centerTitle: true,
          title: Text('split_tunnel'.tr,style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white
          ),),
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: (){
              Get.offAll(()=> const AnimatedDrawerScreen(),transition: Transition.leftToRight);
            },
            icon: const Icon(Icons.arrow_back,color: Colors.white,size: 20,),
          ),
        ),
        backgroundColor: AppColors.appTextFieldFillColor,
        body: _apps.isEmpty
            ? const Center(child: SizedBox(
            height: 25,width: 25,
            child: CircularProgressIndicator(
              backgroundColor: Colors.blue,
              color: Colors.deepPurple,
            )))
            : ListView.builder(
          itemCount: _apps.length,
          itemBuilder: (context, index) {
            final app = _apps[index];
            final isEnabled = _enabledApps.contains(app.packageName);
            return ListTile(
              leading: app.icon != null
                  ? Image.memory(app.icon!, width: 40, height: 40)
                  : const Icon(Icons.android, size: 40),
              title: Text(app.name,style: GoogleFonts.poppins(
                  color: AppColors.appWhiteColor,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0,
                  fontSize: 16
              ),),
              subtitle: Text(app.packageName,style: GoogleFonts.poppins(
                  color: AppColors.appWhiteColor.withValues(alpha: 0.7),
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0,
                  fontSize: 14
              ),),
              trailing: Switch(
                activeColor: Colors.green,
                value: isEnabled,
                onChanged: (value) => _toggleApp(app.packageName, value),
              ),
            );
          },
        ),
      ),
    );
  }
}
