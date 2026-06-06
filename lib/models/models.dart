
class User{
  String firstName;
  String lastName;
  String username;
  String role;
  String email;

  User({
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.email,
    required this.role
  });

  factory User.fromJson(Map<String, dynamic> jsonMap){

    return User(
      firstName: jsonMap['first_name'],
      lastName: jsonMap['last_name'],
      username: jsonMap['username'],
      email: jsonMap['email'],
      role: 'admin', //todo: add the role field to the backend.
    );
  }
}



class LoanApplication{

  final String applicationId;
  final String studentId;
  double amountRequested;
  final String loanReason;
  String status;
  DateTime createdAt;
  DateTime? updatedAt;

  LoanApplication({
    required this.applicationId,
    required this.studentId,
    required this.loanReason,
    required this.amountRequested,
    required this.status,
    required this.createdAt,
    this.updatedAt
  });


  factory LoanApplication.fromJson(Map<String, dynamic> jsonMap){
    return LoanApplication(
      applicationId: jsonMap['id'],
      studentId: jsonMap['student_id'],
      loanReason: jsonMap['loan_reason'] ?? '',
      amountRequested: (jsonMap['amount_requested'] as num).toDouble(),
      status: jsonMap['status'],
      createdAt: DateTime.parse(jsonMap['created_at']),
      updatedAt: jsonMap['updated_at'] == null ? null : DateTime.parse(jsonMap['updated_at']!)
    );
  }
}


String prettyFormat(String s){

  String formatted = '';

  if(s.contains('_')){
    formatted = formatted.replaceAll("_", " ");
  }

  return formatted.toUpperCase();
}


enum ApplicationStatus{

  UNKNOWN("unknown"),
  SUBMITTED("submitted"),
  UNDER_REVIEW("under_review"),
  REJECTED("rejected"),
  APPROVED("approved"),
  CANCELLED("cancelled");

  final String statusString;

  const ApplicationStatus(this.statusString);

  static ApplicationStatus fromStatusString(String statusString){

    for(var status in ApplicationStatus.values){
      if(status.statusString == statusString) return status;
    }

    return UNKNOWN;
  }
}


class Loan{
  String loanId;
  String studentId;
  String applicationId;
  double approvedAmount;
  double interestRate;
  double totalAmount;
  String status;
  DateTime? nextPayment;
  DateTime createdAt;
  DateTime? updatedAt;

  Loan({
    required this.loanId,
    required this.studentId,
    required this.applicationId,
    required this.approvedAmount,
    required this.interestRate,
    required this.totalAmount,
    required this.status,
    this.nextPayment,
    required this.createdAt,
    this.updatedAt,
  });
}



class LoanPayment{

  String paymentId;
  String loanId;
  String studentId;
  String paymentMethod;
  double amount;
  PaymentStatus status;
  DateTime createdAt;
  DateTime? updatedAt;

  LoanPayment({
    required this.paymentId,
    required this.loanId,
    required this.studentId,
    required this.paymentMethod,
    required this.amount,
    required this.status,
    required this.createdAt,
    required this.updatedAt
  });

}

enum PaymentMethod{

  UNKNOWN("unknown"),
  CASH("cash"),
  MOBILE_MONEY("mobile_money");

  final String methodString;

  const PaymentMethod(this.methodString);

  static PaymentMethod fromMethodString(String methodString){

    for(var method in PaymentMethod.values){
      if(method.methodString == methodString) return method;
    }

    return UNKNOWN;
  }
}

enum PaymentStatus{

  UNKNOWN("completed"),
  CONFIRMED("confirmed"),
  COMPLETED("completed");

  final String statusString;

  const PaymentStatus(this.statusString);

  static PaymentStatus fromStatusString(String statusString){

    for(var status in PaymentStatus.values){
      if(status.statusString == statusString) return status;
    }

    return UNKNOWN;
  }
}