import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../helper/fs_helper.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: Text("VOTING ANALYSIS"),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed('votes_added');
              },
              icon: Icon(Icons.add))
        ],
      ),
      body: Column(
        children: [
          Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Container(
                  padding: EdgeInsets.all(20),
                  color: Colors.orange.shade200,
                  child: StreamBuilder(
                    stream: FsHelper.fsHelper.attachmyData(VoterName: "myData"),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(
                          child: Text(
                            "ERROR :${snapshot.error}",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        );
                      } else if (snapshot.hasData) {
                        QuerySnapshot? qSnapshot =
                            snapshot.data as QuerySnapshot<Object?>?;
                        List<QueryDocumentSnapshot> documents = qSnapshot!.docs;
                        List<Map<String, dynamic>> myData = [];
                        for (int i = 0; i < documents.length; i++) {
                          myData
                              .add(documents[i].data() as Map<String, dynamic>);
                        }

                        return ListView.builder(
                          itemCount: myData.length,
                          itemBuilder: (context, i) {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: Card(
                                elevation: 3,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(30),
                                  child: ListTile(
                                      title: Text(
                                    "ID : ${myData[i]['voting Id']}",
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold),
                                  )),
                                ),
                              ),
                            );
                          },
                        );
                      }

                      return Center(child: CircularProgressIndicator());
                    },
                  ),
                ),
              )),
          Expanded(
            child: StreamBuilder(
              stream: FsHelper.fsHelper.attachmyData(VoterName: "myData"),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                      child: Text(
                    "ERROR : ${snapshot.error}",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ));
                } else if (snapshot.hasData) {
                  QuerySnapshot? qSnapshot =
                      snapshot.data as QuerySnapshot<Object?>?;

                  List<QueryDocumentSnapshot> documents = qSnapshot!.docs;
                  List<Map<dynamic, dynamic>> Data = [];
                  List PartyName = [];

                  for (int i = 0; i < documents.length; i++) {
                    Data.add(documents[i].data() as Map<String, dynamic>);
                  }
                  for (int i = 0; i < documents.length; i++) {
                    PartyName.add(documents[i].id);
                  }
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: double.infinity,
                      color: Colors.orange.shade200,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "TOTAL VOTES: ${Data[6]['counter']}",
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 7),
                          Text(
                            "BJP : ${Data[0]['counter']}",
                            style: TextStyle(fontSize: 25),
                          ),
                          SizedBox(height: 7),
                          Text(
                            "SP: ${Data[1]['counter']}",
                            style: TextStyle(fontSize: 25),
                          ),
                          SizedBox(height: 7),
                          Text(
                            "AAP: ${Data[3]['counter']}",
                            style: TextStyle(fontSize: 25),
                          ),
                          SizedBox(height: 7),
                          Text(
                            "NCP: ${Data[4]['counter']}",
                            style: TextStyle(fontSize: 25),
                          ),
                          SizedBox(height: 5),
                        ],
                      ),
                    ),
                  );
                }
                return Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ],
      ),
    );
  }
}
