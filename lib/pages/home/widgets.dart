import 'package:flutter/material.dart';





class UpdateReportWidget extends StatelessWidget {
  final Map<String,int>? updateReport;
  UpdateReportWidget({required this.updateReport,super.key});

  @override
  Widget build(BuildContext context) {
    if(updateReport==null)return Container(); // if the Map was not loaded yet. return an empty widget.
    final total = updateReport!["pages"]! + updateReport!["new-books"]!*2;

    return Center(
      child: Column(
        mainAxisSize:MainAxisSize.min,
        children: [
          SizedBox(width:100, child: _genPrgBar()),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [

              _buildClmn(['${updateReport!["new-books"]}','${total}','${updateReport!["pages"]}'], alignment: CrossAxisAlignment.start),
              _buildClmn([":", ":", ":"]),
              //           new books | total reqests  | html pages
              _buildClmn(['كتب جديدة','إجمالي الطلبات','الصفحات'], alignment:CrossAxisAlignment.end),
            ],
          )
        ]
      ),
    );
  }
  

  Column _buildClmn(Iterable<String> items, {CrossAxisAlignment? alignment}){
    return Column(
      crossAxisAlignment: alignment??CrossAxisAlignment.center,
      children: items.map((txt) => Text(txt)).toList(),
    );
  }



  Widget _genPrgBar(){
    return LinearProgressIndicator(
      value:(updateReport!['books']==0)?0:updateReport!['loaded-books']!/updateReport!['books']!,
      valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
      backgroundColor: Colors.grey,
    );
  }
                
  
}





class EmptyDataBaseMessage extends StatelessWidget {
  final Function action;

  
  EmptyDataBaseMessage({required this.action ,super.key});


  @override
  Widget build(BuildContext context) {
    return Center(
	    child: Column(
	      mainAxisSize: MainAxisSize.min,
	      children: [
	        const Text(
	          "try to fetch new books", 
	          style: TextStyle(
	            color: Colors.grey,
	          ),
	        ),
	        ElevatedButton(
	          onPressed: (){action();},
	          child    : Text("fetch"),
	        ),
	      ],
	    )
	  );
  }
}
