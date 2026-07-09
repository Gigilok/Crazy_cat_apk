class AttackStatus {
  final bool isActive;
  final String targetSsid;
  final String attackType;
  final int progress;
  final String? capturedPassword;
  final int clientCount;

  AttackStatus({
    this.isActive = false,
    this.targetSsid = '',
    this.attackType = '',
    this.progress = 0,
    this.capturedPassword,
    this.clientCount = 0,
  });

  factory AttackStatus.fromJson(Map<String, dynamic> json) {
    return AttackStatus(
      isActive: json['ataque_ativo'] ?? false,
      targetSsid: json['ssid_alvo'] ?? '',
      attackType: json['tipo'] ?? '',
      progress: json['progresso'] ?? 0,
      capturedPassword: json['senha'],
      clientCount: json['clientes'] ?? 0,
    );
  }
}
