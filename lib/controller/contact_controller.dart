import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fast_contacts/fast_contacts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hiv/models/contact_model.dart';
import 'package:hive/hive.dart';
import 'package:permission_handler/permission_handler.dart';

class ContactController extends GetxController {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  late Box<ContactDetail> contactBox;

  final RxList<Contact> phoneContactList = <Contact>[].obs;
  final RxList firebaseContactList = [].obs;
  final RxList filterContactList = [].obs;

  // Hive List Data
  var savePhoneBookContactDetailLocal = <ContactDetail>[].obs;

  String? text;
  final List<ContactField> _fields = ContactField.values.toList();

  RxBool isLoading = false.obs;
  updateLoadingStatus(value) {
    isLoading.value = value;
  }

  @override
  void onInit() {
    super.onInit();
    openBox();
  }

  Future<void> openBox() async {
    contactBox = await Hive.openBox<ContactDetail>('contacts');
    loadContact();
  }

  void loadContact() {
    savePhoneBookContactDetailLocal.value = contactBox.values.toList();
  }

  Future<void> initializeContacts() async {
    updateLoadingStatus(true);
    try {
      await getMatchContact();
      await loadContacts();
      await compareContacts();
      updateLoadingStatus(false);
    } catch (e) {
      updateLoadingStatus(false);
    }
  }

  Future getMatchContact() async {
    try {
      var querySnapshot = await firebaseFirestore
          .collection('users')
          .where('uid', isNotEqualTo: firebaseAuth.currentUser!.uid)
          .get();

      for (var data in querySnapshot.docs) {
        var user = {
          'phone': data['phone'],
          'uid': data['uid'],
          'name': data['name'],
        };
        firebaseContactList.add(user);
      }
      if (kDebugMode) {
        print('getFirebaseContact: $firebaseContactList');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to get contact from firebase: $e');
      }
    }
  }

  Future<void> loadContacts() async {
    try {
      await Permission.contacts.request();
      updateLoadingStatus(true);

      final sw = Stopwatch()..start();
      var contactList = await FastContacts.getAllContacts(fields: _fields);

      phoneContactList.value = contactList.map((contact) {
        final cleanedPhones = contact.phones.map((phone) {
          return Phone(
            number: phone.number.replaceAll(' ', ''),
            label: phone.label,
          );
        }).toList();

        return Contact(
          id: contact.id,
          phones: cleanedPhones,
          emails: contact.emails,
          structuredName: contact.structuredName,
          organization: contact.organization,
        );
      }).toList();

      if (kDebugMode) {
        print('phoneContact: $phoneContactList');
      }
      sw.stop();
      text =
          'Contacts: ${phoneContactList.length}\nTook: ${sw.elapsedMilliseconds}ms';
    } on PlatformException catch (e) {
      updateLoadingStatus(false);
      text = 'Failed to get contacts:\n${e.details}';
    } finally {
      updateLoadingStatus(false);
    }
  }

  Future<void> compareContacts() async {
    try {
      filterContactList.clear(); // Clear previous filtered contacts

      final phoneBookBox = await Hive.openBox<ContactDetail>('contacts');

      await phoneBookBox.clear();
      if (kDebugMode) {
        print('phoneBookClear: ${await phoneBookBox.clear()}');
      }

      // Matching contacts
      final matchingContacts = phoneContactList.where((contact) {
        return contact.phones.any((phone) {
          return firebaseContactList
              .any((firebaseUser) => firebaseUser['phone'] == phone.number);
        });
      }).map((contact) {
        
        final matchingFirebaseContact = firebaseContactList.firstWhere(
          (firebaseUser) => contact.phones
              .any((phone) => firebaseUser['phone'] == phone.number),
        );

        return {
          'contact': contact, 
          'uid': matchingFirebaseContact['uid'], 
          'phone': matchingFirebaseContact['phone'], 
        };
      }).toList();

      // Non-matching contacts
      final nonMatchingContacts = phoneContactList.where((contact) {
        return !contact.phones.any((phone) {
          return firebaseContactList
              .any((firebaseUser) => firebaseUser['phone'] == phone.number);
        });
      }).toList();

      
      filterContactList.addAll(matchingContacts);

      for (var match in matchingContacts) {
        final contact = match['contact'];
        final uid = match['uid'];
        final phone = match['phone'];
        final email =
            contact.emails.isNotEmpty ? contact.emails.first.address : null;

        // Create a ContactDetail object
        final contactDetail = ContactDetail(
          uid: uid,
          phone: phone,
          displayName: contact.structuredName.displayName,
          email: email,
        );

        
        await phoneBookBox.put(uid, contactDetail);
      }

      
      if (kDebugMode) {
        print('Matching Contacts with UID: $filterContactList');
      }
      if (kDebugMode) {
        print('Non-Matching Contacts: $nonMatchingContacts');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to compare contacts: $e');
      }
    }
  }

  Future<List<ContactDetail>> getSavedContacts() async {
    final box = await Hive.openBox<ContactDetail>('contacts');
    return box.values.toList();
  }
}
