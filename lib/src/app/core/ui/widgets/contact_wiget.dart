import 'package:flutter/material.dart';
    
class ContactWiget extends StatelessWidget {

  const ContactWiget({ super.key });
  
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Column(
        spacing: 10,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: Colors.amber,
              foregroundColor:  Colors.amber, 
              radius: 30,
              backgroundImage: NetworkImage('https://images.pexels.com/photos/33646930/pexels-photo-33646930.jpeg'),
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
          Center(child: Text('Nome'),)
      
      
        ],
      ),
    );
  }
}