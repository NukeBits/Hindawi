import 'package:flutter/material.dart';
import 'package:hindawi/modules/struct.dart';
import 'package:hindawi/widgets/cover_loader.dart';



Widget book2row(Book bk){
  return Container(
    height:150,
    padding: EdgeInsets.fromLTRB(5, 7, 5, 0),
    child  : ClipRRect(
	    borderRadius: BorderRadius.circular(17),
      child  : ColoredBox(
	    color  : Colors.green,
	      child: Row(
          mainAxisAlignment:MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
	        children: [
	          Flexible(child:_book2InfoColumn(bk)),
            SizedBox(width: 3,),
	          Flexible(
	            child:SizedBox(
                width: 107,
                child: CoverLoader(book: bk),
              ),
            )  
	          
	        ],
	      ),
	    ),
    ),
  );
}


Column _book2InfoColumn(Book bk){
  return Column(
	  crossAxisAlignment: CrossAxisAlignment.end,
    mainAxisAlignment:MainAxisAlignment.spaceAround,
	  children: [
	    Flexible(
	      child: Text(bk.title),
	    ),
      SizedBox(height: 10,),
	    _tags2Wrap(bk.tags)
	  ],
  );

}


Wrap _tags2Wrap(List<String> tags){
  return Wrap(
    spacing: 3,
    children: tags.map((tg) =>
      ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: ColoredBox(
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 3, horizontal: 10),
            child: Text(tg),
          ),
        ),
      )
    ).toList(),
  );
}
