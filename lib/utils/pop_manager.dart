import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PopManager {
  bool canPopScreen(BuildContext context) {
    log("GoRouter.of(context).canPop(): ${GoRouter.of(context).canPop()}");
    return GoRouter.of(context).canPop();
  }
}
