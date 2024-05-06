import 'dart:async';
import 'dart:developer';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rayka_test/gen/assets.gen.dart';
import 'package:rayka_test/home.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  _OnboardingState createState() => _OnboardingState();
}

List<Image> image = [
  Image(image: Assets.image.page1.provider()),
  Image(image: Assets.image.group59.provider()),
  Image(image: Assets.image.group51.provider()),
];
List<String> title = [
  'درخواست سفر',
  'تایید راننده',
  'پایش سفر',
];
List<String> description = [
  'درخواست سفر در سریع ترین زمان بررسی میشود',
  'سفر یار به شما این امکان را میدهد تا مسیری ایمن را انتخاب کنید',
  'سفر یار برای پایش سفر نیاز به دسترسی دائمی موقعیت مکانی دارد',
];

class _OnboardingState extends State<Onboarding> {
  final PageController _controller = PageController();
  PermissionStatus status = PermissionStatus.denied;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).textTheme;
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: screenSize.width,
          height: screenSize.height,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        CupertinoPageRoute(
                            builder: (context) => const HomeScreen()),
                      );
                    },
                    child: Text(
                      'رد کردن',
                      style: theme.labelLarge,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: PageView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: image.length,
                  controller: _controller,
                  itemBuilder: (BuildContext context, int index) {
                    return Center(
                      child: Column(
                        children: [
                          SizedBox(height: screenSize.height / 10),
                          SizedBox(
                            height: screenSize.height / 3,
                            width: screenSize.width / 1.5,
                            child: image[index],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            title[index],
                            style: theme.titleLarge,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            description[index],
                            style: theme.bodyMedium,
                          ),
                          if (index == 2) ...[
                            Padding(
                              padding:
                                  EdgeInsets.only(top: screenSize.height / 12),
                              child: ElevatedButton(
                                onPressed: () => _handleAccessButton(),
                                child: const Text('گرفتن دسترسی'),
                              ),
                            ),
                          ],
                        ],
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: SmoothPageIndicator(
                  effect: const WormEffect(dotHeight: 5),
                  controller: _controller,
                  count: image.length,
                  axisDirection: Axis.horizontal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleAccessButton() async {
    if (status.isDenied) {
      await _showLocationAccessDialog();
    } else {
      await _showBackgroundServiceDialog();
    }
  }

  Future<void> _showLocationAccessDialog() async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('دسترسی به موقعیت مکانی'),
        content: const Text(
            'برنامه نیاز به دسترسی به موقعیت شما دارد تا بتواند برای شما بهترین راهنمایی‌ها را ارائه کند'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('خیر'),
          ),
          TextButton(
            onPressed: () async {
              await Permission.location.request();
              status = await Permission.locationAlways.request();
              Navigator.of(context).pop();
            },
            child: const Text('بله'),
          ),
        ],
      ),
    );
  }

  Future<void> _showBackgroundServiceDialog() async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('اجازه اجرا در پس زمینه'),
        content: const Text(
            ' برای اجرای برخی از وظایف مهم و ارائه خدمات بهتر، برنامه نیاز به اجرای در پس‌زمینه دارد '),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('خیر'),
          ),
          TextButton(
            onPressed: () async {
              FlutterBackgroundService().invoke('set as background');
              Navigator.of(context).pop();
            },
            child: const Text('بله'),
          ),
        ],
      ),
    );
  }
}

Future<void> initiolizedService() async {
  final service = FlutterBackgroundService();
  await service.configure(
    iosConfiguration: IosConfiguration(),
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      isForegroundMode: true,
      autoStart: true,
    ),
  );
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();
  if (service is AndroidServiceInstance) {
    service.on('set as background').listen((event) {
      service.setAsBackgroundService();
      Timer.periodic(const Duration(seconds: 15), (timer) async {
        log(timer.toString());
      });
    });
  }
  service.invoke('update');
}
