import 'package:csv/csv.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:tflite_flutter/tflite_flutter.dart';

class ModelLoader {
  final _modelFile = 'model.tflite';
  final _featuresFile = 'assets/features.csv';

  Map<String, int> _ref;

  Interpreter _interpreter;

  ModelLoader();

  Future init() async {
    return Future.wait([_loadModel(), _loadFeatures()]);
  }

  Future _loadModel() async {
    _interpreter = await Interpreter.fromAsset(_modelFile);
    print("interpreter loaded successfully");
    return;
  }

  Future _loadFeatures() async {
    final myData = await rootBundle.loadString(_featuresFile);
    List<List<dynamic>> features =
        const CsvToListConverter().convert(myData, eol: '\n');
    features.removeAt(0);
    final Map<String, int> ref = {};
    for (var i = 0; i < features.length; i++) {
      ref[features[i][1]] = features[i][0];
    }
    _ref = ref;
    print("features loaded successfully");
  }

  int convertCarParkId(String id) {
    // Converts a car park ID to it's respective index value in ref
    return _ref[id];
  }

  int predict(String id, DateTime dt) {
    double day = (dt.weekday - 1).toDouble();
    double hour;
    if (dt.hour < 23) {
      hour = dt.hour.toDouble() + 1.0;
    } else {
      hour = 0.0;
    }
    int out = _predictData(id, day, hour).toInt();
    return out;
  }

  double _predictData(String id, double day, double hour) {
    int a = convertCarParkId(id);
    if (a == null) return -1;
    List<double> i = List<double>.filled(_ref.length, 0);
    i[0] = day;
    i[1] = hour;
    i[a] = 1;

    var output = List<int>(1).reshape([1, 1]);
    _interpreter.run(i, output);
    return output[0][0];
  }

  int getModelDim() {
    print(_interpreter.getInputTensors());
    print(_interpreter.getOutputTensors());
    return 1;
  }
}
