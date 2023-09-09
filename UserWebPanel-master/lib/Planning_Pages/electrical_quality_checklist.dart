import 'package:assingment/Planning_Pages/quality_checklist.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';
import '../QualityDatasource/qualityElectricalDatasource/quality_EP.dart';
import '../QualityDatasource/qualityElectricalDatasource/quality_acdb.dart';
import '../QualityDatasource/qualityElectricalDatasource/quality_cdi.dart';
import '../QualityDatasource/qualityElectricalDatasource/quality_charger.dart';
import '../QualityDatasource/qualityElectricalDatasource/quality_ci.dart';
import '../QualityDatasource/qualityElectricalDatasource/quality_cmu.dart';
import '../QualityDatasource/qualityElectricalDatasource/quality_ct.dart';
import '../QualityDatasource/qualityElectricalDatasource/quality_msp.dart';
import '../QualityDatasource/qualityElectricalDatasource/quality_pss.dart';
import '../QualityDatasource/qualityElectricalDatasource/quality_rmu.dart';
import '../components/loading_page.dart';
import '../model/quality_checklistModel.dart';
import '../widget/quality_list.dart';
import '../widget/style.dart';

late QualityPSSDataSource _qualityPSSDataSource;
late QualityrmuDataSource _qualityrmuDataSource;
late QualityctDataSource _qualityctDataSource;
late QualitycmuDataSource _qualitycmuDataSource;
late QualityacdDataSource _qualityacdDataSource;
late QualityCIDataSource _qualityCIDataSource;
late QualityCDIDataSource _qualityCDIDataSource;
late QualityMSPDataSource _qualityMSPDataSource;
late QualityChargerDataSource _qualityChargerDataSource;
late QualityEPDataSource _qualityEPDataSource;

List<dynamic> psstabledatalist = [];
List<dynamic> rmutabledatalist = [];
List<dynamic> cttabledatalist = [];
List<dynamic> cmutabledatalist = [];
List<dynamic> acdbtabledatalist = [];
List<dynamic> citabledatalist = [];
List<dynamic> cditabledatalist = [];
List<dynamic> msptabledatalist = [];
List<dynamic> chargertabledatalist = [];
List<dynamic> eptabledatalist = [];

class ElectricalQualityChecklist extends StatefulWidget {
  String? cityName;
  String? depoName;
  String? currentDate;
  String? userId;
  bool? isHeader;

  ElectricalQualityChecklist(
      {super.key,
      required this.cityName,
      required this.depoName,
      this.currentDate,
      required this.userId,
      this.isHeader = true});

  @override
  State<ElectricalQualityChecklist> createState() =>
      _ElectricalQualityChecklistState();
}

