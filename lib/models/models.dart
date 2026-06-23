

class User{
  String firstName;
  String lastName;
  String username;
  String email;
  String role;
  String status;

  User({
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.email,
    required this.role,
    required this.status
  });

  factory User.fromJson(Map<String, dynamic> jsonMap){

    return User(
      firstName: jsonMap['first_name'],
      lastName: jsonMap['last_name'],
      username: jsonMap['username'],
      email: jsonMap['email'],
      role: jsonMap['role'], //todo: add the role field to the backend.
      status: jsonMap['status']
    );
  }
}



class DashboardModel{

  final Map<String, dynamic> dashboardStats;
  final List<LoanApplication> recentApplications; //the first current applications

  DashboardModel({
    required this.dashboardStats,
    required this.recentApplications
  });


  factory DashboardModel.fromJson(Map<String, dynamic> jsonMap){
    
    List<LoanApplication> applications =  [];

    if(jsonMap.containsKey('recent_applications')){
      applications = List<dynamic>.from(jsonMap['recent_applications']!).map(
              (applicationMap) => LoanApplication.fromJson(applicationMap)).toList();
    }

    return DashboardModel(
      dashboardStats: Map<String,dynamic>.from(jsonMap['dashboard_stats']),
      recentApplications: applications
    );
  }
}



class LoanApplication{

  final String applicationId;
  final String studentId;
  final String studentName;
  double amountRequested;
  final String loanReason;
  String status;
  DateTime createdAt;
  DateTime? updatedAt;

