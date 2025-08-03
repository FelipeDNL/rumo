import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rumo/core/asset_icons.dart';
import 'package:rumo/features/diary/models/place.dart';
import 'package:rumo/features/diary/models/create_diary_model.dart';
import 'package:rumo/features/diary/repositories/diary_repository.dart';
import 'package:rumo/features/diary/repositories/place_repository..dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CreateDiaryBottomSheet extends StatefulWidget {
  const CreateDiaryBottomSheet({super.key});

  @override
  State<CreateDiaryBottomSheet> createState() => _CreateDiaryBottomSheetState();
}

class _CreateDiaryBottomSheetState extends State<CreateDiaryBottomSheet> {
  final placeRepository = PlaceRepository();

  final _formKey = GlobalKey<FormState>();
  final locationSearchController = SearchController();
  final _tripNameController = TextEditingController();
  final _resumeController = TextEditingController();

  double rating = 2.5;
  bool isPrivate = false;
  List<Place> places = [];
  File? selectedImage;
  XFile? selectedImageXFile;
  String? _locationError;
  List<File> tripImages = [];
  Place? selectedPlace;

  String? lastQuery;

  bool isLoading = false;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();

    locationSearchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    locationSearchController.removeListener(_onSearchChanged);
    locationSearchController.dispose();
    _tripNameController.dispose();
    _resumeController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = locationSearchController.text;

    if (query == lastQuery) return;

    setState(() {
      lastQuery = query;
    });

    _debounce?.cancel();

    if (query.trim().isEmpty) return;

