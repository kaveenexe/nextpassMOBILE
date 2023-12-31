import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'Qrcodepage.dart';
import 'login/AuthService.dart';
class MakeTrip extends StatefulWidget {
  const MakeTrip({Key? key}) : super(key: key);

  @override
  _MakeTripState createState() => _MakeTripState();
}

class _MakeTripState extends State<MakeTrip> {
  String? selectedStartingPoint = 'Starting Point';
  String? selectedEndingPoint = 'Ending Point';
  String? qrCodeData;
  int? fee; // to store the randomly retrieved fee


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 30),
            const Text(
              "Start Your Journey!",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: 270,
              height: 180,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(
                  color: Color(0xffD4E0FF),
                  width: 2.0,
                ),
              ),
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('busholts').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Text("No data available.");
                  }

                  final busholts = snapshot.data!.docs;
                  List<String> holtNames = ['Starting Point', 'Ending Point'];

                  for (var busholt in busholts) {
                    var holtName = busholt['HoltName'] as String;
                    holtNames.add(holtName);
                  }

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      DropdownButton<String>(
                        value: selectedStartingPoint,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedStartingPoint = newValue;
                          });
                        },
                        items: holtNames.map((String holtName) {
                          return DropdownMenuItem<String>(
                            value: holtName,
                            child: Text(holtName),
                          );
                        }).toList(),
                      ),
                      DropdownButton<String>(
                        value: selectedEndingPoint,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedEndingPoint = newValue;
                          });
                        },
                        items: holtNames.map((String holtName) {
                          return DropdownMenuItem<String>(
                            value: holtName,
                            child: Text(holtName),
                          );
                        }).toList(),
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: const Color(0xff0048FF),
                onPrimary: Colors.white,
                fixedSize: const Size(245, 60),
                textStyle: const TextStyle(
                    fontSize: 20
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              onPressed: () {
                // Generate a random index to select a fee from Firestore
                int randomIndex = Random().nextInt(10); // Assuming 10 documents in 'fareSE'

                // Retrieve a random fee from Firestore
                FirebaseFirestore.instance
                    .collection('fareSE')
                    .orderBy(FieldPath.documentId)
                    .startAfter([randomIndex.toString()]) // Use the startAfter method
                    .limit(1)
                    .get()
                    .then((QuerySnapshot querySnapshot) {
                  if (querySnapshot.docs.isNotEmpty) {
                    final doc = querySnapshot.docs.first;
                    if (doc.data() is Map && (doc.data() as Map).containsKey('fee')) {
                      setState(() {
                        fee = doc['fee'] as int;
                      });
                    } else {
                      setState(() {
                        fee = null;
                      });
                    }
                  } else {
                    setState(() {
                      fee = null;
                    });
                  }
                });

              },
              child: const Text('Calculate Fee'),
            ),
            const SizedBox(height: 20),
            Text("Your fee for the trip is: $fee",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: const Color(0xff0048FF),
                onPrimary: Colors.white,
                fixedSize: const Size(245, 60),
                textStyle: const TextStyle(fontSize: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              onPressed: () {
                updateQRCode(selectedStartingPoint ?? 'Starting Point', selectedEndingPoint ?? 'Ending Point');
              },
              child: const Text('Update QR Code'),
            ),
            const SizedBox(height: 20),
            if (qrCodeData != null)
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: const Color(0xff0048FF),
                  onPrimary: Colors.white,
                  fixedSize: const Size(245, 60),
                  textStyle: const TextStyle(fontSize: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => QRCodePage(qrCodeData!),
                    ),
                  );
                },
                child: const Text('View QR Code'),
              ),
            const SizedBox(height: 20),
            const Text("Updated QR Code will be displayed here:", textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 20),
            if (qrCodeData != null)
              QrImageView(
                data: qrCodeData!,
                version: QrVersions.auto,
                size: 200.0,
              ),
          ],
        ),
      ),
    );
  }

  Future<void> updateQRCode(String startingPoint, String endingPoint) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userData = {
        "email": user.email,
        "startpoint": startingPoint,
        "endpoint": endingPoint,
        "fee": fee ?? 0,
      };

      // Update the Firestore document with the new data
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set(userData, SetOptions(merge: true));

      // Update the QR code data
      qrCodeData = "data:image/png;base64,${generateQRCode(userData.toString())}";
      setState(() {});
    }
  }

  String generateQRCode(String data) {

    return data;
  }
}
