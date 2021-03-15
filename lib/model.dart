class ModelCal {
  ModelCal({
    this.confidence,
    this.index,
    this.label,
  });

  final double confidence;
  final int index;
  final String label;

  factory ModelCal.fromJson(Map<dynamic, dynamic> json) => ModelCal(
        confidence: json["confidence"].toDouble(),
        index: json["index"],
        label: json["label"],
      );

  Map<String, dynamic> toJson() => {
        "confidence": confidence,
        "index": index,
        "label": label,
      };
}
