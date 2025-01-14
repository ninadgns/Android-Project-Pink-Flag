import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '/widgets/LibraryScreen/LibraryCollections.dart';
import '/widgets/LibraryScreen/LibrarySaved.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  // State variable for the button
  bool isCollectionsSelected = false; // Default to Collections

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.03),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Your Library',
                style: Theme.of(context).textTheme.displayMedium,
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  CupertinoIcons.search,
                  size: 30,
                ),
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
          const SizedBox(height: 20),
          Expanded(
            child: Center(
              child:
                  isCollectionsSelected ? const LibraryCollections() : const LibrarySaved(),
            ),
          ),
        ],
      ),
    );
  }
}
