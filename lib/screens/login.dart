import 'package:flutter/material.dart';
import '../helper/auth_helper.dart';
import '../../global.dart';
import 'package:get/get.dart';
import '../helper/fs_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> signUpFormKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController signUpEmailController = TextEditingController();
  final TextEditingController signUpPasswordController =
  TextEditingController();

  String? email;
  String? password;

  String? name;
  String? age;
  String? signUpEmail;
  String? signUpPassword;

  bool isObscureText = true;
  bool isExistingAccount = true;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: height,
          width: width,
          child: Stack(
            alignment: Alignment.bottomCenter, //const Alignment(0, 0.2),
            children: [
              Column(
                children: [
                      SizedBox(height: 80,),
                     Container(
                      height: height * 0.3,
                      width: width,
                      color: Colors.orange,
                      alignment: Alignment.center,
                      child: Text(
                        "VOTING APP",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                 SizedBox(height: 185,),
                 Container(
                      height: height * 0.3,
                      width: width,
                      color: Colors.green,
                    ),

                ],
              ),
              (isExistingAccount)
                  ? Container(
                height: height * 0.65,
                child: Column(
                  children: [
                    Form(
                      key: loginFormKey,
                      child: Container(
                        width: width * 0.90,
                        height: height * 0.44,
                        padding:
                        const EdgeInsets.symmetric(horizontal: 16),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          // color: Colors.white.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextFormField(
                              controller: emailController,
                              validator: (val) => (val!.isEmpty)
                                  ? "Please enter email...."
                                  : null,
                              onSaved: (val) {
                                setState(() {
                                  email = val;
                                });
                              },
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "Email",
                                suffixIcon: Icon(Icons.person),
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: passwordController,
                              validator: (val) => (val!.isEmpty)
                                  ? "Please enter password...."
                                  : null,
                              onSaved: (val) {
                                setState(() {
                                  password = val;
                                });
                              },
                              obscureText: isObscureText,
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                labelText: "Password",
                                suffixIcon: InkWell(
                                  onTap: () {
                                    setState(() {
                                      isObscureText = !isObscureText;
                                    });
                                  },
                                  child: (isObscureText)
                                      ? const Icon(Icons.visibility_off)
                                      : const Icon(Icons.visibility),
                                ),
                              ),
                            ),
                            const SizedBox(height: 28),
                            Container(
                              height: 50,
                              width: MediaQuery.of(context).size.width *
                                  0.80,
                              child: ElevatedButton(
                                onPressed: () async {
                                  if (loginFormKey.currentState!
                                      .validate()) {
                                    loginFormKey.currentState!.save();

                                    await FirestoreHelper
                                        .firebaseFirestore
                                        .collection('users')
                                        .doc(email!)
                                        .snapshots()
                                        .forEach((element) async {
                                      Global.currentUser = {
                                        'name': element.data()?['name'],
                                        'email': element.data()?['email'],
                                        'password':
                                        element.data()?['password'],
                                        'age': element.data()?['age'],
                                        'hasVoted':
                                        element.data()?['hasVoted'],
                                      };
                                      print(Global.currentUser);

                                      User? user =
                                      await FirebaseAuthHelper
                                          .firebaseAuthHelper
                                          .signInWithEmailAndPassword(
                                          email: email!,
                                          password: password!);

                                      if (user != null) {
                                        Get.offNamedUntil(
                                            '/', (route) => false);
                                      }
                                    });
                                  }
                                },
                                child: Text(
                                  "Sign In",
                                  style:
                                  TextStyle(fontSize: 18),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      height: 55,
                      width: width * 0.92,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.blueGrey),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              height: 52,
                              width: width * 0.45,
                              child: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      isExistingAccount = true;
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    // primary: (isExistingAccount)
                                    //     ? Colors.white
                                    //     : Colors.blue,

                                    textStyle: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  child: const Text("Current"))),
                          Container(
                              height: 52,
                              width: width * 0.45,
                              child: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      isExistingAccount = false;
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    // primary: (isExistingAccount)
                                    //     ? Colors.blue
                                    //     : Colors.white,

                                    textStyle: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  child: const Text("New"))),
                        ],
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ) //SignIn
                  : Container(
                height: height * 0.65,
                child: Column(
                  children: [
                    Form(
                      key: signUpFormKey,
                      child: Container(
                        width: width * 0.90,
                        height: height * 0.51,
                        padding:
                        const EdgeInsets.symmetric(horizontal: 16),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            TextFormField(
                                controller: nameController,
                                onSaved: (val) {
                                  setState(() {
                                    name = val;
                                  });
                                },
                                validator: (val) => (val!.isEmpty)
                                    ? "Please enter name"
                                    : null,
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: "Name")),
                            const SizedBox(height: 14),
                            TextFormField(
                                controller: ageController,
                                onSaved: (val) {
                                  setState(() {
                                    age = val;
                                  });
                                },
                                keyboardType: TextInputType.number,
                                validator: (val) => (val!.isEmpty)
                                    ? "Please enter your age"
                                    : (int.parse(val) <= 18)
                                    ? "Your age must be greater than 18"
                                    : null,
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: "Age")),
                            const SizedBox(height: 14),
                            TextFormField(
                                controller: signUpEmailController,
                                onSaved: (val) {
                                  setState(() {
                                    signUpEmail = val;
                                  });
                                },
                                validator: (val) => (val!.isEmpty)
                                    ? "Please enter email..."
                                    : null,
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: "Email")),
                            const SizedBox(height: 14),
                            TextFormField(
                                obscureText: isObscureText,
                                controller: signUpPasswordController,
                                onSaved: (val) {
                                  setState(() {
                                    signUpPassword = val;
                                  });
                                },
                                validator: (val) => (val!.isEmpty)
                                    ? "Please enter your password..."
                                    : (val.length < 6)
                                    ? "Password must be greater than 6 chars..."
                                    : null,
                                decoration: InputDecoration(
                                    border: const OutlineInputBorder(),
                                    suffixIcon: InkWell(
                                      onTap: () {
                                        setState(() {
                                          isObscureText = !isObscureText;
                                        });
                                      },
                                      child: (isObscureText)
                                          ? const Icon(
                                          Icons.visibility_off)
                                          : const Icon(Icons.visibility),
                                    ),
                                    labelText: "Password")),
                            const SizedBox(height: 22),
                            Container(
                              height: 50,
                              width: MediaQuery.of(context).size.width *
                                  0.80,
                              child: ElevatedButton(
                                onPressed: () async {
                                  if (signUpFormKey.currentState!
                                      .validate()) {
                                    signUpFormKey.currentState!.save();

                                    User? user = await FirebaseAuthHelper
                                        .firebaseAuthHelper
                                        .signUp(
                                        email: signUpEmail!,
                                        password: signUpPassword!);

                                    await FirestoreHelper.firestoreHelper
                                        .insertRecord(
                                        id: signUpEmail!,
                                        name: name!,
                                        email: signUpEmail!,
                                        age: int.parse(age!),
                                        password: signUpPassword!);

                                    if (user != null) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              "New User registered successfully..."),
                                          backgroundColor: Colors.green,
                                          behavior:
                                          SnackBarBehavior.floating,
                                        ),
                                      );
                                    }

                                    nameController.clear();
                                    ageController.clear();
                                    signUpEmailController.clear();
                                    signUpPasswordController.clear();

                                    setState(() {
                                      name = null;
                                      age = null;
                                      signUpEmail = null;
                                      signUpPassword = null;
                                    });
                                  }
                                },
                                child: Text(
                                  "Sign Up",
                                  style:
                                  TextStyle(fontSize: 18),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      height: 55,
                      width: width * 0.92,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.blueGrey),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              height: 52,
                              width: width * 0.45,
                              child: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      isExistingAccount = true;
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: (isExistingAccount)
                                        ? Colors.white
                                        : Colors.blue,

                                    textStyle: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  child: const Text("Existing"))),
                          Container(
                              height: 52,
                              width: width * 0.45,
                              child: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      isExistingAccount = false;
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: (isExistingAccount)
                                        ? Colors.blue
                                        : Colors.white,

                                    textStyle: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  child: const Text("New"))),
                        ],
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ), //SignUp
            ],
          ),
        ),
      ),
    );
  }
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.moveTo(0, size.height * 0.90);
    path.quadraticBezierTo(size.width * 0.20, size.height * 0.45,
        size.width * 0.5, size.height * 0.60);
    path.quadraticBezierTo(
        size.width * 0.70, size.height * 0.70, size.width, size.height * 0.25);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

class MyClipper2 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.moveTo(0, size.height * 0.75);
    path.quadraticBezierTo(size.width * 0.25, size.height * 0.40,
        size.width * 0.5, size.height * 0.55);
    path.quadraticBezierTo(
        size.width * 0.80, size.height * 0.75, size.width, size.height * 0.35);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}