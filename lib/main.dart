// import 'package:borrow/pages/change_screen_pin_screen.dart';
import 'package:borrow/pages/lock_screen.dart';
import 'package:borrow/pages/login_screen.dart';
import 'package:borrow/pages/payment_status_screen.dart';
import 'package:borrow/providers/auth_provider.dart';
import 'package:borrow/providers/transaction_provider.dart';
import 'package:borrow/providers/user_provider.dart';
import 'package:borrow/widget_tree.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';

void main() {
  // f
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => TransactionProvider()),
      ],
      child: MyApp(),
    ),
  );
  // runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final storage = FlutterSecureStorage();
  Future<String?> getToken() async {
    return await storage.read(key: "access");
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.purple,
          brightness: Brightness.light,
        ),
      ),

      home: FutureBuilder<String?>(
        future: getToken(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(body: Center(child: CircularProgressIndicator()));
          } else if (snapshot.hasData && snapshot.data != null) {
            return LockScreen();
          } else {
            return LoginScreen();
          }
        },
      ),
      // debugShowCheckedModeBanner: false,
      // home: PaymentStatusScreen(data: {}),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Widget _child = widgettree[2];
  int index = 2;
  // Color _navColor = Color.fromRGBO(255, 255, 255, 0.5);
  bool extend = false;

  final PageController _pageController = PageController(initialPage: 2);
  void _onNavItemTapped(int index) {
    setState(() {
      this.index = index;
      if (index == 2) {
        extend = true;
      } else {
        extend = false;
      }
    });
    _pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 200), // Animation speed
      curve: Curves.easeInOut, // Animation style
    );
    // _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: extend,
      body: PageView(
        controller: _pageController,
        children: widgettree,
        onPageChanged: (index) {
          setState(() {
            this.index = index;
          });
        },
      ),
      // bottomNavigationBar: FluidNavBar(
      //   defaultIndex: 2,
      //   scaleFactor: 2.0,
      //   animationFactor: 0.2,
      //   style: FluidNavBarStyle(
      //     barBackgroundColor: Colors.transparent,
      //     iconBackgroundColor: Colors.deepPurple,
      //     iconSelectedForegroundColor: Colors.white,
      //   ), // (1)
      //   icons: [
      //     FluidNavBarIcon(icon: Icons.takeout_dining),
      //     FluidNavBarIcon(icon: Icons.payment),
      //     FluidNavBarIcon(icon: Icons.home),
      //     FluidNavBarIcon(icon: Icons.payment),
      //   ],
      //   onChange: _handleNavigationChange,
      // ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GNav(
          // backgroundColor: _navColor,
          tabActiveBorder: Border.all(color: Colors.black, width: 1),
          selectedIndex: 2,
          // tabBackgroundColor: Colors.purple,
          tabBorderRadius: 15,
          tabs: [
            GButton(icon: Icons.explore, text: "Explore"),
            GButton(icon: Icons.qr_code, text: "Borrow"),
            GButton(icon: Icons.home, text: "Home"),
            GButton(icon: Icons.list, text: "Activity"),
          ],
          onTabChange: _onNavItemTapped,
        ),
      ),
    );
  }

  // void _handleNavigationChange(int index) {
  //   setState(() {
  //     switch (index) {
  //       case 0:
  //         _child = widgettree[index];
  //         break;
  //       case 1:
  //         _child = widgettree[index];
  //         break;
  //       case 2:
  //         _child = widgettree[index];
  //       case 3:
  //         _child = widgettree[index];
  //         break;
  //     }
  //     _child = AnimatedSwitcher(
  //       switchInCurve: Curves.easeInOutCirc,
  //       switchOutCurve: Curves.easeInOutCirc,
  //       duration: Duration(milliseconds: 500),
  //       child: _child,
  //     );
  //   });
  // }
}