    _debounce = Timer(Duration(seconds: 1, milliseconds: 500), () async {
      final remotePlaces = await placeRepository.getPlaces(query: query);
      if (!mounted) return;
      setState(() {
        places = remotePlaces;
      });

      if (!locationSearchController.isOpen) {
        locationSearchController.openView();
      } else {
        locationSearchController.closeView(query);
        locationSearchController.openView();
      }
    });
  }

  void showSuccess() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Diário criado com sucesso!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void showError(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Erro'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  InputDecoration iconTextFieldDecoration({
    required Widget icon,
    required String hintText,
  }) => InputDecoration(
    prefixIcon: Padding(
      padding: const EdgeInsets.only(
        top: 17.5,
        bottom: 17.5,
        left: 12,
        right: 6,
      ),
      child: icon,
    ),
    alignLabelWithHint: true,
    prefixIconConstraints: BoxConstraints(maxWidth: 48),
    hintText: hintText,
  );

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
    child: ListView(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            top: 5,
            left: 24,
            right: 24,
            bottom: 5,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Novo Diário',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.primary,
                  textStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                child: Text('Cancelar'),
              ),
            ],
          ),
        ),
        Stack(
          children: [
            InkWell(
              onTap: () async {
                final imagePicker = ImagePicker();

                final file = await imagePicker.pickImage(
                  source: ImageSource.gallery,
                  imageQuality: 85,
                );

                if (file == null) return;

                // para web
                if (kIsWeb) {
                  setState(() {
                    selectedImage = null;
                    selectedImageXFile = file;
                  });
                } else {
                  setState(() {
                    selectedImage = File(file.path);
                  });
                }
              },
              child: Container(
                height: 136,
                decoration: BoxDecoration(
                  gradient: selectedImage == null
                      ? LinearGradient(
                          colors: [Color(0xFFCED4FF), Colors.white],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        )
                      : null,
                  image: (selectedImage != null || selectedImageXFile != null)
                      ? DecorationImage(
                          image: kIsWeb && selectedImageXFile != null
                              ? NetworkImage(selectedImageXFile!.path)
                              : FileImage(selectedImage!) as ImageProvider,
                          fit: BoxFit.cover,
                          colorFilter: ColorFilter.mode(
                            Colors.black.withAlpha(100),
                            BlendMode.darken,
                          ),
                        )
                      : null,
                ),
                alignment: Alignment.topCenter,
                padding: const EdgeInsets.only(top: 32),
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    spacing: 4,
                    children: [
                      SvgPicture.asset(
                        AssetIcons.iconCamera,
                        width: 16,
                        height: 16,
                      ),
                      Text(
                        'Escolher uma foto de capa',
                        style: TextStyle(
                          color: Color(0xFFF3F3F3),
                          fontWeight: FontWeight.w500,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.only(left: 24, right: 24, top: 94),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 16,
                  children: [
                    SearchAnchor.bar(
                      onTap: () {
                        PlaceRepository().getPlaces(query: 'Galeria Bar');
                      },
                      searchController: locationSearchController,
                      barBackgroundColor: WidgetStateProperty.all(
                        const Color(0xFFF9FAFB),
                      ),
                      barHintText: 'Localização',
                      barHintStyle: WidgetStateProperty.all(
                        TextStyle(color: Color(0xFF9EA2AE)),
                      ),
                      barLeading: SvgPicture.asset(
                        AssetIcons.iconLocalPin,
                        width: 24,
                        height: 24,
                        fit: BoxFit.cover,
                      ),
                      viewLeading: SvgPicture.asset(
                        AssetIcons.iconLocalPin,
                        width: 24,
                        height: 24,
                        fit: BoxFit.cover,
                      ),
                      suggestionsBuilder: (context, controller) {
                        return List.generate(places.length, (index) {
                          final place = places.elementAt(index);
                          final address = place.address;
                          String placeName = place.name;

                          if (address != null) {
                            placeName =
                                '${address.amenity}, ${address.road} - ${address.city} - ${address.country}';
                          }

                          return InkWell(
                            onTap: () {
                              setState(() {
                                controller.closeView(placeName);
                                controller.text = placeName;
                                selectedPlace = place;
                              });
                            },
                            child: Text(placeName),
                          );
                        });
                      },
                      isFullScreen: false,
                      dividerColor: Colors.transparent,
                    ),
                    if (_locationError != null)
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Text(
                          _locationError!,
                          style: TextStyle(color: Colors.red, fontSize: 12),
                        ),
                      ),
                    TextFormField(
                      controller: _tripNameController,
                      decoration: iconTextFieldDecoration(
                        icon: SvgPicture.asset(
                          AssetIcons.iconTag,
                          width: 24,
                          height: 24,
                          fit: BoxFit.cover,
                        ),
                        hintText: 'Nome da sua viagem',
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Por favor, insira um nome para viagem';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _resumeController,
                      minLines: 4,
                      maxLines: 4,
                      decoration: iconTextFieldDecoration(
                        icon: Padding(
                          padding: const EdgeInsets.only(bottom: 70.0),
                          child: SvgPicture.asset(
                            AssetIcons.iconThreeLines,
                            width: 16,
                            height: 16,
                            fit: BoxFit.cover,
                          ),
                        ),
                        hintText: 'Resumo da sua viagem',
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Adicione um resumo da sua viagem';
                        }
                        return null;
                      },
                    ),
                    InkWell(
                      onTap: () async {
                        final pickedFiles = await ImagePicker()
                            .pickMultiImage();
                        if (pickedFiles.isEmpty) return;

                        setState(() {
                          tripImages = pickedFiles
                              .map((file) => File(file.path))
                              .toList();
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xFFF9FAFB),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Color(0xFFE5E7EA),
                            width: 1.5,
                          ),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 17.5,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              spacing: 12,
                              children: [
                                SvgPicture.asset(
                                  AssetIcons.iconPhoto,
                                  width: 18,
                                  height: 18,
                                  fit: BoxFit.cover,
                                ),
                                Text(
                                  'Imagens da sua viagem',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal,
                                    color: Color(0xFF9EA2AE),
                                  ),
                                ),
                              ],
                            ),
                            Builder(
                              builder: (context) {
                                if (tripImages.isEmpty) {
                                  return SizedBox.shrink();
                                }
                                return Padding(
                                  padding: const EdgeInsets.only(top: 12),
                                  child: Wrap(
                                    direction: Axis.horizontal,
                                    runSpacing: 6,
                                    spacing: 6,
                                    children: tripImages.map<Widget>((image) {
                                      return InkWell(
                                        onTap: () {
                                          setState(() {
                                            tripImages.remove(image);
                                          });
                                        },
                                        child: SizedBox(
                                          height: 56,
                                          width: 56,
                                          child: Stack(
                                            children: [
                                              Align(
                                                alignment: Alignment.bottomLeft,
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                  child: Image.file(
                                                    image,
                                                    width: 48,
                                                    height: 48,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                              Align(
                                                alignment: Alignment.topRight,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: Color(0xFFEE443F),
                                                    border: Border.all(
                                                      color: Colors.white,
                                                      width: 1.17,
                                                    ),
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Icon(
                                                    Icons.close,
                                                    size: 14,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xFFD9D9D9), width: 1),
                        borderRadius: BorderRadius.circular(12),
                        color: Color(0xFFF9FAFB),
                      ),
                      padding: EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Text('Nota para a viagem'),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              StarRating(
                                size: 30.0,
                                rating: rating,
                                filledIcon: Icons.star,
                                halfFilledIcon: Icons.star_half,
                                emptyIcon: Icons.star_outlined,
                                color: Colors.yellow,
                                borderColor: Colors.grey,
                                allowHalfRating: true,
                                starCount: 5,
                                onRatingChanged: (rating) => setState(() {
                                  this.rating = rating;
                                }),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      spacing: 16,
                      children: [
                        Switch(
                          value: isPrivate,
                          onChanged: (value) {
                            setState(() {
                              isPrivate = value;
                            });
                          },
                        ),
                        Text(
                          'Manter diário privado',
                          style: TextStyle(color: Color(0xFF757575)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.only(left: 24.0, right: 24),
          child: FilledButton(
            onPressed: isLoading
                ? null
                : () async {
                    setState(() {
                      _locationError = locationSearchController.text.isEmpty
                          ? 'Selecione uma localização'
                          : null;
                    });

                    if (selectedImage == null) {
                      showError("Por favor, selecione uma imagem de capa");
                      return;
                    }
                    final ownerId = FirebaseAuth.instance.currentUser?.uid;
                    if (ownerId == null) return;

                    setState(() {
                      isLoading = true;
                    });

                    await DiaryRepository().createDiary(
                      diary: CreateDiaryModel(
                        ownerId: ownerId,
                        location: locationSearchController.text,
                        name: _tripNameController.text,
                        coverImage: selectedImage?.path ?? '',
                        resume: _resumeController.text,
                        images: tripImages.map((image) => image.path).toList(),
                        rating: rating,
                        isPrivate: isPrivate,
                      ),
                    );

                    setState(() {
                      isLoading = false;
                    });

                    if (!context.mounted) return;
                    Navigator.pop(context);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Diário criado com sucesso!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
            child: Builder(
              builder: (context) {
                if (isLoading) {
                  return SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(color: Colors.white),
                  );
                }
                return Text('Entrar');
              },
            ),
          ),
        ),
      ],
    ),
  );
}
