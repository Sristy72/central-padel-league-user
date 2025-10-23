class CreatePaymentRequest {
  final String userId;
  final String league;
  final double amount;
  final String team;

  CreatePaymentRequest({
    required this.userId,
    required this.league,
    required this.amount,
    required this.team,
  });

  Map<String, dynamic> toJson() {
    return {'userId': userId, 'league': league, 'amount': amount, 'team': team};
  }
}
