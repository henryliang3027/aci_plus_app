import 'package:aci_plus_app/repositories/config.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ConfigApi {
  ConfigApi() : _configBox = Hive.box('UserData');
  final Box<Config> _configBox;
}
