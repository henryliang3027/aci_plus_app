# ACI Plus App - lib/ 目錄結構文檔

## 概述

ACI Plus App 是一個基於 Flutter 開發的 ACI 設備管理應用程式，設備包含 1.8G/1.2G 放大器(AMP) 及 DSIM ，採用 BLoC
架構進行狀態管理。支援藍牙和 USB 連接，用於配置和監控設備。

## 項目架構

- **架構模式**: BLoC (Business Logic Component)
- **狀態管理**: flutter_bloc
- **本地資料庫**: Hive
- **多國語言**: flutter_localizations
- **主題**: adaptive_theme (支援深色/淺色模式)

## 開發規範

### 命名規範

- **BLoC**: `功能名稱_bloc.dart`、`功能名稱_event.dart`、`功能名稱_state.dart`
- **視圖**: `功能名稱_page.dart`（頁面）、`功能名稱_form.dart`（表單）
- **倉庫**: `功能名稱_repository.dart`

### 架構模式

- 採用 BLoC 模式進行狀態管理
- 使用 Repository 模式處理數據邏輯
- 視圖與邏輯分離，確保代碼可維護性

## 主要技術特性

### 連接方式

- **藍牙連接**: 支援 Android/iOS/Windows 平台藍牙通訊
- **USB 連接**: 支援 Android 通過 FTDI 晶片進行 USB 串行通訊

### 設備支援

- **AMP 設備**: 1.8G/1.2G 放大器
- **Node**: C-Cor Node 設備

### 功能特性

- **設備配置**: 完整的設備參數設定功能
- **狀態監控**: 即時設備狀態顯示，每 5 秒更新一次
- **數據圖表**: RF 輸出強度、數據日誌等圖表顯示
- **韌體更新**: 支援設備韌體升級
- **QR 碼**: QR 碼生成和掃描功能
- **多國語言**: 支援英文、西班牙文、法文、繁體中文

### 測試支援 (專案自動生成的目錄，無實作)

- 單元測試: `mocktail`、`bloc_test`
- 集成測試: `integration_test`
- 驅動測試: `flutter_driver`

## 版本資訊

- **當前版本**: 2.5.0+2
- **Flutter SDK**: >=3.4.0 <4.0.0
- **開發狀態**: 測試版本 (v2.5.0-beta9)

## 目錄結構

### `/lib/` - 根目錄

```
lib/
├── main.dart             # 應用程式入口點，初始化配置和依賴注入
├── app.dart              # 主應用程式組件，配置主題和路由
├── env_config.dart       # 環境配置文件
├── firebase_options.dart # Firebase 配置選項
```

### `/about/` - 關於頁面模組

```
about/
├── about_page.dart       # 應用程式關於頁面
├── about18_page.dart     # AMP 設備關於頁面
├── about18_form.dart     # AMP 關於表單組件
└── shared/
    └── constants.dart    # 關於頁面共用常數
```

### `/advanced/` - 進階設定模組

```
advanced/
├── bloc/                 # BLoC 狀態管理
│   ├── description_input/        # QR code 描述輸入功能
│   ├── qr_code_generator/        # QR code 生成功能
│   ├── setting18_advanced/       # AMP / Node 進階設定，責管理頁面中各種按鈕和操作的啟用/禁用狀態
│   ├── setting18_ccor_node_config_edit/ # Node 配置編輯
│   ├── setting18_config/         # AMP / Node 配置管理
│   ├── setting18_config_edit/    # AMP 配置編輯
│   ├── setting18_firmware_log/   # 韌體日誌管理
│   └── setting18_firmware_update/ # 韌體更新功能
└── view/                 # UI 視圖組件
    ├── description_input_form.dart    # QR碼描述輸入表單
    ├── description_input_page.dart    # QR碼描述輸入頁面
    ├── qr_code_generator_form.dart    # QR碼生成表單
    ├── qr_code_generator_page.dart    # QR碼生成頁面
    ├── qr_code_image_viewer.dart      # QR碼圖片查看器
    ├── qr_code_scanner.dart           # QR碼掃描器 (Android/iOS)
    ├── qr_code_scanner_win.dart       # QR碼掃描器 (Windows)
    ├── setting18_advanced_form.dart   # AMP進階設定表單
    ├── setting18_advanced_page.dart   # AMP進階設定頁面
    ├── setting18_advanced_tab_bar.dart # AMP進階設定標籤頁
    ├── setting18_config_edit_form.dart # AMP配置編輯表單
    ├── setting18_config_edit_page.dart # AMP配置編輯頁面
    ├── setting18_config_form.dart     # AMP / Node 配置管理表單
    ├── setting18_config_page.dart     # AMP / Node 配置管理頁面
    ├── setting18_config_tab_bar.dart  # AMP / Node 配置標籤頁
    ├── setting18_distribution_config_form.dart # 支線放大器配置表單
    ├── setting18_firmware_log_form.dart # 韌體日誌表單
    ├── setting18_firmware_log_page.dart # 韌體日誌頁面
    ├── setting18_firmware_page.dart   # 韌體管理主頁面
    ├── setting18_firmware_tabbar.dart # 韌體管理標籤頁
    ├── setting18_firmware_update_form.dart # 韌體更新表單
    ├── setting18_firmware_update_page.dart # 韌體更新頁面
    ├── setting18_mdu_config_form.dart # 多住戶單元(Multi Dwelling Unit ; MDU) 配置表單
    ├── setting18_node_config_edit_form.dart # Node 配置編輯表單
    ├── setting18_node_config_edit_page.dart # Node 配置編輯頁面
    ├── setting18_node_config_form.dart # Node 配置表單
    └── setting18_trunk_config_form.dart # 幹線放大器配置表單
```

