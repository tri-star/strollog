import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:strollog/domain/map_info.dart';
import 'package:strollog/repositories/map_info_repository.dart';
import 'package:strollog/repositories/photo_repository.dart';
import 'package:strollog/services/auth_service.dart';

class PointEditFormStore extends ChangeNotifier {
  final MapInfoRepository _mapInfoRepository;
  final PhotoRepository _photoRepository;
  final AuthService _authService;

  Spot? _originalSpot;

  late MapInfo _mapInfo;

  late String _spotId;

  String title = '';
  String comment = '';

  final ImagePicker _picker;

  List<XFile> photos = [];

  bool _initialized = false;
  bool _interacted = false;
  bool _saving = false;

  bool get initialized => _initialized;
  bool get interacted => _interacted;
  bool get saving => _saving;

  PointEditFormStore(
      this._mapInfoRepository, this._photoRepository, this._authService)
      : _picker = ImagePicker();

  Future<void> init(MapInfo mapInfo, String spotId) async {
    _initialized = false;
    _mapInfo = mapInfo;
    _spotId = spotId;

    _originalSpot = await _mapInfoRepository.fetchSpot(mapInfo, spotId);
    title = _originalSpot!.title;
    comment = _originalSpot!.comment;
    photos = [];
    _initialized = true;
    notifyListeners();
  }

  void setInteracted(bool value) {
    _interacted = value;
    notifyListeners();
  }

  String? validateTitle(String? value) {
    if (value == null || value == '') {
      return 'タイトルを入力してください';
    }
    return null;
  }

  Future<void> save() async {
    var point = _originalSpot!.point;
    var originalPhotos = _originalSpot!.photos;
    var newMapPoint = Spot(title, point,
        comment: comment,
        newDate: _originalSpot!.date,
        userNameInfo: _originalSpot!.userNameInfo);

    _saving = true;
    notifyListeners();

    var uid = _authService.getUser().id;
    var uploadedPhotos =
        await _photoRepository.uploadPhotos(_mapInfo, uid, photos);

    newMapPoint.photos = originalPhotos;
    if (uploadedPhotos.length > 0) {
      newMapPoint.addPhotos(uploadedPhotos);
    }

    await _mapInfoRepository.updatePoint(_mapInfo, _spotId, newMapPoint);
    _saving = false;
    notifyListeners();
  }

  Future<void> pickImage() async {
    List<XFile>? newPhotos = await _picker.pickMultiImage();
    if (newPhotos == null) {
      return;
    }
    photos.addAll(newPhotos);
    notifyListeners();
  }

  @override
  operator ==(other) {
    if (identical(this, other)) return true;

    return other is PointEditFormStore &&
        title == other.title &&
        comment == other.comment &&
        photos == other.photos;
  }

  @override
  int get hashCode => hashValues(title, comment, photos);
}
