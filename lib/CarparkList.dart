import 'package:flutter/material.dart';
import 'package:hacknroll2021/Carpark.dart';
import 'package:hacknroll2021/DataSource.dart';

class CarparkList extends StatefulWidget {
  @override
  _CarparkListState createState() => _CarparkListState();
}

class _CarparkListState extends State<CarparkList> {
  Future<List<Carpark>> _carparkList;

  final _biggerFont = TextStyle(fontSize: 18.0);

  @override
  void initState() {
    super.initState();
    DataSource ds = new DataSource();
    _carparkList = ds.fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Carpark>>(
        future: _carparkList,
        builder: (BuildContext context, AsyncSnapshot<List<Carpark>> snapshot) {
          if (snapshot.hasData) {
            List<Carpark> data = snapshot.data;
            return ListView.builder(
                padding: EdgeInsets.all(16.0),
                itemBuilder: (context, i) {
                  if (i.isOdd) return Divider();

                  final index = i ~/ 2;
                  if (index >= data.length) {
                    return null;
                  }

                  return _buildRow(data[index]);
                });
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          } else {
            return CircularProgressIndicator();
          }
        });
  }

  Widget _buildRow(Carpark carpark) {
    return ListTile(
      title: Text(
        carpark.carparkId + " " + carpark.development,
        style: _biggerFont,
      ),
    );
  }
}
