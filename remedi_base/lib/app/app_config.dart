/// AppConfig is in charge of managing product flavor, device info and os info.
import 'dart:developer' as dev;
import 'dart:io';
import 'dart:ui' as ui;

import 'package:device_info/device_info.dart';
import 'package:flutter/services.dart';
import 'package:flutter_user_agent/flutter_user_agent.dart';
import 'package:package_info/package_info.dart';

import 'app_repository.dart';

class AppConfig {
  static String _baseUrl;
  static String _baseWebUrl;
  static bool _isRelease;
  static String _endpoint;
  static String _appVersion;
  static String _buildNumber;
  static bool _enablePrintLog;
  static String _osVersion;
  static int _osVersionSdk = 0;
  static String _deviceManufacturer;
  static String _deviceModel;
  static String _userAgent;

  static String get baseUrl => _baseUrl;

  static String get baseWebUrl => _baseWebUrl;

  static bool get isRelease => _isRelease;

  static String get endpoint => _endpoint;

  static String get appVersion => _appVersion;

  static String get buildNumber => _buildNumber;

  static bool get enablePrintLog => _enablePrintLog;

  static String get osVersion => _osVersion;

  static int get osVersionSdk => _osVersionSdk;

  static String get deviceManufacturer => _deviceManufacturer;

  static String get deviceModel => _deviceModel;

  static String get userAgent => _userAgent;

  // set device info.
  static Future init() async {
    return await Future.wait([
      _setPackageInfo(),
      _setDeviceInfo(),
      _setUserAgent(),
    ]);
  }

  /// baseUrl, baseWebUrl, endpoint flavor, logging
  /// user set this config in main()
  static setFlavorConfig(
      {String baseUrl,
      String baseWebUrl,
      bool isRelease,
      String endpoint,
      bool enablePrintLog}) {
    AppConfig._baseUrl = baseUrl ?? "";
    AppConfig._baseWebUrl = baseWebUrl ?? "";
    AppConfig._isRelease = isRelease ?? false;
    AppConfig._endpoint = endpoint ?? "";
    AppConfig._enablePrintLog = enablePrintLog ?? false;
  }

  static String get platform {
    if (Platform.isIOS) {
      return "ios";
    }

    if (Platform.isAndroid) {
      return "android";
    }

    if (Platform.isFuchsia) {
      return "fuchsia";
    }

    if (Platform.isLinux) {
      return "linux";
    }

    if (Platform.isMacOS) {
      return "macOs";
    }

    if (Platform.isWindows) {
      return "windows";
    }

    return "unknown";
  }

  static Future _setPackageInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    AppConfig._appVersion = packageInfo.version;
    AppConfig._buildNumber = packageInfo.buildNumber;
  }

  static Future _setDeviceInfo() async {
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    try {
      if (Platform.isIOS) {
        IosDeviceInfo info = await deviceInfo.iosInfo;
        AppConfig._osVersion = info.systemVersion;
        List<String> split = AppConfig._osVersion.split(".");
        AppConfig._osVersionSdk = int.parse(split[0]);
        AppConfig._deviceManufacturer = "apple";
        AppConfig._deviceModel = info.model;
      }

      if (Platform.isAndroid) {
        AndroidDeviceInfo info = await deviceInfo.androidInfo;
        AppConfig._osVersion = info.version.release;
        AppConfig._osVersionSdk = info.version.sdkInt;
        AppConfig._deviceManufacturer = info.manufacturer;
        AppConfig._deviceModel = info.model;
      }
    } on PlatformException catch (e) {}
  }

  static Future _setUserAgent() async {
    try {
      AppConfig._userAgent =
          await FlutterUserAgent.getPropertyAsync('userAgent');
    } catch (e) {}
  }

  static Future<String> get appId => AppRepository.instance.appId;

  static void log() async {
    dev.log(_baseUrl ?? "unknown", name: "baseUrl");
    dev.log(_baseWebUrl ?? "unknown", name: "webBaseUrl");
    dev.log("$_isRelease", name: "isRelease");
    dev.log(_endpoint ?? "unknown", name: "endpoint");
    dev.log(_appVersion ?? "unknown", name: "appVersion");
    dev.log(_buildNumber ?? "unknown", name: "buildNumber");
    dev.log(platform ?? "unknown", name: "platform");
    dev.log(_osVersion ?? "unknown", name: "osVersion");
    dev.log("$_osVersionSdk", name: "osVersionSdk");
    dev.log(_deviceManufacturer ?? "unknown", name: "deviceManufacturer");
    dev.log(_deviceModel ?? "unknown", name: "deviceModel");
    dev.log("${await AppRepository.instance.appId}", name: "appId");
    dev.log("${ui.window.physicalSize.width}", name: "physicalSize.width");
    dev.log("${ui.window.devicePixelRatio}", name: "devicePixelRatio");
  }
}
