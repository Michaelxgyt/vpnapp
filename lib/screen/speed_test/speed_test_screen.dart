import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_internet_speed_test/flutter_internet_speed_test.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:gamers_shield_vpn/screen/speed_test/palatte.dart';
import 'package:gamers_shield_vpn/screen/speed_test/progress_bar.dart';
import '../../utils/app_constant.dart';

class SpeedTestScreen extends StatefulWidget {
  const SpeedTestScreen({super.key});

  @override
  State<SpeedTestScreen> createState() => _SpeedTestScreenState();
}

class _SpeedTestScreenState extends State<SpeedTestScreen> {
  final internetSpeedTest = FlutterInternetSpeedTest()..enableLog();

  bool _testInProgress = false;
  double _downloadRate = 0;
  double _uploadRate = 0;


  String _unitText = 'Mbps';

  // Value for NeedlePointer
  double _needlePointerValue = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      reset();
    });
  }

  void reset() {
    setState(() {
      {
        _testInProgress = false;
        _downloadRate = 0;
        _uploadRate = 0;
        _unitText = 'Mbps';

      }
    });
  }

  // Using a flag to prevent the user from interrupting running tests
  bool isTesting = false;

  final ProgressBar progressBar = ProgressBar();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 2,
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: (){
            Get.back();
          },
          icon: const Icon(Icons.arrow_back,color: Colors.white,),
        ),
        title: Text('speed_test_internet'.tr,style: GoogleFonts.aBeeZee(
            color: Colors.white,
            fontSize: 16,
          fontWeight: FontWeight.w500
        ),),
      ),

      body: SizedBox(
        width: double.infinity,
        height: double.infinity,

        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 20),

              // --- Download/Upload Panel ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white10),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildSpeedInfoCard(
                        icon: Icons.arrow_downward,
                        label: 'download'.tr,
                        rate: _downloadRate,
                        unit: _unitText,
                        color: Colors.green,
                      ),
                      _buildSpeedInfoCard(
                        icon: Icons.arrow_upward,
                        label: 'upload'.tr,
                        rate: _uploadRate,
                        unit: _unitText,
                        color: Colors.blue,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // --- Radial Gauge ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.04),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: SfRadialGauge(
                      axes: <RadialAxis>[
                        RadialAxis(
                          minimum: 0,
                          maximum: 150,
                          showLabels: false,
                          showTicks: false,
                          axisLineStyle: const AxisLineStyle(
                            thickness: 0.15,
                            thicknessUnit: GaugeSizeUnit.factor,
                          ),
                          ranges: <GaugeRange>[
                            GaugeRange(
                              startValue: 0,
                              endValue: 50,
                              color: Colors.green,
                              startWidth: 10,
                              endWidth: 10,
                            ),
                            GaugeRange(
                              startValue: 50,
                              endValue: 100,
                              color: Colors.orange,
                              startWidth: 10,
                              endWidth: 10,
                            ),
                            GaugeRange(
                              startValue: 100,
                              endValue: 150,
                              color: Colors.red,
                              startWidth: 10,
                              endWidth: 10,
                            ),
                          ],
                          pointers: <GaugePointer>[
                            NeedlePointer(
                              value: _needlePointerValue,
                              enableAnimation: true,
                              needleColor: Colors.white,
                              knobStyle: const KnobStyle(color: Colors.white),
                            ),
                          ],
                          annotations: <GaugeAnnotation>[
                            GaugeAnnotation(
                              widget: Text(
                                '${_needlePointerValue.toStringAsFixed(1)} $_unitText',
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              angle: 90,
                              positionFactor: 0.5,
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    value: _testInProgress ? null : 0,
                    strokeWidth: 6.0,
                    backgroundColor: Colors.grey.withValues(alpha: 0.3),
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // --- Progress Spinner ---
              if(!_testInProgress)...{
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(80.0)),
                      padding: const EdgeInsets.all(0.0),
                      color: Colors.red,
                      textColor: txtCol,
                      onPressed: () async {
                        if (!_testInProgress) {
                          reset();
                          await internetSpeedTest.startTesting(
                            onStarted: () {
                              setState(() {
                                _testInProgress = true;
                              });
                            },
                            onCompleted: (TestResult download, TestResult upload) {
                              if (kDebugMode) {
                                print(
                                    'the transfer rate ${download.transferRate}, ${upload.transferRate}');
                              }
                              setState(() {
                                _downloadRate = download.transferRate;
                                _unitText =
                                download.unit == SpeedUnit.kbps ? 'Kbps' : 'Mbps';
                                // Update NeedlePointer value
                                _needlePointerValue = _downloadRate;
                              });
                              setState(() {
                                _uploadRate = upload.transferRate;
                                _unitText =
                                upload.unit == SpeedUnit.kbps ? 'Kbps' : 'Mbps';
                                // Update NeedlePointer value
                                _needlePointerValue = _uploadRate;
                                _testInProgress = false;
                              });
                            },
                            onProgress: (double percent, TestResult data) {
                              if (kDebugMode) {
                                print(
                                    'the transfer rate $data.transferRate, the percent $percent');
                              }
                              setState(() {
                                _unitText =
                                data.unit == SpeedUnit.kbps ? 'Kbps' : 'Mbps';
                                if (data.type == TestType.download) {
                                  _downloadRate = data.transferRate;
                                  // Update NeedlePointer value
                                  _needlePointerValue = _downloadRate;
                                } else {
                                  _uploadRate = data.transferRate;
                                  // Update NeedlePointer value
                                  _needlePointerValue = _uploadRate;
                                }
                              });
                            },
                            onError: (String errorMessage, String speedTestError) {
                              if (kDebugMode) {
                                print(
                                    'the errorMessage $errorMessage, the speedTestError $speedTestError');
                              }
                              reset();
                            },
                            onDefaultServerSelectionInProgress: () {
                              setState(() {
                              });
                            },
                            onDefaultServerSelectionDone: (Client? client) {
                              setState(() {
                              });
                            },
                            onDownloadComplete: (TestResult data) {
                              setState(() {
                                _downloadRate = data.transferRate;
                                _unitText =
                                data.unit == SpeedUnit.kbps ? 'Kbps' : 'Mbps';
                              });
                            },
                            onUploadComplete: (TestResult data) {
                              setState(() {
                                _uploadRate = data.transferRate;
                                _unitText =
                                data.unit == SpeedUnit.kbps ? 'Kbps' : 'Mbps';
                              });
                            },
                            onCancel: () {
                              reset();
                            },
                          );
                        }
                      },
                      child: Ink(
                        decoration: BoxDecoration(
                          gradient: buttonGradient,
                          borderRadius: const BorderRadius.all(Radius.circular(80.0)),
                        ),
                        child: Container(
                          constraints: const BoxConstraints(
                              minWidth: 188.0, minHeight: 46.0), // min sizes for Material buttons
                          alignment: Alignment.center,
                          child: Text(
                            'start_test'.tr,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              }
              else...{
                MaterialButton(
                  minWidth: 150,
                  height: 40,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(80.0)),
                  padding: const EdgeInsets.all(0.0),
                  color: Colors.red,
                  textColor: txtCol,
                  child: Text('cancel_test'.tr,style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),),
                  onPressed: () => internetSpeedTest.cancelTest(),
                ),
              },
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildSpeedInfoCard({
    required IconData icon,
    required String label,
    required double rate,
    required String unit,
    required Color color,
  }) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.8),
          radius: 26,
          child: Icon(icon, color: Colors.white),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${rate.toStringAsFixed(1)} $unit',
          style: GoogleFonts.inter(
            fontSize: 14,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }

}
