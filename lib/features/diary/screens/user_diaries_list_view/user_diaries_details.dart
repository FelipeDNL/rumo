import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/svg.dart';
import 'package:latlong2/latlong.dart';
import 'package:rumo/core/asset_icons.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:rumo/features/diary/models/diary_model.dart';
import 'package:rumo/features/diary/repositories/diary_repository.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:rumo/features/diary/screens/user_diaries_list_view/widgets/show_user_diaries_comments.dart';
import 'package:rumo/features/diary/widgets/diary_map_marker.dart';

class UserDiariesDetails extends StatefulWidget {
  final String diaryId;

  const UserDiariesDetails({super.key, required this.diaryId});

  @override
  State<UserDiariesDetails> createState() => _UserDiariesDetailsState();
}

class _UserDiariesDetailsState extends State<UserDiariesDetails> {
  late Future<DiaryModel> diary;
  final MapController mapController = MapController();

  //isso aqui ta errado pq ta pegando só o usuario atual - mudar
  User? user = FirebaseAuth.instance.currentUser;
  String? userName;

  @override
  void initState() {
    super.initState();
    diary = DiaryRepository().getDiaryById(widget.diaryId);
    _fetchUserName();
  }

  Future<void> _fetchUserName() async {
    if (user != null) {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get();
      setState(() {
        userName = doc.data()?['name'] as String?;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: FutureBuilder<DiaryModel>(
        future: diary,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return const Center(child: Text('Nenhum dado encontrado'));
          }

          final diaryData = snapshot.data!;

          return Stack(
            children: [
              Image.network(
                diaryData.coverImage,
                fit: BoxFit.cover,
                height: 300,
                width: double.infinity,
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: IconButton.filled(
                        padding: const EdgeInsets.all(10),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        color: const Color(0xFF383838),
                        icon: const Icon(Icons.chevron_left, size: 29),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.only(
                          top: 32,
                          bottom: 32,
                          left: 24,
                          right: 24,
                        ),
                        width: double.maxFinite,
                        height:
                            MediaQuery.of(context).size.height *
                            0.7, // Define uma altura específica
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(32),
                          ),
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    spacing: 5,
                                    children: [
                                      Container(
                                        height: 30,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF5F5F5),
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        padding: const EdgeInsets.all(8),
                                        child: Row(
                                          children: [
                                            CircleAvatar(radius: 15),
                                            Text(
                                              userName ?? 'Usuário',
                                              style: TextStyle(
                                                fontFamily: 'Inter',
                                                fontSize: 10,
                                                fontWeight: FontWeight.w500,
                                                color: Color.fromARGB(
                                                  255,
                                                  0,
                                                  0,
                                                  0,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        height: 30,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF5F5F5),
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                        padding: const EdgeInsets.all(8),
                                        child: Row(
                                          spacing: 0.9,
                                          children: [
                                            Icon(
                                              Icons.calendar_today_outlined,
                                              size: 15,
                                            ),
                                            Text(
                                              '10/08/2025',
                                              style: TextStyle(
                                                fontFamily: 'Inter',
                                                fontSize: 10,
                                                fontWeight: FontWeight.w500,
                                                color: Color.fromARGB(
                                                  255,
                                                  0,
                                                  0,
                                                  0,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),

                                  SvgPicture.asset(
                                    AssetIcons.iconDotsMenu,
                                    fit: BoxFit.cover,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                diaryData.name,
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Color.fromARGB(255, 0, 0, 0),
                                ),
                              ),
                              Text(
                                diaryData.location,
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w200,
                                  color: Color.fromARGB(255, 0, 0, 0),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                spacing: 3,
                                children: [
                                  SvgPicture.asset(
                                    AssetIcons.iconStar,
                                    colorFilter: const ColorFilter.mode(
                                      Colors.yellow,
                                      BlendMode.srcIn,
                                    ),
                                    height: 16,
                                  ),
                                  Text(diaryData.rating.toString()),
                                  const SizedBox(width: 8),
                                  SvgPicture.asset(
                                    AssetIcons.iconHeartFilled,
                                    colorFilter: const ColorFilter.mode(
                                      Colors.red,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                  Text('0.0'),
                                ],
                              ),
                              const SizedBox(height: 24),
                              Text(
                                'SOBRE A VIAGEM',
                                style: TextStyle(color: Color(0xFF757575)),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                diaryData.resume,
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xFF757575),
                                ),
                              ),
                              const SizedBox(height: 12),
                              // Mapa com marker no local do diário
                              Builder(
                                builder: (context) {
                                  final mapKey =
                                      dotenv.env["MAPTILE_KEY"] ?? "";
                                  return Container(
                                    width: double.maxFinite,
                                    height: 200,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: const Color(0xFFD9D9D9),
                                        width: 1,
                                      ),
                                    ),
                                    clipBehavior: Clip.antiAlias,
                                    child: FlutterMap(
                                      mapController: mapController,
                                      options: MapOptions(
                                        initialCenter: LatLng(
                                          diaryData.latitude,
                                          diaryData.longitude,
                                        ),
                                      ),
                                      children: [
                                        TileLayer(
                                          urlTemplate:
                                              'https://api.maptiler.com/maps/streets-v2/{z}/{x}/{y}.png?key=$mapKey',
                                          userAgentPackageName:
                                              'br.com.felipe.rumo',
                                        ),
                                        MarkerLayer(
                                          markers: [
                                            Marker(
                                              point: LatLng(
                                                diaryData.latitude,
                                                diaryData.longitude,
                                              ),
                                              width: 80,
                                              height: 80,
                                              child: DiaryMapMarker(
                                                imageUrl: diaryData.coverImage,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 24),
                              Text('GALERIA'),
                              const SizedBox(height: 12),
                              StaggeredGrid.count(
                                crossAxisCount: 3,
                                mainAxisSpacing: 4,
                                crossAxisSpacing: 4,
                                children: [
                                  StaggeredGridTile.count(
                                    crossAxisCellCount: 1,
                                    mainAxisCellCount: 1,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: const Color(0xFFD9D9D9),
                                          width: 1,
                                        ),
                                        image: diaryData.images.length > 0
                                            ? DecorationImage(
                                                image: NetworkImage(
                                                  diaryData.images[0],
                                                ),
                                                fit: BoxFit.cover,
                                              )
                                            : null,
                                      ),
                                      child: diaryData.images.length > 0
                                          ? null
                                          : Center(
                                              child: Icon(
                                                Icons.image_not_supported,
                                                color: Colors.grey,
                                                size: 40,
                                              ),
                                            ),
                                    ),
                                  ),
                                  StaggeredGridTile.count(
                                    crossAxisCellCount: 1,
                                    mainAxisCellCount: 1,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: const Color(0xFFD9D9D9),
                                          width: 1,
                                        ),
                                        image: diaryData.images.length > 1
                                            ? DecorationImage(
                                                image: NetworkImage(
                                                  diaryData.images[1],
                                                ),
                                                fit: BoxFit.cover,
                                              )
                                            : null,
                                      ),
                                      child: diaryData.images.length > 1
                                          ? null
                                          : Center(
                                              child: Icon(
                                                Icons.image_not_supported,
                                                color: Colors.grey,
                                                size: 40,
                                              ),
                                            ),
                                    ),
                                  ),
                                  StaggeredGridTile.count(
                                    crossAxisCellCount: 1,
                                    mainAxisCellCount: 1,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: const Color(0xFFD9D9D9),
                                          width: 1,
                                        ),
                                        image: diaryData.images.length > 2
                                            ? DecorationImage(
                                                image: NetworkImage(
                                                  diaryData.images[2],
                                                ),
                                                fit: BoxFit.cover,
                                              )
                                            : null,
                                      ),
                                      child: diaryData.images.length > 2
                                          ? null
                                          : Center(
                                              child: Icon(
                                                Icons.image_not_supported,
                                                color: Colors.grey,
                                                size: 40,
                                              ),
                                            ),
                                    ),
                                  ),
                                  StaggeredGridTile.count(
                                    crossAxisCellCount:
                                        2, // Este ocupa 2 colunas
                                    mainAxisCellCount: 1,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: const Color(0xFFD9D9D9),
                                          width: 1,
                                        ),
                                        image: diaryData.images.length > 3
                                            ? DecorationImage(
                                                image: NetworkImage(
                                                  diaryData.images[3],
                                                ),
                                                fit: BoxFit.cover,
                                              )
                                            : null,
                                      ),
                                      child: diaryData.images.length > 3
                                          ? null
                                          : Center(
                                              child: Icon(
                                                Icons.image_not_supported,
                                                color: Colors.grey,
                                                size: 40,
                                              ),
                                            ),
                                    ),
                                  ),
                                  StaggeredGridTile.count(
                                    crossAxisCellCount: 1,
                                    mainAxisCellCount: 1,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: const Color(0xFFD9D9D9),
                                          width: 1,
                                        ),
                                        image: diaryData.images.length > 4
                                            ? DecorationImage(
                                                image: NetworkImage(
                                                  diaryData.images[4],
                                                ),
                                                fit: BoxFit.cover,
                                              )
                                            : null,
                                      ),
                                      child: diaryData.images.length > 4
                                          ? null
                                          : Center(
                                              child: Icon(
                                                Icons.image_not_supported,
                                                color: Colors.grey,
                                                size: 40,
                                              ),
                                            ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),
                              Row(
                                spacing: 5,
                                children: [
                                  SvgPicture.asset(AssetIcons.iconHeartEmpty),
                                  Text('0'),
                                  const SizedBox(width: 8),
                                  InkWell(
                                    onTap: () {
                                      showModalBottomSheet(
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(30),
                                          ),
                                        ),
                                        constraints: BoxConstraints(
                                          maxHeight:
                                              MediaQuery.of(
                                                context,
                                              ).size.height *
                                              0.8,
                                        ),
                                        context: context,
                                        isScrollControlled: true,
                                        builder: (context) {
                                          return ShowUserDiariesComments();
                                        },
                                      );
                                    },
                                    child: SvgPicture.asset(
                                      AssetIcons.iconCommentEmpty,
                                    ),
                                  ),
                                  Text('0'),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
