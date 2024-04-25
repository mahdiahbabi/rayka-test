// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
];
List<String> description = [
  'درخواست سفر در سریع ترین زمان بررسی میشود',
  'سفر یار به شما این امکان را میدهد تا مسیری ایمن را انتخاب کنید',
  'سفر یار برای پایش سفر نیاز به دسترسی دائمی موقعیت مکانی دارد',
];

class _OnboardingState extends State<Onboarding> {
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
                      Navigator.of(context).pushReplacement(CupertinoPageRoute(
                          builder: (context) => const HomeScreen()));
                    },
                    child: Text(
                      'رد کردن',
                      style: theme.labelLarge,
                    ))
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
                        SizedBox(
                          height: screenSize.height / 10,
                        ),
                        SizedBox(
                            height: screenSize.height / 3,
                            width: screenSize.width / 1.5,
                            child: image[index]),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          title[index],
                          style: theme.titleLarge,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          description[index],
                          style: theme.bodyMedium,
                        ),
                        if (index == 2)
                          Padding(
                            padding:
                                EdgeInsets.only(top: screenSize.height / 12),
                            child: ElevatedButton(
                              onPressed: () async {
                                final status =
                                    await Permission.location.request();
                                await Permission.locationAlways.request();
                                if (status.isGranted) {
                                  Navigator.of(context)
                                      .pushReplacement(CupertinoPageRoute(
                                    builder: (context) => const HomeScreen(),
                                  ));
                                } else if (status.isDenied) {
                                  locationAccessAlert(context);
                                } else if (status.isPermanentlyDenied) {
                                  locationAccessAlert(context);
                                }
                              },
                              child: const Text('گرفتن دسترسی'),
                            ),
                          )
                        else
                          const SizedBox(
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
                effect: const WormEffect(dotHeight: 5),
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

  Future<dynamic> locationAccessAlert(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: const Text('دسترسی موقعیت مکانی'),
          content: const Text('لطفا دسترسی به موقعیت مکانی را بدهید'),
          actions: [
            TextButton(
              onPressed: () => openAppSettings(),
              child: const Text('رفتن به تنظیمات'),
            ),
          ],
        ),
      ),
    );
  }
}
