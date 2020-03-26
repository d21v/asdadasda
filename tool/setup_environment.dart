import 'dart:convert';
import 'dart:io';

import 'package:asdadasda/configuration_keys.dart';

const _RELATIVE_PATH_TO_SOURCE_FROM_PROJECT_ROOT = "lib/";
const _ENVIRONMENT_FILE_NAME = ".env.dart";
const _LOCAL_ENVIRONMENT_FILE = "tool/debug_environment.json";

Future<void> main(List<String> arguments) async {
  final directory = Directory(_RELATIVE_PATH_TO_SOURCE_FROM_PROJECT_ROOT);
  if (await directory.exists()) {
    String configJson = await prepareConfig();
    File("${directory.path}$_ENVIRONMENT_FILE_NAME")
        .writeAsString('const Map<String, dynamic> ENVIRONMENT = $configJson;');
  } else {
    print("$directory does no exists. Please run script from project root dir");
  }
}

Future<String> prepareConfig() async {
  if (await File(_LOCAL_ENVIRONMENT_FILE).exists()) {
    print("Setup with local json");
    return await File(_LOCAL_ENVIRONMENT_FILE).readAsString();
  } else {
    print("Setup with environment variables");
    return jsonEncode({
      ConfigurationKeys.BASE_URL_KEY:
          Platform.environment[ConfigurationKeys.BASE_URL_KEY],
    });
  }
}
