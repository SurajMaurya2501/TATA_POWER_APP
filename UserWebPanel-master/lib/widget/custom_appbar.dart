import 'package:assingment/overview/material_vendor.dart';
import 'package:assingment/widget/style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import '../Authentication/auth_service.dart';
import '../Authentication/login_register.dart';
import '../Planning_Pages/jmr.dart';
import '../Planning_Pages/quality_checklist.dart';
import '../Planning_Pages/safety_checklist.dart';
import '../overview/closure_report.dart';
import '../overview/daily_project.dart';
import '../overview/depot_overview.dart';
import '../overview/detailed_Eng.dart';
import '../overview/key_events.dart';
import '../overview/monthly_project.dart';
import '../overview/testing_report.dart';

class CustomAppBar extends StatefulWidget {
  String? cityname;
  String? text;
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

  // final IconData? icon;
  final bool haveSynced;
  final bool haveSummary;
  final void Function()? store;
  VoidCallback? onTap;
  bool havebottom;
  bool havedropdown;
  bool isdetailedTab;
  bool showDepoBar;

  TabBar? tabBar;

  CustomAppBar({
    this.cityname,
    super.key,
    this.text,
    this.haveSynced = false,
    this.haveSummary = false,
    this.store,
    this.onTap,
    this.havedropdown = false,
    this.havebottom = false,
    this.isdetailedTab = false,
    this.tabBar,
    this.showDepoBar = false,
    this.toChecklist = false,
    this.toTesting = false,
    this.toClosure = false,
    this.toEasyMonitoring = false,
    this.toSubmission = false,
    this.toOverview = false,
    this.toPlanning = false,
    this.toMaterial = false,
    this.toMonthly = false,
    this.toDetailEngineering = false,
    this.toJmr = false,
    this.toSafety = false,
  });

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  dynamic userId;
  TextEditingController selectedDepoController = TextEditingController();
  String? rangeStartDate = DateFormat.yMMMMd().format(DateTime.now());
  String selectedDepot = '';

  @override
  void initState() {
    getUserId().whenComplete(() {
      setState(() {});
    });
    super.initState();
  }

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
                            selectedDepot = suggestion.toString();
                            widget.toOverview
                                ? Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DepotOverview(
                                        cityName: widget.cityname,
                                        depoName: selectedDepot,
                                      ),
                                    ))
                                : widget.toPlanning
                                    ? Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => KeyEvents(
                                            depoName: suggestion,
                                            cityName: widget.cityname,
                                          ),
                                        ))
                                    : widget.toMaterial
                                        ? Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  MaterialProcurement(
                                                depoName: suggestion,
                                                cityName: widget.cityname,
                                              ),
                                            ))
                                        : widget.toSubmission
                                            ? Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      DailyProject(
                                                    depoName: suggestion,
                                                    cityName: widget.cityname,
                                                  ),
                                                ))
                                            : widget.toMonthly
                                                ? Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          MonthlyProject(
                                                        depoName: suggestion,
                                                        cityName:
                                                            widget.cityname,
                                                      ),
                                                    ))
                                                : widget.toDetailEngineering
                                                    ? Navigator.pushReplacement(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              DetailedEng(
                                                            cityName:
                                                                widget.cityname,
                                                            depoName:
                                                                suggestion,
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
                                                                    cityName: widget
                                                                        .cityname,
                                                                    depoName:
                                                                        suggestion,
                                                                  ),
                                                                ))
                                                        : widget.toSafety
                                                            ? Navigator
                                                                .pushReplacement(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              SafetyChecklist(
                                                                        cityName:
                                                                            widget.cityname,
                                                                        depoName:
                                                                            suggestion,
                                                                      ),
                                                                    ))
                                                            : widget.toChecklist
                                                                ? Navigator
                                                                    .pushReplacement(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                          builder: (context) =>
                                                                              QualityChecklist(
                                                                            cityName:
                                                                                widget.cityname,
                                                                            depoName:
                                                                                suggestion,
                                                                          ),
                                                                        ))
                                                                : widget.toTesting
                                                                    ? Navigator.pushReplacement(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                          builder: (context) =>
                                                                              TestingReport(
                                                                            cityName:
                                                                                widget.cityname,
                                                                            depoName:
                                                                                suggestion,
                                                                          ),
                                                                        ))
                                                                    : widget.toClosure
                                                                        ? Navigator.pushReplacement(
                                                                            context,
                                                                            MaterialPageRoute(
                                                                              builder: (context) => ClosureReport(
                                                                                depoName: suggestion,
                                                                                cityName: widget.cityname,
                                                                              ),
                                                                            ))
                                                                        : widget.toEasyMonitoring
                                                                            ? Navigator.pushReplacement(
                                                                                context,
                                                                                MaterialPageRoute(
                                                                                  builder: (context) => KeyEvents(
                                                                                    depoName: selectedDepot,
                                                                                    cityName: widget.cityname,
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
              const SizedBox(
                width: 10,
              ),
              widget.haveSummary
                  ? Padding(
                      padding:
                          const EdgeInsets.only(right: 10, top: 10, bottom: 10),
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
                          SizedBox(width: 5),
                          Text(
                            userId ?? '',
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
                                  builder: (context) => LoginRegister(),
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
        .doc(widget.cityname)
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

  Future<void> getUserId() async {
    await AuthService().getCurrentUserId().then((value) {
      userId = value;
    });
  }
}
