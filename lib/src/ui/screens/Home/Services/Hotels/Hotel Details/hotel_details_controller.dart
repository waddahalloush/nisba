import 'package:get/get.dart';

/// Data model for a room.
class Room {
  final String name;
  final String imageUrl;
  final String capacity;
  final String bedType;
  final double area;
  final String view;
  final List<String> amenities;
  final double pricePerNight;

  const Room({
    required this.name,
    required this.imageUrl,
    required this.capacity,
    required this.bedType,
    required this.area,
    required this.view,
    required this.amenities,
    required this.pricePerNight,
  });
}

class HotelDetailsController extends GetxController {
  // ── Reactive state ──
  final currentImageIndex = 0.obs;
  final selectedRoomTab = 0.obs;
  final isLoading = false.obs;

  // ── Hotel info ──
  final hotelName = 'فندق لاكجري دبي';
  final location = 'دبي، الإمارات';
  final rating = 4.8;
  final reviewCount = 523;
  final ratingLabel = 'ممتاز';
  final stars = 5;
  final subtitle = 'فندق خمس نجوم';
  final totalImages = 25;

  final amenities = <String>[
    'واي فاي مجاني',
    'مسبح',
    'إفطار مجاني',
    'مواقف سيارات',
  ];

  // ── Room tabs ──
  final roomTabs = <String>['غرفة دبل', 'غرفة فردية', 'جناح', 'جناح ملكي'];

  // ── Rooms ──
  final rooms = <Room>[
    const Room(
      name: 'غرفة دبل',
      imageUrl: '',
      capacity: 'شخصان',
      bedType: 'سرير مزدوج',
      area: 28,
      view: 'إطلالة على المدينة',
      amenities: [
        'تكييف هواء',
        'تلفزيون ذكي',
        'ميني بار',
        'حمام خاص مع لوازم مجانية',
      ],
      pricePerNight: 450,
    ),
    const Room(
      name: 'غرفة فردية',
      imageUrl: '',
      capacity: 'شخص واحد',
      bedType: 'سرير فردي',
      area: 22,
      view: 'إطلالة على الحديقة',
      amenities: ['تكييف هواء', 'تلفزيون ذكي', 'حمام خاص مع لوازم مجانية'],
      pricePerNight: 300,
    ),
    const Room(
      name: 'جناح',
      imageUrl: '',
      capacity: 'شخصان',
      bedType: 'سرير كينج',
      area: 45,
      view: 'إطلالة على البحر',
      amenities: [
        'تكييف هواء',
        'تلفزيون ذكي',
        'ميني بار',
        'حمام خاص مع جاكوزي',
        'غرفة معيشة منفصلة',
      ],
      pricePerNight: 750,
    ),
    const Room(
      name: 'جناح ملكي',
      imageUrl: '',
      capacity: '4 أشخاص',
      bedType: 'سريرين كينج',
      area: 80,
      view: 'إطلالة بانورامية على البحر',
      amenities: [
        'تكييف هواء',
        'تلفزيون ذكي',
        'ميني بار',
        'حمام خاص مع جاكوزي',
        'غرفة معيشة منفصلة',
        'مطبخ خاص',
        'بلكونة خاصة',
      ],
      pricePerNight: 1200,
    ),
  ];

  /// Currently selected room.
  Room get selectedRoom => rooms[selectedRoomTab.value];

  void selectRoomTab(int index) {
    selectedRoomTab.value = index;
  }

  void setImageIndex(int index) {
    currentImageIndex.value = index;
  }
}
