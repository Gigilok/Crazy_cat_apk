import 'package:flutter/material.dart';

class AppConstants {
  static const String appName = 'Crazy Cat v3.0';
  static const String appVersion = '3.0.0';
  static const String firmwareVersion = 'Crazy Cat v3.0';
  
  // ESP32 Default AP
  static const String esp32SSID = 'CrazyCat';
  static const String esp32Password = '12345678';
  static const String esp32DefaultIP = '192.168.4.1';
  static const int esp32WebPort = 80;
  
  // Bluetooth
  static const String btDeviceName = 'CrazyCat';
  static const String btServiceUUID = '0000ffe0-0000-1000-8000-00805f9b34fb';
  static const String btCharacteristicUUID = '0000ffe1-0000-1000-8000-00805f9b34fb';
  
  // Serial
  static const int serialBaudRate = 115200;
  static const int serialDataBits = 8;
  static const int serialStopBits = 1;
  
  // Timeouts
  static const Duration connectionTimeout = Duration(seconds: 10);
  static const Duration commandTimeout = Duration(seconds: 5);
  static const Duration scanTimeout = Duration(seconds: 15);
  
  // Camera defaults
  static const List<int> cameraPorts = [80, 8080, 554, 37777, 8000, 9000];
  static const List<String> cameraVendors = ['Dahua', 'Hikvision', 'Intelbras', 'IPCam', 'RTSP'];
  
  // RF Frequencies
  static const List<double> rfFrequencies = [
    300.0, 303.0, 304.0, 305.0, 310.0, 315.0, 318.0,
    330.0, 390.0, 418.0, 433.0, 433.92, 434.0, 
    868.0, 868.35, 915.0
  ];
  
  // Common RF Codes
  static const List<String> commonCodes = [
    '000000', 'FFFFFF', '123456', '654321', 
    '111111', '222222', '333333', '444444'
  ];
}

class AppColors {
  static const Color background = Color(0xFF0A0A0F);
  static const Color surface = Color(0xFF1A1A2E);
  static const Color primary = Color(0xFF00FF88);
  static const Color secondary = Color(0xFF00D4FF);
  static const Color accent = Color(0xFFFF006E);
  static const Color warning = Color(0xFFFFB703);
  static const Color error = Color(0xFFFF3333);
  static const Color textPrimary = Color(0xFFE0E0E0);
  static const Color textSecondary = Color(0xFF888888);
  static const Color success = Color(0xFF00FF88);
  static const Color danger = Color(0xFFFF3333);
}

class APIEndpoints {
  static const String status = '/api/status';
  static const String redes = '/api/redes';
  static const String ataques = '/api/ataques';
  static const String iniciar = '/api/iniciar';
  static const String parar = '/api/parar';
  static const String dados = '/api/dados';
  static const String mitm = '/api/mitm';
  static const String wps = '/api/wps';
  static const String mobile = '/mobile';
}

class SerialCommands {
  static const String up = 'up';
  static const String down = 'down';
  static const String select = 'ok';
  static const String back = 'back';
  static const String scanWiFi = 'scan_wifi';
  static const String scanBle = 'scan_ble';
  static const String scanCam = 'scan_cam';
  static const String deauth = 'deauth';
  static const String evilTwin = 'evil';
  static const String handshake = 'handshake';
  static const String wps = 'wps';
  static const String mitm = 'mitm';
  static const String rfScan = 'rf_scan';
  static const String rfJam = 'rf_jam';
  static const String rfCapture = 'rf_cap';
  static const String rfTx = 'rf_tx';
  static const String rfBrute = 'rf_brute';
  static const String camScan = 'cam_scan';
  static const String camBrute = 'cam_brute';
  static const String camReboot = 'cam_reboot';
  static const String camFreeze = 'cam_freeze';
  static const String status = 'status';
  static const String stop = 'stop';
  static const String reboot = 'reboot';
  static const String help = 'help';
  static const String ok = '[+]';
  static const String error = '[-]';
  static const String info = '[INFO]';
  static const String statusPrefix = '[STATUS]';
}