### `/chart/` - 圖表與數據可視化模組

```
chart/
├── bloc/                 # 圖表數據狀態管理
│   ├── chart/                    # DSIM 圖表
│   ├── chart18/                  # AMP 圖表管理功能
│   ├── chart18_ccor_node/        # Node 圖表
│   ├── code_input/               # 人員代碼輸入功能
│   ├── data_log_chart/           # AMP 數據 log 圖表
│   ├── downloader18/             # AMP 數據 log 下載器
│   ├── downloader18_ccor_node/   # Node 數據 log 下載器
│   ├── downloader18_rf_out/      # AMP RF 輸出強度數據 log 下載器
│   └── rf_level_chart/           # AMP RF 輸出強度 log 圖表
├── shared/               # 圖表共用組件
│   ├── event1p8g_value.dart     # 事件數值處理
│   ├── message_dialog.dart      # 訊息對話框
│   └── share_file_widget.dart   # 文件分享組件
└── view/                 # 圖表視圖組件
    ├── chart18_ccor_node_form.dart   # Node 圖表表單
    ├── chart18_ccor_node_page.dart   # Node 圖表頁面
    ├── chart18_form.dart             # AMP 圖表表單
    ├── chart18_page.dart             # AMP 圖表頁面
    ├── chart18_tab_bar.dart          # AMP 圖表標籤頁
    ├── chart_form.dart               # DSIM 圖表表單
    ├── chart_page.dart               # DSIM 圖表頁面
    ├── code_input_form.dart          # 人員代碼輸入表單
    ├── code_input_page.dart          # 人員代碼輸入頁面
    ├── data_log_chart_page.dart      # AMP 數據 log 圖表頁面
    ├── data_log_chart_view.dart      # AMP 數據 log 圖表視圖
    ├── downloader18_ccor_node_form.dart # Node 數據 log 下載器表單
    ├── downloader18_ccor_node_page.dart # Node 數據 log 下載器頁面
    ├── downloader18_form.dart        # AMP 數據 log 下載器表單
    ├── downloader18_page.dart        # AMP 數據 log 下載器頁面
    ├── downloader18_rf_out_form.dart # AMP RF 輸出強度下載器表單
    ├── downloader18_rf_out_page.dart # AMP RF 輸出強度下載器頁面
    ├── full_screen_chart_form.dart   # 全螢幕圖表顯示表單
    ├── rf_level_chart_page.dart      # AMP RF 輸出強度頁面
    └── rf_level_chart_view.dart      # AMP RF 輸出強度視圖
```

### `/core/` - 核心功能模組

```
core/
├── command.dart                  # DSIM command 定義
├── command18.dart                # AMP command 定義
├── command18_c_core_node.dart    # Node 定義
├── common_enum.dart              # 通用 Enum 定義
├── control_item_*.dart           # 控制項目相關
├── crc16_calculate.dart          # CRC16 校驗計算
├── custom_dialog.dart            # 自定義對話框
├── custom_icons/                 # 自定義 Icon
├── custom_style.dart             # 自定義樣式，顏色，字體等等常數
├── data_key.dart                 # AMP / Node 鍵值定義
├── firmware_file_id.dart         # 韌體檔案驗證碼檢查表
├── form_status.dart              # 表單狀態管理
├── message_localization.dart     # 多國語言訊息轉換
├── notice_dialog.dart            # 通知對話框
├── pilot_channel.dart            # DSIM 導頻頻道
├── pulsator.dart                 # AMP / Node 的 Alarm 脈衝特效組件
├── secondary_tab_bar_theme.dart  # 次標籤欄主題
├── setting_items_table.dart      # AMP / Node 設定項目表格
├── setup_wizard_dialog.dart      # 設置嚮導對話框
├── shared_preference_key.dart    # 本地端資料儲存 share preference 方式儲存 DSIM 資料, Hive 版本
├── status_items_table.dart       # 狀態項目表格
├── utils.dart                    # 通用工具函數
└── working_mode_table.dart       # AMP 工作模式表格
```