  LoanApplication({
    required this.applicationId,
    required this.studentId,
    required this.studentName,
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
      studentName: jsonMap['student_name'],
      loanReason: jsonMap['loan_reason'] ?? '',
      amountRequested: (jsonMap['amount_requested'] as num).toDouble(),
      status: jsonMap['status'],
      createdAt: DateTime.parse(jsonMap['created_at']),
      updatedAt: jsonMap['updated_at'] == null ? null : DateTime.parse(jsonMap['updated_at'])
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

  factory Loan.fromJson(Map<String, dynamic> jsonMap) {

    return Loan(
      loanId: jsonMap['id'],
      studentId: jsonMap['student_id'],
      applicationId: jsonMap['application_id'],
      approvedAmount: (jsonMap['approved_amount'] as num).toDouble(),
      interestRate: (jsonMap['interest_rate'] as num).toDouble(),
      totalAmount: (jsonMap['total_amount'] as num).toDouble(),
      status: jsonMap['status'],
      nextPayment: null,
      createdAt: DateTime.parse(jsonMap['created_at']),
      updatedAt: jsonMap['updated_at'] != null ? DateTime.parse('updated_at') : null
    );
  }
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





class LoanApplicationInfo{

  //personal information
  final String firstNames;
  final String surname;
  final String gender;
  final String phoneNumber;
  final String email;
  final String ghanaCardNumber;
  final String nationality;

  //guardian information
  final String guardianName;
  final String guardianRelationship;
  final String guardianPhoneNumber;

  //academic information
  final String indexNumber;
  final String referenceNumber;
  final String program;
  final String department;
  final String level;


  LoanApplicationInfo({
    required this.firstNames,
    required this.surname,
    required this.gender,
    required this.phoneNumber,
    required this.email,
    required this.ghanaCardNumber,
    required this.nationality,

    required this.guardianName,
    required this.guardianRelationship,
    required this.guardianPhoneNumber,

    required this.referenceNumber,
    required this.indexNumber,
    required this.level,
    required this.program,
    required this.department,
  });


  String get fullName => '$surname $firstNames';

  factory LoanApplicationInfo.fromJson(Map<String, dynamic> jsonMap){

    return LoanApplicationInfo(
      firstNames: jsonMap['first_names'],
      surname: jsonMap['surname'],
      gender: jsonMap['gender'],
      phoneNumber: jsonMap['phone_number'],
      email: jsonMap['email'],
      ghanaCardNumber: jsonMap['ghana_card_number'],
      nationality: jsonMap['nationality'],

      guardianName: jsonMap['guardian_name'],
      guardianRelationship: jsonMap['guardian_relationship'],
      guardianPhoneNumber: jsonMap['guardian_phone_number'],

      referenceNumber: jsonMap['reference_number'],
      indexNumber: jsonMap['index_number'],
      level: jsonMap['level'],
      program: jsonMap['program'],
      department: jsonMap['department'],
    );
  }
}



class ApplicationReview{

  final String reviewId;
  final String status;
  final String reviewedBy;
  final String comments;
  final double approvedAmount;
  final String rejectionReason;
  final DateTime reviewedAt;

  ApplicationReview({
    required this.reviewId,
    required this.status,
    required this.reviewedBy,
    required this.comments,
    required this.approvedAmount,
    required this.rejectionReason,
    required this.reviewedAt
  });



  factory ApplicationReview.fromJson(Map<String, dynamic> jsonMap){
    return ApplicationReview(
      reviewId: jsonMap['id'],
      status: jsonMap['status'],
      reviewedBy: jsonMap['reviewed_by'],
      comments: jsonMap['comments'],
      approvedAmount: (jsonMap['approved_amount'] ?? 0 as num).toDouble(),
      rejectionReason: jsonMap['rejection_reason'],
      reviewedAt: DateTime.parse(jsonMap['reviewed_at'])
    );
  }
}


class ApplicationDocument{
  final String id;
  final String applicationId;
  final String studentId;
  final String documentType;
  final String fileUrl;
  final String status;
  final DocumentFraudDetectionAnalysis fraudAnalysis;
  final DateTime createdAt;
  final DateTime? updatedAt;


  ApplicationDocument({
    required this.id,
    required this.applicationId,
    required this.studentId,
    required this.documentType,
    required this.fileUrl,
    required this.status,
    required this.fraudAnalysis,
    required this.createdAt,
    required this.updatedAt
  });


  factory ApplicationDocument.fromJson(Map<String, dynamic> jsonMap){

    DocumentFraudDetectionAnalysis analysis = DocumentFraudDetectionAnalysis
        .fromJson(Map<String, dynamic>.from(jsonMap['fraud_detection_analysis']));

    return ApplicationDocument(
      id: jsonMap['id'],
      applicationId: jsonMap['application_id'],
      studentId: jsonMap['student_id'],
      documentType: jsonMap['document_type'],
      fileUrl: jsonMap['file_url'],
      status: jsonMap['status'],
      fraudAnalysis: analysis,
      createdAt: DateTime.parse(jsonMap['created_at']),
      updatedAt: jsonMap['updated_at'] == null ? null : DateTime.parse(jsonMap['updated_at'])
    );
  }
}

class DocumentFraudDetectionAnalysis{

  final String verificationStatus;
  final double ocrConfidence;
  final String riskLevel;
  final double riskScore;
  final List<String> indicators;
  final bool requiresManualReview;

  DocumentFraudDetectionAnalysis({
    required this.verificationStatus,
    required this.ocrConfidence,
    required this.riskLevel,
    required this.riskScore,
    required this.indicators,
    required this.requiresManualReview
  });

  factory DocumentFraudDetectionAnalysis.fromJson(Map<String, dynamic> jsonMap){

    Map<String, dynamic> fdMap = Map<String, dynamic>.from(jsonMap['fraud_detection']);

    String riskLevel = fdMap['risk_level'];
    double riskScore = (fdMap['risk_score'] as num).toDouble();

    List<String> indicators = List<String>.from(fdMap['indicators']);

    bool isManual = fdMap['requires_manual_review'] ?? true;

    return DocumentFraudDetectionAnalysis(
      verificationStatus: jsonMap['verification_status'],
      ocrConfidence: (jsonMap['ocr_confidence'] as num).toDouble(),
      riskLevel: riskLevel,
      riskScore: riskScore,
      indicators: indicators,
      requiresManualReview: isManual
    );
  }

}

