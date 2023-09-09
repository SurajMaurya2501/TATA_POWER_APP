import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';
import 'package:web_appllication/KeyEvents/key_eventsUser.dart';
import 'package:web_appllication/OverviewPages/closure_summary.dart';
import 'package:web_appllication/OverviewPages/closure_summary_table.dart';
import 'package:web_appllication/OverviewPages/monthly_summary.dart';
import 'package:web_appllication/OverviewPages/safety_summary.dart';
import '../Authentication/login_register.dart';
import '../KeyEvents/key_events.dart';
import '../OverviewPages/Jmr_screen/jmr.dart';
import '../OverviewPages/daily_project.dart';
import '../OverviewPages/depot_overview.dart';
import '../OverviewPages/detailed_Eng.dart';
import '../OverviewPages/material_vendor.dart';
import '../OverviewPages/quality_checklist.dart';
import '../OverviewPages/testing_report.dart';
import '../style.dart';

class CustomAppBar extends StatefulWidget {
  final String? text;
  String? userid;
  // final IconData? icon;
  final bool haveSynced;
  final bool haveSummary;
  final void Function()? store;
  VoidCallback? onTap;
  bool havebottom;
  bool isdetailedTab;
  bool isdownload;
  TabBar? tabBar;
  String? cityName;
  bool showDepoBar;
  bool toOverview;
  bool toPlanning;
  bool toMaterial;
  bool toSubmission;
  bool toMonthly;
  bool toDetailEngineering;
  bool toJmr;
  bool toSafety;
  bool toChecklist;
  bool toTesting;
  bool toClosure;
  bool toEasyMonitoring;
  bool toDaily;

