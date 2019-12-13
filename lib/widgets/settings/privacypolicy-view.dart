import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:soundshare/models/User.dart';
import 'package:soundshare/services/auth.dart';
import 'package:soundshare/services/camera.dart';
import 'package:soundshare/services/db.dart';
import 'package:soundshare/services/info-overlay.dart';
import 'package:soundshare/services/storage.dart';
import 'package:soundshare/validators/email.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';

class PrivacyPolicyView extends StatefulWidget {
  @override
  _PrivacyPolicyView createState() => _PrivacyPolicyView();
}

class _PrivacyPolicyView extends State<PrivacyPolicyView> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      //backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          iconTheme: IconThemeData(color: Colors.black),
          elevation: 0.0,
        ),
        body: Center(
          child: Text("Wir schützen deine Daten nicht. Eltern haften für ihre Kinder."),
        )
    );
  }
}