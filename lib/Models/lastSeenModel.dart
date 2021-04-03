class LastSeenModel{
  final int type;
  final String like;
  final DateTime date;

  LastSeenModel({ this.type, this.like, this.date });

  factory LastSeenModel.fromJson(dynamic json) {
    return LastSeenModel(
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