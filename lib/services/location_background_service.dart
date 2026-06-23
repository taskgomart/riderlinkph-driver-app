import 'dart:async';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';

const String notificationChannelId = 'riderlinkph_location_tracking';
const int notificationId = 888;

/// Initializes the Flutter background service with location foreground service type.
/// Call this once during app startup, after location permissions are granted.
Future<void> initializeBackgroundService() async {
  final service = FlutterBackgroundService();

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: false,
      isForegroundMode: true,
      foregroundServiceTypes: [AndroidForegroundType.location],
      notificationChannelId: notificationChannelId,
      initialNotificationTitle: 'RiderLink PH Driver',
      initialNotificationContent: 'Tracking your location while on duty',
      foregroundServiceNotificationId: notificationId,
    ),
    iosConfiguration: IosConfiguration(
      onForeground: onStart,
      onBackground: onIosBackground,
    ),
  );
}

/// Starts the background location service.
/// The service will keep running as a foreground service with a persistent
/// notification even when the app is in the background.
Future<void> startLocationService() async {
  final service = FlutterBackgroundService();
  final isRunning = await service.isRunning();
  if (!isRunning) {
    service.startService();
  }
}

/// Stops the background location service.
Future<void> stopLocationService() async {
  final service = FlutterBackgroundService();
  final isRunning = await service.isRunning();
  if (isRunning) {
    service.invoke('stopService');
  }
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });
    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }

  service.on('stopService').listen((event) {
    service.stopSelf();
  });

  // Periodic location updates while on duty.
  // The actual location-fetch and backend-push logic lives in the existing
  // ProfileController.startLocationRecord() timer, which runs in the main
  // isolate. This service's role is purely to keep that isolate alive in
  // the background with a valid foreground-service identity on Android 14+.
  Timer.periodic(const Duration(seconds: 30), (timer) async {
    if (service is AndroidServiceInstance) {
      if (await service.isForegroundService()) {
        service.setForegroundNotificationInfo(
          title: 'RiderLink PH Driver',
          content: 'Location tracking is active',
        );
      }
    }
  });
}

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  return true;
}