// import 'dart:async';
// import 'package:eva_icons_flutter/eva_icons_flutter.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:notekeep/models/note.dart';
// import 'package:notekeep/utils/database_helper.dart';
// import 'package:intl/intl.dart';
// import 'package:path_provider/path_provider.dart';

// import 'package:marquee/marquee.dart';

// class NoteDetail extends StatefulWidget {
//   final String appBarTitle;
//   final Note note;

//   NoteDetail(this.note, this.appBarTitle);

//   @override
//   State<StatefulWidget> createState() {
//     return NoteDetailState(this.note, this.appBarTitle);
//   }
// }

// class NoteDetailState extends State<NoteDetail> {
//   //static var _priorities = ['High', 'Low'];

//   DatabaseHelper helper = DatabaseHelper();

//   String appBarTitle;
//   Note note;
//   int priority;

//   Icon state = Icon(CupertinoIcons.heart);

//   int charac = 0;
//   TextEditingController titleController = TextEditingController();
//   TextEditingController descriptionController = TextEditingController();

//   DateTime now = new DateTime.now();
//   String dateTime = "";
//   void updateCharac() {
//     setState(() {
//       charac = note.description.length;
//     });
//   }

//   NoteDetailState(this.note, this.appBarTitle);

//   @override
//   Widget build(BuildContext context) {
//     TextStyle textStyle = Theme.of(context).textTheme.title;

//     titleController.text = note.title;
//     descriptionController.text = note.description;
//     priority = note.priority;

//     dateTime = DateFormat('yyyy-MM-dd').format(now);

//     //likes = note.likes;

//     return WillPopScope(
//         onWillPop: () {
//           // Write some code to control things, when user press Back navigation button in device navigationBar
//           moveToLastScreen();
//         },
//         child: Scaffold(
//           backgroundColor: Theme.of(context).primaryColor,
//           appBar: AppBar(
//             title: Text(appBarTitle),
//             leading: IconButton(
//                 icon: Icon(EvaIcons.arrowIosBack,
//                     color: Theme.of(context).accentColor),
//                 onPressed: () {
//                   // Write some code to control things, when user press back button in AppBar
//                   moveToLastScreen();
//                 }),
//             actions: <Widget>[
//               IconButton(
//                 icon: state,
//                 onPressed: () {
//                   setState(() {
//                     priority = -priority;
//                     updateIcon();
//                   });
//                   updatePriority();
//                 },
//               ),
//               IconButton(
//                 icon: Icon(
//                   EvaIcons.info,
//                   color: Theme.of(context).accentColor,
//                 ),
//                 onPressed: () {
//                   setState(() {
//                     _showAlertDialog("the me inc",
//                         "Beta Version" + "\n" + "mail me on 2019csb1071");
//                   });
//                 },
//               ),
//               IconButton(
//                 icon: Icon(EvaIcons.save, color: Theme.of(context).accentColor),
//                 onPressed: () {
//                   setState(() {
//                     debugPrint("Save button clicked");

//                     _save();
//                   });
//                 },
//               )
//             ],
//           ),
//           body: Padding(
//             padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
//             child: ListView(
//               children: <Widget>[
//                 //SLlider functionality implementation
//                 //         Slider(
//                 //   min: 0,
//                 //   max: 100,
//                 //   value: priority,
//                 //   onChanged: (value) {
//                 //     setState(() {
//                 //       priority = value;

//                 //       updatePriority();
//                 //     });
//                 //   },
//                 // ),

// //DropDownMEnu implementataion
//                 // First element
//                 // ListTile(
//                 //   title: DropdownButton(
//                 // 	    items: _priorities.map((String dropDownStringItem) {
//                 // 	    	return DropdownMenuItem<String> (
//                 // 			    value: dropDownStringItem,
//                 // 			    child: Text(dropDownStringItem),
//                 // 		    );
//                 // 	    }).toList(),

//                 // 	    style: textStyle,

//                 // 	    value: getPriorityAsString(note.priority),

//                 // 	    onChanged: (valueSelectedByUser) {
//                 // 	    	setState(() {
//                 // 	    	  debugPrint('User selected $valueSelectedByUser');
//                 // 	    	  updatePriorityAsInt(valueSelectedByUser);
//                 // 	    	});
//                 // 	    }
//                 //   ),
//                 // ),

//                 // Second Element

//                 Padding(
//                   padding: EdgeInsets.only(
//                       top: 15.0, bottom: 15.0, left: 10, right: 10),
//                   child: TextField(
//                     controller: titleController,
//                     style: textStyle,
//                     onChanged: (value) {
//                       debugPrint('Something changed in Title Text Field');
//                       updateTitle();
//                     },
//                     decoration: InputDecoration.collapsed(
//                         hintText: "Title",
//                         hintStyle: TextStyle(fontSize: 30.0)),
//                   ),
//                 ),

//                 Padding(
//                   padding: EdgeInsets.only(top: 15.0, bottom: 15.0, left: 10),
//                   child: Row(
//                     children: <Widget>[
//                       Text("$dateTime",
//                           style: TextStyle(
//                               color: Theme.of(context).accentColor,
//                               fontSize: 16)),
//                       Container(
//                           margin: EdgeInsets.only(left: 4, right: 4),
//                           width: 1,
//                           height: 10,
//                           color: Colors.grey),
//                       Text(charac.toString() + " characters",
//                           style: TextStyle(
//                               color: Theme.of(context).accentColor,
//                               fontSize: 16))
//                     ],
//                   ),
//                 ),

