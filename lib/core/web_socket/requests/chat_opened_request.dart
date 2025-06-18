class ChatOpenedRequest {
  final String type;
  final String branchId;
  final String event;

  ChatOpenedRequest({this.type = 'chat', required this.branchId, required this.event});

  Map<String, dynamic> toJson() {
    return {
      "type": type,
      "branchId": branchId,
    };
  }
}
