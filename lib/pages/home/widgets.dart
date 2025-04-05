import 'package:flutter/material.dart';










class EmptyDataBaseMessage extends StatelessWidget {
  final Function action;

  
  EmptyDataBaseMessage({required this.action ,super.key});


  @override
  Widget build(BuildContext context) {
    action(); // automatically starts the fetching func.
    return Center(
	    child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Fetching Books...'),
          SizedBox(height: 12),
          CircularProgressIndicator()
        ]
      )
    );
  }
}
