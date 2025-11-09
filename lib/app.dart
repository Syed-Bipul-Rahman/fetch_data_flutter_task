import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'core/utils/app_colors.dart';
import 'features/home/presentation/controllers/home_controller.dart';
import 'features/home/presentation/home_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          title: 'StackFood',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.green,
            scaffoldBackgroundColor: AppColors.background,
            textTheme: GoogleFonts.robotoTextTheme(Theme.of(context).textTheme),
            appBarTheme: AppBarTheme(
              backgroundColor: Colors.white,
              elevation: 0,
              iconTheme: const IconThemeData(color: Colors.black87),
              titleTextStyle: GoogleFonts.roboto(
                color: Colors.black87,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          initialBinding: BindingsBuilder(() {
            Get.lazyPut<HomeController>(() => HomeController());
          }),
          home: child,
        );
      },
      child: const HomePage(),
    );
  }
}
