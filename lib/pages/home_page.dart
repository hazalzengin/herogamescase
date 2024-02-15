import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:herogamescase/services/auth/auth_services.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _displayNameController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _biographyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

    final authService = Provider.of<AuthService>(context, listen: false);
    final currentUser = authService.currentUser;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'HeroGames',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
        ),
        body: TabBarView(
          children: [
            // Home Page
            ListView(
              padding: EdgeInsets.all(16),
              children: [
                Card(
                  elevation: 5,
                  child: ListTile(
                    title: Text(
                      'Home Page',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 8),

                        // Fetch user data
                        FutureBuilder<DocumentSnapshot>(
                          future: _firebaseFirestore.collection('users').doc(currentUser?.uid).get(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return Text(
                                'Loading user data...',
                                style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                ),
                              );
                            } else if (snapshot.hasError) {
                              return Text(
                                'Error loading user data',
                                style: TextStyle(
                                  color: Colors.red,
                                ),
                              );
                            } else {
                              Map<String, dynamic> userData = snapshot.data!.data() as Map<String, dynamic>;

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Name: ${userData['displayName'] ?? 'N/A'}',
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    'Email: ${currentUser?.email ?? 'N/A'}',
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    'Birth Date: ${userData['birthDate'] ?? 'N/A'}',
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    'Biography: ${userData['biography'] ?? 'N/A'}',
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  ElevatedButton(
                                    onPressed: () {
                                      _showAddHobbyDialog();
                                    },
                                    child: Text('Add Hobby'),
                                  ),
                                ],
                              );
                            }
                          },
                        ),
                        FutureBuilder<DocumentSnapshot>(
                          future: _firebaseFirestore.collection('hobbies').doc(currentUser?.uid).get(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return Text(
                                'Loading hobbies data...',
                                style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                ),
                              );
                            } else if (snapshot.hasError) {
                              return Text(
                                'Error loading hobbies data',
                                style: TextStyle(
                                  color: Colors.red,
                                ),
                              );
                            } else {
                              Map<String, dynamic>? hobbiesData = snapshot.data?.data() as Map<String, dynamic>?;

                              if (hobbiesData != null && hobbiesData.containsKey('hobbies')) {
                                List<dynamic>? hobbies = hobbiesData['hobbies'];

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 16),
                                    Text(
                                      'Hobbies:',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green,
                                      ),
                                    ),
                                    if (hobbies != null && hobbies.isNotEmpty) ...{
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: hobbies.map((hobby) => Text('- $hobby')).toList(),
                                      ),
                                    } else
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'No hobbies',
                                            style: TextStyle(
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                  ],
                                );
                              } else {
                                return Text(
                                  'No hobbies data available',
                                  style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                  ),
                                );
                              }
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                // Add other widgets for the home page content here
              ],
            ),
            // Profile Page
            FutureBuilder<DocumentSnapshot>(
              future: _firebaseFirestore.collection('users').doc(currentUser?.uid).get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error loading user data',
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  );
                } else {
                  Map<String, dynamic> userData = snapshot.data!.data() as Map<String, dynamic>;
                  _displayNameController.text = userData['displayName'] ?? '';
                  _birthDateController.text = userData['birthDate'] ?? '';
                  _biographyController.text = userData['biography'] ?? '';

                  return Card(
                    elevation: 5,
                    margin: EdgeInsets.all(16),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.account_circle,
                            size: 80,
                            color: Colors.blue,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'User Information',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                          SizedBox(height: 8),
                          TextField(
                            controller: _displayNameController,
                            decoration: InputDecoration(
                              labelText: 'Display Name',
                              labelStyle: TextStyle(
                                color: Colors.blue,
                              ),
                            ),
                          ),
                          TextField(
                            controller: _birthDateController,
                            decoration: InputDecoration(
                              labelText: 'Birth Date',
                              labelStyle: TextStyle(
                                color: Colors.blue,
                              ),
                            ),
                          ),
                          TextField(
                            controller: _biographyController,
                            decoration: InputDecoration(
                              labelText: 'Biography',
                              labelStyle: TextStyle(
                                color: Colors.blue,
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              _updateUserProfile(currentUser?.uid);
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Colors.grey,
                            ),
                            child: Text('Update Profile'),
                          ),
                        ],
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          child: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.home)),
              Tab(icon: Icon(Icons.account_circle)),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _updateUserProfile(String? uid) async {
    final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

    try {
      final DocumentSnapshot userDataSnapshot = await _firebaseFirestore.collection('users').doc(uid).get();
      final Map<String, dynamic>? userData = userDataSnapshot.data() as Map<String, dynamic>?;

      if (userData != null) {
        await _firebaseFirestore.collection('users').doc(uid).update({
          'birthDate': _birthDateController.text.isNotEmpty ? _birthDateController.text : userData['birthDate'],
          'biography': _biographyController.text.isNotEmpty ? _biographyController.text : userData['biography'],
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Profile updated successfully',
              style: TextStyle(
                color: Colors.green,
              ),
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'User data not found',
              style: TextStyle(
                color: Colors.red,
              ),
            ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error updating profile: $e',
            style: TextStyle(
              color: Colors.red,
            ),
          ),
        ),
      );
    }
  }

  Future<void> _addHobby(String hobby) async {
    final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
    final currentUser = FirebaseAuth.instance.currentUser;

    try {
      await _firebaseFirestore.collection('hobbies').doc(currentUser?.uid).set({
        'hobbies': FieldValue.arrayUnion([hobby]),
      }, SetOptions(merge: true));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Hobby added successfully',
            style: TextStyle(
              color: Colors.green,
            ),
          ),
        ),
      );

      // Refresh the state to reflect the changes
      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error adding hobby: $e',
            style: TextStyle(
              color: Colors.red,
            ),
          ),
        ),
      );
    }
  }

  Future<void> _showAddHobbyDialog() async {
    String hobby = '';

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Add Hobby',
            style: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: TextField(
            onChanged: (value) {
              hobby = value;
            },
            decoration: InputDecoration(
              labelText: 'Enter your hobby',
              labelStyle: TextStyle(
                color: Colors.blue,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                _addHobby(hobby);
                Navigator.pop(context);
              },
              child: Text(
                'Add',
                style: TextStyle(
                  color: Colors.green,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    _birthDateController.dispose();
    _biographyController.dispose();
    super.dispose();
  }
}
