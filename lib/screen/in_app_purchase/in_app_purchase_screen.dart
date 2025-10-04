import 'dart:async';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import '../../controller/subscription_controller.dart';
import '../../utils/app_colors.dart';
import '../profile/profile_screen.dart';

class InAppPurchaseScreen extends StatefulWidget {
  const InAppPurchaseScreen({super.key});

  @override
  State<InAppPurchaseScreen> createState() => _InAppPurchaseScreenState();
}

class _InAppPurchaseScreenState extends State<InAppPurchaseScreen> {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>>? _purchaseUpdateStream;

  List<ProductDetails> _products = [];
  final Set<String> _productIds = {
    'one_month_subscription',
    'six_month_subscription',
    'one_year_subscription',
    'three_month_subscription'
  };

  @override
  void initState() {
    super.initState();
    // Listen for purchase updates
    _purchaseUpdateStream = _inAppPurchase.purchaseStream.listen((List<PurchaseDetails> purchaseDetailsList) {
      _listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      _purchaseUpdateStream!.cancel();
    }, onError: (Object error) {
      // handle error here.
    });

    // Fetch the products and ensure lifecycle integrity
    _getProducts();
  }

  @override
  void dispose() {
    // Cancel the purchase update stream subscription on dispose
    _purchaseUpdateStream?.cancel();
    super.dispose();
  }


  void _listenToPurchaseUpdated(List<PurchaseDetails> purchases) {
    for (PurchaseDetails purchase in purchases) {
      if (purchase.status == PurchaseStatus.purchased ||
          purchase.status == PurchaseStatus.restored) {
        _handleSubscription(purchase);
        log("Purchase is done");
      } else if (purchase.status == PurchaseStatus.error) {
        if (kDebugMode) {
          log("Purchase is error");
        }
      } else if (purchase.status == PurchaseStatus.pending) {
        if (kDebugMode) {
          print('Purchase is pending');
          log("Purchase is pending");
        }
      }
      else{
        log("Not Purchase");
      }
    }
  }

  Future<void> _getProducts() async {
    try {
      ProductDetailsResponse response = await _inAppPurchase.queryProductDetails(_productIds);
      log("Available Products: ${response.productDetails.length}");
      log("Not Found IDs: ${response.notFoundIDs}");

      if (response.notFoundIDs.isEmpty) {
        setState(() {
          _products = response.productDetails;
        });
      } else {
        if (kDebugMode) {
          print('Error fetching products: ${response.notFoundIDs}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Exception fetching products: $e');
      }
    }
  }

  Future<void> _buySubscription(ProductDetails product) async {
    try {
      final PurchaseParam purchaseParam = PurchaseParam(productDetails: product);
      await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
    } catch (e) {
      if (kDebugMode) {
        print('Error buying subscription: $e');
      }
    }
  }

  void _handleSubscription(PurchaseDetails purchase) {
    if (purchase.productID == 'one_month_subscription') {

      if (purchase.pendingCompletePurchase) {
        _inAppPurchase.completePurchase(purchase).then((value){
          Get.find<SubscriptionController>().purchaseSubscription(
              packageName: _products[0].title,
              validity: _products[0].price,
              price: _products[0].price
          ).then((value){
            if(value==200) {
              Get.offAll(()=> ProfileScreen(isLogin: true));
              Fluttertoast.showToast(
                msg: "Plan purchased successfully",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.green,
                textColor: Colors.white,
                fontSize: 16.0,
              );
            }
            else{
              Fluttertoast.showToast(
                msg: "Something went wrong! Try again",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0,
              );
            }
          });
        });
      }

    }
    else if (purchase.productID == 'six_month_subscription') {

      if (purchase.pendingCompletePurchase) {
        _inAppPurchase.completePurchase(purchase).then((value){
          Get.find<SubscriptionController>().purchaseSubscription(
              packageName: _products[2].title,
              validity: _products[2].price,
              price: _products[2].price
          ).then((value){
            if(value==200) {
              Fluttertoast.showToast(
                msg: "Plan purchased successfully",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.green,
                textColor: Colors.white,
                fontSize: 16.0,
              );
              Get.offAll(()=> ProfileScreen(isLogin: true));
            }
            else{
              Fluttertoast.showToast(
                msg: "Something went wrong! Try again",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0,
              );
            }
          });
        });
      }

    }
    else if (purchase.productID == 'one_year_subscription') {

      if (purchase.pendingCompletePurchase) {
        _inAppPurchase.completePurchase(purchase).then((value){
          Get.find<SubscriptionController>().purchaseSubscription(
              packageName: _products[1].title,
              validity: _products[1].price,
              price: _products[1].price
          ).then((value){
            if(value==200) {
              Fluttertoast.showToast(
                msg: "Plan purchased successfully",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.green,
                textColor: Colors.white,
                fontSize: 16.0,
              );
              Get.offAll(()=> ProfileScreen(isLogin: true));
            }
            else{
              Fluttertoast.showToast(
                msg: "Something went wrong! Try again",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0,
              );
            }
          });
        });
      }

    }
    else if (purchase.productID == 'three_month_subscription') {

      if (purchase.pendingCompletePurchase) {
        _inAppPurchase.completePurchase(purchase).then((value){
          Get.find<SubscriptionController>().purchaseSubscription(
              packageName: _products[3].title,
              validity: _products[3].price,
              price: _products[3].price
          ).then((value){
            if(value==200) {
              Fluttertoast.showToast(
                msg: "Plan purchased successfully",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.green,
                textColor: Colors.white,
                fontSize: 16.0,
              );
              Get.offAll(()=> ProfileScreen(isLogin: true));
            }
            else{
              Fluttertoast.showToast(
                msg: "Something went wrong! Try again",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0,
              );
            }
          });
        });
      }

    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBgColor,
      appBar: AppBar(
        backgroundColor: AppColors.appBgColor,
        elevation: 10,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        title: Text(
          "subscription_plan".tr,
          style: GoogleFonts.poppins(color: Colors.white, fontSize: 16,
          fontWeight: FontWeight.w500
          ),
        ),
      ),
      body: Center(
        child: _products.isEmpty
            ? const Center(child: SizedBox(height: 25, width: 25, child: CircularProgressIndicator()))
            : ListView.builder(
          itemCount: _products.length,
          itemBuilder: (context, index) {
            ProductDetails product = _products[index];

            // Badge text logic
            String? badgeText;
            if (index == 1) {
              badgeText = "Most Popular";
            } else if (index == 2) {
              badgeText = "Best Savings";
            }

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.appButtonColor.withOpacity(0.9),
                          AppColors.appButtonColor.withOpacity(0.7),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(20),
                      title: Text(
                        product.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          product.description,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.85),
                            fontSize: 14,
                          ),
                        ),
                      ),
                      trailing: Text(
                        product.price,
                        style: const TextStyle(
                          color: Colors.amberAccent,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onTap: () => _buySubscription(product),
                    ),
                  ),

                  // Premium Badge (Ribbon Style)
                  if (badgeText != null)
                    Positioned(
                      top: -4,
                      right: 12,
                      child: Transform.rotate(
                        angle: 0.1, // slight tilt
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: index == 1 ? Colors.deepOrange : Colors.teal,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            badgeText,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        )


      ),
    );
  }
}


