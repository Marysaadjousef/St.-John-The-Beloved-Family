import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:habat_khardal/components/ranking_list_view.dart';
import '../constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../helper/show_snackbar.dart';

class RankingScreen extends StatefulWidget {
  const RankingScreen({super.key});
  static const String id = "RankingScreen";

  @override
  State<RankingScreen> createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen> {
  List<Map<String, dynamic>> sortedEntries = [];
  bool? usersFound;

  Future<void> getUsers() async {
    CollectionReference attendance =
        FirebaseFirestore.instance.collection(kAttendance);
    var attendanceCollection = await attendance.get();
    var attendanceMap = attendanceCollection.docs.isNotEmpty
        ? attendanceCollection.docs[0].data() as Map<String, dynamic>
        : {};

    var attendanceList = attendanceMap.entries.toList();

    attendanceList.sort((a, b) => b.value["count"].compareTo(a.value["count"]));

    int rank = 1;

    for (int index = 0; index < attendanceList.length; index++) {
      if (rank < 4) {
        if (index != 0 &&
            attendanceList[index].value["count"] !=
                attendanceList[index - 1].value["count"]) {
          rank += 1;
        }
        if (rank < 4) {
          sortedEntries.add({
            "name": attendanceList[index].key,
            "count": attendanceList[index].value["count"],
            "image": rank,
          });
        } else {
          sortedEntries.add({
            "name": attendanceList[index].key,
            "count": attendanceList[index].value["count"],
          });
        }
      } else {
        sortedEntries.add({
          "name": attendanceList[index].key,
          "count": attendanceList[index].value["count"],
        });
      }
    }

    CollectionReference users = FirebaseFirestore.instance.collection(kUsers);
    var usersCollection = await users.get();
    var usersMap = usersCollection.docs[0].data() as Map<String, dynamic>;
    List<String> l = [];
    for (var doc in usersMap.keys) {
      l.add(doc);
    }
    l.sort();
    l.remove("Abona Bvnoty");

    for (var userDoc in l) {
      // get the users that has no attendance history yet
      bool found = false;
      for (var doc in attendanceMap.keys) {
        if (doc == userDoc) {
          found = true;
          break;
        }
      }

      if (!found) {
        sortedEntries.add({"name": userDoc, "count": 0});
      }
    }
    usersFound = sortedEntries.isNotEmpty;

    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUsers().timeout(const Duration(seconds: 10), onTimeout: () {
      showSnackBar(context, "Check your internet connection!");
    });
  }

  @override
  Widget build(BuildContext context) {
    if (usersFound != null && usersFound!) {
      return Expanded(
        child: Column(
          children: [
            Expanded(child: RankingListView(users: sortedEntries)),
          ],
        ),
      );
    } else if (usersFound == null) {
      return const Expanded(
        child: Column(
          children: [
            Spacer(flex: 1),
            CircularProgressIndicator(),
            Spacer(flex: 2),
          ],
        ),
      );
    } else {
      return Column(
        children: [
          const Spacer(
            flex: 1,
          ),
          Text("No Users yet",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18.sp,
              )),
          const Spacer(
            flex: 1,
          ),
        ],
      );
    }
  }
}
