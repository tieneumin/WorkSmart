// import 'package:flutter/material.dart';
// import 'package:worksmart/data/repo/request_supabase.dart';
// import 'package:worksmart/data/model/request.dart';

// class RequestsScreen extends StatefulWidget {
//   const RequestsScreen({super.key});

//   @override
//   State<RequestsScreen> createState() => _RequestsScreenState();
// }

// class _RequestsScreenState extends State<RequestsScreen> {
//   final _repo = RequestSupabase();
//   var _requests = <Request>[];

//   @override
//   void initState() {
//     _refresh();
//     super.initState();
//   }

//   void _refresh() async {
//     final res = await _repo.getAllRequests();
//     setState(() {
//       _requests = res;
//     });
//   }

//   // Future<void> _updateStatus(Request req, String status) async {
//   //   // TODO: Update request status in backend
//   //   // await RequestRepo().updateRequest(req.copy(status: status));
//   //   setState(() {
//   //     _requests =
//   //         _requests
//   //             .map((r) => r.id == req.id ? req.copy(status: status) : r)
//   //             .toList();
//   //   });
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Requests')),
//       body: SafeArea(
//         child: ListView.builder(
//           itemCount: _requests.length,
//           itemBuilder: (context, index) => RequestItem(request: request, onClickItem: onClickItem)
//             return ListTile(
//               title: Text(req.body),
//               subtitle: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text('Status: ${req.status}'),
//                   Text('Created: ${req.createdAt}'),
//                   if (req.attachment.isNotEmpty)
//                     Text(
//                       'Attachment: ${req.attachment}',
//                       style: const TextStyle(fontSize: 12),
//                     ),
//                 ],
//               ),
//               trailing: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   IconButton(
//                     icon: const Icon(Icons.check, color: Colors.green),
//                     onPressed:
//                         req.status == 'pending'
//                             ? () => _updateStatus(req, 'approved')
//                             : null,
//                   ),
//                   IconButton(
//                     icon: const Icon(Icons.close, color: Colors.red),
//                     onPressed:
//                         req.status == 'pending'
//                             ? () => _updateStatus(req, 'rejected')
//                             : null,
//                   ),
//                 ],
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

// class RequestItem extends StatelessWidget {
//   const RequestItem({
//     super.key,
//     required this.request,
//     required this.onClickItem,
//   });

//   final Request request;
//   final Function(Request) onClickItem;

//   @override
//   Widget build(BuildContext context) {
//     return const Placeholder();
//   }
// }
