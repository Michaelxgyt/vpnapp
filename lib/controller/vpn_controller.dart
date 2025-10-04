import 'package:flutter_v2ray_client/flutter_v2ray.dart';
import 'package:get/get.dart';

class VpnController extends GetxController {
  late V2ray flutterV2ray;
  var v2rayStatus = V2RayStatus().obs; // Используем .obs для реактивности

  @override
  void onInit() {
    super.onInit();
    flutterV2ray = V2ray(
      onStatusChanged: (status) {
        v2rayStatus.value = status;
      },
    );
    flutterV2ray.initialize().then((_) {
      // Возможно, здесь потребуется дополнительная логика инициализации
    });
  }

  Future<void> startVpn({
    required String remark,
    required String config,
    required List<String> bypassSubnets,
    required List<String>? blockedApps,
  }) async {
    if (v2rayStatus.value.state == "DISCONNECTED") {
      if (await flutterV2ray.requestPermission()) {
        await flutterV2ray.startV2Ray(
          remark: remark,
          config: config,
          proxyOnly: false,
          bypassSubnets: bypassSubnets,
          blockedApps: blockedApps,
        );
      }
    }
  }

  Future<void> stopVpn() async {
    if (v2rayStatus.value.state != "DISCONNECTED") {
      await flutterV2ray.stopV2Ray();
    }
  }

  bool isVpnConnected() {
    return v2rayStatus.value.state == "CONNECTED";
  }
}