class _ElectricalQualityChecklistState
    extends State<ElectricalQualityChecklist> {
  List<QualitychecklistModel> qualitylisttable1 = <QualitychecklistModel>[];
  List<QualitychecklistModel> qualitylisttable2 = <QualitychecklistModel>[];
  List<QualitychecklistModel> qualitylisttable3 = <QualitychecklistModel>[];
  List<QualitychecklistModel> qualitylisttable4 = <QualitychecklistModel>[];
  List<QualitychecklistModel> qualitylisttable5 = <QualitychecklistModel>[];
  List<QualitychecklistModel> qualitylisttable6 = <QualitychecklistModel>[];
  List<QualitychecklistModel> qualitylisttable7 = <QualitychecklistModel>[];
  List<QualitychecklistModel> qualitylisttable8 = <QualitychecklistModel>[];
  List<QualitychecklistModel> qualitylisttable9 = <QualitychecklistModel>[];
  List<QualitychecklistModel> qualitylisttable10 = <QualitychecklistModel>[];
  List<QualitychecklistModel> qualitylisttable11 = <QualitychecklistModel>[];
  List<QualitychecklistModel> qualitylisttable12 = <QualitychecklistModel>[];

// late QualityChecklistDataSource _checklistDataSource;

  Stream? _stream;
  Stream? _stream1;
  Stream? _stream2;
  Stream? _stream3;
  Stream? _stream4;
  Stream? _stream5;
  Stream? _stream6;
  Stream? _stream7;
  Stream? _stream8;
  Stream? _stream9;
  Stream? _stream10;
  Stream? _stream11;
  late DataGridController _dataGridController;
  bool _isloading = true;
  int? _selectedIndex = 0;

  @override
  void initState() {
    super.initState();

    qualitylisttable1 = getData();
    _qualityPSSDataSource = QualityPSSDataSource(
        qualitylisttable1, widget.depoName!, widget.cityName!);
    _dataGridController = DataGridController();

    qualitylisttable2 = rmu_getData();
    _qualityrmuDataSource = QualityrmuDataSource(
        qualitylisttable2, widget.depoName!, widget.cityName!);
    _dataGridController = DataGridController();

    qualitylisttable3 = ct_getData();
    _qualityctDataSource = QualityctDataSource(
        qualitylisttable3, widget.depoName!, widget.cityName!);
    _dataGridController = DataGridController();

    qualitylisttable4 = cmu_getData();
    _qualitycmuDataSource = QualitycmuDataSource(
        qualitylisttable4, widget.depoName!, widget.cityName!);
    _dataGridController = DataGridController();

    qualitylisttable5 = acdb_getData();
    _qualityacdDataSource = QualityacdDataSource(
        qualitylisttable5, widget.depoName!, widget.cityName!);
    _dataGridController = DataGridController();

    qualitylisttable6 = ci_getData();
    _qualityCIDataSource = QualityCIDataSource(
        qualitylisttable6, widget.depoName!, widget.cityName!);
    _dataGridController = DataGridController();

    qualitylisttable7 = cdi_getData();
    _qualityCDIDataSource = QualityCDIDataSource(
        qualitylisttable7, widget.depoName!, widget.cityName!);
    _dataGridController = DataGridController();

    qualitylisttable8 = msp_getData();
    _qualityMSPDataSource = QualityMSPDataSource(
        qualitylisttable8, widget.depoName!, widget.cityName!);
    _dataGridController = DataGridController();

    qualitylisttable9 = charger_getData();
    _qualityChargerDataSource = QualityChargerDataSource(
        qualitylisttable9, widget.depoName!, widget.cityName!);
    _dataGridController = DataGridController();

    qualitylisttable10 = earth_pit_getData();
    _qualityEPDataSource = QualityEPDataSource(
        qualitylisttable10, widget.depoName!, widget.cityName!);
    _dataGridController = DataGridController();
    _isloading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 10,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            toolbarHeight: 20,
            bottom: TabBar(
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
              onTap: (value) {
                _selectedIndex = value;
                setState(() {});
              },
              tabs: const [
                Tab(text: "PSS"),
                Tab(text: "RMU"),
                Tab(text: "CT"),
                Tab(text: "CMU"),
                Tab(text: "ACDB"),
                Tab(text: "CI"),
                Tab(text: "CDI"),
                Tab(text: "MSP"),
                Tab(text: "CHARGER"),
                Tab(text: "EARTH PIT"),
              ],
            ),
          ),
          body: TabBarView(children: [
            upperScreen(),
            upperScreen(),
            upperScreen(),
            upperScreen(),
            upperScreen(),
            upperScreen(),
            upperScreen(),
            upperScreen(),
            upperScreen(),
            upperScreen(),
          ]),
        ));
  }

  upperScreen() {
    return _isloading
        ? LoadingPage()
        : StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('ElectricalQualityChecklistCollection')
                .doc('${widget.depoName}')
                .collection('widget.userId!')
                .doc(widget.currentDate)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      height: 80,
                      decoration: BoxDecoration(color: lightblue),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Image.asset('assets/Tata-Power.jpeg',
                                  height: 50, width: 100),
                              const Text('TATA POWER'),
                            ],
                          ),
                          Text(
                            title[int.parse(_selectedIndex.toString())],
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          const Text('TPCL /DIST/EV/CHECKLIST ')
                        ],
                      ),
                    ),
                    Container(
                        decoration: BoxDecoration(color: lightblue),
                        child: Row(
                          children: [
                            Column(
                              children: [
                                Container(
                                  color: lightblue,
                                  width: 625,
                                  padding: const EdgeInsets.all(3),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Container(
                                          width: 150,
                                          child: Text(
                                            'Employee Name',
                                          )),
                                      const SizedBox(width: 5),
                                      Expanded(
                                          child: Container(
                                              height: 30,
                                              child: widget.isHeader!
                                                  ? TextFormField(
                                                      decoration:
                                                          const InputDecoration(
                                                              contentPadding:
                                                                  EdgeInsets.only(
                                                                      top: 0,
                                                                      bottom: 0,
                                                                      left: 5)),
                                                      initialValue: snapshot
                                                              .data!
                                                              .data()
                                                              .toString()
                                                              .contains(
                                                                  'EmployeeName')
                                                          ? snapshot.data!.get(
                                                              'EmployeeName')
                                                          : 'Employee Name',
                                                      style: const TextStyle(
                                                          fontSize: 15),
                                                      onChanged: (value) {
                                                        empName = value;
                                                      },
                                                      onSaved: (newValue) {
                                                        empName =
                                                            newValue.toString();
                                                      },
                                                    )
                                                  : Container(
                                                      width: 120,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                          border: Border.all(
                                                              color: blue)),
                                                      child: Text(
                                                        snapshot.data!
                                                                .data()
                                                                .toString()
                                                                .contains(
                                                                    'EmployeeName')
                                                            ? snapshot.data!.get(
                                                                    'EmployeeName') ??
                                                                ''
                                                            : 'Employee Name',
                                                      )))),
                                    ],
                                  ),
                                ),
                                Container(
                                  color: lightblue,
                                  width: 625,
                                  padding: const EdgeInsets.all(3),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Container(
                                          width: 150,
                                          child: Text(
                                            'Doc No.:TPCL/ DIST-EV',
                                          )),
                                      SizedBox(width: 5),
                                      Expanded(
                                          child: Container(
                                              height: 30,
                                              child: widget.isHeader!
                                                  ? TextFormField(
                                                      decoration:
                                                          const InputDecoration(
                                                              contentPadding:
                                                                  EdgeInsets.only(
                                                                      top: 0,
                                                                      bottom: 0,
                                                                      left: 5)),
                                                      initialValue: snapshot
                                                              .data!
                                                              .data()
                                                              .toString()
                                                              .contains(
                                                                  'Dist EV')
                                                          ? snapshot.data!.get(
                                                                  'Dist EV') ??
                                                              ''
                                                          : 'Dist EV',
                                                      style: const TextStyle(
                                                          fontSize: 15),
                                                      onChanged: (value) {
                                                        distev = value;
                                                      },
                                                      onSaved: (newValue) {
                                                        distev =
                                                            newValue.toString();
                                                      },
                                                    )
                                                  : Container(
                                                      width: 120,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                          border: Border.all(
                                                              color: blue)),
                                                      child: Text(snapshot.data!
                                                              .data()
                                                              .toString()
                                                              .contains(
                                                                  'Dist EV')
                                                          ? snapshot.data!.get(
                                                                  'Dist EV') ??
                                                              ''
                                                          : 'Dist EV')))),
                                    ],
                                  ),
                                ),
                                Container(
                                  color: lightblue,
                                  width: 625,
                                  padding: const EdgeInsets.all(3),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Container(
                                          width: 150,
                                          child: Text(
                                            ' VENDOR NAME',
                                          )),
                                      SizedBox(width: 5),
                                      Expanded(
                                          child: Container(
                                              height: 30,
                                              child: widget.isHeader!
                                                  ? TextFormField(
                                                      decoration:
                                                          const InputDecoration(
                                                              contentPadding:
                                                                  EdgeInsets.only(
                                                                      top: 0,
                                                                      bottom: 0,
                                                                      left: 5)),
                                                      initialValue: snapshot
                                                              .data!
                                                              .data()
                                                              .toString()
                                                              .contains(
                                                                  'VendorName')
                                                          ? snapshot.data!.get(
                                                                  'VendorName') ??
                                                              ''
                                                          : 'VendorName',
                                                      style: const TextStyle(
                                                          fontSize: 15),
                                                      onChanged: (value) {
                                                        vendorname = value;
                                                      },
                                                      onSaved: (newValue) {
                                                        vendorname =
                                                            newValue.toString();
                                                      },
                                                    )
                                                  : Container(
                                                      width: 120,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                          border: Border.all(
                                                              color: blue)),
                                                      child: Text(snapshot.data!
                                                              .data()
                                                              .toString()
                                                              .contains(
                                                                  'VendorName')
                                                          ? snapshot.data!.get(
                                                                  'VendorName') ??
                                                              ''
                                                          : 'VendorName')))),
                                    ],
                                  ),
                                ),
                                Container(
                                  color: lightblue,
                                  width: 625,
                                  padding: const EdgeInsets.all(3),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Container(
                                          width: 150,
                                          child: Text(
                                            ' DATE',
                                          )),
                                      SizedBox(width: 5),
                                      Expanded(
                                          child: Container(
                                              height: 30,
                                              child: widget.isHeader!
                                                  ? TextFormField(
                                                      decoration:
                                                          const InputDecoration(
                                                              contentPadding:
                                                                  EdgeInsets.only(
                                                                      top: 0,
                                                                      bottom: 0,
                                                                      left: 5)),
                                                      initialValue: snapshot
                                                              .data!
                                                              .data()
                                                              .toString()
                                                              .contains('Date')
                                                          ? snapshot.data!.get(
                                                                  'Date') ??
                                                              ''
                                                          : 'Date',
                                                      style: const TextStyle(
                                                          fontSize: 15),
                                                      onChanged: (value) {
                                                        date = value;
                                                      },
                                                      onSaved: (newValue) {
                                                        date =
                                                            newValue.toString();
                                                      },
                                                    )
                                                  : Container(
                                                      width: 120,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                          border: Border.all(
                                                              color: blue)),
                                                      child: Text(
                                                        snapshot.data!
                                                                .data()
                                                                .toString()
                                                                .contains(
                                                                    'Date')
                                                            ? snapshot.data!.get(
                                                                    'Date') ??
                                                                ''
                                                            : 'Date',
                                                      )))),
                                    ],
                                  ),
                                )
                              ],
                              //   children: [
                              //     HeaderValue('Employee Name', '', empName ?? ''),
                              //     HeaderValue('Doc No.:TPCL/ DIST-EV', '', distev ?? ''),
                              //     HeaderValue('VENDOR NAME', '', vendorname ?? ''),
                              //     HeaderValue('DATE', '', date ?? ''),
                              //   ],
                              // ),
                              // Column(
                              //   children: [
                              //     HeaderValue('OLA NUMBER', '', olano ?? ''),
                              //     HeaderValue('PANEL SR NO.', '', panel ?? ''),
                              //     HeaderValue('DepotName', '', depotname ?? ''),
                              //     HeaderValue('CUSTOMER NAME', '', customername ?? ''),
                              //   ],
                            ),
                            Column(
                              children: [
                                Container(
                                  color: lightblue,
                                  width: 625,
                                  padding: const EdgeInsets.all(3),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Container(
                                          width: 150,
                                          child: Text(
                                            ' OLA NUMBER',
                                          )),
                                      SizedBox(width: 5),
                                      Expanded(
                                          child: Container(
                                              height: 30,
                                              child: widget.isHeader!
                                                  ? TextFormField(
                                                      decoration:
                                                          const InputDecoration(
                                                              contentPadding:
                                                                  EdgeInsets.only(
                                                                      top: 0,
                                                                      bottom: 0,
                                                                      left: 5)),
                                                      initialValue: snapshot
                                                              .data!
                                                              .data()
                                                              .toString()
                                                              .contains('OlaNo')
                                                          ? snapshot.data!.get(
                                                                  'OlaNo') ??
                                                              ''
                                                          : 'OlaNo',
                                                      style: const TextStyle(
                                                          fontSize: 15),
                                                      onChanged: (value) {
                                                        olano = value;
                                                      },
                                                      onSaved: (newValue) {
                                                        olano =
                                                            newValue.toString();
                                                      },
                                                    )
                                                  : Container(
                                                      width: 120,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                          border: Border.all(
                                                              color: blue)),
                                                      child: Text(snapshot.data!
                                                              .data()
                                                              .toString()
                                                              .contains('OlaNo')
                                                          ? snapshot.data!.get(
                                                                  'OlaNo') ??
                                                              ''
                                                          : 'OlaNo')))),
                                    ],
                                  ),
                                ),
                                Container(
                                  color: lightblue,
                                  width: 625,
                                  padding: const EdgeInsets.all(3),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Container(
                                          width: 150,
                                          child: Text(
                                            ' PANEL SR NO.',
                                          )),
                                      SizedBox(width: 5),
                                      Expanded(
                                          child: Container(
                                              height: 30,
                                              child: widget.isHeader!
                                                  ? TextFormField(
                                                      decoration:
                                                          const InputDecoration(
                                                              contentPadding:
                                                                  EdgeInsets.only(
                                                                      top: 0,
                                                                      bottom: 0,
                                                                      left: 5)),
                                                      initialValue: snapshot
                                                              .data!
                                                              .data()
                                                              .toString()
                                                              .contains(
                                                                  'PanelNo')
                                                          ? snapshot.data!.get(
                                                                  'PanelNo') ??
                                                              ''
                                                          : 'PanelNo',
                                                      style: const TextStyle(
                                                          fontSize: 15),
                                                      onChanged: (value) {
                                                        panel = value;
                                                      },
                                                      onSaved: (newValue) {
                                                        panel =
                                                            newValue.toString();
                                                      },
                                                    )
                                                  : Container(
                                                      width: 120,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                          border: Border.all(
                                                              color: blue)),
                                                      child: Text(
                                                        snapshot.data!
                                                                .data()
                                                                .toString()
                                                                .contains(
                                                                    'PanelNo')
                                                            ? snapshot.data!.get(
                                                                    'PanelNo') ??
                                                                ''
                                                            : 'PanelNo',
                                                      )))),
                                    ],
                                  ),
                                ),
                                Container(
                                  color: lightblue,
                                  width: 625,
                                  padding: const EdgeInsets.all(3),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Container(
                                          width: 150,
                                          child: Text(
                                            ' Depot Name',
                                          )),
                                      SizedBox(width: 5),
                                      Expanded(
                                          child: Container(
                                              height: 30,
                                              child: widget.isHeader!
                                                  ? TextFormField(
                                                      decoration:
                                                          const InputDecoration(
                                                              contentPadding:
                                                                  EdgeInsets.only(
                                                                      top: 0,
                                                                      bottom: 0,
                                                                      left: 5)),
                                                      initialValue: snapshot
                                                              .data!
                                                              .data()
                                                              .toString()
                                                              .contains(
                                                                  'DepotName')
                                                          ? snapshot.data!.get(
                                                                  'DepotName') ??
                                                              ''
                                                          : 'DepotName',
                                                      style: const TextStyle(
                                                          fontSize: 15),
                                                      onChanged: (value) {
                                                        depotname = value;
                                                      },
                                                      onSaved: (newValue) {
                                                        depotname =
                                                            newValue.toString();
                                                      },
                                                    )
                                                  : Container(
                                                      width: 120,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                          border: Border.all(
                                                              color: blue)),
                                                      child: Text(
                                                        snapshot.data!
                                                                .data()
                                                                .toString()
                                                                .contains(
                                                                    'DepotName')
                                                            ? snapshot.data!.get(
                                                                    'DepotName') ??
                                                                ''
                                                            : 'DepotName',
                                                      )))),
                                    ],
                                  ),
                                ),
                                Container(
                                  color: lightblue,
                                  width: 625,
                                  padding: const EdgeInsets.all(3),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Container(
                                          width: 150,
                                          child: Text(
                                            'CustomerName',
                                          )),
                                      SizedBox(width: 5),
                                      Expanded(
                                          child: Container(
                                              height: 30,
                                              child: widget.isHeader!
                                                  ? TextFormField(
                                                      decoration:
                                                          const InputDecoration(
                                                              contentPadding:
                                                                  EdgeInsets.only(
                                                                      top: 0,
                                                                      bottom: 0,
                                                                      left: 5)),
                                                      initialValue: snapshot
                                                              .data!
                                                              .data()
                                                              .toString()
                                                              .contains(
                                                                  'CustomerName')
                                                          ? snapshot.data!.get(
                                                                  'CustomerName') ??
                                                              ''
                                                          : 'CustomerName',
                                                      style: const TextStyle(
                                                          fontSize: 15),
                                                      onChanged: (value) {
                                                        customername = value;
                                                      },
                                                      onSaved: (newValue) {
                                                        customername =
                                                            newValue.toString();
                                                      },
                                                    )
                                                  : Container(
                                                      width: 120,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                          border: Border.all(
                                                              color: blue)),
                                                      child: Text(
                                                        snapshot.data!
                                                                .data()
                                                                .toString()
                                                                .contains(
                                                                    'CustomerName')
                                                            ? snapshot.data!.get(
                                                                    'CustomerName') ??
                                                                ''
                                                            : 'CustomerName',
                                                      )))),
                                    ],
                                  ),
                                )
                              ],
                            )
                          ],
                        )),
                    Expanded(
                      child: StreamBuilder(
                        stream: _selectedIndex == 0
                            ? _stream
                            : _selectedIndex == 1
                                ? _stream1
                                : _selectedIndex == 2
                                    ? _stream2
                                    : _selectedIndex == 3
                                        ? _stream3
                                        : _selectedIndex == 4
                                            ? _stream4
                                            : _selectedIndex == 5
                                                ? _stream5
                                                : _selectedIndex == 6
                                                    ? _stream6
                                                    : _selectedIndex == 7
                                                        ? _stream7
                                                        : _selectedIndex == 8
                                                            ? _stream8
                                                            : _selectedIndex ==
                                                                    9
                                                                ? _stream9
                                                                : _selectedIndex ==
                                                                        10
                                                                    ? _stream10
                                                                    : _stream11,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return LoadingPage();
                          }
                          if (!snapshot.hasData ||
                              snapshot.data.exists == false) {
                            return widget.isHeader!
                                ? SfDataGridTheme(
                                    data:
                                        SfDataGridThemeData(headerColor: blue),
                                    child: SfDataGrid(
                                      source: _selectedIndex == 0
                                          ? _qualityPSSDataSource
                                          : _selectedIndex == 1
                                              ? _qualityrmuDataSource
                                              : _selectedIndex == 2
                                                  ? _qualityctDataSource
                                                  : _selectedIndex == 3
                                                      ? _qualitycmuDataSource
                                                      : _selectedIndex == 4
                                                          ? _qualityacdDataSource
                                                          : _selectedIndex == 5
                                                              ? _qualityCIDataSource
                                                              : _selectedIndex ==
                                                                      6
                                                                  ? _qualityCDIDataSource
                                                                  : _selectedIndex ==
                                                                          7
                                                                      ? _qualityMSPDataSource
                                                                      : _selectedIndex ==
                                                                              8
                                                                          ? _qualityChargerDataSource
                                                                          : _qualityEPDataSource,
                                      // _selectedIndex == 10
                                      //     ? _qualityRoofingDataSource
                                      //     : _qualityPROOFINGDataSource,

                                      //key: key,
                                      allowEditing: true,
                                      frozenColumnsCount: 2,
                                      gridLinesVisibility:
                                          GridLinesVisibility.both,
                                      headerGridLinesVisibility:
                                          GridLinesVisibility.both,
                                      selectionMode: SelectionMode.single,
                                      navigationMode: GridNavigationMode.cell,
                                      columnWidthMode: ColumnWidthMode.auto,
                                      editingGestureType:
                                          EditingGestureType.tap,
                                      controller: _dataGridController,

                                      // onQueryRowHeight: (details) {
                                      //   return details.rowIndex == 0 ? 60.0 : 49.0;
                                      // },
                                      columns: [
                                        GridColumn(
                                          columnName: 'srNo',
                                          width: 80,
                                          autoFitPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 16),
                                          allowEditing: false,
                                          label: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            alignment: Alignment.center,
                                            child: Text('Sr No',
                                                overflow:
                                                    TextOverflow.values.first,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                    color: white)),
                                          ),
                                        ),
                                        GridColumn(
                                          width: 350,
                                          columnName: 'checklist',
                                          allowEditing: false,
                                          label: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            alignment: Alignment.center,
                                            child: Text('ACTIVITY',
                                                overflow:
                                                    TextOverflow.values.first,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                    color: white)),
                                          ),
                                        ),
                                        GridColumn(
                                          columnName: 'responsibility',
                                          width: 250,
                                          allowEditing: true,
                                          label: Container(
                                            padding: const EdgeInsets.all(8.0),
                                            alignment: Alignment.center,
                                            child: Text('RESPONSIBILITY',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                  color: white,
                                                )),
                                          ),
                                        ),
                                        GridColumn(
                                          columnName: 'Reference',
                                          allowEditing: true,
                                          width: 250,
                                          label: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            alignment: Alignment.center,
                                            child: Text('DOCUMENT REFERENCE',
                                                overflow:
                                                    TextOverflow.values.first,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                    color: white)),
                                          ),
                                        ),
                                        GridColumn(
                                          columnName: 'observation',
                                          allowEditing: true,
                                          width: 200,
                                          label: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            alignment: Alignment.center,
                                            child: Text('OBSERVATION',
                                                overflow:
                                                    TextOverflow.values.first,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                    color: white)),
                                          ),
                                        ),
                                        GridColumn(
                                          columnName: 'Upload',
                                          allowEditing: false,
                                          visible: true,
                                          width: 150,
                                          label: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            alignment: Alignment.center,
                                            child: Text('Upload',
                                                overflow:
                                                    TextOverflow.values.first,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                    color: white)),
                                          ),
                                        ),
                                        GridColumn(
                                          columnName: 'View',
                                          allowEditing: true,
                                          width: 150,
                                          label: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            alignment: Alignment.center,
                                            child: Text('View',
                                                overflow:
                                                    TextOverflow.values.first,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                    color: white)),
                                          ),
                                        ),
                                        // GridColumn(
                                        //   columnName: 'Delete',
                                        //   autoFitPadding:
                                        //       const EdgeInsets.symmetric(
                                        //           horizontal: 16),
                                        //   allowEditing: false,
                                        //   visible: true,
                                        //   width: 120,
                                        //   label: Container(
                                        //     padding: const EdgeInsets.symmetric(
                                        //         horizontal: 8.0),
                                        //     alignment: Alignment.center,
                                        //     child: Text('Delete Row',
                                        //         overflow:
                                        //             TextOverflow.values.first,
                                        //         style: TextStyle(
                                        //             fontWeight: FontWeight.bold,
                                        //             fontSize: 16,
                                        //             color: white)
                                        //         //    textAlign: TextAlign.center,
                                        //         ),
                                        //   ),
                                        // ),
                                      ],

                                      // stackedHeaderRows: [
                                      //   StackedHeaderRow(cells: [
                                      //     StackedHeaderCell(
                                      //         columnNames: ['SrNo'],
                                      //         child: Container(child: Text('Project')))
                                      //   ])
                                      // ],
                                    ),
                                  )
                                : Center(
                                    child: Container(
                                      padding: EdgeInsets.all(25),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          border: Border.all(color: blue)),
                                      child: const Text(
                                        '     No data available yet \n Please wait for admin process',
                                        style: TextStyle(
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  );
                          } else if (snapshot.hasData) {
                            alldata = '';
                            alldata = snapshot.data['data'] as List<dynamic>;
                            qualitylisttable1.clear();
                            alldata.forEach((element) {
                              qualitylisttable1
                                  .add(QualitychecklistModel.fromJson(element));
                              if (_selectedIndex == 0) {
                                _qualityPSSDataSource = QualityPSSDataSource(
                                    qualitylisttable1,
                                    widget.cityName!,
                                    widget.depoName!);
                                _dataGridController = DataGridController();
                              } else if (_selectedIndex == 1) {
                                _qualityrmuDataSource = QualityrmuDataSource(
                                    qualitylisttable2,
                                    widget.cityName!,
                                    widget.depoName!);
                                _dataGridController = DataGridController();
                              } else if (_selectedIndex == 2) {
                                _qualityctDataSource = QualityctDataSource(
                                    qualitylisttable3,
                                    widget.cityName!,
                                    widget.depoName!);
                                _dataGridController = DataGridController();
                              } else if (_selectedIndex == 3) {
                                _qualitycmuDataSource = QualitycmuDataSource(
                                    qualitylisttable4,
                                    widget.cityName!,
                                    widget.depoName!);
                                _dataGridController = DataGridController();
                              } else if (_selectedIndex == 4) {
                                _qualityacdDataSource = QualityacdDataSource(
                                    qualitylisttable5,
                                    widget.cityName!,
                                    widget.depoName!);
                                _dataGridController = DataGridController();
                              } else if (_selectedIndex == 5) {
                                _qualityCIDataSource = QualityCIDataSource(
                                    qualitylisttable6,
                                    widget.cityName!,
                                    widget.depoName!);
                                _dataGridController = DataGridController();
                              } else if (_selectedIndex == 6) {
                                _qualityCDIDataSource = QualityCDIDataSource(
                                    qualitylisttable7,
                                    widget.cityName!,
                                    widget.depoName!);
                                _dataGridController = DataGridController();
                              } else if (_selectedIndex == 7) {
                                _qualityMSPDataSource = QualityMSPDataSource(
                                    qualitylisttable8,
                                    widget.cityName!,
                                    widget.depoName!);
                                _dataGridController = DataGridController();
                              } else if (_selectedIndex == 8) {
                                _qualityChargerDataSource =
                                    QualityChargerDataSource(qualitylisttable9,
                                        widget.cityName!, widget.depoName!);
                                _dataGridController = DataGridController();
                              } else if (_selectedIndex == 9) {
                                _qualityEPDataSource = QualityEPDataSource(
                                    qualitylisttable10,
                                    widget.cityName!,
                                    widget.depoName!);
                                _dataGridController = DataGridController();
                              }
                              //  else if (_selectedIndex == 10) {
                              //   _qualityRoofingDataSource = QualityWCRDataSource(
                              //       qualitylisttable1,
                              //       widget.depoName!,
                              //       widget.cityName!);
                              //   _dataGridController = DataGridController();
                              // } else if (_selectedIndex == 11) {
                              //   _qualityPROOFINGDataSource =
                              //       QualityPROOFINGDataSource(qualitylisttable1,
                              //           widget.depoName!, widget.cityName!);
                              //   _dataGridController = DataGridController();
                              // }
                            });
                            return SfDataGridTheme(
                              data: SfDataGridThemeData(headerColor: blue),
                              child: SfDataGrid(
                                source: _selectedIndex == 0
                                    ? _qualityPSSDataSource
                                    : _selectedIndex == 1
                                        ? _qualityrmuDataSource
                                        : _selectedIndex == 2
                                            ? _qualityctDataSource
                                            : _selectedIndex == 3
                                                ? _qualitycmuDataSource
                                                : _selectedIndex == 4
                                                    ? _qualityacdDataSource
                                                    : _selectedIndex == 5
                                                        ? _qualityCIDataSource
                                                        : _selectedIndex == 6
                                                            ? _qualityCDIDataSource
                                                            : _selectedIndex ==
                                                                    7
                                                                ? _qualityMSPDataSource
                                                                : _selectedIndex ==
                                                                        8
                                                                    ? _qualityChargerDataSource
                                                                    : _qualityEPDataSource,
                                // : _selectedIndex ==
                                //         10
                                //     ? _qualityRoofingDataSource
                                // : _qualityPROOFINGDataSource,

                                //key: key,
                                allowEditing: true,
                                frozenColumnsCount: 2,
                                gridLinesVisibility: GridLinesVisibility.both,
                                headerGridLinesVisibility:
                                    GridLinesVisibility.both,
                                selectionMode: SelectionMode.single,
                                navigationMode: GridNavigationMode.cell,
                                columnWidthMode: ColumnWidthMode.auto,
                                editingGestureType: EditingGestureType.tap,
                                controller: _dataGridController,

                                // onQueryRowHeight: (details) {
                                //   return details.rowIndex == 0 ? 60.0 : 49.0;
                                // },
                                columns: [
                                  GridColumn(
                                    columnName: 'srNo',
                                    width: 80,
                                    autoFitPadding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    allowEditing: false,
                                    label: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      alignment: Alignment.center,
                                      child: Text('Sr No',
                                          overflow: TextOverflow.values.first,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: white)),
                                    ),
                                  ),
                                  GridColumn(
                                    width: 350,
                                    columnName: 'checklist',
                                    allowEditing: false,
                                    label: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      alignment: Alignment.center,
                                      child: Text('ACTIVITY',
                                          overflow: TextOverflow.values.first,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: white)),
                                    ),
                                  ),
                                  GridColumn(
                                    columnName: 'responsibility',
                                    width: 250,
                                    allowEditing: true,
                                    label: Container(
                                      padding: const EdgeInsets.all(8.0),
                                      alignment: Alignment.center,
                                      child: Text('RESPONSIBILITY',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: white,
                                          )),
                                    ),
                                  ),
                                  GridColumn(
                                    columnName: 'Reference',
                                    allowEditing: true,
                                    width: 250,
                                    label: Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 8.0),
                                      alignment: Alignment.center,
                                      child: Text('DOCUMENT REFERENCE',
                                          overflow: TextOverflow.values.first,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: white)),
                                    ),
                                  ),
                                  GridColumn(
                                    columnName: 'observation',
                                    allowEditing: true,
                                    width: 200,
                                    label: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      alignment: Alignment.center,
                                      child: Text('OBSERVATION',
                                          overflow: TextOverflow.values.first,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: white)),
                                    ),
                                  ),
                                  GridColumn(
                                    columnName: 'Upload',
                                    allowEditing: false,
                                    visible: true,
                                    width: 150,
                                    label: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      alignment: Alignment.center,
                                      child: Text('Upload.',
                                          overflow: TextOverflow.values.first,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: white)),
                                    ),
                                  ),
                                  GridColumn(
                                    columnName: 'View',
                                    allowEditing: true,
                                    width: 150,
                                    label: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      alignment: Alignment.center,
                                      child: Text('View',
                                          overflow: TextOverflow.values.first,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: white)),
                                    ),
                                  ),
                                  // GridColumn(
                                  //   columnName: 'Delete',
                                  //   autoFitPadding: const EdgeInsets.symmetric(
                                  //       horizontal: 16),
                                  //   allowEditing: false,
                                  //   width: 120,
                                  //   visible: true,
                                  //   label: Container(
                                  //     padding: const EdgeInsets.symmetric(
                                  //         horizontal: 8.0),
                                  //     alignment: Alignment.center,
                                  //     child: Text('Delete Row',
                                  //         overflow: TextOverflow.values.first,
                                  //         style: TextStyle(
                                  //             fontWeight: FontWeight.bold,
                                  //             fontSize: 16,
                                  //             color: white)
                                  //         //    textAlign: TextAlign.center,
                                  //         ),
                                  //   ),
                                  // ),
                                ],

                                // stackedHeaderRows: [
                                //   StackedHeaderRow(cells: [
                                //     StackedHeaderCell(
                                //         columnNames: ['SrNo'],
                                //         child: Container(child: Text('Project')))
                                //   ])
                                // ],
                              ),
                            );
                          } else {
                            // here w3e have to put Nodata page
                            return LoadingPage();
                          }
                        },
                      ),
                    ),
                    // widget.isHeader!!
                    //     ? Padding(
                    //         padding: const EdgeInsets.all(10.0),
                    //         child: Align(
                    //           alignment: Alignment.bottomRight,
                    //           child: FloatingActionButton(
                    //             child: Icon(Icons.add),
                    //             onPressed: (() {
                    //               if (_selectedIndex == 0) {
                    //                 qualitylisttable1.add(
                    //                   QualitychecklistModel(
                    //                     srNo: 1,
                    //                     checklist: 'checklist',
                    //                     responsibility: 'responsibility',
                    //                     reference: 'reference',
                    //                     observation: 'observation',
                    //                     // photoNo: 12345,
                    //                   ),
                    //                 );
                    //                 _qualityExcavationDataSource.buildDataGridRows();
                    //                 _qualityExcavationDataSource
                    //                     .updateDatagridSource();
                    //               } else if (_selectedIndex == 1) {
                    //                 qualitylisttable1.add(
                    //                   QualitychecklistModel(
                    //                     srNo: 1,
                    //                     checklist: 'checklist',
                    //                     responsibility: 'responsibility',
                    //                     reference: 'reference',
                    //                     observation: 'observation',
                    //                     // photoNo: 12345,
                    //                   ),
                    //                 );
                    //                 _qualityBackFillingDataSource.buildDataGridRows();
                    //                 _qualityBackFillingDataSource
                    //                     .updateDatagridSource();
                    //               } else if (_selectedIndex == 2) {
                    //                 qualitylisttable1.add(
                    //                   QualitychecklistModel(
                    //                     srNo: 1,
                    //                     checklist: 'checklist',
                    //                     responsibility: 'responsibility',
                    //                     reference: 'reference',
                    //                     observation: 'observation',
                    //                     // photoNo: 12345,
                    //                   ),
                    //                 );
                    //                 _qualityMassonaryDataSource.buildDataGridRows();
                    //                 _qualityMassonaryDataSource.updateDatagridSource();
                    //               } else if (_selectedIndex == 3) {
                    //                 qualitylisttable1.add(
                    //                   QualitychecklistModel(
                    //                     srNo: 1,
                    //                     checklist: 'checklist',
                    //                     responsibility: 'responsibility',
                    //                     reference: 'reference',
                    //                     observation: 'observation',
                    //                     // photoNo: 12345,
                    //                   ),
                    //                 );
                    //                 _qualityGlazzingDataSource.buildDataGridRows();
                    //                 _qualityGlazzingDataSource
                    //                     .updateDatagridSource();
                    //               } else if (_selectedIndex == 4) {
                    //                 qualitylisttable1.add(
                    //                   QualitychecklistModel(
                    //                     srNo: 1,
                    //                     checklist: 'checklist',
                    //                     responsibility: 'responsibility',
                    //                     reference: 'reference',
                    //                     observation: 'observation',
                    //                     // photoNo: 12345,
                    //                   ),
                    //                 );
                    //                 _qualityCeillingDataSource=.buildDataGridRows();
                    //                 _qualityCeillingDataSource=
                    //                     .updateDatagridSource();
                    //               } else if (_selectedIndex == 5) {
                    //                 qualitylisttable1.add(
                    //                   QualitychecklistModel(
                    //                     srNo: 1,
                    //                     checklist: 'checklist',
                    //                     responsibility: 'responsibility',
                    //                     reference: 'reference',
                    //                     observation: 'observation',
                    //                     // photoNo: 12345,
                    //                   ),
                    //                 );
                    //                 _QualityflooringDataSource.buildDataGridRows();
                    //                 _QualityflooringDataSource.updateDatagridSource();
                    //               } else if (_selectedIndex == 6) {
                    //                 qualitylisttable1.add(
                    //                   QualitychecklistModel(
                    //                     srNo: 1,
                    //                     checklist: 'checklist',
                    //                     responsibility: 'responsibility',
                    //                     reference: 'reference',
                    //                     observation: 'observation',
                    //                     // photoNo: 12345,
                    //                   ),
                    //                 );
                    //                 _qualityInspectionDataSource.buildDataGridRows();
                    //                 _qualityInspectionDataSource
                    //                     .updateDatagridSource();
                    //               } else if (_selectedIndex == 7) {
                    //                 qualitylisttable1.add(
                    //                   QualitychecklistModel(
                    //                     srNo: 1,
                    //                     checklist: 'checklist',
                    //                     responsibility: 'responsibility',
                    //                     reference: 'reference',
                    //                     observation: 'observation',
                    //                     // photoNo: 12345,
                    //                   ),
                    //                 );
                    //                 _qualityIroniteflooringDataSource.buildDataGridRows();
                    //                 _qualityIroniteflooringDataSource
                    //                     .updateDatagridSource();
                    //               } else if (_selectedIndex == 8) {
                    //                 qualitylisttable1.add(
                    //                   QualitychecklistModel(
                    //                     srNo: 1,
                    //                     checklist: 'checklist',
                    //                     responsibility: 'responsibility',
                    //                     reference: 'reference',
                    //                     observation: 'observation',
                    //                     // photoNo: 12345,
                    //                   ),
                    //                 );
                    //                 _qualityPaintingDataSource
                    //                     .buildDataGridRows();
                    //                 _qualityPaintingDataSource
                    //                     .updateDatagridSource();
                    //               } else if (_selectedIndex == 9) {
                    //                 qualitylisttable1.add(
                    //                   QualitychecklistModel(
                    //                     srNo: 1,
                    //                     checklist: 'checklist',
                    //                     responsibility: 'responsibility',
                    //                     reference: 'reference',
                    //                     observation: 'observation',
                    //                     // photoNo: 12345,
                    //                   ),
                    //                 );
                    //                _qualityPavingDataSource.buildDataGridRows();
                    //                _qualityPavingDataSource.updateDatagridSource();
                    //               }
                    //             }),
                    //           ),
                    //         ),
                    //       )
                    //     : Container()
                  ],
                );
              } else {
                return LoadingPage();
              }
            },
          );
  }
}

