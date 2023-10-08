import 'package:flutter/material.dart';

import 'package:svs/screens/login/login_screen.dart';
import 'package:svs/screens/layout/home_layout.dart';
import 'package:svs/screens/payment/add_payment_screen.dart';

final routes = {
  '/login': (BuildContext context) => new LoginScreen(),
  '/customerlist': (BuildContext context) => new HomeLayout(
        index: 0,
        filterIndex: 0,
      ),
  '/paymentlist': (BuildContext context) => new HomeLayout(
        index: 1,
        filterIndex: 0,
      ),
  '/home': (BuildContext context) => new HomeLayout(
        index: 2,
        filterIndex: 0,
      ),
  '/invoicelist': (BuildContext context) => new HomeLayout(
        index: 3,
        filterIndex: 0,
      ),
  '/complaintlist': (BuildContext context) => new HomeLayout(
        index: 4,
        filterIndex: 0,
      ),
  '/add-payment': (BuildContext context) => new AddPaymentScreen()
};
