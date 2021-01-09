import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import "package:google_maps_webservice/places.dart";
import 'package:implicitly_animated_reorderable_list/implicitly_animated_reorderable_list.dart';
import 'package:implicitly_animated_reorderable_list/transitions.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';

import './Place.dart';

class SearchBarWrapper extends StatefulWidget {
  final Function updateSearchLocationCallBack;

  SearchBarWrapper({this.updateSearchLocationCallBack});

  @override
  _SearchBarWrapperState createState() => _SearchBarWrapperState();
}

class _SearchBarWrapperState extends State<SearchBarWrapper> {
  List<Place> places = [];

  final controller = FloatingSearchBarController();

  Future<List<Place>> fetchData(String query) async {
    final places =
        new GoogleMapsPlaces(apiKey: FlutterConfig.get('MAPS_API_KEY'));
    PlacesSearchResponse response = await places.searchByText(query);
    List<Place> placeList =
        response.results.map((res) => Place(res.name, res.placeId)).toList();
    return placeList;
  }

  @override
  Widget build(BuildContext context) {
    return buildSearchBar();
  }

  void onQueryChanged(String query) async {
    List<Place> buildList = await fetchData(query);
    setState(() {
      places = buildList;
    });
  }

  Widget buildSearchBar() {
    final actions = [
      FloatingSearchBarAction(
        showIfOpened: false,
        child: CircularButton(
          icon: const Icon(Icons.place),
          onPressed: () {},
        ),
      ),
      FloatingSearchBarAction.searchToClear(
        showIfClosed: false,
      ),
    ];

    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return FloatingSearchBar(
      automaticallyImplyBackButton: false,
      controller: controller,
      clearQueryOnClose: true,
      hint: 'Search...',
      iconColor: Colors.grey,
      transitionDuration: const Duration(milliseconds: 500),
      transitionCurve: Curves.easeInOutCubic,
      physics: const BouncingScrollPhysics(),
      axisAlignment: isPortrait ? 0.0 : -1.0,
      openAxisAlignment: 0.0,
      maxWidth: isPortrait ? 600 : 500,
      actions: actions,
      progress: false,
      debounceDelay: const Duration(milliseconds: 500),
      onQueryChanged: onQueryChanged,
      scrollPadding: EdgeInsets.zero,
      transition: CircularFloatingSearchBarTransition(),
      builder: (context, _) => buildExpandableBody(),
    );
  }

  Widget buildExpandableBody() {
    return Material(
      color: Colors.white,
      elevation: 4.0,
      borderRadius: BorderRadius.circular(8),
      child: ImplicitlyAnimatedList<Place>(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        items: places,
        areItemsTheSame: (a, b) => a == b,
        itemBuilder: (context, animation, place, i) {
          return SizeFadeTransition(
            animation: animation,
            child: buildItem(context, place),
          );
        },
        updateItemBuilder: (context, animation, place) {
          return FadeTransition(
            opacity: animation,
            child: buildItem(context, place),
          );
        },
        insertDuration: Duration(milliseconds: 250),
        removeDuration: Duration(milliseconds: 250),
        updateDuration: Duration(milliseconds: 250),
      ),
    );
  }

  Widget buildItem(BuildContext context, Place place) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: () {
            controller.close();
            widget.updateSearchLocationCallBack(place);
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                SizedBox(
                  width: 36,
                  child: Icon(Icons.place, key: Key('place')),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      Text(
                        place.description,
                        style: textTheme.subtitle1,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
