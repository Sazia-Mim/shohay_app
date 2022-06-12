
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shohay_app/Models/simplified_contact.dart';

import 'action_button.dart';

class ContactList extends StatefulWidget {
  final Function(List<SimplifiedContact>, List<int>) onDone;
  final List<int> selectedContactIndices;

  const ContactList({
    Key? key,
    required this.onDone,
    required this.selectedContactIndices,
  }) : super(key: key);

  @override
  _ContactListState createState() => _ContactListState();
}

class _ContactListState extends State<ContactList> {
  late List<SimplifiedContact> contactList = [];
  List<int> selectedIndices = [];

  @override
  void initState() {
    super.initState();

    selectedIndices = widget.selectedContactIndices;
    getContacts();
  }

  Future<PermissionStatus> _getPermission() async {
    final PermissionStatus permission = await Permission.contacts.status;
    const PermissionStatus granted = PermissionStatus.granted;
    const PermissionStatus denied = PermissionStatus.denied;
    if (permission == granted || permission == denied) {
      return permission;
    }
    return permission;
  }

  Future<void> getContacts() async {
    final PermissionStatus permissionStatus = await _getPermission();

    if (permissionStatus == PermissionStatus.granted) {
      int index = 0;
      final Iterable<Contact> contacts = await ContactsService.getContacts();
      // final List<SimplifiedContact> tempContacts = [];

      setState(() {
        contactList = [];
        for (var contact in contacts) {
          for (var phoneData in contact.phones!) {
            contactList.add(SimplifiedContact(
              index,
              contact.displayName!,
              phoneData.value!,
            ));

            index++;
          }
        }
      });

      // setState(() {
      //   contactList = tempContacts;
      // });
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: const Text('Permissions error'),
          content: const Text('Grant contacts permission to see the contacts'),
          actions: <Widget>[
            CupertinoDialogAction(
              child: const Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
        ),
      );
    }
  }

  void onContactSelect(int index) {
    setState(() {
      selectedIndices.add(index);
    });
  }

  void onContactRemove(int index) {
    int elementIndex = selectedIndices.indexOf(index);

    if (elementIndex > -1) {
      setState(() {
        selectedIndices.removeAt(elementIndex);
      });
    }
  }

  void selectAll(BuildContext context) {
    List<int> indexList = [];
    int index = 0;

    for (var element in contactList) {
      indexList.add(index++);
    }

    setState(() {
      selectedIndices = indexList;
    });
  }

  void unselectAll(BuildContext context) {
    setState(() {
      selectedIndices = [];
    });
  }

  void onDone(BuildContext context) {
    int index = 0;
    List<SimplifiedContact> tempSelected = [];

    for (var element in contactList) {
      if (selectedIndices.contains(index++)) {
        tempSelected.add(element);
      }
    }

    widget.onDone(tempSelected, selectedIndices);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    if (contactList == null) {
      return const Flexible(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Flexible(
      child: Column(
        children: [
          Flexible(
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: contactList.length,
              itemBuilder: (BuildContext context, int index) {
                SimplifiedContact contact = contactList.elementAt(index);

                return Column(
                  children: [
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 2,
                        horizontal: 18,
                      ),
                      title: Text(contact.name),
                      subtitle: Text(contact.phone),
                      trailing: ActionButton(
                        isSelected: selectedIndices.contains(index),
                        onRemove: () {
                          onContactRemove(index);
                        },
                        onSelect: () {
                          onContactSelect(index);
                        },
                      ),
                    ),
                    const Divider(
                      height: 1,
                    ),
                  ],
                );
              },
            ),
          ),
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 50),
            child: selectedIndices.length == contactList.length
                ? ElevatedButton(
                    child: const Text('Unselect All'),
                    onPressed: () {
                      unselectAll(context);
                    },
                  )
                : ElevatedButton(
                    child: const Text('Select All'),
                    onPressed: () {
                      selectAll(context);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