class ToolDescriptions {
  static const Map<String, Map<String, String>> tools = {
    'nRF24 Scanner': {
      'desc': 'Escaneia o espectro 2.4GHz usando nRF24L01+',
      'details': 'Detecta sinais em 126 canais (2.400-2.525 GHz). Útil para encontrar drones, mouse sem fio, controles RC e outros dispositivos 2.4GHz.',
      'usage': '1. Conecte o ESP32\n2. Selecione nRF24 Scanner\n3. Observe o espectro em tempo real\n4. Use UP/DOWN para navegar canais',
      'tech': 'nRF24L01+ | 2.4GHz | 126 canais | -82dBm sensibilidade',
    },
    'nRF24 Jammer': {
      'desc': 'Jammer de 2.4GHz via nRF24L01+',
      'details': 'Transmite ruído em todos os 126 canais do 2.4GHz. Pode interferir em WiFi, Bluetooth, drones, mouse/teclado sem fio.',
      'usage': '1. Selecione nRF24 Jammer\n2. Pressione SELECT para iniciar\n3. Pressione novamente para parar',
      'tech': 'nRF24L01+ | 2.4GHz Jamming | 2Mbps | PA_MAX',
    },
    'CC1101 Scanner': {
      'desc': 'Escaneia Sub-GHz (300-928 MHz)',
      'details': 'Monitora RSSI em frequências Sub-GHz. Útil para portões, alarmes, sensores 433/868/915 MHz.',
      'usage': '1. Selecione CC1101 Scanner\n2. Observe RSSI em tempo real\n3. Barra gráfica mostra intensidade do sinal',
      'tech': 'CC1101 | 300-928 MHz | OOK/ASK/FSK | -110dBm',
    },
    'CC1101 Capture': {
      'desc': 'Captura e replay de sinais RF',
      'details': 'Auto-detecta frequência ativa, captura sinal bruto (timings/levels) e permite replay. Suporta 5 slots de memória.',
      'usage': '1. SELECT para iniciar scan\n2. Aperte controle quando solicitado\n3. Sinal salvo automaticamente\n4. UP para transmitir sinal salvo',
      'tech': 'CC1101 | RAW capture | 500 samples | 5 slots',
    },
    'CC1101 FreqSweep': {
      'desc': 'Varredura de frequência Sub-GHz',
      'details': 'Varre faixa 300-928 MHz mostrando gráfico de RSSI. Útil para encontrar frequências desconhecidas.',
      'usage': '1. SELECT para iniciar/parar\n2. UP/DOWN ajusta step (0.1-10 MHz)\n3. Gráfico mostra atividade',
      'tech': 'CC1101 | Sweep 300-928MHz | Step ajustável',
    },
    'CC1101 BruteForce': {
      'desc': 'Força bruta em controles RF',
      'details': '6 modos: COMUM (codes conhecidos), DEBRUIJN (sequência ótima), FULL (todos 24-bit), SMART (DB+Comum+DeBruijn+Full), ROLLJAM (ataque relay), ROLLING-PWN (predição).',
      'usage': '1. SELECT para iniciar/parar\n2. UP muda modo\n3. DOWN muda frequência\n4. BACK para sair',
      'tech': 'CC1101 | 6 modos | PT2262/EV1527/Kaku/HT12E/V2/Nice',
    },
    'BLE Scan': {
      'desc': 'Escaneia dispositivos Bluetooth Low Energy',
      'details': 'Descobre dispositivos BLE próximos mostrando nome, RSSI e tipo de endereço. Útil para AirTags, wearables, sensores.',
      'usage': '1. Aguarde scan automático\n2. UP/DOWN navega dispositivos\n3. BACK para sair',
      'tech': 'ESP32 BLE | Active Scan | 3s intervalo',
    },
    'WiFi Scan': {
      'desc': 'Escaneia redes WiFi 2.4GHz',
      'details': 'Lista SSIDs, RSSI, canal e tipo de criptografia. Atualiza a cada 10 segundos.',
      'usage': '1. Scan automático ao entrar\n2. UP/DOWN navega redes\n3. SELECT para selecionar alvo',
      'tech': 'ESP32 WiFi | 2.4GHz | 14 canais | WPA/WPA2/WPA3',
    },
    'WiFi Connect': {
      'desc': 'Conecta a rede WiFi',
      'details': 'Conecta ESP32 a rede WiFi. Tenta senhas comuns automaticamente ou conecta em redes abertas.',
      'usage': '1. Escolha rede na lista\n2. SELECT para conectar\n3. Aguarde resultado',
      'tech': 'ESP32 STA | WPS | Brute common passwords',
    },
    'WiFi Deauth': {
      'desc': 'Ataque de desautenticação 802.11',
      'details': 'Envia frames de deauth para desconectar clientes de um AP. Requer ESP32 em modo STA.',
      'usage': '1. Selecione AP alvo\n2. SELECT para atacar\n3. SELECT para parar\n4. BACK para sair',
      'tech': '802.11 deauth | 15 pkts/burst | 19.5dBm',
    },
    'Sour Apple': {
      'desc': 'Spams BLE Apple pairing',
      'details': 'Transmite pacotes BLE falsos simulando AirPods, AirPods Pro, AppleTV, etc. Causa popups em iPhones próximos.',
      'usage': '1. SELECT para iniciar/parar\n2. Dispositivo fake muda automaticamente\n3. BACK para sair',
      'tech': 'BLE ADV | Apple AirPods protocol | 20ms interval',
    },
    'Evil Twin': {
      'desc': 'Rogue Access Point + Captive Portal',
      'details': 'Cria AP com mesmo SSID do alvo + portal cativo falso. Captura senhas digitadas. Salva em /senhas_capturadas.txt.',
      'usage': '1. Escaneie e selecione alvo\n2. Inicie Evil Twin\n3. Aguarde vítima conectar\n4. Senha aparece no display',
      'tech': 'Rogue AP | DNS hijack | HTML portal | SPIFFS storage',
    },
    'Handshake': {
      'desc': 'Captura WPA handshake (EAPOL)',
      'details': 'Captura pacotes EAPOL para crack offline. Salva em formato PCAP compatível com hashcat/aircrack.',
      'usage': '1. Selecione rede alvo\n2. Inicie captura\n3. Aguarde 4-way handshake\n4. Arquivo .pcap salvo em /handshakes/',
      'tech': 'Promiscuous mode | PCAP format | EAPOL filter',
    },
    'WPS Brute': {
      'desc': 'Força bruta em PIN WPS',
      'details': 'Testa PINs comuns e sequenciais no WPS. ESP32 não suporta WPS nativo, tenta como senha WPA.',
      'usage': '1. Selecione rede com WPS\n2. Inicie ataque\n3. Aguarde tentativas\n4. Resultado salvo em /wps_resultado.txt',
      'tech': 'WPS PIN | Common PINs | Sequential | 5s timeout',
    },
    'MITM': {
      'desc': 'Man-in-the-Middle (Offload)',
      'details': 'ESP32 não tem poder para MITM completo. Retorna comando para executar no celular via Termux/Kali.',
      'usage': '1. Selecione função MITM\n2. Use celular com Termux\n3. Execute: bettercap -iface wlan0',
      'tech': 'Offload | bettercap | Termux | Kali NetHunter',
    },
    'Scan Cameras': {
      'desc': 'Descobre câmeras IP na rede',
      'details': 'Varre subnet conectada procurando portas de câmera (80, 8080, 554, 37777, 8000, 9000). Detecta Dahua, Hikvision, Intelbras.',
      'usage': '1. Conecte a uma rede WiFi primeiro\n2. Inicie Scan Cameras\n3. Aguarde varredura 1-254\n4. Câmeras listadas com vendor',
      'tech': 'TCP scan | HTTP fingerprint | RTSP detect | 6 ports',
    },
    'Brute Cameras': {
      'desc': 'Força bruta em câmeras IP',
      'details': 'Testa credenciais comuns em câmeras descobertas. Dahua (admin/admin), Hikvision (admin/12345), Intelbras (admin/admin).',
      'usage': '1. Escaneie câmeras primeiro\n2. Inicie Brute\n3. Aguarde tentativas\n4. Credenciais exibidas ao encontrar',
      'tech': 'HTTP Basic Auth | 12 cred sets | Dahua/Hikvision/Intelbras API',
    },
    'Controle Cam': {
      'desc': 'Controle de câmeras hackeadas',
      'details': 'Reboot (reinicia câmera) ou Freeze (flood de auth falha para travar stream).',
      'usage': '1. Selecione câmera cracked\n2. SELECT alterna ações\n3. Ação 1: Reboot\n4. Ação 2: Freeze stream',
      'tech': 'Dahua API reboot | Hikvision ISAPI | Auth flood | HTTP',
    },
    'Sub-GHz DB': {
      'desc': 'Banco de dados de controles',
      'details': '24 marcas de portão (Peccinin, PPA, Garen, RCG, Pado, Seg, ECP, Intelbras, Omega, Stilus, Rossi, UniMotor) em 315/433 MHz.',
      'usage': '1. UP/DOWN navega marcas\n2. SELECT transmite code\n3. 5s de transmissão automática',
      'tech': '24 entries | 315/433 MHz | PT2262/EV1527',
    },
  };
}
