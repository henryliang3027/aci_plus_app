//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <bluetooth_enable/bluetooth_enable_plugin_c_api.h>
#include <camera_checker/camera_checker_plugin_c_api.h>
#include <firebase_core/firebase_core_plugin_c_api.h>
#include <geolocator_windows/geolocator_windows.h>
#include <permission_handler_windows/permission_handler_windows_plugin.h>
#include <share_plus/share_plus_windows_plugin_c_api.h>
#include <universal_ble/universal_ble_plugin_c_api.h>
#include <url_launcher_windows/url_launcher_windows.h>
#include <webview_windows/webview_windows_plugin.h>
#include <win_outlook/win_outlook_plugin_c_api.h>

void RegisterPlugins(flutter::PluginRegistry* registry) {
  BluetoothEnablePluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("BluetoothEnablePluginCApi"));
  CameraCheckerPluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("CameraCheckerPluginCApi"));
  FirebaseCorePluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("FirebaseCorePluginCApi"));
  GeolocatorWindowsRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("GeolocatorWindows"));
  PermissionHandlerWindowsPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("PermissionHandlerWindowsPlugin"));
  SharePlusWindowsPluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("SharePlusWindowsPluginCApi"));
  UniversalBlePluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("UniversalBlePluginCApi"));
  UrlLauncherWindowsRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("UrlLauncherWindows"));
  WebviewWindowsPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("WebviewWindowsPlugin"));
  WinOutlookPluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("WinOutlookPluginCApi"));
}
