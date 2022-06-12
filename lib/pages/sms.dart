import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:shohay_app/Models/simplified_contact.dart';


// ignore: must_be_immutable
class SMS extends StatefulWidget {
  final _position;
  List<SimplifiedContact> selectedContacts = [];
  SMS(this._position, this.selectedContacts, {Key? key}) : super(key: key);
  @override
  _MySMSState createState() => _MySMSState(_position,selectedContacts);
}

class _MySMSState extends State<SMS> {
  final _position;
  List<SimplifiedContact> selectedContacts = [];
  _MySMSState(this._position, this.selectedContacts);
  late String _controllerMessage;
  late List<SimplifiedContact> _controllerPeople;
  String? _message, body;
  String _canSendSMSMessage = 'Check is not run.';
  bool sendDirect = false;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    _controllerPeople = selectedContacts;
    _controllerMessage = _position;
  }

  Future<void> _sendSMS(List<String> recipients) async {
    try {
      String _result = await sendSMS(
        message: _position.toString(),
        recipients: recipients,
        sendDirect: sendDirect,
      );
      setState(() => _message = _result);
    } catch (error) {
      setState(() => _message = error.toString());
    }
  }

  Future<bool> _canSendSMS() async {
    bool _result = await canSendSMS();
    setState(() => _canSendSMSMessage =
        _result ? 'This unit can send SMS' : 'This unit cannot send SMS');
    return _result;
  }

  Widget _phoneTile(SimplifiedContact name) {
    return Padding(
      padding: const EdgeInsets.all(3),
      child: Container(
          decoration: BoxDecoration(
              border: Border(
            bottom: BorderSide(color: Colors.grey.shade300),
            top: BorderSide(color: Colors.grey.shade300),
            left: BorderSide(color: Colors.grey.shade300),
            right: BorderSide(color: Colors.grey.shade300),
          )),
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () =>
                      setState(() => _controllerPeople.remove(name)),
                ),
                Padding(
                  padding: const EdgeInsets.all(0),
                  child: Text(
                    name.name,
                    textScaleFactor: 1,
                    style: const TextStyle(fontSize: 12),
                  ),
                )
              ],
            ),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('SMS/MMS Example'),
        ),
        body: ListView(
          children: <Widget>[
            if (_controllerPeople.isEmpty)
              const SizedBox(height: 0)
            else
              SizedBox(
                height: 90,
                child: Padding(
                  padding: const EdgeInsets.all(3),
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: List<Widget>.generate(_controllerPeople.length,
                        (int index) {
                      return _phoneTile(_controllerPeople[index]);
                    }),
                  ),
                ),
              ),
            // ListTile(
            //   leading: const Icon(Icons.people),
            //   // title: TextField(
            //   //   controller: _controllerPeople,
            //   //   decoration:
            //   //       const InputDecoration(labelText: 'Add Phone Number'),
            //   //   keyboardType: TextInputType.number,
            //   //   onChanged: (String value) => setState(() {}),
            //   // ),
            //   trailing: IconButton(
            //     icon: const Icon(Icons.add),
            //     onPressed: _controllerPeople.text.isEmpty
            //         ? null
            //         : () => setState(() {
            //               people.add(_controllerPeople.text.toString());
            //               _controllerPeople.clear();
            //             }),
            //   ),
            // ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.message),
              title: _position != null
                  ? TextField(
                      decoration: InputDecoration(
                        labelText: 'Current Location: ' + _position.toString(),
                      ),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : const Text('No Location Data'),
              // title: TextField(
              //   decoration: const InputDecoration(labelText: 'Add Message'),
              //
              //   onChanged: (String value) => setState(() {}),
              // ),
            ),
            const Divider(),
            ListTile(
              title: const Text('Can send SMS'),
              subtitle: Text(_canSendSMSMessage),
              trailing: IconButton(
                padding: const EdgeInsets.symmetric(vertical: 16),
                icon: const Icon(Icons.check),
                onPressed: () {
                  _canSendSMS();
                },
              ),
            ),
            SwitchListTile(
                title: const Text('Send Direct'),
                subtitle: const Text(
                    'Should we skip the additional dialog? (Android only)'),
                value: sendDirect,
                onChanged: (bool newValue) {
                  setState(() {
                    sendDirect = newValue;
                  });
                }),
            Padding(
              padding: const EdgeInsets.all(8),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith(
                      (states) => Theme.of(context).colorScheme.secondary),
                  padding: MaterialStateProperty.resolveWith(
                      (states) => const EdgeInsets.symmetric(vertical: 16)),
                ),
                onPressed: () {
                  _send();
                },
                child: Text(
                  'SEND',
                  style: Theme.of(context).textTheme.displayMedium,
                ),
              ),
            ),
            Visibility(
              visible: _message != null,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        _message ?? 'No Data',
                        maxLines: null,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _send() {
    if (_controllerPeople.isEmpty) {
      setState(() => _message = 'At Least 1 Person or Message Required');
    } else {
      List<String> collectphonenos = [];
      for (var i = 0; i < _controllerPeople.length; i++) {
        collectphonenos.add(_controllerPeople[i].phone);
      }
      _sendSMS(collectphonenos);
    }
  }
}