  CustomAppBar(
      {super.key,
      this.text,
      this.userid,
      this.haveSynced = false,
      this.haveSummary = false,
      this.store,
      this.onTap,
      this.havebottom = false,
      this.isdownload = false,
      this.isdetailedTab = false,
      this.tabBar,
      this.cityName,
      this.showDepoBar = false,
      this.toOverview = false,
      this.toPlanning = false,
      this.toMaterial = false,
      this.toSubmission = false,
      this.toMonthly = false,
      this.toDetailEngineering = false,
      this.toJmr = false,
      this.toSafety = false,
      this.toChecklist = false,
      this.toTesting = false,
      this.toClosure = false,
      this.toEasyMonitoring = false,
      this.toDaily = false});

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  TextEditingController selectedDepoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: blue,
            title: Text(
              widget.text.toString(),
            ),
            actions: [
              widget.showDepoBar
                  ? Container(
                      padding: const EdgeInsets.all(5.0),
                      width: 200,
                      height: 30,
                      child: TypeAheadField(
                          animationStart: BorderSide.strokeAlignCenter,
                          suggestionsCallback: (pattern) async {
                            return await getDepoList(pattern);
                          },
                          itemBuilder: (context, suggestion) {
                            return ListTile(
                              title: Text(
                                suggestion.toString(),
                                style: const TextStyle(fontSize: 14),
                              ),
                            );
                          },
                          onSuggestionSelected: (suggestion) {
                            selectedDepoController.text = suggestion.toString();

                            widget.toDaily
                                ? Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DailyProject(
                                        depoName: suggestion.toString(),
                                        cityName: widget.cityName,
                                      ),
                                    ))
                                : widget.toOverview
                                    ? Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => DepotOverview(
                                            cityName: widget.cityName,
                                            depoName: suggestion.toString(),
                                          ),
                                        ))
                                    : widget.toPlanning
                                        ? Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  KeyEventsUser(
                                                depoName: suggestion.toString(),
                                                cityName: widget.cityName,
                                                userId: widget.userid,
                                              ),
                                            ))
                                        : widget.toMaterial
                                            ? Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      MaterialProcurement(
                                                    depoName:
                                                        suggestion.toString(),
                                                    cityName: widget.cityName,
                                                  ),
                                                ))
                                            : widget.toSubmission
                                                ? Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          DailyProject(
                                                        depoName: suggestion
                                                            .toString(),
                                                        cityName:
                                                            widget.cityName,
                                                      ),
                                                    ))
                                                : widget.toMonthly
                                                    ? Navigator.pushReplacement(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              MonthlySummary(
                                                            depoName: suggestion
                                                                .toString(),
                                                            cityName:
                                                                widget.cityName,
                                                            id: 'Monthly Summary',
                                                          ),
                                                        ))
                                                    : widget.toDetailEngineering
                                                        ? Navigator
                                                            .pushReplacement(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          DetailedEng(
                                                                    cityName: widget
                                                                        .cityName,
                                                                    depoName:
                                                                        suggestion
                                                                            .toString(),
                                                                  ),
                                                                ))
                                                        : widget.toJmr
                                                            ? Navigator
                                                                .pushReplacement(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              Jmr(
                                                                        cityName:
                                                                            widget.cityName,
                                                                        depoName:
                                                                            suggestion.toString(),
                                                                      ),
                                                                    ))
                                                            : widget.toSafety
                                                                ? Navigator
                                                                    .pushReplacement(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                          builder: (context) =>
                                                                              SafetySummary(
                                                                            cityName:
                                                                                widget.cityName,
                                                                            depoName:
                                                                                suggestion.toString(),
                                                                          ),
                                                                        ))
                                                                : widget.toChecklist
                                                                    ? Navigator.pushReplacement(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                          builder: (context) =>
                                                                              QualityChecklist(
                                                                            cityName:
                                                                                widget.cityName,
                                                                            depoName:
                                                                                suggestion.toString(),
                                                                          ),
                                                                        ))
                                                                    : widget.toTesting
                                                                        ? Navigator.pushReplacement(
                                                                            context,
                                                                            MaterialPageRoute(
                                                                              builder: (context) => TestingReport(
                                                                                cityName: widget.cityName,
                                                                                depoName: suggestion.toString(),
                                                                              ),
                                                                            ))
                                                                        : widget.toClosure
                                                                            ? Navigator.pushReplacement(
                                                                                context,
                                                                                MaterialPageRoute(
                                                                                  builder: (context) => ClosureSummaryTable(
                                                                                    depoName: suggestion.toString(),
                                                                                    cityName: widget.cityName,
                                                                                    id: 'Closure Report',
                                                                                  ),
                                                                                ))
                                                                            : widget.toEasyMonitoring
                                                                                ? Navigator.pushReplacement(
                                                                                    context,
                                                                                    MaterialPageRoute(
                                                                                      builder: (context) => KeyEvents(
                                                                                        depoName: suggestion.toString(),
                                                                                        cityName: widget.cityName,
                                                                                        userId: '',
                                                                                      ),
                                                                                    ))
                                                                                : ' ';
                          },
                          textFieldConfiguration: TextFieldConfiguration(
                            decoration: const InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              contentPadding: EdgeInsets.all(5.0),
                              hintText: 'Go To Depot',
                            ),
                            style: const TextStyle(
                              fontSize: 15,
                            ),
                            controller: selectedDepoController,
                          )),
                    )
                  : Container(),
              widget.isdownload
                  ? const Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(Icons.download),
                    )
                  : widget.haveSummary
                      ? Padding(
                          padding: const EdgeInsets.only(
                              right: 40, top: 10, bottom: 10),
                          child: Container(
                            height: 15,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.blue),
                            child: TextButton(
                                onPressed: widget.onTap,
                                child: Text(
                                  'View Summary',
                                  style: TextStyle(color: white, fontSize: 20),
                                )),
                          ),
                        )
                      : Container(),
              widget.haveSynced
                  ? Padding(
                      padding:
                          const EdgeInsets.only(right: 20, top: 10, bottom: 10),
                      child: Container(
                        height: 15,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.blue),
                        child: TextButton(
                            onPressed: () {
                              widget.store!();
                            },
                            child: Text(
                              'Sync Data',
                              style: TextStyle(color: white, fontSize: 20),
                            )),
                      ),
                    )
                  : Container(),
              Padding(
                  padding: const EdgeInsets.only(right: 40),
                  child: GestureDetector(
                      onTap: () {
                        onWillPop(context);
                      },
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/logout.png',
                            height: 20,
                            width: 20,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            widget.userid ?? '',
                            style: const TextStyle(fontSize: 18),
                          )
                        ],
                      ))),
            ],
            bottom: widget.havebottom
                ? TabBar(
                    labelColor: Colors.yellow,
                    labelStyle: buttonWhite,
                    unselectedLabelColor: white,

                    //indicatorSize: TabBarIndicatorSize.label,
                    indicator: MaterialIndicator(
                      horizontalPadding: 24,
                      bottomLeftRadius: 8,
                      bottomRightRadius: 8,
                      color: almostblack,
                      paintingStyle: PaintingStyle.fill,
                    ),

                    tabs: const [
                      Tab(text: "PSS"),
                      Tab(text: "RMU"),
                      Tab(text: "PSS"),
                      Tab(text: "RMU"),
                      Tab(text: "PSS"),
                      Tab(text: "RMU"),
                      Tab(text: "PSS"),
                      Tab(text: "RMU"),
                      Tab(text: "PSS"),
                    ],
                  )
                : widget.isdetailedTab
                    ? TabBar(
                        labelColor: Colors.yellow,
                        labelStyle: buttonWhite,
                        unselectedLabelColor: white,

                        //indicatorSize: TabBarIndicatorSize.label,
                        indicator: MaterialIndicator(
                          horizontalPadding: 24,
                          bottomLeftRadius: 8,
                          bottomRightRadius: 8,
                          color: almostblack,
                          paintingStyle: PaintingStyle.fill,
                        ),

                        tabs: const [
                          Tab(text: "RFC Drawings of Civil Activities"),
                          Tab(
                              text:
                                  "EV Layout Drawings of Electrical Activities"),
                          Tab(text: "Shed Lighting Drawings & Specification"),
                        ],
                      )
                    : widget.tabBar));
  }

  Future<bool> onWillPop(BuildContext context) async {
    bool a = false;
    await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              backgroundColor: white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
              content: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Close TATA POWER?",
                      style: subtitle1White,
                    ),
                    const SizedBox(
                      height: 36,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                            child: InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            height: 40,
                            decoration: BoxDecoration(
                              //color: blue,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            //color: blue,
                            child: Center(
                                child: Text(
                              "No",
                              style: button.copyWith(color: blue),
                            )),
                          ),
                        )),
                        Expanded(
                            child: InkWell(
                          onTap: () {
                            a = true;
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginRegister(),
                                ));
                            // exit(0);
                          },
                          child: Container(
                            height: 40,
                            decoration: BoxDecoration(
                              color: blue,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            //color: blue,
                            child: Center(
                                child: Text(
                              "Yes",
                              style: button,
                            )),
                          ),
                        ))
                      ],
                    )
                  ],
                ),
              ),
            ));
    return a;
  }

  Future<List<dynamic>> getDepoList(String pattern) async {
    List<dynamic> depoList = [];
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('DepoName')
        .doc(widget.cityName)
        .collection('AllDepots')
        .get();

    depoList = querySnapshot.docs.map((deponame) => deponame.id).toList();

    if (pattern.isNotEmpty) {
      depoList = depoList
          .where((element) => element
              .toString()
              .toUpperCase()
              .startsWith(pattern.toUpperCase()))
          .toList();
    }

    return depoList;
  }
}