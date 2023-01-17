import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../helper/fs_helper.dart';

class VotesAdded extends StatefulWidget {
  const VotesAdded({Key? key}) : super(key: key);

  @override
  State<VotesAdded> createState() => _VotesAddedState();
}

dynamic value;
final TextEditingController VoterController = TextEditingController();
final TextEditingController VoterIdController = TextEditingController();
final GlobalKey<FormState> controller = GlobalKey<FormState>();

List myList = [
  {
    "name": "BJP",
    "image":
        "https://seeklogo.com/images/B/BJP-logo-C3CCCD3D69-seeklogo.com.png",
  },
  {
    "name": "SP",
    "image":
        "https://cdn.shopify.com/s/files/1/1284/2827/products/P_1_1024x1024.png?v=1553153979",
  },
  {
    "name": "AAP",
    "image":
        "https://upload.wikimedia.org/wikipedia/commons/8/88/Aam_Aadmi_Party_%28AAP%29_Logo_New.png",
  },
  {
    "name": "NCP",
    "image":
        "https://upload.wikimedia.org/wikipedia/commons/thumb/0/0e/Clock_symbol_of_NCP.png/2048px-Clock_symbol_of_NCP.png",
  },
];

class _VotesAddedState extends State<VotesAdded> {
  @override
  void initState() {
    super.initState();
    VoterController.clear();
    VoterIdController.clear();
    value = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.deepOrange,
          title: Text("ADDED VOTES"),
          centerTitle: true),
      body: SingleChildScrollView(
        child: StreamBuilder(
            stream: FsHelper.fsHelper.attachC(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text("Error : ${snapshot.error}"));
              } else if (snapshot.hasData) {
                QuerySnapshot? qSnapshot =
                    snapshot.data as QuerySnapshot<Object?>?;

                List<QueryDocumentSnapshot> documents = qSnapshot!.docs;
                List<Map<dynamic, dynamic>> MyData = [];
                List VotersName = [];

                for (int i = 0; i < documents.length; i++) {
                  MyData.add(documents[i].data() as Map<String, dynamic>);
                }
                for (int i = 0; i < documents.length; i++) {
                  VotersName.add(documents[i].id);
                }

                int count = ++MyData[6]['counter'];
                return StreamBuilder(
                    stream: FsHelper.fsHelper.attachmyData(VoterName: "myData"),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(
                          child: Text("ERROR :${snapshot.error}"),
                        );
                      } else if (snapshot.hasData) {
                        QuerySnapshot? qSnapshot =
                            snapshot.data as QuerySnapshot<Object?>?;
                        List<QueryDocumentSnapshot> nextDocs = qSnapshot!.docs;
                        List<Map<String, dynamic>> nextdata = [];
                        for (int i = 0; i < nextDocs.length; i++) {
                          nextdata
                              .add(nextDocs[i].data() as Map<String, dynamic>);
                        }

                        return Padding(
                          padding: const EdgeInsets.all(10),
                          child: Form(
                            key: controller,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(height: 70),
                                Text(
                                  "ID :${count}",
                                  style: TextStyle(fontSize: 20),
                                ),
                                SizedBox(height: 20),
                                TextFormField(
                                    controller: VoterController,
                                    validator: (val) {
                                      if (val!.isEmpty) {
                                        return "Enter Valid Name";
                                      }

                                      return null;
                                    },
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        label: Text("Your Name"),
                                        hintText: "Enter Your Name")),
                                SizedBox(height: 30),
                                TextFormField(
                                    controller: VoterIdController,
                                    validator: (val) {
                                      if (val!.isEmpty) {
                                        return "Enter Valid ID";
                                      }
                                      if (val.length <= 9) {
                                        return "Enter Valid Id";
                                      }
                                      return null;
                                    },
                                    maxLength: 10,
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        label: Text("Your Voter Id"),
                                        hintText: "Enter Your Voting Id")),
                                SizedBox(height: 70),
                                Row(
                                  children: [
                                    Text(
                                      "PARTY NAME",
                                      style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    DropdownButtonHideUnderline(
                                      child: DropdownButton<dynamic>(
                                        value: value,
                                        items: myList
                                            .map((e) => DropdownMenuItem(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          Center(
                                                              child: Text(
                                                                  "  ${e['name']}\n")),
                                                          SizedBox(width: 20),
                                                          Image.network(
                                                            e['image'],
                                                            height: 40,
                                                          )
                                                        ]),
                                                  ),
                                                  value: "${e['name']}",
                                                ))
                                            .toList(),
                                        onChanged: (val) {
                                          setState(() {
                                            value = val;
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 60),
                                ElevatedButton(
                                    onPressed: () {
                                      int b = nextdata.length;
                                      b = --b;
                                      if (controller.currentState!.validate()) {
                                        if (value != null) {
                                          for (int i = 0;
                                              i < nextdata.length;
                                              i++) {
                                            if (nextdata[i]['voting Id'] ==
                                                VoterIdController.text
                                                    .toUpperCase()) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                content: Text("REPEATED ID"),
                                                backgroundColor:
                                                    Colors.redAccent,
                                                behavior:
                                                    SnackBarBehavior.floating,
                                              ));
                                              b = ++b;
                                            } else {
                                              if (b == i) {
                                                Map<String, dynamic> data = {
                                                  "id": MyData[6]['counter'],
                                                  "VoterName":
                                                      VoterController.text,
                                                  "VoterId": VoterIdController
                                                      .text
                                                      .toUpperCase(),
                                                  "Party name":
                                                      value.toString(),
                                                };
                                                Map<String, dynamic> data2 = {
                                                  "counter": MyData[6]
                                                      ['counter']
                                                };
                                                for (int i = 0;
                                                    i < documents.length;
                                                    i++) {
                                                  if (value.toString() ==
                                                      documents[i].id) {
                                                    Map<String, dynamic> data3 =
                                                        {
                                                      "counter": ++MyData[i]
                                                          ['counter']
                                                    };
                                                    FsHelper.fsHelper.NewlyCT(
                                                        myData: data3,
                                                        VoterName:
                                                            "${documents[i].id}");
                                                  } else {}
                                                }

                                                FsHelper.fsHelper.addingmyData(
                                                    VoterName: "myData",
                                                    myData: data);

                                                FsHelper.fsHelper.NewlyCT(
                                                    myData: data2,
                                                    VoterName: "total");
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                  content: Text(
                                                      "VOTED SUCCESSFULLY"),
                                                  backgroundColor: Colors.green,
                                                  behavior:
                                                      SnackBarBehavior.floating,
                                                ));
                                                Navigator.of(context)
                                                    .pushNamedAndRemoveUntil(
                                                  '/',
                                                  (route) => false,
                                                );
                                              }
                                            }
                                          }
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            content: Text(
                                                "PARTY NAME IS NOT SELECTED"),
                                            backgroundColor: Colors.redAccent,
                                            behavior: SnackBarBehavior.floating,
                                          ));
                                        }
                                      }
                                    },
                                    child: Text(
                                      "VOTE",
                                      style: TextStyle(fontSize: 25),
                                    ))
                              ],
                            ),
                          ),
                        );
                      }
                      return Center(child: CircularProgressIndicator());
                    });
              }
              return Center(child: CircularProgressIndicator());
            }),
      ),
    );
  }
}
