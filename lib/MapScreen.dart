import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hacknroll2021/Carpark.dart';
import 'package:hacknroll2021/HDBCarpark.dart';
import 'package:hacknroll2021/HDBCarparkDetails.dart';
import 'package:hacknroll2021/MallCarpark.dart';
import 'package:hacknroll2021/MallCarparkDetails.dart';
import 'package:hacknroll2021/MapWidget.dart';
import 'package:hacknroll2021/Place.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import './CarparkDetails.dart';
import './ModelLoader.dart';
import './SearchBar.dart';

/*
    to programatically open/close bottom sheet, use:
      _pc.open()
      _pc.close()
      _pc.show()
      _pc.hide()
  */

class MapScreen extends StatefulWidget {
  MapScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  PanelController _pc;
  Carpark _selectedCarpark;
  GlobalKey<MapWidgetState> mapWidgetKey = GlobalKey();
  ModelLoader _modelLoader;
  bool _loaded = false, _faded = false;

  void selectCarpark(Carpark carpark) {
    setState(() {
      _selectedCarpark = carpark;
      _pc.show();
    });
  }

  @override
  void initState() {
    super.initState();
    _pc = new PanelController();
    WidgetsBinding.instance.addPostFrameCallback((_) => _pc.hide());
    _modelLoader = ModelLoader();
    _loadModel();
  }

  void _loadModel() async {
    await _modelLoader.init();
  }

  @override
  Widget build(BuildContext context) {
    BorderRadiusGeometry radius = BorderRadius.only(
      topLeft: Radius.circular(24.0),
      topRight: Radius.circular(24.0),
    );

    Function updateSearchLocationCallBack = (Place place) {
      mapWidgetKey.currentState.moveToSearchLocation(place);
    };

    void onLoad() {
      setState(() {
        _loaded = true;
      });
    }

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          WillPopScope(
            child: SlidingUpPanel(
              body: MapWidget(
                selectCallback: selectCarpark,
                loadedCallback: onLoad,
                key: mapWidgetKey,
              ),
              controller: _pc,
              isDraggable: false,
              panelBuilder: (sc) => _panel(sc),
              minHeight: 225,
              borderRadius: radius,
            ),
            onWillPop: () {
              if (_pc.isPanelShown) {
                _pc.hide();
                return Future.value(false);
              } else {
                return Future.value(true);
              }
            },
          ),
          SearchBarWrapper(
            updateSearchLocationCallBack: updateSearchLocationCallBack,
          ),
          if (!_faded)
            AnimatedOpacity(
              opacity: _loaded ? 0.0 : 1.0,
              duration: Duration(milliseconds: 500),
              onEnd: () {
                setState(() {
                  _faded = true;
                });
              },
              child: Center(
                child: Container(
                  color: Color.fromRGBO(33, 52, 88, 1.0),
                  child: Image(image: AssetImage('assets/images/splash.png')),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _panel(ScrollController sc) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: buildPanel(sc),
    );
  }

  Widget buildPanel(ScrollController sc) {
    if (_selectedCarpark is HDBCarpark) {
      return HDBCarParkDetails(sc, _selectedCarpark.withPrice(), _modelLoader);
    } else if (_selectedCarpark is MallCarpark) {
      return MallCarParkDetails(sc, _selectedCarpark.withPrice(), _modelLoader);
    } else if (_selectedCarpark == null) {
      return Container();
    } else {
      return CarParkDetails(sc, _selectedCarpark, _modelLoader);
    }
  }
}
