import 'package:twake/models/globals/globals.dart';
import 'package:twake/models/socketio/socketio_room.dart';
import 'package:twake/services/service_bundle.dart';

class SynchronizationService {
  static late SynchronizationService _service;
  final _api = ApiService.instance;

  final _socketio = SocketIOService.instance;
  List<SocketIORoom> _subRooms = [];

  factory SynchronizationService({required bool reset}) {
    if (reset) {
      _service = SynchronizationService._();
    }
    return _service;
  }

  static SynchronizationService get instance => _service;

  SynchronizationService._();

  Future<List<SocketIORoom>> get socketIORooms async {
    final queryParameters = {
      'company_id': Globals.instance.companyId,
      'workspace_id': Globals.instance.workspaceId
    };
    final List<Map<String, dynamic>> result = await _api.get(
      endpoint: Endpoint.notificationRooms,
      queryParameters: queryParameters,
    );

    final rooms = result.map((r) => SocketIORoom.fromJson(json: r));

    return rooms.toList();
  }

  Future<Stream<SocketIOResource>> subscribeForChannels() async {
    const wsRooms = const [RoomType.channelsList, RoomType.directsList];

    // Unsubscribe from previous workspace
    for (final room in _subRooms.where((r) => wsRooms.contains(r.type))) {
      _socketio.unsubscribe(room: room.key);
    }
    // Request rooms for new workspace
    _subRooms = await socketIORooms;

    // Subscribe for new workspace
    for (final room in _subRooms.where((r) => wsRooms.contains(r.type))) {
      _socketio.subscribe(room: room.key);
    }

    return _socketio.resourceStream.where((r) {
      return r.type == ResourceType.channel ||
          r.type == ResourceType.channelActivity;
    });
  }

  Future<Stream<SocketIOResource>> subscribeToBadges() async {
    // TODO: implement subscription to badge updates
    return _socketio.resourceStream;
  }

  Stream<SocketIOEvent> subscribeToMessages({required String channelId}) {
    const chRooms = const [RoomType.channel, RoomType.direct];

    if (Globals.instance.isNetworkConnected)
      throw Exception('Shoud not be called with no active connection');

    // Unsubscribe from previous channels
    _subRooms.forEach((r) {
      if (chRooms.contains(r.type) && r.subscribed && r.id != channelId) {
        _socketio.unsubscribe(room: r.key);
        r.subscribed = false;
      }
    });

    // Make sure that channel rooms has been fetched before,
    // or you'll get Bad state
    final channelRoom = _subRooms
        .firstWhere((r) => r.type == RoomType.channel && r.id == channelId);

    // Subscribe, to new channel
    _socketio.subscribe(room: channelRoom.key);
    channelRoom.subscribed = true;

    return _socketio.eventStream;
  }
}