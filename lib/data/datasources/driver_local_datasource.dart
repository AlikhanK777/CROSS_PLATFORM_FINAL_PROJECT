import 'package:hive/hive.dart';
import '../models/custom_driver_model.dart';

class DriverLocalDatasource {
  static const String boxName = 'custom_drivers';

  Box<CustomDriver> get _box => Hive.box<CustomDriver>(boxName);

  List<CustomDriver> getAllDrivers() {
    return _box.values.toList();
  }

  Future<void> addDriver(CustomDriver driver) async {
    await _box.put(driver.id, driver);
  }

  Future<void> updateDriver(CustomDriver driver) async {
    await _box.put(driver.id, driver);
  }

  Future<void> deleteDriver(String id) async {
    await _box.delete(id);
  }

  CustomDriver? getDriver(String id) {
    return _box.get(id);
  }
}
