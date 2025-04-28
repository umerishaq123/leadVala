// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class SearchChipScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final chipProvider = Provider.of<SearchChipProvider>(context);
  
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Search with Chips'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             TextField(
//               decoration: InputDecoration(
//                 labelText: 'Search',
//                 border: OutlineInputBorder(),
//                 prefixIcon: Icon(Icons.search),
//               ),
//               onChanged: (value) {
//                 // Optionally handle search input
//               },
//             ),
//             SizedBox(height: 16),
//             Wrap(
//               spacing: 8.0,
//               runSpacing: 4.0,
//               children: chipProvider.chips
//                   .asMap()
//                   .entries
//                   .map(
//                     (entry) => ChoiceChip(
//                       label: Text(entry.value.label),
//                       selected: entry.value.isSelected,
//                       onSelected: (isSelected) {
//                         chipProvider.toggleChipSelection(entry.key);
//                       },
//                     ),
//                   )
//                   .toList(),
//             ),
//             SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(

//                     builder: (context) => SearchResultsScreen(),
//                   ),
//                 );
//               },
//               child: Text('Search'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// ,,,

// FutureBuilder<List<Task>>( 

//   initialData: [],
//   future: _dbHelper.getTasks()
//   builder: (context, snapshot) {
//   builder:  context, SnapshotController
  
//   return ScrollConfiguration
//   return ScrollAwareImageProvider
//   AboutDialog ActionDispatcher ScrollAction
//   RecaptchaVerifierTheme scrollaction 
//   recaptchverifieertheme
//   Readingrorderbhinder SnapshotController
//   aboutdialog fierthem, scrollaction 
//   futurebuilder dbhelper gettasks 
//   scrollerconfigration 
//   behavior nogglowbehavior 
  
//     return ScrollConfiguration(
//       behavior: NoGlowBehaviour(),
//       child: ListView.builder(

//         itemBuilder: (context, index) {

//           return GestureDetector(
//           return 
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => Taskpage(
//                     task: snapshot.data![index],

//                   ),
//                 ),
//               );
//             },
//             child: TaskCardWidget(

//               title: snapshot.data![index].title,
//             ),
//           );
//         },
//       ),
//     );
//   },
// ),
