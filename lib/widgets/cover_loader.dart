import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hindawi/glob.dart';
import 'package:hindawi/modules/struct.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hindawi/utils/download/process.dart';




final imageLoadingAnimation = Stack(
  children: [
    Image.asset(
      'assets/default.png',
      fit: BoxFit.cover,
      height: double.infinity,

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

  bool imgLoaded   = false;
  bool imgInQueque = false;

  @override
  Widget build(BuildContext context) {
    if (!imgInQueque && !imgLoaded) loadImage();
    return image;
  }



  void loadImage() async{

    if (!mounted) return;
    final imgFromFile = GestureDetector(
      onTap: (widget.action == null)?(){}:(){widget.action!();},
      child: SvgPicture.file(
        widget.coverFile,
        fit: BoxFit.cover,
      ),
    );


    //--------------------------------
    if (await widget.coverFile.exists()){
      imgLoaded = true;
      if (mounted) setState(() {
        image = imgFromFile;
      });
      return; 
    }
    

    if(!dm.processExists("cover${widget.book.id}"))
      dm.queCover(widget.book, widget.coverFile, imageDownloadCallBack);
    imgInQueque = true;
    

  }



  void imageDownloadCallBack(){
    final id = "cover${widget.book.id}";

    if(!dm.processExists(id))
      dm.queCover(widget.book, widget.coverFile, imageDownloadCallBack);

    DownloadProcess d = dm.getProcess(id)!;

    if(!mounted) return;
    if (d.doneWithoutErr()) loadImage();
    if (d.doneWithErr()) {
      setState(() {
        image = GestureDetector(
          onTap: (){
            setState(() {
              image = imageLoadingAnimation;
            });
            dm.queCover(widget.book, widget.coverFile, imageDownloadCallBack);
          },
          child: Stack(
            children: [
              Image.asset(
                'assets/default.png',
                fit: BoxFit.cover,
                height:double.infinity,
              ),
              Center(
                child:Icon(Icons.refresh,color:Colors.white,weight:30)
              ),
            ]
          ),
        );   
      });
    }


  }
  
}