### `/home/` - 主頁面模組

```
home/
├── bloc/                 # 主頁面狀態管理
│   ├── alarm_description/        # Alarm 描述功能
│   ├── home/                     # 主頁面邏輯
│   └── peripheral_selector/      # 外圍設備選擇器
└── views/                # 主頁面視圖
    ├── alarm_description_form.dart  # Alarm 描述表單，顯示設備 Alarm 詳細資訊
    ├── alarm_description_page.dart  # Alarm 描述頁面
    ├── home_bottom_navigation_bar.dart # DSIM 底部導航列
    ├── home_buttom_navigation_bar18.dart # AMP / Node 底部導航列 (包含 Alarm 脈衝功能)
    ├── home_form.dart               # 主頁面表單，整合所有設備功能頁面
    ├── home_page.dart               # 主頁面入口
    ├── peripheral_selector_form.dart # 藍牙設備選擇器表單
    └── peripheral_selector_page.dart # 藍牙設備選擇器頁面
```

### `/information/` - 資訊顯示模組

```
information/
├── bloc/                 # 資訊頁面狀態管理
│   ├── information/              # DSIM 資訊功能
│   ├── information18/            # AMP 資訊功能
│   ├── information18_ccor_node/  # Node 資訊功能
│   ├── information18_ccor_node_preset/ # Node preset 功能
│   ├── information18_preset/     # AMP 預設配置功能
│   ├── mode_input/               # 模式輸入功能
│   ├── theme/                    # 主題管理功能
│   └── warm_reset/               # 熱重啟功能
├── shared/               # 共用組件
│   ├── mode_Input_form.dart     # 模式輸入表單
│   ├── mode_Input_page.dart     # 模式輸入頁面
│   ├── mode_widget.dart         # 模式選擇組件
│   ├── theme_option_form.dart   # 主題選項表單 (淺色/深色/系統)
│   ├── theme_option_page.dart   # 主題選項頁面
│   ├── theme_option_widget.dart # 主題選項組件
│   ├── utils.dart               # 資訊頁面共用函數
│   └── warm_reset_widget.dart   # 熱重啟對話框組件
└── views/                # 資訊視圖
    ├── information18_ccor_node_config_list_view.dart # Node preset 清單視圖
    ├── information18_ccor_node_form.dart # Node 資訊表單
    ├── information18_ccor_node_page.dart # Node 資訊頁面
    ├── information18_ccor_node_preset_form.dart # Node preset 表單
    ├── information18_ccor_node_preset_page.dart # Node preset 頁面
    ├── information18_config_list_view.dart # AMP preset 清單視圖
    ├── information18_form.dart          # AMP 資訊表單
    ├── information18_page.dart          # AMP 資訊頁面
    ├── information18_preset_form.dart   # AMP preset 表單
    ├── information18_preset_page.dart   # AMP preset 頁面
    ├── information_form.dart            # DSIM 資訊表單
    ├── information_page.dart            # DSIM 資訊頁面
    ├── name_plate_view.dart             # 銘版圖視圖
    ├── warm_reset_form.dart             # 熱重啟表單
    └── warm_reset_page.dart             # 熱重啟頁面
```

### `/l10n/` - 多國語言模組

```
l10n/
├── app_en.arb           # 英文語言資源
├── app_es.arb           # 西班牙文語言資源
├── app_fr.arb           # 法文語言資源
└── app_zh.arb           # 繁體中文語言資源
```

### `/repositories/` - 數據倉庫模組

