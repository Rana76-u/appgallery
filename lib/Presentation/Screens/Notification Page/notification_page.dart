import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Page'),
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance.collection('notifications').get(),
        builder: (context, snapshot) {
          if(snapshot.hasData){
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10, top: 5),
                  child: ListTile(
                    tileColor: Colors.blue.shade400.withOpacity(0.1),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)
                    ),
                    title: Text(
                        snapshot.data!.docs[index].get('title'),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(snapshot.data!.docs[index].get('description')),
                  ),
                );
              },
            );
          }
          else if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          else {
            return const Center(
              child: Text('Error Loading Data'),
            );
          }
        },
      ),
    );
  }
}
