class Bid {
  final String id;
  final String auctionId;
  final String bidderId;
  final String bidderName;
  final String? bidderCompany;
  final double amount;
  final DateTime timestamp;
  final bool isWinning;
  
  Bid({
    required this.id,
    required this.auctionId,
    required this.bidderId,
    required this.bidderName,
    this.bidderCompany,
    required this.amount,
    required this.timestamp,
    this.isWinning = false,
  });
}
