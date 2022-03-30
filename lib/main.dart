import 'package:doctro/localization/language_localization.dart';
import 'package:doctro/screens/ChangePassword.dart';
import 'package:doctro/screens/SignIn.dart';
import 'package:doctro/screens/ViewAllAppointment.dart';
import 'package:doctro/screens/ViewAllNotification.dart';
import 'package:doctro/screens/changeLanguage.dart';
import 'package:doctro/screens/forgotpassword.dart';
import 'package:doctro/screens/videocallhistory.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'VideoCall/overlay_handler.dart';
import 'constant/prefConstatnt.dart';
import 'localization/localization_constant.dart';
import 'screens/signup.dart';
import 'screens/phoneverification.dart';
import 'screens/loginhome.dart';
import 'screens/patient_information.dart';
import 'screens/cancelappointment.dart';
import 'screens/appointment_history.dart';
import 'screens/rate&review.dart';
import 'screens/notifications.dart';
import 'screens/profile.dart';
import 'screens/payment.dart';
import 'package:doctro/constant/preferences.dart';
import 'package:doctro/screens/SubScription.dart';
import 'package:doctro/screens/PaymentGetway.dart';
import 'package:doctro/screens/SubscriptionHistory.dart';
import 'package:doctro/screens/ScheduleTimings.dart';
import 'package:doctro/screens/StripePayment.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferenceHelper.init();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {

  @override
  _MyAppState createState() => _MyAppState();

  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState state = context.findAncestorStateOfType<_MyAppState>()!;
    state.setLocale(newLocale);
  }
}

class _MyAppState extends State<MyApp> {

  get skip => null;

  Locale? _locale;

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void didChangeDependencies() {
    getLocale().then((local) => {
      setState(() {
        this._locale = local;
      })
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {

    if (_locale == null) {
      return Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    else {

      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);

      return ChangeNotifierProvider<OverlayHandlerProvider>(
        create: (_) => OverlayHandlerProvider(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: LoginHome(),
          locale: _locale,
          supportedLocales: [
            Locale(ENGLISH, 'US'),
            Locale(ARABIC, 'AE'),
          ],
          localizationsDelegates: [
            LanguageLocalization.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          localeResolutionCallback: (deviceLocal, supportedLocales) {
            for (var local in supportedLocales) {
              if (local.languageCode == deviceLocal!.languageCode &&
                  local.countryCode == deviceLocal.countryCode) {
                return deviceLocal;
              }
            }
            return supportedLocales.first;
          },

          initialRoute: SharedPreferenceHelper.getBoolean(Preferences.is_logged_in) == true
              ? 'loginhome'
              : 'SignIn',
          routes: {
            'SignIn': (context) => SignIn(),
            'signup': (context) => CreateAccount(),
            'ForgotPasswordScreen': (context) => ForgotPasswordScreen(),
            'phoneverification': (context) => PhoneVerificationScreen(),
            'ViewAllAppointment': (context) => ViewAllAppointment(),
            'loginhome': (context) => LoginHome(),
            'patientinformation': (context) => PatientInformationScreen(),
            'cancelappoitment': (context) => CancelAppointmentScreen(),
            'AppointmentHistoryScreen': (context) => AppointmentHistoryScreen(),
            'rateandreview': (context) => RateAndReviewScreen(),
            'notifications': (context) => NotificationsScreen(),
            'profile': (context) => ProfileScreen(),
            'payment': (context) => PaymentScreen(),
            'subscription': (context) => SubScription(),
            'paymentgetway': (context) => PaymentGetway(),
            'Subscription History': (context) => SubscriptionHistory(),
            'Schedule Timings': (context) => ScheduleTimings(),
            'Change Password': (context) => ChangePassword(),
            'Change Language': (context) => ChangeLanguage(),
            'ViewAllNotification': (context) => ViewAllNotification(),
            'Stripe' :(context) => Stripe(),
            'VideoCallHistory' :(context) => VideoCallHistory(),
          },
        ),
      );
    }
  }
}