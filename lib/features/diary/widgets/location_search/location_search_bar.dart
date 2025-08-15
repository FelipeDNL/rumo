import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rumo/features/diary/models/place.dart';
import 'package:rumo/features/diary/repositories/place_repository.dart';
import 'package:rumo/core/asset_icons.dart';

class LocationSearchBar extends StatefulWidget {
  final TextEditingController controller;
  final Place? initialPlace;
  final void Function(Place place) onPlaceSelected; // callback quando um local é selecionado

  const LocationSearchBar({
    required this.controller,
    required this.onPlaceSelected,
    this.initialPlace,
    super.key,
  });

  @override
  State<LocationSearchBar> createState() => _LocationSearchBarState();
}

class _LocationSearchBarState extends State<LocationSearchBar> {
  final PlaceRepository _placeRepository = PlaceRepository();
  List<Place> _places = [];

  bool _isSearching = false;
  bool _showSuggestions = false;

  Timer? _debounce;

  // focus node para controlar o foco do campo de texto
  final FocusNode _focusNode = FocusNode();
  final GlobalKey _targetKey = GlobalKey();
  OverlayEntry? _overlayEntry;

  String? lastQuery;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onSearchChanged);

    // caso o campo de texto ganhe foco e não esteja vazio, mostrar sugestões
    _focusNode.addListener(() {
      if (_focusNode.hasFocus && widget.controller.text.trim().isNotEmpty) {
        _setShowSuggestions(true);
      } else if (!_focusNode.hasFocus) {
        _setShowSuggestions(false);
      }
    });

    // caso o widget inicialPlace não seja nulo - acho que não ta funcionando
    if (widget.initialPlace != null) {
      widget.controller.text = widget.initialPlace!.formattedLocation;
      lastQuery = widget.controller.text;
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _removeOverlay();
    _focusNode.dispose();
    widget.controller.removeListener(_onSearchChanged);
    super.dispose();
  }

  void _setShowSuggestions(bool show) {
    if (_showSuggestions == show) return;
    _showSuggestions = show;
    if (show) {
      _showOverlay();
    } else {
      _removeOverlay();
    }
    setState(() {});
  }

  void _onSearchChanged() {
    final query = widget.controller.text;
    if (query == lastQuery) return;
    lastQuery = query;

    _debounce?.cancel();

    if (query.trim().isEmpty) {
      // se query for vazia limpar resultados
      _places = [];
      _isSearching = false;
      _overlayEntry
          ?.markNeedsBuild(); //markNeedsBuild é usado para atualizar o overlay
      _setShowSuggestions(false);
      return;
    }

    // debounce
    _isSearching = true;
    _overlayEntry?.markNeedsBuild();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      try {
        final remotePlaces = await _placeRepository.getPlaces(query: query);
        if (!mounted) return;
        _places = remotePlaces;
        _isSearching = false;
        // mostrar overlay ou atualizar
        if (!_showSuggestions) {
          _setShowSuggestions(true);
        } else {
          _overlayEntry?.markNeedsBuild();
        }
      } catch (e) {
        _places = [];
        _isSearching = false;
        _overlayEntry?.markNeedsBuild();
      }
    });
  }

  void _showOverlay() {
    if (_overlayEntry != null) return;
    final renderBox =
        _targetKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;
    final targetSize = renderBox.size;
    final targetPosition = renderBox.localToGlobal(Offset.zero);

    // overlay para a lista de sugestões, que precisa ficar em cima de outros componentes
    _overlayEntry = OverlayEntry(
      builder: (context) {
        // pegar o tamanho e posição do widget alvo - essa parte foi ia kk
        final renderBoxInner =
            _targetKey.currentContext?.findRenderObject() as RenderBox?;
        final tSize = renderBoxInner?.size ?? targetSize;
        final tPos =
            renderBoxInner?.localToGlobal(Offset.zero) ?? targetPosition;

        return Positioned(
          //positioned usado para a lista de sugestões
          left: tPos.dx,
          top: tPos.dy + tSize.height + 8, // espaço de separação
          width: tSize.width,
          child: Material(
            color: Colors.transparent,
            child: Container(
              constraints: const BoxConstraints(maxHeight: 220),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE5E7EA), width: 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: _isSearching
                  ? const Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  : _places.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        'Nenhum local encontrado.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF757575),
                        ),
                      ),
                    )
                  : ListView.separated(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: _places.length,
                      separatorBuilder: (_, __) => const Divider(
                        height: 0,
                        thickness: 0,
                        color: Colors.white,
                      ),
                      itemBuilder: (context, index) {
                        final place = _places[index];
                        return InkWell(
                          onTap: () {
                            widget.controller.text = place.formattedLocation;
                            widget.onPlaceSelected(place);
                            _focusNode.unfocus();
                            _setShowSuggestions(false);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 12,
                            ),
                            child: Text(
                              place.formattedLocation,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 14,
                                color: Color(0xFF131927),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),
        );
      },
    );

    Overlay.of(
      context,
    ).insert(_overlayEntry!); // overlay inserido na árvore de widgets
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Container(
          key: _targetKey,
          decoration: BoxDecoration(
            color: Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE5E7EA), width: 1.5),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
          child: Row(
            children: [
              SvgPicture.asset(AssetIcons.iconLocationPin, width: 30),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 4),
                    Text(
                      'Localização',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF757575),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextField(
                      focusNode: _focusNode,
                      controller: widget.controller,
                      decoration: const InputDecoration(
                        constraints: BoxConstraints(maxHeight: 25),
                        fillColor: Color(0xFFF9FAFB),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        hintText: 'Busque um local',
                        contentPadding: EdgeInsets.only(
                          left: 0,
                          right: 8,
                          top: 0,
                          bottom: 15,
                        ),
                      ),
                      onTap: () {
                        if (widget.controller.text.trim().isNotEmpty) {
                          _setShowSuggestions(true);
                        } else {
                          // vai mostrar "Nenhum local encontrado." até achar algo
                          _setShowSuggestions(true);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}