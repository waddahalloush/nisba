// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:iconsax/iconsax.dart';
// import 'place_details_controller.dart';

// class PlaceDetailsScreen extends GetView<PlaceDetailsController> {
//   const PlaceDetailsScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final item = controller.item;
//     final theme = Theme.of(context);

//     return Scaffold(
//       body: CustomScrollView(
//         slivers: [
//           // ── 1. هيدر الصورة البانورامي المتداخل مع الكورنيش ──
//           SliverAppBar(
//             expandedHeight: 320,
//             pinned: true,
//             leading: IconButton(
//               icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
//               onPressed: () => Get.back(),
//             ),
//             actions: [
//               Obx(() => IconButton(
//                 icon: Icon(
//                   controller.isFavorite.value ? Iconsax.heart5 : Iconsax.heart,
//                   color: controller.isFavorite.value ? Colors.red : Colors.white,
//                 ),
//                 onPressed: controller.toggleFavorite,
//               )),
//             ],
//             flexibleSpace: FlexibleSpaceBar(
//               background: Stack(
//                 fit: StackFit.expand,
//                 children: [
//                   Image.asset(
//                     item.imageUrl,
//                     fit: BoxFit.cover,
//                   ),
//                   // طبقة تظليل لجعل النصوص والأزرار البيضاء مقروءة
//                   const DecoratedBox(
//                     decoration: BoxDecoration(
//                       gradient: LinearGradient(
//                         begin: Alignment.topCenter,
//                         end: Alignment.bottomCenter,
//                         colors: [Colors.black54, Colors.transparent, Colors.black87],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),

//           // ── 2. محتوى تفاصيل المكان ──
//           SliverToBoxAdapter(
//             child: Padding(
//               padding: const EdgeInsets.all(20.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // الاسم والتصنيف
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Container(
//                         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                         decoration: BoxDecoration(
//                           color: theme.primaryColor.withOpacity(0.1),
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                         child: Text(
//                           item.category,
//                           style: TextStyle(color: theme.primaryColor, fontWeight: FontWeight.bold),
//                         ),
//                       ),
//                       Row(
//                         children: [
//                           const Icon(Iconsax.star5, color: Colors.amber, size: 20),
//                           const SizedBox(width: 4),
//                           Text(
//                             '${item.rating}',
//                             style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 12),
//                   Text(
//                     item.name,
//                     style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(height: 16),

//                   // أوقات العمل والمسافة
//                   Row(
//                     children: [
//                       Expanded(
//                         child: _buildInfoTile(
//                           icon: Iconsax.clock,
//                           title: 'أوقات العمل',
//                           subtitle: item.hours??"",
//                           theme: theme,
//                         ),
//                       ),
//                       Expanded(
//                         child: _buildInfoTile(
//                           icon: Iconsax.routing,
//                           title: 'المسافة',
//                           subtitle: item.distance,
//                           theme: theme,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const Divider(height: 32),

//                   // العنوان التفصيلي
//                   const Text(
//                     'الموقع والعنوان',
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(height: 8),
//                   Row(
//                     children: [
//                       Icon(Iconsax.location, color: theme.primaryColor),
//                       const SizedBox(width: 8),
//                       Expanded(
//                         child: Text(
//                           item.address,
//                           style: const TextStyle(color: Colors.grey, fontSize: 15),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const Divider(height: 32),

//                   // المميزات والخصائص المميزة للخدمة
//                   if (item.features!.isNotEmpty) ...[
//                     const Text(
//                       'أبرز ما يميز المكان',
//                       style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                     ),
//                     const SizedBox(height: 12),
//                     ...item.features!.map((feature) => Padding(
//                       padding: const EdgeInsets.only(bottom: 12.0),
//                       child: Row(
//                         children: [
//                           Container(
//                             padding: const EdgeInsets.all(8),
//                             decoration: BoxDecoration(
//                               color: theme.primaryColor.withOpacity(0.08),
//                               shape: BoxShape.circle,
//                             ),
//                             child: Icon(feature.icon, color: theme.primaryColor, size: 20),
//                           ),
//                           const SizedBox(width: 12),
//                           Expanded(
//                             child: Text(
//                               feature.label,
//                               style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
//                             ),
//                           ),
//                         ],
//                       ),
//                     )),
//                     const SizedBox(height: 24),
//                   ],

//                   // أزرار العمليات السريعة (الاتصال والتنقل)
//                   Row(
//                     children: [
//                       Expanded(
//                         child: ElevatedButton.icon(
//                           onPressed: () {
//                             // منطق فتح جوجل ماب للعنوان
//                           },
//                           icon: const Icon(Iconsax.map, color: Colors.white),
//                           label: const Text('الاتجاهات (خريطة)'),
//                           style: ElevatedButton.styleFrom(
//                             padding: const EdgeInsets.symmetric(vertical: 14),
//                             backgroundColor: theme.primaryColor,
//                             foregroundColor: Colors.white,
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 12),
//                       Container(
//                         decoration: BoxDecoration(
//                           border: Border.all(color: theme.primaryColor),
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: IconButton(
//                           icon: Icon(Iconsax.call, color: theme.primaryColor),
//                           onPressed: () {
//                             // منطق الاتصال السريع
//                           },
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildInfoTile({
//     required IconData icon,
//     required String title,
//     required String subtitle,
//     required ThemeData theme,
//   }) {
//     return Row(
//       children: [
//         Container(
//           padding: const EdgeInsets.all(10),
//           decoration: BoxDecoration(
//             color: theme.primaryColor.withOpacity(0.05),
//             borderRadius: BorderRadius.circular(10),
//           ),
//           child: Icon(icon, color: theme.primaryColor, size: 22),
//         ),
//         const SizedBox(width: 10),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 title,
//                 style: const TextStyle(fontSize: 12, color: Colors.grey),
//               ),
//               Text(
//                 subtitle,
//                 style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
//                 maxLines: 1,
//                 overflow: TextOverflow.ellipsis,
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }