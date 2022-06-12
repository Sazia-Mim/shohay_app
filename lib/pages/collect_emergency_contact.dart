import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shohay_app/pages/sms.dart';

import 'package:shohay_app/widgets/contact_list.dart';

import '../Models/simplified_contact.dart';

class EmergencyContact extends StatefulWidget {
  // Get contacts permission
  @override
  _EmergencyContactState createState() => _EmergencyContactState();
}

class _EmergencyContactState extends State<EmergencyContact> {
  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Position? _position;

  void _getCurrentLocation() async {
    Position position = await _determinePosition();
    setState(() {
      _position = position;
    });
  }

  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  Future<PermissionStatus> _askPermissions() async {
    PermissionStatus permissionStatus = await _getContactPermission();
    return permissionStatus;
    // if (permissionStatus == PermissionStatus.granted) {
    // } else {
    //   _handleInvalidPermissions(permissionStatus);
    // }
  }

  Future<PermissionStatus> _getContactPermission() async {
    PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.permanentlyDenied) {
      PermissionStatus permissionStatus = await Permission.contacts.request();
      return permissionStatus;
    } else {
      return permission;
    }
  }

  void _handleInvalidPermissions(PermissionStatus permissionStatus) {
    if (permissionStatus == PermissionStatus.denied) {
      const snackBar = SnackBar(content: Text('Access to contact data denied'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else if (permissionStatus == PermissionStatus.permanentlyDenied) {
      const snackBar =
          SnackBar(content: Text('Contact data not available on device'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  final GlobalKey<dynamic> contactWidgetKey = GlobalKey();

  List<SimplifiedContact> selectedContacts = [];
  List<int> selectedContactIndices = [];

  void onContactSelect(List<SimplifiedContact> contacts, List<int> indices) {
    setState(() {
      selectedContacts = contacts;
      selectedContactIndices = indices;
    });
  }

  Future<void> onContactBtnPress(BuildContext context) async {
    showDialog(
      context: context,
      barrierColor: Colors.white,
      barrierDismissible: false,
      builder: (_) => Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(
            color: Colors.black,
          ),
          title: const Text('Select Contact'),
          actions: [
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: () {
                contactWidgetKey.currentState.onDone(context);
              },
            )
          ],
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          toolbarTextStyle: const TextTheme(
            headline6: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ).bodyText2,
          titleTextStyle: const TextTheme(
            headline6: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ).headline6,
        ),
        body: Column(
          children: [
            Container(
              child: ContactList(
                key: contactWidgetKey,
                onDone: onContactSelect,
                selectedContactIndices: selectedContactIndices,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Image.asset('images/ill2.png', width: w * 0.5, height: h * 0.3),
            Container(
              margin: const EdgeInsets.only(top: 20),
              child: ElevatedButton(
                onPressed: () async {
                  PermissionStatus permissionStatus = await _askPermissions();
                  if (permissionStatus == PermissionStatus.granted) {
                    onContactBtnPress(context);
                  } else {
                    _handleInvalidPermissions(permissionStatus);
                  }
                },
                child: const Text('Edit Emergency Contacts'),
              ),
            ),
            Container(
              child: Flexible(
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: selectedContacts.length,
                  itemBuilder: (BuildContext context, int index) {
                    SimplifiedContact contact =
                        selectedContacts.elementAt(index);

                    return Column(
                      children: [
                        ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 2,
                            horizontal: 18,
                          ),
                          title: Text(contact.name),
                          subtitle: Text(contact.phone),
                        ),
                        const Divider(
                          height: 1,
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top:20.0),
              child: ElevatedButton(
                child: const Text('SOS',
                  style: TextStyle(fontSize: 25),
                ),
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(150, 150),
                  shape: const CircleBorder(),
                ),
                onPressed: () {
                  print(_position);
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return SMS(_position, selectedContacts);
                  }));
                  // print(emergencyContactList[2].phone);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
