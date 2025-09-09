import 'dart:developer';

import 'package:flutter/material.dart';
    
class StoryContactWiget extends StatelessWidget {
   final String name ;
   final String urlImage;
   final VoidCallback onTap;
  const StoryContactWiget({ super.key, required this.name, required this.urlImage, required this.onTap });
  
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
         log("STORY teste");
         onTap();
      } ,
      child: Column(
        spacing: 10,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: Colors.amber,
              foregroundColor:  Colors.amber, 
              radius: 30,
              backgroundImage: NetworkImage(urlImage),
              child: SizedBox( 
                height: 85,
                width: 85,
                child: CircularProgressIndicator(
                  value: 1,
                  strokeWidth: 5,
                  color: Colors.amberAccent,
                )),
            ),
          ),
          Center(child: Text(name),)
        ],
      ),
    );
  }
}