class AdminStatistics {
  final int totalDoctors;
  final int totalPatients;
  final int totalAppointments;
  final double monthlyRevenue;
  final int pendingDoctors;
  final int approvedDoctors;
  final int rejectedDoctors;

  AdminStatistics({
    required this.totalDoctors,
    required this.totalPatients,
    required this.totalAppointments,
    required this.monthlyRevenue,
    required this.pendingDoctors,
    required this.approvedDoctors,
    required this.rejectedDoctors,
  });

  factory AdminStatistics.fromMap(Map<String, dynamic> map) {
    return AdminStatistics(
      totalDoctors: map['totalDoctors'] ?? 0,
      totalPatients: map['totalPatients'] ?? 0,
      totalAppointments: map['totalAppointments'] ?? 0,
      monthlyRevenue: (map['monthlyRevenue'] ?? 0.0).toDouble(),
      pendingDoctors: map['pendingDoctors'] ?? 0,
      approvedDoctors: map['approvedDoctors'] ?? 0,
      rejectedDoctors: map['rejectedDoctors'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'totalDoctors': totalDoctors,
      'totalPatients': totalPatients,
      'totalAppointments': totalAppointments,
      'monthlyRevenue': monthlyRevenue,
      'pendingDoctors': pendingDoctors,
      'approvedDoctors': approvedDoctors,
      'rejectedDoctors': rejectedDoctors,
    };
  }
}