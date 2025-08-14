import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rumo/core/asset_icons.dart';
import 'package:rumo/features/diary/models/diary_model.dart';
import 'package:rumo/features/diary/repositories/diary_repository.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:rumo/features/diary/screens/user_diaries_list_view/widgets/show_user_diaries_comments.dart';

class UserDiariesDetails extends StatefulWidget {
  final String diaryId;

  const UserDiariesDetails({super.key, required this.diaryId});

  @override
  State<UserDiariesDetails> createState() => _UserDiariesDetailsState();
}

class _UserDiariesDetailsState extends State<UserDiariesDetails> {
  late Future<DiaryModel> diary;

  @override
  void initState() {
    super.initState();
    diary = DiaryRepository().getDiaryById(widget.diaryId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 23, left: 25),
            child: Text('IMAGEM AQUI'),
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
                            children: [
                              Container(
                                height: 30,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF5F5F5),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                padding: const EdgeInsets.all(8),
                                child: Row(
                                  children: [
                                    CircleAvatar(radius: 10),
                                    Text(
                                      'Nome',
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500,
                                        color: Color.fromARGB(255, 0, 0, 0),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height: 30,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF5F5F5),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                padding: const EdgeInsets.all(8),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.calendar_today_outlined,
                                      size: 15,
                                    ),
                                    Text(
                                      ' DD/MM/AAAA',
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500,
                                        color: Color.fromARGB(255, 0, 0, 0),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SvgPicture.asset(
                                AssetIcons.iconDotsMenu,
                                fit: BoxFit.cover,
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Título do Diário',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Color.fromARGB(255, 0, 0, 0),
                            ),
                          ),
                          const Text(
                            'Local, Local',
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
                              Text('0'),
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
                            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF757575),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            width: double.maxFinite,
                            constraints: BoxConstraints(minHeight: 200),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(16),
                              ),
                              border: Border.all(
                                color: const Color(0xFFD9D9D9),
                                width: 1,
                              ),
                            ),
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
                                  ),
                                ),
                              ),
                              StaggeredGridTile.count(
                                crossAxisCellCount: 2, // Este ocupa 2 colunas
                                mainAxisCellCount: 1,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: const Color(0xFFD9D9D9),
                                      width: 1,
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
                                      maxHeight: MediaQuery.of(context).size.height * 0.8,
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
      ),
    );
  }
}
