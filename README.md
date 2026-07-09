# CrazyCat v3.0 - RF Hacking Controller

Aplicativo Flutter para controle remoto do dispositivo CrazyCat (ESP32) com funcionalidades de RF hacking, WiFi pentest, BLE e controle de cameras IP.

## Funcionalidades

### Conectividade
- **WiFi**: Conecta ao AP do ESP32 (SSID: `CrazyCat`, IP: `192.168.4.1`)
- **Bluetooth**: Pareamento Serial BT com o ESP32
- **USB Serial**: Conexao via cabo OTG

### Ferramentas RF
- CC1101 Scan (300-928MHz)
- CC1101 Jammer
- NRF24 Scan & Jammer (2.4GHz)
- SubGHz Database
- Replay Attack
- Raw TX/RX

### WiFi Pentest
- Scan de redes
- Evil Twin (Portal Cativo)
- Deauth Attack
- Handshake Capture (PCAP)
- WPS Brute Force
- MITM (Offload para celular)

### Camera Hacker
- Busca automatica de cameras IP
- Suporte Dahua, Hikvision, Intelbras
- Stream MJPEG ao vivo
- Controles PTZ (Pan/Tilt/Zoom)

### Outros
- Signal Manager (salvar/exportar sinais)
- Terminal Serial
- Interface Web Mobile integrada

## Dependencias

```yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^1.1.0
  flutter_bluetooth_serial: ^0.4.0
  flutter_usb_serial: ^0.5.0
  flutter_mjpeg: ^2.0.4
  provider: ^6.1.1
