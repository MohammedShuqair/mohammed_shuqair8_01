class Mail {
  final String toAddress;
  final String subject;
  final String body;

  Mail({required this.toAddress, required this.subject, required this.body});
  static Mail mail = Mail(
      toAddress: "disa_2334@gmail.com", subject: "test", body: "test body");
}
