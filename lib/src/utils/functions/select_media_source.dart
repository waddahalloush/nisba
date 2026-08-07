// import 'package:carcom/generated/assets.gen.dart';
// import 'package:carcom/src/configs/constants_utils.dart';
// import 'package:carcom/src/configs/dimensions.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// void selectMediaSource({
//   required BuildContext context,
//   required String title,
//   required VoidCallback onCameraTab,
//   required VoidCallback onGalleryTab,
// }) {
//   showModalBottomSheet(
//     backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//     context: context,
//     isScrollControlled: true,
//     shape: const RoundedRectangleBorder(
//       borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
//     ),
//     builder: (context) => DraggableScrollableSheet(
//       initialChildSize: 0.25,
//       maxChildSize: 0.3,
//       minChildSize: 0.1,
//       expand: false,
//       builder: (context, scrollController) {
//         return Container(
//           // color: Colors.grey.shade300,
//           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 title,
//                 textAlign: TextAlign.center,
//                 style: Get.textTheme.bodyMedium!.copyWith(
//                   fontWeight: FontWeight.w900,
//                 ),
//               ),
//               SizedBox(height: 30.h),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   ElevatedButton.icon(
//                     style: ElevatedButton.styleFrom(
//                       minimumSize: Size(160.w, 57.h),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(13.r),
//                       ),
//                       backgroundColor: kMainColor,
//                     ),
//                     onPressed: onCameraTab,
//                     icon: Assets.images.svg.icSelectCamera.svg(),
//                     label: Text(
//                       'Camera',
//                       textAlign: TextAlign.center,
//                       style: Get.textTheme.headlineMedium!.copyWith(
//                         fontWeight: FontWeight.w700,
//                       ),
//                     ),
//                   ),
//                   ElevatedButton.icon(
//                     style: ElevatedButton.styleFrom(
//                       minimumSize: Size(160.w, 57.h),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(13.r),
//                       ),
//                       backgroundColor: kMainColor,
//                     ),
//                     onPressed: onGalleryTab,
//                     icon: Assets.images.svg.icSelectGallery.svg(),
//                     label: Text(
//                       'Gallery',
//                       textAlign: TextAlign.center,
//                       style: Get.textTheme.headlineMedium!.copyWith(
//                         fontWeight: FontWeight.w700,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         );
//       },
//     ),
//   );
// }
