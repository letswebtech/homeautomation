// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flash_chat/constants.dart';

// import 'package:firebase_auth/firebase_auth.dart';

// final _firestore = FirebaseFirestore.instance;
// String loginUserEmail;

// class ChatScreen extends StatefulWidget {
//   static const routeName = '/chat';

//   @override
//   _ChatScreenState createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
//   final messageTextController = TextEditingController();

//   final _auth = FirebaseAuth.instance;
//   String messageText;
//   String senderEmail;

//   @override
//   void initState() {
//     super.initState();
//     getCurrentUser();
//   }

//   void getCurrentUser() {
//     try {
//       final user = _auth.currentUser;
//       if (user != null) {
//         senderEmail = user.email;
//         loginUserEmail = senderEmail;
//       }
//     } catch (e) {
//       print(e);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: null,
//         actions: <Widget>[
//           IconButton(
//               icon: Icon(Icons.close),
//               onPressed: () {
//                 _auth.signOut();
//                 Navigator.pop(context);
//               }),
//         ],
//         title: Text('⚡️Chat'),
//         backgroundColor: Colors.lightBlueAccent,
//       ),
//       body: SafeArea(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: <Widget>[
//             MessageStream(),
//             Container(
//               decoration: kMessageContainerDecoration,
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: <Widget>[
//                   Expanded(
//                     child: TextField(
//                       onChanged: (value) {
//                         messageText = value;
//                       },
//                       controller: messageTextController,
//                       decoration: kMessageTextFieldDecoration,
//                     ),
//                   ),
//                   FlatButton(
//                     onPressed: () {
//                       messageTextController.clear();
//                       try {
//                         _firestore
//                             .collection('messages')
//                             .add({'text': messageText, 'sender': senderEmail});
//                       } catch (e) {
//                         print(e);
//                       }
//                     },
//                     child: Text(
//                       'Send',
//                       style: kSendButtonTextStyle,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class MessageStream extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<QuerySnapshot>(
//       stream: _firestore.collection('messages').snapshots(),
//       builder: (context, snapshot) {
//         if (!snapshot.hasData) {
//           return Center(
//               child: CircularProgressIndicator(
//             backgroundColor: Colors.lightBlueAccent,
//           ));
//         }
//         final messages = snapshot.data.docs.reversed;
//         List<Widget> messageBubbles = [];
//         for (var message in messages) {
//           final messageText = message.data()['text'];
//           final messageSender = message.data()['sender'];
//           final isMe = messageSender == loginUserEmail;
//           final messageBubble = MessageBubble(
//               text: messageText, sender: messageSender, isMe: isMe);

//           messageBubbles.add(messageBubble);
//         }
//         return Expanded(
//           child: ListView(
//             padding: EdgeInsets.symmetric(horizontal: 1.0, vertical: 20.0),
//             children: messageBubbles,
//           ),
//         );
//       },
//     );
//   }
// }

// class MessageBubble extends StatelessWidget {
//   final String sender;
//   final String text;
//   final bool isMe;

//   MessageBubble({@required this.text, @required this.sender, this.isMe});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.all(10.0),
//       child: Column(
//         crossAxisAlignment:
//             isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
//         children: [
//           Text('$sender',
//               style: TextStyle(color: Colors.black54, fontSize: 10.0)),
//           Material(
//             borderRadius: isMe ? BorderRadius.only(
//               topLeft: Radius.circular(30.0),
//               bottomLeft: Radius.circular(30.0),
//               bottomRight: Radius.circular(30.0),
//             ) : BorderRadius.only(
//               topRight: Radius.circular(30.0),
//               bottomLeft: Radius.circular(30.0),
//               bottomRight: Radius.circular(30.0),
//             ),
//             elevation: 5.0,
//             color: isMe ? Colors.lightBlueAccent : Colors.white,
//             child: Padding(
//               padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
//               child: Text(
//                 '$text',
//                 style: TextStyle(
//                   fontSize: 15.0,
//                   color: isMe ? Colors.white: Colors.black54
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
