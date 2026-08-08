import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:nisba_app/src/configs/dimensions.dart';
import 'package:nisba_app/src/ui/screens/Search/search_controller.dart';
import 'package:nisba_app/src/ui/screens/Search/widgets/nearby_partner_card.dart';

/// عرض الخريطة مع DraggableScrollableSheet للشركاء القريبين
class MapViewSheet extends StatefulWidget {
  const MapViewSheet({super.key});

  @override
  State<MapViewSheet> createState() => _MapViewSheetState();
}

class _MapViewSheetState extends State<MapViewSheet> {
  final MapController _mapController = MapController();
  final SearchhController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Stack(
      children: [
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: LatLng(
              controller.userLat.value,
              controller.userLng.value,
            ),
            initialZoom: 12.5,
            onPositionChanged: (camera, hasGesture) {
              if (!hasGesture) return;
              final b = camera.visibleBounds;
              controller.onMapBoundsChanged(
                ne: b.northEast,
                sw: b.southWest,
                center: camera.center,
              );
            },
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.nisba.app',
            ),
            Obx(() {
              final markers = controller.mapPartners
                  .where((p) => p.latitude != 0 || p.longitude != 0)
                  .map(
                    (p) => Marker(
                      point: LatLng(p.latitude, p.longitude),
                      width: 40.w,
                      height: 40.h,
                      child: GestureDetector(
                        onTap: () => controller.openPartner(p),
                        child: Icon(
                          Icons.location_on_rounded,
                          color: cs.primary,
                          size: 36.sp,
                        ),
                      ),
                    ),
                  )
                  .toList();

              markers.add(
                Marker(
                  point: LatLng(
                    controller.userLat.value,
                    controller.userLng.value,
                  ),
                  width: 28.w,
                  height: 28.h,
                  child: Icon(
                    Icons.my_location,
                    color: cs.error,
                    size: 26.sp,
                  ),
                ),
              );

              return MarkerLayer(markers: markers);
            }),
          ],
        ),

        Positioned(
          top: 12.h,
          right: 16.w,
          child: Column(
            children: [
              _buildMapControlBtn(
                context,
                Icons.my_location_rounded,
                onTap: () {
                  controller.recenterMap();
                  _mapController.move(
                    LatLng(controller.userLat.value, controller.userLng.value),
                    13,
                  );
                },
              ),
              SizedBox(height: 8.h),
              _buildMapControlBtn(
                context,
                Icons.refresh_rounded,
                onTap: controller.fetchMap,
              ),
            ],
          ),
        ),

        DraggableScrollableSheet(
          initialChildSize: 0.11,
          minChildSize: 0.11,
          maxChildSize: 0.47,
          builder: (_, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: cs.surface,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24.r),
                  topRight: Radius.circular(24.r),
                ),
                boxShadow: [
                  BoxShadow(
                    color: cs.shadow.withValues(alpha: 0.12),
                    blurRadius: 16.r,
                    offset: Offset(0, -4.h),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                controller: scrollController,
                physics: const ClampingScrollPhysics(),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 10.h, bottom: 4.h),
                      child: Container(
                        width: 36.w,
                        height: 5.h,
                        decoration: BoxDecoration(
                          color: cs.onSurface.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(3.r),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 9.h,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () => controller.setMapView(false),
                            child: Text(
                              'view_all'.tr,
                              style: theme.textTheme.labelLarge?.copyWith(
                                color: cs.primary,
                                fontWeight: FontWeight.w600,
                                fontSize: 14.sp,
                              ),
                            ),
                          ),
                          Text(
                            'auto_key_548'.tr,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 14.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Obx(() {
                      final nearby = controller.nearbyPartners;
                      if (nearby.isEmpty) {
                        return Padding(
                          padding: EdgeInsets.all(24.r),
                          child: Text(
                            'auto_key_549'.tr,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: cs.onSurface.withValues(alpha: 0.5),
                            ),
                          ),
                        );
                      }
                      return SizedBox(
                        height: 170.h,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          itemCount: nearby.length,
                          itemBuilder: (_, i) => NearbyPartnerCard(
                            partner: nearby[i],
                            onTap: () => controller.openPartner(nearby[i]),
                          ),
                        ),
                      );
                    }),
                    SizedBox(height: 16.h),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildMapControlBtn(
    BuildContext context,
    IconData icon, {
    VoidCallback? onTap,
  }) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40.r,
        height: 40.r,
        decoration: BoxDecoration(
          color: cs.surface,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: cs.shadow.withValues(alpha: 0.15),
              blurRadius: 8.r,
              offset: Offset(0, 2.h),
            ),
          ],
        ),
        child: Icon(icon, size: 20.sp, color: cs.onSurface),
      ),
    );
  }
}
