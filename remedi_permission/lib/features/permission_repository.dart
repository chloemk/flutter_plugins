import 'package:permission_handler/permission_handler.dart';
import 'package:remedi_permission/model/app_permission.dart';
import 'package:remedi_permission/repository/i_permission_repository.dart';

import '../model/app_permission.dart';
import '../repository/i_permission_repository.dart';

class PermissionRepository extends IPermissionRepository {
  PermissionRepository(AppPermission permission)
      : super(permission: permission);

  @override
  Future<bool> goToSettings() async {
    return await openAppSettings();
  }

  @override
  Future init() async {
    await readPermissionStatus();
  }

  @override
  bool get isDenied => status.isDenied || status.isRestricted;

  @override
  bool get isError => !isGranted && permission.mandatory;

  @override
  bool get isGranted => status.isGranted || status.isLimited;

  @override
  bool get isPermanentlyDenied => status.isPermanentlyDenied;

  @override
  Future<PermissionStatus> request() async {
    PermissionStatus status = await permission.permission.request();
    this.status = status;
    return status;
  }

  @override
  Future<PermissionStatus> readPermissionStatus() async {
    status = await permission.permission.status;
    return status;
  }
}
