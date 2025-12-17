import 'package:flutter/material.dart';

class StandardBottomSheetExample extends StatefulWidget {
  const StandardBottomSheetExample({Key? key}) : super(key: key);

  @override
  State<StandardBottomSheetExample> createState() =>
      _StandardBottomSheetExampleState();
}

class _StandardBottomSheetExampleState
    extends State<StandardBottomSheetExample> {
  // GlobalKey for the ScaffoldState to access showBottomSheet
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[200],
      key: _scaffoldKey, // Assign the key to the Scaffold
      appBar: AppBar(title: const Text('Standard Bottom Sheet')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return Container(
                  // Content of your bottom sheet
                  height: 200, // Example height
                  child: Center(
                    child: Text('This is a Material 3 Modal Bottom Sheet!'),
                  ),
                );
              },
            );
          },
          child: Text('Show Bottom Sheet'),
        ),
      ),
    );
  }
}
