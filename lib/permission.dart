import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Permissions extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _Permissions();
}

class _Permissions extends State<Permissions> {
  bool _requrested = false;
  bool _fetching = false;
  late NotificationSettings _settings;

  Future<void> requrestPermissions() async {
    setState(() {
      _fetching = true;
    });

    // プッシュ通知のパーミッション許可ダイアログを出すメソッド
    final settings = await FirebaseMessaging.instance.requestPermission(
      announcement: true,
      carPlay: true,
      criticalAlert: true
    );

    setState(() {
      _requrested = true;
      _fetching = false;
      _settings = settings;
    });
  }

  Widget row(String title, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('$title:', style: const TextStyle(fontWeight: FontWeight.bold),),
          Text(value),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_fetching) {
      return const CircularProgressIndicator();
    }

    if (!_requrested) {
      return ElevatedButton(
          onPressed: requrestPermissions,
          child: const Text("Request Permissions"),
      );
    }

    return Column(
      children: [
        row('Authorization Status', statusMap[_settings.authorizationStatus]!),
        if (defaultTargetPlatform == TargetPlatform.iOS) ...[
          row('Alert', settingsMap[_settings.alert]!),
          row('Announcement', settingsMap[_settings.announcement]!),
          row('Badge', settingsMap[_settings.badge]!),
          row('Car Play', settingsMap[_settings.carPlay]!),
          row('Lock Screen', settingsMap[_settings.lockScreen]!),
          row('Notification Center', settingsMap[_settings.notificationCenter]!),
          row('Show Previews', previewMap[_settings.showPreviews]!),
          row('Sound', settingsMap[_settings.sound]!),
        ],
        ElevatedButton(
            onPressed: () {},
            child: const Text('Reload Permissions')
        )
      ],
    );
  }

}

const statusMap = {
  AuthorizationStatus.authorized: 'Authorized',
  AuthorizationStatus.denied: 'Denied',
  AuthorizationStatus.notDetermined: 'Not Determined',
  AuthorizationStatus.provisional: 'Provisional',
};

const settingsMap = {
  AppleNotificationSetting.disabled: 'Disabled',
  AppleNotificationSetting.enabled: 'Enabled',
  AppleNotificationSetting.notSupported: 'Not Supported',
};

const previewMap = {
  AppleShowPreviewSetting.always: 'Always',
  AppleShowPreviewSetting.never: 'Never',
  AppleShowPreviewSetting.notSupported: 'Not Supported',
  AppleShowPreviewSetting.whenAuthenticated: 'Only When Authenticated',
};