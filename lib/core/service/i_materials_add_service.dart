import 'package:login/core/model/my_app_materials.dart';

abstract class IMaterialsAddService {
  Future<MyAppUserMaterials> createMaterialsWithQr(
      {required String materialId,
      required int materialQr,
      required String materialClass,
      required String materiaName,
      required String materialDepartment,
      required String materialReceiver,
      required String materialDelivery,
      required DateTime materialPurchaseDate,
      required DateTime materialReturnDate});
}
