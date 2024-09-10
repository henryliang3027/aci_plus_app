int getDelayByRSSI(int rssi) {
  if (rssi > -65) {
    return 26;
  } else if (rssi < -65 && rssi >= -70) {
    return 27;
  } else if (rssi < -70 && rssi >= -75) {
    return 28;
  } else if (rssi < -75 && rssi >= -80) {
    return 29;
  } else {
    return 30;
  }
}
