class PaymentModel{

  final String userId;
  final String invoice;
  final DateTime acceptedDate;
  final String bank;
  final String transactionRef;
  final DateTime date;
  final int packageMonth;
  final int status;
  final bool confirmed;
  final String email;
  final String depositedByName;

  PaymentModel({this.userId, this.invoice, this.acceptedDate, this.bank, this.transactionRef, this.date, this.packageMonth, this.status, this.confirmed, this.email, this.depositedByName});

  factory PaymentModel.fromJson(dynamic json){
    return PaymentModel(
      userId: json['userId'],
      acceptedDate: json['status']==1 ? DateTime.fromMicrosecondsSinceEpoch(json['acceptedDate'].microsecondsSinceEpoch) : null,
      bank: json['bank'],
      date: DateTime.fromMicrosecondsSinceEpoch(json['date'].microsecondsSinceEpoch),
      packageMonth: json['packageMonth'],
      status: json['status'],
      confirmed: json['confirmed'],
      invoice: json['invoice'],
      transactionRef: json['confirmed'] ? json['transactionRef'] : "",
      email: json['email'],
      depositedByName: json['depositedByName']
    );
  }

  Map<String, dynamic> toJson() =>
      {
        'userId': userId,
        'acceptedDate': acceptedDate,
        'bank': bank,
        'transactionRef': transactionRef,
        'date': date,
        'packageMonth': packageMonth,
        'status': status,
        'confirmed': confirmed,
        'invoice': invoice,
        'email': email,
        'depositedByName': depositedByName,
      };


}