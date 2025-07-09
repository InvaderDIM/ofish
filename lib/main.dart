// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:latlong2/latlong.dart';
//
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'OpenStreetMap Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: const MapPage(),
//     );
//   }
// }
//
// class MapPage extends StatelessWidget {
//   const MapPage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('OpenStreetMap на Flutter')),
//       body: FlutterMap(
//         options: MapOptions(
//           center: LatLng(46.623090, 14.307846),
//           zoom: 13,
//         ),
//         children: [
//           TileLayer(
//             // !!!!! urlTemplate: 'https://mapsneu.wien.gv.at/basemap/bmaphidpi/normal/google3857/{z}/{y}/{x}.jpg',
//             // urlTemplate: 'https://mapsneu.wien.gv.at/basemap/bmapgrau/normal/google3857/{z}/{y}/{x}.png',
//             // !!!!! urlTemplate: 'https://a.tile.openstreetmap.fr/hot/{z}/{x}/{y}.png https://b.tile.openstreetmap.fr/hot/{z}/{x}/{y}.png',
//             // urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
//             // !!!  urlTemplate: 'https://tile.openstreetmap.bzh/ca/{z}/{x}/{y}.png',
//             // urlTemplate: 'https://server.arcgisonline.com/ArcGIS/rest/services/World_Topo_Map/MapServer/tile/{z}/{y}/{x}',
//             urlTemplate: 'https://mapsneu.wien.gv.at/basemap/bmaphidpi/normal/google3857/{z}/{y}/{x}.jpg',
//             subdomains: ['a', 'b', 'c'],
//             userAgentPackageName: 'com.example.app',
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Map Style Switcher',
      home: MapScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  // Начальный стиль карты
  String _tileUrl = 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';

  // Доступные стили карт
  final Map<String, String> mapStyles = {
    'OSM Standard': 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
    'Good 1': 'https://mapsneu.wien.gv.at/basemap/bmaphidpi/normal/google3857/{z}/{y}/{x}.jpg',
    'Good 2': 'https://a.tile.openstreetmap.fr/hot/{z}/{x}/{y}.png https://b.tile.openstreetmap.fr/hot/{z}/{x}/{y}.png',
    'Good 3': 'https://tile.openstreetmap.bzh/ca/{z}/{x}/{y}.png',
    'Normal 1': 'https://mapsneu.wien.gv.at/basemap/bmapgrau/normal/google3857/{z}/{y}/{x}.png',
    'Normal 2': 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
    'Normal 3': 'https://server.arcgisonline.com/ArcGIS/rest/services/World_Topo_Map/MapServer/tile/{z}/{y}/{x}',
  };

  void _showStyleMenu() async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      builder: (context) => ListView(
        children: mapStyles.entries.map((entry) {
          return ListTile(
            title: Text(entry.key),
            onTap: () => Navigator.pop(context, entry.key),
          );
        }).toList(),
      ),
    );

    if (selected != null && mapStyles.containsKey(selected)) {
      setState(() {
        _tileUrl = mapStyles[selected]!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map with a style choice'),
        actions: [
          IconButton(
            icon: Icon(Icons.layers),
            onPressed: _showStyleMenu,
          ),
        ],
      ),
      body: FlutterMap(
        options: MapOptions(
          center: LatLng(46.623090, 14.307846),
          zoom: 13,
        ),
        children: [
          TileLayer(
            urlTemplate: _tileUrl,
            subdomains: ['a', 'b', 'c'],
            userAgentPackageName: 'com.example.mapapp',
          ),
        ],
      ),
    );
  }
}
