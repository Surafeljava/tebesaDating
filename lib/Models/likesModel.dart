class LikesModel{
  final int type;
  final String like;
  final DateTime date;

  LikesModel({ this.type, this.like, this.date });

  factory LikesModel.fromJson(dynamic json) {
    return LikesModel(
      type: json['type']!=null ? json['type'] : 0,
      like: json['like']!=null ? json['like'] : '',
      date: json['date']!=null ? DateTime.fromMicrosecondsSinceEpoch(json['date'].microsecondsSinceEpoch) : '',
    );
  }

  Map<String, dynamic> toJson() =>
      {
        'type': type,
        'like': like,
        'date': date,
      };
}