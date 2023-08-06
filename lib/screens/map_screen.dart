import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'profile_dialog.dart';
import 'login_screen.dart';
import 'profile_widget.dart';
import 'map_screen.dart';
import 'package:zenlyapp/app_bar.dart';
import 'package:zenlyapp/floating_action_button.dart';
import 'package:zenlyapp/location_service.dart';
import 'package:zenlyapp/map_service.dart';
import 'package:zenlyapp/user_repository.dart';


class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LocationData? _currentLocation;
  Marker? _marker; // Изменено: добавлен знак вопроса после типа
  MapController _mapController = MapController();
  List<String> _friends = [];
  String _nickname = 'Аноним';
  String _currentUserId = '';

  final LocationService _locationService = LocationService();
  final UserRepository _userRepository = UserRepository();
  final MapService _mapService = MapService();

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  Future<void> _getLocation() async {
    _currentLocation = await _locationService.getLocation();
    _marker = (await _mapService.getMarker(_currentLocation))!;

    setState(() {
      _mapController.move(
        LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!),
        _mapController.zoom,
      );
    });
  }

  void _openProfileDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ProfileDialog(
          currentNickname: _nickname,
          friends: _friends,
          onSaveNickname: _handleNicknameSave,
          onSearchUser: _handleUserSearch,
          onSendFriendRequest: _handleFriendRequest,
        );
      },
    );
  }

  void _handleNicknameSave(String newNickname) {
    setState(() {
      _nickname = newNickname;
    });
  }

  Future<DocumentSnapshot?> _handleUserSearch(String nickname) async {
    return await _userRepository.findUserByNickname(nickname);
  }

  void _handleFriendRequest(String friendId) {
    _userRepository.sendFriendRequest(_currentUserId, friendId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        nickname: _nickname,
        friends: _friends,
        onSaveNickname: _handleNicknameSave,
        onSearchUser: _handleUserSearch,
        onSendFriendRequest: _handleFriendRequest,
      ),
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          center: _currentLocation != null
              ? LatLng(
              _currentLocation!.latitude!, _currentLocation!.longitude!)
              : LatLng(51.5074, -0.1278),
          zoom: 13.0,
        ),
        children: [
          TileLayer(
            tileProvider: NetworkTileProvider(),
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: ['a', 'b', 'c'],
          ),
          MarkerLayer(
            markers: _marker != null ? [_marker!] : [],
          ),
        ],
      ),
      floatingActionButton: CustomFloatingActionButton(
        onPressed: _getLocation,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}