import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hindawi/glob.dart';
import 'package:hindawi/modules/struct.dart';
import 'package:flutter_svg/svg.dart';




final imageLoadingAnimation = Stack(
  children: [
    Image.asset(
      'assets/default.png',
      fit: BoxFit.cover,
    ),
    Center(
      child:CircularProgressIndicator(color:Colors.white)
    )
  ]
);








class CoverLoader extends StatefulWidget {
  Function? action;
  Book     book;
  late final File coverFile;


  CoverLoader({required this.book, this.action}){
    coverFile = File(documPath+"/covers/${book.id}.svg");
  }

  @override
  State<CoverLoader> createState() => _CoverLoaderState();
}

class _CoverLoaderState extends State<CoverLoader> {
  


  Widget image = imageLoadingAnimation;

  bool imageLoaded = false;


  @override
  Widget build(BuildContext context) {
    if (!imageLoaded) loadImage();
    return image;
  }



  void loadImage()async{
    if (imageLoaded) return;
    final img = GestureDetector(
      onTap: (widget.action == null)?(){}:(){widget.action!();},
      child: SvgPicture.file(
        widget.coverFile,
        fit: BoxFit.cover,
      ),
    );


    if (await widget.coverFile.exists() && mounted){

      
      setState(() {
        image = img;
      });
      imageLoaded = true;
      return; 
    }
    bool errHappend = false;
    try{

      final imgData = (await http.get(Uri.parse(widget.book.coverUrl))).bodyBytes;
      await widget.coverFile.writeAsBytes(imgData);

    } catch (e){
      errHappend = true;
    }

    
    if (!mounted) return;

    if (!errHappend) {
      setState(() {
        image = img;
      });
    }
  
    else setState(() {
      image = GestureDetector(
        onTap: (){
          setState(() {
            image = imageLoadingAnimation;
      
          });
          imageLoaded = false;
          loadImage();
        },
        child: Stack(
          children: [
            Image.asset(
              'assets/default.png',
              fit: BoxFit.cover,
            ),
            Center(
              child:Icon(Icons.refresh)
            ),
          ]
        ),
      );
    });
    imageLoaded = true;



    
  }
}