//                 //third elemrnt
//                 Column(
//                   children: <Widget>[
//                     Padding(
//                       padding: EdgeInsets.only(
//                           top: 12.0, bottom: 15.0, left: 10, right: 10),
//                       child: TextField(
//                           maxLines: 200,
//                           minLines: 200,
//                           controller: descriptionController,
//                           style: textStyle,
//                           onChanged: (value) {
//                             debugPrint(
//                                 'Something changed in Description Text Field');
//                             updateDescription();

//                             //note.description = value;

//                             //updateCharac();
//                           },
//                           decoration: InputDecoration.collapsed(
//                               hintText: "Your Note Here"
//                               // border: OutlineInputBorder(
//                               //     borderRadius: BorderRadius.circular(5.0)
//                               )),
//                     ),
//                   ],
//                 ),

//                 // // Fourth Element
//                 // Padding(
//                 //   padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
//                 //   child: Row(
//                 //     children: <Widget>[
//                 //     	Expanded(
//                 // 		    child: RaisedButton(
//                 // 			    color: Theme.of(context).primaryColorDark,
//                 // 			    textColor: Theme.of(context).primaryColorLight,
//                 // 			    child: Text(
//                 // 				    'Save',
//                 // 				    textScaleFactor: 1.5,
//                 // 			    ),
//                 // 			    onPressed: () {
//                 //             if (note.title!= null && note.description!=null){
//                 // 			    	setState(() {
//                 // 			    	  debugPrint("Save button clicked");
//                 // 			    	  _save();
//                 // 			    	});}
//                 //             else{
//                 //               moveToLastScreen();
//                 //             }
//                 // 			    },
//                 // 		    ),
//                 // 	    ),

//                 // 	    Container(width: 5.0,),

//                 // 	    Expanded(
//                 // 		    child: RaisedButton(
//                 // 			    color: Theme.of(context).primaryColorDark,
//                 // 			    textColor: Theme.of(context).primaryColorLight,
//                 // 			    child: Text(
//                 // 				    'Delete',
//                 // 				    textScaleFactor: 1.5,
//                 // 			    ),
//                 // 			    onPressed: () {
//                 // 				    setState(() {
//                 // 					    debugPrint("Delete button clicked");
//                 // 					    _delete();
//                 // 				    });
//                 // 			    },
//                 // 		    ),
//                 // 	    ),

//                 //     ],
//                 //   ),
//                 // ),
//               ],
//             ),
//           ),
//         ));
//   }

//   void moveToLastScreen() {
//     Navigator.pop(context, true);
//   }

//   // Convert the String priority in the form of integer before saving it to Database
//   // void updatePriorityAsInt(String value) {
//   // 	switch (value) {
//   // 		case 'High':
//   // 			note.priority = 1;
//   // 			break;
//   // 		case 'Low':
//   // 			note.priority = 2;
//   // 			break;
//   // 	}
//   // }

//   // Convert int priority to String priority and display it to user in DropDown
//   // String getPriorityAsString(int value) {
//   // 	String priority;
//   // 	switch (value) {
//   // 		case 1:
//   // 			priority = _priorities[0];  // 'High'
//   // 			break;
//   // 		case 2:
//   // 			priority = _priorities[1];  // 'Low'
//   // 			break;
//   // 	}
//   // 	return priority;
//   // }

//   // Update the title of Note object
//   void updateTitle() {
//     note.title = titleController.text;
//   }
//   // void updateDate(){
//   //   note.date = dateTime;
//   // }

//   void updatePriority() {
//     if (priority == -1 || priority == 1) {
//       note.priority = priority;
//     }
//   }

//   void updateIcon() {
//     state = priority > 0
//         ? Icon(CupertinoIcons.heart_solid, color: Colors.redAccent)
//         : Icon(CupertinoIcons.heart);
//   }

//   // Update the description of Note object
//   void updateDescription() {
//     note.description = descriptionController.text;
//   }

//   // Save data to database
//   void _save() async {
//     moveToLastScreen();

//     note.date = DateFormat.yMMMd().format(DateTime.now());
//     int result;
//     if (note.id != null) {
//       // Case 1: Update operation
//       result = await helper.updateNote(note);
//     } else {
//       // Case 2: Insert Operation
//       result = await helper.insertNote(note);
//     }

//     if (result != 0) {
//       // Success
//       _showAlertDialog('Status', 'Note Saved Successfully');
//     } else {
//       // Failure
//       _showAlertDialog('Status', 'Problem Saving Note');
//     }
//   }

//   void _delete() async {
//     moveToLastScreen();

//     // Case 1: If user is trying to delete the NEW NOTE i.e. he has come to
//     // the detail page by pressing the FAB of NoteList page.
//     if (note.id == null) {
//       _showAlertDialog('Status', 'No Note was deleted');
//       return;
//     }

//     // Case 2: User is trying to delete the old note that already has a valid ID.
//     int result = await helper.deleteNote(note.id);
//     if (result != 0) {
//       _showAlertDialog('Status', 'Note Deleted Successfully');
//     } else {
//       _showAlertDialog('Status', 'Error Occured while Deleting Note');
//     }
//   }

//   void _showAlertDialog(String title, String message) {
//     AlertDialog alertDialog = AlertDialog(
//       title: Text(title),
//       content: Text(message),
//     );
//     showDialog(context: context, builder: (_) => alertDialog);
//   }
// }
