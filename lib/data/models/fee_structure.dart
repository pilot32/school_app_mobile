enum FeeType { tuition, transport, library, sports, laboratory, examination, development, other }

class FeeStructure {
  final String id;
  final String className;
  final String section;
  final Map<FeeType, double> fees;
  final String academicYear;
  final DateTime effectiveFrom;
  final DateTime? effectiveTo;
  final String? description;
  final DateTime createdAt;
  final DateTime updatedAt;

  FeeStructure({
    required this.id,
    required this.className,
    required this.section,
    required this.fees,
    required this.academicYear,
    required this.effectiveFrom,
    this.effectiveTo,
    this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  factory FeeStructure.fromJson(Map<String, dynamic> json) {
    Map<FeeType, double> feesMap = {};
    if (json['fees'] != null) {
      json['fees'].forEach((key, value) {
        feesMap[_mapFeeType(key)] = (value as num).toDouble();
      });
    }

    return FeeStructure(
      id: json['id'] ?? '',
      className: json['class_name'] ?? '',
      section: json['section'] ?? '',
      fees: feesMap,
      academicYear: json['academic_year'] ?? '',
      effectiveFrom: DateTime.parse(json['effective_from']),
      effectiveTo: json['effective_to'] != null ? DateTime.parse(json['effective_to']) : null,
      description: json['description'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, double> feesJson = {};
    fees.forEach((key, value) {
      feesJson[key.name] = value;
    });

    return {
      'id': id,
      'class_name': className,
      'section': section,
      'fees': feesJson,
      'academic_year': academicYear,
      'effective_from': effectiveFrom.toIso8601String(),
      'effective_to': effectiveTo?.toIso8601String(),
      'description': description,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  static FeeType _mapFeeType(String type) {
    switch (type.toLowerCase()) {
      case 'tuition':
        return FeeType.tuition;
      case 'transport':
        return FeeType.transport;
      case 'library':
        return FeeType.library;
      case 'sports':
        return FeeType.sports;
      case 'laboratory':
        return FeeType.laboratory;
      case 'examination':
        return FeeType.examination;
      case 'development':
        return FeeType.development;
      case 'other':
        return FeeType.other;
      default:
        return FeeType.other;
    }
  }

  double get totalFee {
    return fees.values.fold(0.0, (sum, fee) => sum + fee);
  }

  FeeStructure copyWith({
    String? id,
    String? className,
    String? section,
    Map<FeeType, double>? fees,
    String? academicYear,
    DateTime? effectiveFrom,
    DateTime? effectiveTo,
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return FeeStructure(
      id: id ?? this.id,
      className: className ?? this.className,
      section: section ?? this.section,
      fees: fees ?? this.fees,
      academicYear: academicYear ?? this.academicYear,
      effectiveFrom: effectiveFrom ?? this.effectiveFrom,
      effectiveTo: effectiveTo ?? this.effectiveTo,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
