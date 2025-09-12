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
- **Repository**: `功能名稱_repository.dart`