import 'package:dim/widgets/SearchScreen/ReicipeListView.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/CollectionModel.dart';
import '/widgets/LibraryScreen/LibraryCollections.dart';
import '/widgets/LibraryScreen/LibrarySaved.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

Future<void> saveCollection(
    String userId, String collectionName, BuildContext context) async {
  try {
    final supabase = Supabase.instance.client;

    // Check if the record exists
    final response = await supabase
        .from('collections')
        .select('id')
        .eq('user_id', userId)
        .eq('collection_name', collectionName)
        .maybeSingle();
    print(response);
    if (response != null) {
      // Record exists, so show a message
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Collection with the same name already exists')));
    } else {
      // Record does not exist, so insert it
      final insertResponse = await supabase
          .from('collections')
          .insert({
            'user_id': userId,
            'collection_name': collectionName,
          })
          .select('id')
          .single();

      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text('Collection saved successfully')),
      // );
      print('****************************************');
      addCollectionItem(CollectionModelItem(
        id: insertResponse['id'],
        name: collectionName,
      ));
      print(collectionsList.value.length);
      print('Collection saved successfully');
    }
  } on Exception catch (e) {
    print('Error saving collection: $e');
  }
}

class _LibraryScreenState extends State<LibraryScreen> {
  // State variable for the button
  bool isCollectionsSelected = false; // Default to Collections
  TextEditingController controller = TextEditingController();
  bool flag = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    collectionsList.addListener(_onCollectionsListChanged);
  }

  void _onCollectionsListChanged() {
    setState(() {
      flag = !flag;
    });
  }

  @override
  void dispose() {
    collectionsList.removeListener(_onCollectionsListChanged);
    super.dispose();
  }

  void addCollection(BuildContext context, TextEditingController controller) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Theme(
          data: Theme.of(context).copyWith(
            dialogBackgroundColor: Colors.white,
          ),
          child: AlertDialog(
            title: Text('Add to Collections'),
            content: TextFormField(
              controller: controller,
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  controller.clear();
                },
                child: Text('Cancel'),
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  foregroundColor: Colors.black,
                  // backgroundColor: Colors.black,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  final userId = FirebaseAuth.instance.currentUser?.uid;
                  saveCollection(userId!, controller.text, context);
                  // addCollectionItem(CollectionModelItem(
                  //   id: '1',
                  //   name: controller.text,
                  // ));
                  controller.clear();
                  setState(() {
                    flag = !flag;
                  });
                },
                child: Text('Save'),
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.black,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Container(
      // padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.03),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your Library',
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                    if (isCollectionsSelected)
                      InkWell(
                        child: Icon(Icons.add_circle_rounded),
                        onTap: () {
                          addCollection(context, controller);
                        },
                      ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              isCollectionsSelected = false;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: isCollectionsSelected
                                  ? Colors.white
                                  : Theme.of(context).colorScheme.error,
                              borderRadius: !isCollectionsSelected
                                  ? const BorderRadius.all(Radius.circular(25))
                                  : const BorderRadius.only(
                                      bottomLeft: Radius.circular(25),
                                      topLeft: Radius.circular(25),
                                    ),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'Saved',
                              style: TextStyle(
                                color: isCollectionsSelected
                                    ? Colors.black
                                    : Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              isCollectionsSelected = true;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: isCollectionsSelected
                                  ? Theme.of(context).colorScheme.error
                                  : Colors.white,
                              borderRadius: isCollectionsSelected
                                  ? const BorderRadius.all(Radius.circular(25))
                                  : const BorderRadius.only(
                                      topRight: Radius.circular(25),
                                      bottomRight: Radius.circular(25),
                                    ),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'Collections',
                              style: TextStyle(
                                color: isCollectionsSelected
                                    ? Colors.white
                                    : Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // if (isCollectionsSelected)
          Expanded(
            child: isCollectionsSelected
                ?  LibraryCollections(
                    flag: flag,
                  )
                : const LibrarySaved(),
          ),
        ],
      ),
    );
  }
}