```
repositories/
├── aci_device_repository.dart    # 處理USB/BLE連接，處理 ACI 設備類型 AMP / Node
├── amp18_ccor_node_chart_cache.dart # Node 圖表數據快取
├── amp18_ccor_node_parser.dart   # Node 數據解析器
├── amp18_ccor_node_repository.dart # Node 設備倉庫
├── amp18_chart_cache.dart        # AMP 圖表數據快取
├── amp18_parser.dart             # AMP 數據解析器
├── amp18_repository.dart         # AMP 設備數據倉庫
├── ble_client.dart               # BLE 客戶端 (Android/iOS)
├── ble_command_mixin.dart        # BLE 命令混入類，提供設備參數設定功能
├── ble_peripheral.dart           # BLE dongle 狀態定義
├── ble_windows_client.dart       # Windows 平台 BLE 客戶端
├── code_repository.dart          # 人員代碼驗證倉庫
├── config.dart                   # 設備配置數據模型類別
├── config_repository.dart        # 配置檔案管理倉庫 (匯入/匯出)
├── connection_client.dart        # 連接客戶端抽象類別
├── connection_client_factory.dart # 連接客戶端工廠，自動選擇 USB 或 BLE
├── distribution_config.dart      # 支線放大器配置模型
├── distribution_config.g.dart    # 支線放大器配置序列化文件 (自動生成)
├── distribution_config_api.dart  # 支線放大器配置API
├── dongle.dart                   # Dongle 設備配置模型 (沒有用到了)
├── dongle.g.dart                 # Dongle 配置序列化文件 (自動生成) (沒有用到了)
├── dsim_parser.dart              # DSIM 數據解析器
├── dsim_repository.dart          # DSIM 設備數據倉庫
├── firmware_repository.dart      # 韌體更新管理倉庫
├── gps_repository.dart           # GPS 定位服務倉庫
├── mdu_config.dart               # MDU (多住戶單元) 配置模型
├── mdu_config.g.dart             # MDU 配置序列化文件 (自動生成)
├── mdu_config_api.dart           # MDU 配置API
├── mock/                         # 模擬數據目錄
│   ├── amp18_repository_data.dart    # AMP 模擬測試數據
│   ├── sample_aci_device_repository.dart # DSIM 模擬設備倉庫
│   └── sample_amp18_repository.dart  # AMP 模擬設備倉庫
├── node_config.dart              # Node 配置模型
├── node_config.g.dart            # Node 配置序列化文件 (自動生成)
├── node_config_api.dart          # Node 配置API
├── sample_data.dart              # 模擬測試數據
├── trunk_config.dart             # 幹線放大器配置模型
├── trunk_config.g.dart           # 幹線放大器配置序列化文件 (自動生成)
├── trunk_config_api.dart         # 幹線放大器配置API
├── unit_converter.dart           # 溫度單位轉換工具
├── unit_repository.dart          # 單位管理倉庫 (華氏/攝氏溫度)
└── usb_client.dart               # USB 客戶端 (FTDI串口通訊，僅限 Android)
```

### `/setting/` - 設定頁面模組

```
setting/
├── bloc/                 # 設定頁面狀態管理
│   ├── confirm_input/            # 確認輸入功能
│   ├── setting18/                # AMP18 基礎設定
│   ├── setting18_*_attribute/    # 屬性設定
│   ├── setting18_*_control/      # 控制設定
│   ├── setting18_*_graph_*/      # 圖形相關設定
│   ├── setting18_*_regulation/   # 調節設定
│   ├── setting18_*_threshold/    # 閾值設定
│   └── setting_list_view/        # 設定列表視圖
├── model/                # 設定頁面數據模型
│   ├── card_color.dart           # 卡片顏色
│   ├── confirm_input_dialog.dart # 確認輸入對話框
│   ├── custom_input.dart         # 自定義輸入
│   ├── formz_input_initializer.dart # 表單初始化器
│   ├── graph_module_form_color.dart # 圖形模組表單顏色
│   ├── pilot_code.dart           # 導頻代碼
│   ├── setting18_result_text.dart # AMP18 結果文本
│   ├── setting_widgets.dart      # 設定組件
│   └── svg_image.dart           # SVG 圖像
└── views/                # 設定視圖
    ├── circuit_painter.dart      # 電路繪製器
    ├── confirm_input_*.dart      # 確認輸入視圖
    ├── custom_setting_dialog.dart # 自定義設定對話框
    ├── setting18_ccor_node_views/ # C-Cor 節點設定視圖
    ├── setting18_views/          # AMP18 設定視圖
    └── setting_views/            # 基礎設定視圖
```

### `/status/` - 狀態監控模組

```
status/
├── bloc/                 # 狀態頁面狀態管理
│   ├── status/                   # 基礎狀態功能
│   ├── status18/                 # AMP18 狀態
│   └── status18_ccor_node/       # C-Cor 節點狀態
├── shared/               # 狀態頁面共用組件
│   └── utils.dart               # 狀態頁面共用函數
└── views/                # 狀態視圖
    ├── status18_ccor_node_form.dart # Node 狀態表單，顯示 Node 設備的各種狀態卡片
    ├── status18_ccor_node_page.dart # Node 狀態頁面
    ├── status18_form.dart           # AMP 狀態表單，顯示運行模式、工作模式、溫度、電壓等各種狀態卡片
    ├── status18_page.dart           # AMP 狀態頁面
    ├── status_form.dart             # DSIM 狀態表單，顯示溫度、衰減、電源供應等狀態卡片
    └── status_page.dart             # DSIM 狀態頁面
```
