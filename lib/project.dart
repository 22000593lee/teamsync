import 'package:cloud_firestore/cloud_firestore.dart';

class Project {
  String leaderUid;
  String title;
  String duration;
  int members;
  String description;
  double progress;
  bool isCompleted;

  Project({
    required this.leaderUid,
    required this.title,
    required this.duration,
    required this.members,
    required this.description,
    required this.progress,
    required this.isCompleted,
  });

  factory Project.fromDocumentSnapshot(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    String startDateStr = data['startDate'];
    String endDateStr = data['endDate'];
    DateTime? startDate =
        startDateStr.isNotEmpty ? DateTime.parse(startDateStr) : null;
    DateTime? endDate =
        endDateStr.isNotEmpty ? DateTime.parse(endDateStr) : null;

    double progress = 0.0;
    if (startDate != null && endDate != null && startDate.isBefore(endDate)) {
      DateTime now = DateTime.now();
      int totalDays = endDate.difference(startDate).inDays;
      int elapsedDays = now.difference(startDate).inDays;
      progress = (elapsedDays / totalDays).clamp(0.0, 1.0);
    }

    return Project(
      leaderUid: data['leaderUid'],
      title: data['title'],
      duration: '$startDateStr ~ $endDateStr',
      members: data['members'],
      description: data['description'],
      progress: progress,
      isCompleted: progress != 1.0 ? false : true,
    );
  }
}
