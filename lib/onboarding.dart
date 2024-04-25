// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rayka_test/gen/assets.gen.dart';
import 'package:rayka_test/home.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

final PageController _controller = PageController();
List<Image> image = [
  Image(image: Assets.image.page1.provider()),
  Image(image: Assets.image.group59.provider()),
  Image(image: Assets.image.group51.provider()),
];
List<String> title = [
  'درخواست سفر',
  'تایید راننده',
  'پایش سفر',
  '',
];
List<String> description = [
  'درخواست سفر شما به نزدیکترین راننده ها ارسال مشود',
  'سفر یار به شما این امکان را میدهد تا مسیری ایمن را انتخاب کنید',
  'سفر یار برلی پایش مسیر حرکت شما نیاز به دسترسی موقغیت مکانی دارد ',
];

class _OnboardingState extends State<Onboarding> {
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
          child: SizedBox(
        width: screenSize.width,
        height: screenSize.height,
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: image.length,
                controller: _controller,
                itemBuilder: (BuildContext context, int index) {
                  return Center(
                    child: Column(
                      children: [
                        SizedBox(
                          height: screenSize.height / 5,
                        ),
                        image[index],
                        const SizedBox(
                          height: 10,
                        ),
                        Text(title[index]),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(description[index]),
                        index == 2
                            ? ElevatedButton(
                                onPressed: () async {
                                  final status =
                                      await Permission.location.request();
                                  if (status.isGranted) {
                                    Navigator.of(context)
                                        .pushReplacement(CupertinoPageRoute(
                                      builder: (context) => const HomeScreen(),
                                    ));
                                  } else if (status.isDenied) {
                                    // The user denied the permission, you can handle this case here
                                    // For example, you can show a dialog explaining why the permission is needed
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: Text('Location Permission'),
                                        content: Text(
                                            'Please grant access to location for the app to function properly.'),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.of(context).pop(),
                                            child: Text('OK'),
                                          ),
                                        ],
                                      ),
                                    );
                                  } else if (status.isPermanentlyDenied) {
                                    // The user permanently denied the permission, you can navigate them to app settings
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: Text('Location Permission'),
                                        content: Text(
                                            'Please go to app settings and grant access to location.'),
                                        actions: [
                                          TextButton(
                                            onPressed: () => openAppSettings(),
                                            child: Text('Settings'),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                },
                                child: const Text('گرفتن دسترسی'),
                              )
                            : const SizedBox(
                                width: 0,
                                height: 0,
                              )
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: SmoothPageIndicator(
                controller: _controller,
                count: image.length,
                axisDirection: Axis.horizontal,
              ),
            ),
          ],
        ),
      )),
    );
  }
}
