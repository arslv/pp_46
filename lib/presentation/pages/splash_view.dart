import 'dart:async';
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get_it/get_it.dart';
import 'package:pp_46/business/helpers/dialog_helper.dart';
import 'package:pp_46/business/services/navigation/route_names.dart';
import 'package:pp_46/data/repository/database_keys.dart';
import 'package:pp_46/data/repository/database_service.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  final _databaseService = GetIt.instance<DatabaseService>();
  final _connectivity = Connectivity();

  @override
  void initState() {
    _init();
    super.initState();
  }

  Future<void> _init() async {
    await _initConnectivity(
      () async => await DialogHelper.showNoInternetDialog(context),
    );

    _navigate();
  }

  Future<void> _initConnectivity(Future<void> Function() callback) async {
    late ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
      if (result == ConnectivityResult.none) {
        await callback.call();
        return;
      }
    } on PlatformException catch (e) {
      log('Couldn\'t check connectivity status', error: e);
      return;
    }

    if (!mounted) {
      return Future.value(null);
    }
  }

  void _navigate() {
    FlutterNativeSplash.remove();
    final seenOnboarding = _databaseService.get(DatabaseKeys.seenOnboarding) ?? false;

    if (!seenOnboarding) {
      Navigator.of(context).pushReplacementNamed(RouteNames.onboarding);
    } else {
      final acceptedPrivacy = _databaseService.get(DatabaseKeys.acceptedPrivacy) ?? false;
      Navigator.of(context).pushReplacementNamed(
        !acceptedPrivacy ? RouteNames.privacy : RouteNames.main, ///TODO uncomment
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(color: Theme.of(context).colorScheme.onPrimary),
      ),
    );
  }
}
