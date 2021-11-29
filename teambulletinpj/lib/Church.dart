
class Church {
  const Church({
    required this.id,
    required this.churchName,
    required this.location,
    required this.callNumber,
    required this.imageURL,
    required this.master,
    required this.pastor,
    required this.memberList,
  });

  final String id;
  final String churchName;
  final String location;
  final String callNumber;
  final String imageURL;
  final String master;
  final String pastor;
  final List<String> memberList;

  @override
  String toString() => churchName;
}