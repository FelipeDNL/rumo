import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:rumo/core/asset_images.dart';
import 'package:rumo/features/auth/repositories/auth_repository.dart';
import 'package:rumo/features/diary/models/diary_model.dart';
import 'package:rumo/features/diary/repositories/diary_repository.dart';
import 'package:rumo/features/diary/widgets/diary_map_marker.dart';
import 'package:rumo/services/location_service.dart';

class UserDiariesScreen extends StatefulWidget {
  const UserDiariesScreen({super.key});

  @override
  State<UserDiariesScreen> createState() => _UserDiariesScreenState();
}

class _UserDiariesScreenState extends State<UserDiariesScreen> {
  final MapController mapController = MapController();
  final locationService = LocationService();

  bool isMapReady = false;

  String get mapKey => dotenv.env["MAPTILE_KEY"] ?? "";

  LatLng? userCooordinates;

  List<DiaryModel> diaries = [];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      getUserLocation();

      final user = AuthRepository().getCurrentUser();

      if (user == null) return;

      final userId = user.uid;

      final fetchedDiaries = await DiaryRepository().getUserDiaries(
        userId: userId,
      );
      if (mounted) {
        setState(() {
          diaries = fetchedDiaries;
        });
        if (diaries.isEmpty) return;
        final diariesCoordinates = diaries
            .map<LatLng>((diary) => LatLng(diary.latitude, diary.longitude))
            .toList();

        if (isMapReady) {
          mapController.fitCamera(
            CameraFit.coordinates(
              coordinates: diariesCoordinates,
              minZoom: 12,
              maxZoom: 18,
            ),
          );
        }
      }
    });
  }

  void getUserLocation() async {
    final userPosition = await locationService.askAndGetUserLocation();
    if (userPosition == null) {
      return;
    }

    setState(() {
      userCooordinates = LatLng(
        userPosition.latitude!,
        userPosition.longitude!,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: Colors.white,
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
        ),
      ),
      child: Scaffold(
        bottomSheet: DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.3,
          minChildSize: 0.3,
          builder: (context, controller) {
            return ListView.builder(
              controller: controller,
              itemCount: diaries.length,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 30,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Meus diários',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 24),
                        Center(child: Image.asset(AssetImages.diariesCount)),
                        SizedBox(height: 40),
                        Text(
                          'TODOS OS DIÁRIOS',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF757575),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return Padding(
                  padding: const EdgeInsets.only(
                    left: 24.0,
                    right: 24.0,
                    bottom: 16.0,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        spacing: 12.0,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              AssetImages.catedral,
                              width: 58,
                              height: 58,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                diaries[index].name,
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                diaries[index].location,
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                          Spacer(),
                          Icon(Icons.more_vert_rounded),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
        body: FlutterMap(
          mapController: mapController,
          options: MapOptions(
            initialCenter: userCooordinates ?? LatLng(0, 0),
            onMapReady: () {
              setState(() {
                isMapReady = true;
              });
              getUserLocation();
            },
          ),
          children: [
            TileLayer(
              urlTemplate:
                  'https://api.maptiler.com/maps/streets-v2/{z}/{x}/{y}.png?key=$mapKey',
              userAgentPackageName: 'br.com.othavioh.rumo',
            ),
            Builder(
              builder: (context) {
                if (diaries.isEmpty) return SizedBox.shrink();

                List<Marker> markers = diaries.map<Marker>((diary) {
                  return Marker(
                    point: LatLng(diary.latitude, diary.longitude),
                    width: 80,
                    height: 80,
                    child: DiaryMapMarker(imageUrl: diary.coverImage),
                  );
                }).toList();

                return MarkerLayer(markers: markers);
              },
            ),
          ],
        ),
      ),
    );
  }
}