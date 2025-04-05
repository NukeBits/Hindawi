import 'package:flutter/material.dart';










class EmptyDataBaseMessage extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
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
