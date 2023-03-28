// import 'package:firebase_database/ui/firebase_animated_list.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:vdo/main.dart';
// import 'package:vdo/screens/video_player.dart';
// import 'package:video_player/video_player.dart';

// class VideoList extends StatefulWidget {
//   const VideoList({super.key});

//   @override
//   State<VideoList> createState() => _VideoListState();
// }

// class _VideoListState extends State<VideoList> {
//   @override
//   Widget build(BuildContext context) {
//     String videoURL =
//         'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4';
//     return Scaffold(
//       body: SafeArea(
//           child: Column(
//         children: [
//           VideoApp(
//             videoURL: videoURL,
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: FirebaseAnimatedList(
//               query: dbReference.child("vdos"),
//               physics: const NeverScrollableScrollPhysics(),
//               shrinkWrap: true,
//               sort: (b, a) {
//                 return a.key.toString().compareTo(b.key.toString());
//               },
//               defaultChild: const Center(
//                 child: CircularProgressIndicator(
//                   color: Colors.blue,
//                 ),
//               ),
//               itemBuilder: (context, snapshot, animation, index) {
//                 return Column(
//                   children: [
//                     const SizedBox(
//                       height: 10,
//                     ),
//                     GestureDetector(
//                       onTap: () {
//                         setState(() {
//                           videoURL = snapshot.value.toString();
//                         });
//                       },
//                       child: Container(
//                         width: double.infinity,
//                         decoration: BoxDecoration(
//                           color: Colors.grey,
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                         padding: const EdgeInsets.all(20.0),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             // imgOrPdf(snapshot),
//                             const SizedBox(
//                               width: 10,
//                             ),
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   // titleWithDel(snapshot),
//                                   const SizedBox(
//                                     height: 2,
//                                   ),
//                                   Text(
//                                     snapshot.key.toString(),
//                                     style: GoogleFonts.ubuntu(
//                                       fontWeight: FontWeight.normal,
//                                       fontSize: 13,
//                                     ),
//                                   ),
//                                   const SizedBox(
//                                     height: 2,
//                                   ),
//                                   Row(
//                                     mainAxisAlignment: MainAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         "${snapshot.value.toString().substring(0, 60) + "..."}",
//                                         style: const TextStyle(
//                                           fontSize: 10,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 );
//               },
//             ),
//           ),
//         ],
//       )),
      
//     );
//   }
// }
