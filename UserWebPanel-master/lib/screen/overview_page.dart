import 'package:assingment/Planning_Pages/jmr.dart';
import 'package:assingment/Planning_Pages/quality_checklist.dart';
import 'package:assingment/Planning_Pages/safety_checklist.dart';
import 'package:assingment/overview/closure_report.dart';
import 'package:assingment/overview/daily_project.dart';
import 'package:assingment/overview/detailed_Eng.dart';
import 'package:assingment/overview/key_events.dart';
import 'package:assingment/overview/material_vendor.dart';
import 'package:assingment/overview/testing_report.dart';

import 'package:assingment/widget/style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../overview/depot_overview.dart';
import '../overview/monthly_project.dart';
import '../widget/custom_appbar.dart';

class OverviewPage extends StatefulWidget {
  String? cityName;
  String depoName;
  OverviewPage({super.key, required this.depoName, this.cityName});

  @override
  State<OverviewPage> createState() => _OverviewPageState();
}

class _OverviewPageState extends State<OverviewPage> {
  List<Widget> pages = [];
  // List<IconData> icondata = [
  //   Icons.search_off_outlined,
  //   Icons.play_lesson_rounded,
  //   Icons.chat_bubble_outline_outlined,
  //   Icons.book_online_rounded,
  //   Icons.notes,
  //   Icons.track_changes_outlined,
  //   Icons.domain_verification,
  //   Icons.list_alt_outlined,
  //   Icons.electric_bike_rounded,
  //   Icons.text_snippet_outlined,
  //   Icons.monitor_outlined,
  // ];
  List imagedata = [
    'assets/overview_image/overview.png',
    'assets/overview_image/project_planning.png',
    'assets/overview_image/resource.png',
    'assets/overview_image/daily_progress.png',
    'assets/overview_image/monthly.png',

    'assets/overview_image/detailed_engineering.png',
    'assets/overview_image/jmr.png',
    // 'assets/overview_image/safety.png',
    'assets/overview_image/safety.png',
    'assets/overview_image/quality.png',
    // 'assets/overview_image/testing_commissioning.png',
    'assets/overview_image/testing_commissioning.png',
    'assets/overview_image/closure_report.png',
    'assets/overview_image/easy_monitoring.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    List<String> desription = [
      'Overview of Project Progress Status of ${widget.depoName} EV Bus Charging Infra',
      'Project Planning & Scheduling Bus Depot Wise [Gant Chart] ',
      'Material Procurement & Vendor Finalization Status',
      'Submission of Daily Progress Report for Individual Project',
      'Monthly Project Monitoring & Review',

      'Detailed Engineering Of Project Documents like GTP, GA Drawing',
      // 'Tracking of Individual Project Progress (SI No 2 & 6 S1 No.link)',
      'Online JMR verification for projects',
      'Safety check list & observation',
      'FQP Checklist for Civil,Electrical work & Quality Checklist',
      // 'Quality check list & observation',
      // 'FQP Checklist for Civil & Electrical work',
      'Testing & Commissioning Reports of Equipment',
      'Closure Report',
      'Easy monitoring of O & M schedule for all the equipment of depots.',
    ];
    pages = [
      DepotOverview(
        cityName: widget.cityName,
        depoName: widget.depoName,
      ),
      KeyEvents(
        depoName: widget.depoName,
        cityName: widget.cityName,
      ),
      MaterialProcurement(
        cityName: widget.cityName,
        depoName: widget.depoName,
      ),
      // ResourceAllocation(
      //   depoName: widget.depoName,
      //   cityName: widget.cityName,
      // ),
      DailyProject(
        depoName: widget.depoName,
        cityName: widget.cityName,
      ),
      MonthlyProject(
        depoName: widget.depoName,
        cityName: widget.cityName,
      ),
      DetailedEng(
        cityName: widget.cityName,
        depoName: widget.depoName,
      ),
      // PlanningPage(
      //   cityName: widget.cityName,
      //   depoName: widget.depoName,
      // ),

      Jmr(
        cityName: widget.cityName,
        depoName: widget.depoName,
      ),
      SafetyChecklist(
        cityName: widget.cityName,
        depoName: widget.depoName,
      ),
      QualityChecklist(
        cityName: widget.cityName,
        depoName: widget.depoName,
      ),
      // KeyEvents(
      //   depoName: widget.depoName,
      //   cityName: widget.depoName,
      // ),
      TestingReport(
        cityName: widget.cityName,
        depoName: widget.depoName,
      ),
      ClosureReport(
        cityName: widget.cityName,
        depoName: widget.depoName,
      ),
      KeyEvents(
        depoName: widget.depoName,
        cityName: widget.depoName,
      ),
    ];
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: CustomAppBar(
            text: '${widget.cityName} / ${widget.depoName} / Overview Page ',
            haveSynced: false,
          )),
      body: GridView.count(
        crossAxisCount: 6,
        mainAxisSpacing: 10,
        childAspectRatio: 1.0,
        children: List.generate(desription.length, (index) {
          return cards(desription[index], imagedata[index], index);
        }),
      ),
    );
  }

  Widget cards(String desc, String image, int index) {
    return Padding(
      padding: const EdgeInsets.all(17.0),
      child: GestureDetector(
        onTap: (() {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => pages[index],
              ));
        }),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: blue),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 80,
                width: 80,
                child: Image.asset(image, fit: BoxFit.cover),
              ),
              const SizedBox(height: 5),
              Expanded(
                child: Text(
                  desc,
                  textAlign: TextAlign.center,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
