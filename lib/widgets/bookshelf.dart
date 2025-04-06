import 'package:flutter/material.dart';
import 'package:hindawi/modules/struct.dart';
import 'package:hindawi/widgets/cover_loader.dart';



const double spacing = 4.6;



class BookShelf extends StatelessWidget {
  List<Book>       books;
  ScrollController? controller;

  BookShelf({
    required this.books,
    this.controller,
  });


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(spacing),
      child  : GridView.builder(
	      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
	        crossAxisCount  : 2,
	        childAspectRatio: 0.75,
	        mainAxisSpacing : spacing,
	        crossAxisSpacing: spacing,
	      ),
	      controller: controller,
	      itemCount:books.length,
	      itemBuilder: (context, index){
	        return ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: CoverLoader(book: books[index])
          );
	      },
	    )
	  );
  }
}
