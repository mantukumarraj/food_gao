class PaymentData {
  final String bankName;
  final String accountHolderName;
  final String ifscCode;
  final String accountNumber;

  PaymentData({
    required this.bankName,
    required this.accountHolderName,
    required this.ifscCode,
    required this.accountNumber,
  });
}
class Bank {

  final String name;
  final String logoUrl;

  Bank(this.name, this.logoUrl);
}