storeData(BuildContext context, String depoName, String currentDate) {
  Map<String, dynamic> pssTableData = Map();
  Map<String, dynamic> rmuTableData = Map();
  Map<String, dynamic> ctTableData = Map();
  Map<String, dynamic> cmuTableData = Map();
  Map<String, dynamic> acdbTableData = Map();
  Map<String, dynamic> ciTableData = Map();
  Map<String, dynamic> cdiTableData = Map();
  Map<String, dynamic> mspTableData = Map();
  Map<String, dynamic> chargerTableData = Map();
  Map<String, dynamic> epTableData = Map();

  for (var i in _qualityPSSDataSource.dataGridRows) {
    for (var data in i.getCells()) {
      if (data.columnName != 'button' ||
          data.columnName == 'View' ||
          data.columnName != 'Delete') {
        pssTableData[data.columnName] = data.value;
      }
    }

    psstabledatalist.add(pssTableData);
    pssTableData = {};
  }

  FirebaseFirestore.instance
      .collection('QualityChecklist')
      .doc(depoName)
      .collection('PSS TABLE DATA')
      .doc('PSS')
      .collection(userId)
      .doc(currentDate)
      .set({
    'data': psstabledatalist,
  }).whenComplete(() {
    psstabledatalist.clear();
    for (var i in _qualityrmuDataSource.dataGridRows) {
      for (var data in i.getCells()) {
        if (data.columnName != 'button' ||
            data.columnName == 'View' ||
            data.columnName != 'Delete') {
          rmuTableData[data.columnName] = data.value;
        }
      }
      rmutabledatalist.add(rmuTableData);
      rmuTableData = {};
    }

    FirebaseFirestore.instance
        .collection('QualityChecklist')
        .doc(depoName)
        .collection('RMU TABLE DATA')
        .doc('RMU')
        .collection(userId)
        .doc(currentDate)
        .set({
      'data': rmutabledatalist,
    }).whenComplete(() {
      rmutabledatalist.clear();
      for (var i in _qualityctDataSource.dataGridRows) {
        for (var data in i.getCells()) {
          if (data.columnName != 'button' ||
              data.columnName == 'View' ||
              data.columnName != 'Delete') {
            ctTableData[data.columnName] = data.value;
          }
        }

        cttabledatalist.add(ctTableData);
        ctTableData = {};
      }

      FirebaseFirestore.instance
          .collection('QualityChecklist')
          .doc(depoName)
          .collection('CONVENTIONAL TRANSFORMER TABLE DATA')
          .doc('CONVENTIONAL TRANSFORMER')
          .collection(userId)
          .doc(currentDate)
          .set({
        'data': cttabledatalist,
      }).whenComplete(() {
        cttabledatalist.clear();
        for (var i in _qualitycmuDataSource.dataGridRows) {
          for (var data in i.getCells()) {
            if (data.columnName != 'button' ||
                data.columnName == 'View' ||
                data.columnName != 'Delete') {
              cmuTableData[data.columnName] = data.value;
            }
          }
          cmutabledatalist.add(cmuTableData);
          cmuTableData = {};
        }

        FirebaseFirestore.instance
            .collection('QualityChecklist')
            .doc(depoName)
            .collection('CTPT METERING UNIT TABLE DATA')
            .doc('CTPT METERING UNIT')
            .collection(userId)
            .doc(currentDate)
            .set({
          'data': cmutabledatalist,
        }).whenComplete(() {
          cmutabledatalist.clear();
          for (var i in _qualityacdDataSource.dataGridRows) {
            for (var data in i.getCells()) {
              if (data.columnName != 'button' || data.columnName != 'Delete') {
                acdbTableData[data.columnName] = data.value;
              }
            }
            acdbtabledatalist.add(acdbTableData);
            acdbTableData = {};
          }

          FirebaseFirestore.instance
              .collection('QualityChecklist')
              .doc(depoName)
              .collection('ACDB TABLE DATA')
              .doc('ACDB DATA')
              .collection(userId)
              .doc(currentDate)
              .set({
            'data': acdbtabledatalist,
          }).whenComplete(() {
            acdbtabledatalist.clear();
            for (var i in _qualityCIDataSource.dataGridRows) {
              for (var data in i.getCells()) {
                if (data.columnName != 'button' ||
                    data.columnName == 'View' ||
                    data.columnName != 'Delete') {
                  ciTableData[data.columnName] = data.value;
                }
              }
              citabledatalist.add(ciTableData);
              ciTableData = {};
            }

            FirebaseFirestore.instance
                .collection('QualityChecklist')
                .doc(depoName)
                .collection('CABLE INSTALLATION TABLE DATA')
                .doc('CABLE INSTALLATION')
                .collection(userId)
                .doc(currentDate)
                .set({
              'data': citabledatalist,
            }).whenComplete(() {
              citabledatalist.clear();
              for (var i in _qualityCDIDataSource.dataGridRows) {
                for (var data in i.getCells()) {
                  if (data.columnName != 'button' ||
                      data.columnName == 'View' ||
                      data.columnName != 'Delete') {
                    cdiTableData[data.columnName] = data.value;
                  }
                }
                cditabledatalist.add(cdiTableData);
                cdiTableData = {};
              }

              FirebaseFirestore.instance
                  .collection('QualityChecklist')
                  .doc(depoName)
                  .collection('CDI TABLE DATA')
                  .doc('CDI DATA')
                  .collection(userId)
                  .doc(currentDate)
                  .set({
                'data': cditabledatalist,
              }).whenComplete(() {
                cditabledatalist.clear();
                for (var i in _qualityMSPDataSource.dataGridRows) {
                  for (var data in i.getCells()) {
                    if (data.columnName != 'button' ||
                        data.columnName == 'View' ||
                        data.columnName != 'Delete') {
                      mspTableData[data.columnName] = data.value;
                    }
                  }
                  msptabledatalist.add(mspTableData);
                  mspTableData = {};
                }

                FirebaseFirestore.instance
                    .collection('QualityChecklist')
                    .doc(depoName)
                    .collection('MSP TABLE DATA')
                    .doc('MSP DATA')
                    .collection(userId)
                    .doc(currentDate)
                    .set({
                  'data': msptabledatalist,
                }).whenComplete(() {
                  msptabledatalist.clear();
                  for (var i in _qualityChargerDataSource.dataGridRows) {
                    for (var data in i.getCells()) {
                      if (data.columnName != 'button' ||
                          data.columnName == 'View' ||
                          data.columnName != 'Delete') {
                        chargerTableData[data.columnName] = data.value;
                      }
                    }
                    chargertabledatalist.add(chargerTableData);
                    chargerTableData = {};
                  }

                  FirebaseFirestore.instance
                      .collection('QualityChecklist')
                      .doc(depoName)
                      .collection('CHARGER TABLE DATA')
                      .doc('CHARGER DATA')
                      .collection(userId)
                      .doc(currentDate)
                      .set({
                    'data': chargertabledatalist,
                  }).whenComplete(() {
                    chargertabledatalist.clear();
                    for (var i in _qualityEPDataSource.dataGridRows) {
                      for (var data in i.getCells()) {
                        if (data.columnName != 'button' ||
                            data.columnName == 'View' ||
                            data.columnName != 'Delete') {
                          epTableData[data.columnName] = data.value;
                        }
                      }
                      eptabledatalist.add(epTableData);
                      epTableData = {};
                    }

                    FirebaseFirestore.instance
                        .collection('QualityChecklist')
                        .doc(depoName)
                        .collection('EARTH TABLE DATA')
                        .doc('EARTH DATA')
                        .collection(userId)
                        .doc(currentDate)
                        .set({
                      'data': eptabledatalist,
                    }).whenComplete(() {
                      eptabledatalist.clear();
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: const Text('Data are synced'),
                        backgroundColor: blue,
                      ));
                    });
                  });
                });
              });
            });
          });
        });
      });
    });
  });
}
