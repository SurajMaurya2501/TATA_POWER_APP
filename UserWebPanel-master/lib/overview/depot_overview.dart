// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../Authentication/auth_service.dart';
import '../FirebaseApi/firebase_api.dart';
import '../KeysEvents/view_AllFiles.dart';
import '../components/loading_page.dart';
import '../datasource/depot_overviewdatasource.dart';
import '../model/depot_overview.dart';
import '../widget/chart_data.dart';
import '../widget/cupertino_Dialog.dart';
import '../widget/custom_appbar.dart';
import '../widget/custom_textfield.dart';
import '../widget/cupertino_Dialog.dart';
import '../widget/style.dart';

class DepotOverview extends StatefulWidget {
  String? cityName;
  String? depoName;

  DepotOverview({super.key, required this.cityName, required this.depoName});

  @override
  State<DepotOverview> createState() => _DepotOverviewState();
}

class _DepotOverviewState extends State<DepotOverview> {
  late DepotOverviewDatasource _employeeDataSource;
  bool isProjectManager = false;
  List<DepotOverviewModel> _employees = <DepotOverviewModel>[];
  late DataGridController _dataGridController;
  List<dynamic> tabledata2 = [];

  FilePickerResult? result;
  FilePickerResult? result1;
  FilePickerResult? result2;
  // TextEditingController _addressController = TextEditingController();
  bool _isloading = true;
  List fileNames = [];
  late TextEditingController _addressController,
      _scopeController,
      _chargerController,
      _ratingController,
      _loadController,
      _powersourceController,
      _elctricalManagerNameController,
      _electricalEngineerController,
      _electricalVendorController,
      _civilManagerNameController,
      _civilEngineerController,
      _civilVendorController;

  // var address,
  //     scope,
  //     required,
  //     charger,
  //     load,
  //     powerSource,
  //     boqElectrical,
  //     boqCivil,
  //     managername,
  //     electmanagername,
  //     elecEng,
  //     elecVendor,
  //     civilmanagername,
  //     civilEng,
  //     civilVendor;

  Stream? _stream, _stream1;
  var alldata;
  Uint8List? fileBytes;
  Uint8List? fileBytes1;
  Uint8List? fileBytes2;
  dynamic userId;
  bool _isEdit = true;
  bool isdialog = false;

  void initializeController() {
    _addressController = TextEditingController();
    _scopeController = TextEditingController();
    _chargerController = TextEditingController();
    _ratingController = TextEditingController();
    _loadController = TextEditingController();
    _powersourceController = TextEditingController();
    _elctricalManagerNameController = TextEditingController();
    _electricalEngineerController = TextEditingController();
    _electricalVendorController = TextEditingController();
    _civilManagerNameController = TextEditingController();
    _civilEngineerController = TextEditingController();
    _civilVendorController = TextEditingController();
  }

  @override
  void initState() {
    initializeController();
    getUserId().whenComplete(() {
      _employees = getEmployeeData();
      // ignore: use_build_context_synchronously
      _employeeDataSource = DepotOverviewDatasource(_employees, context);
      _dataGridController = DataGridController();
      verifyProjectManager();

      setState(() {
        _isloading = false;
      });
    });

    super.initState();
  }

  final List<PieChartData> chartData = [
    PieChartData('A1', 25, blue),
    PieChartData('A2', 38, Colors.lightBlue),
    PieChartData('A3', 34, green),
    PieChartData('A4', 52, Colors.yellow)
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: PreferredSize(
            // ignore: sort_child_properties_last
            child: CustomAppBar(
              showDepoBar: true,
              toOverview: true,
              cityname: widget.cityName,
              text: '${widget.cityName} / ${widget.depoName} / Depot Overview',
              haveSynced: _isEdit,
              store: () {
                FirebaseFirestore.instance
                    .collection('OverviewCollection')
                    .doc(widget.depoName)
                    .collection("OverviewFieldData")
                    .doc(userId)
                    .set({
                  'address': _addressController.text,
                  'scope': _scopeController.text,
                  'required': _chargerController.text,
                  'charger': _ratingController.text,
                  'load': _loadController.text,
                  'powerSource': _powersourceController.text,
                  // 'ManagerName': managername ?? '',
                  'CivilManagerName': _civilManagerNameController.text,
                  'CivilEng': _civilEngineerController.text,
                  'CivilVendor': _civilVendorController.text,
                  'ElectricalManagerName': _elctricalManagerNameController.text,
                  'ElectricalEng': _electricalEngineerController.text,
                  'ElectricalVendor': _electricalVendorController.text,
                }, SetOptions(merge: true));

                FirebaseApi().defaultKeyEventsField(
                    'OverviewCollectionTable', widget.depoName!);
                FirebaseApi().nestedKeyEventsField('OverviewCollectionTable',
                    widget.depoName!, 'OverviewTabledData', userId);
                storeData();
              },
            ),
            preferredSize: const Size.fromHeight(50)),
        body: _isloading
            ? LoadingPage()
            : isProjectManager == false
                ? Center(
                    child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                          height: 400,
                          width: 300,
                          child: Image.asset(
                            'assets/overview_image/depotOverview.webp',
                          )),
                      const Text(
                        'Only Project Manager Can Access This Page',
                        style: TextStyle(fontSize: 30),
                      )
                    ],
                  ))
                : Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                            width: 500,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: blue),
                            child: Text(
                              'Brief Overview of ${widget.depoName} E-Bus Depot',
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: white),
                            )),
                      ),
                      cards(),
                      Expanded(
                          child: StreamBuilder(
                        stream: _stream,
                        builder: (context, snapshot) {
                          if (!snapshot.hasData ||
                              snapshot.data.exists == false) {
                            return SfDataGrid(
                              source: _employeeDataSource,
                              allowEditing: true,
                              frozenColumnsCount: 2,
                              gridLinesVisibility: GridLinesVisibility.both,
                              headerGridLinesVisibility:
                                  GridLinesVisibility.both,
                              // checkboxColumnSettings:
                              //     DataGridCheckboxColumnSettings(
                              //         showCheckboxOnHeader: false),

                              // showCheckboxColumn: true,
                              selectionMode: SelectionMode.multiple,
                              navigationMode: GridNavigationMode.cell,
                              columnWidthMode: ColumnWidthMode.auto,
                              editingGestureType: EditingGestureType.tap,
                              controller: _dataGridController,

                              // onQueryRowHeight: (details) {
                              //   return details.rowIndex == 0 ? 60.0 : 49.0;
                              // },
                              columns: [
                                GridColumn(
                                  visible: false,
                                  columnName: 'srNo',
                                  autoFitPadding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  allowEditing: true,
                                  label: Container(
                                    alignment: Alignment.center,
                                    child: Text('Sr No',
                                        overflow: TextOverflow.values.first,
                                        style: tableheader
                                        //    textAlign: TextAlign.center,
                                        ),
                                  ),
                                ),
                                GridColumn(
                                  columnName: 'Date',
                                  width: 160,
                                  allowEditing: false,
                                  label: Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Risk On Date',
                                      overflow: TextOverflow.values.first,
                                      style: tableheader,
                                    ),
                                  ),
                                ),
                                GridColumn(
                                  columnName: 'RiskDescription',
                                  width: 180,
                                  allowEditing: true,
                                  label: Container(
                                    padding: const EdgeInsets.all(8.0),
                                    alignment: Alignment.center,
                                    child: Text('Risk Description',
                                        textAlign: TextAlign.center,
                                        style: tableheader),
                                  ),
                                ),
                                GridColumn(
                                  columnName: 'TypeRisk',
                                  width: 180,
                                  allowEditing: false,
                                  label: Container(
                                    padding: const EdgeInsets.all(8.0),
                                    alignment: Alignment.center,
                                    child: Text('Type', style: tableheader),
                                  ),
                                ),
                                GridColumn(
                                  columnName: 'impactRisk',
                                  width: 150,
                                  allowEditing: false,
                                  label: Container(
                                    alignment: Alignment.center,
                                    child: Text('Impact Risk',
                                        overflow: TextOverflow.values.first,
                                        style: tableheader),
                                  ),
                                ),
                                GridColumn(
                                  columnName: 'Owner',
                                  allowEditing: true,
                                  width: 150,
                                  label: Column(
                                    children: [
                                      Container(
                                        alignment: Alignment.center,
                                        child: Text('Owner',
                                            overflow: TextOverflow.values.first,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16)),
                                      ),
                                      Text('Person Who will manage the risk',
                                          overflow: TextOverflow.values.first,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12))
                                    ],
                                  ),
                                ),
                                GridColumn(
                                  columnName: 'MigratingRisk',
                                  allowEditing: true,
                                  columnWidthMode:
                                      ColumnWidthMode.fitByCellValue,
                                  width: 150,
                                  label: Column(
                                    children: [
                                      Container(
                                        alignment: Alignment.center,
                                        child: Text('Mitigation Action',
                                            overflow: TextOverflow.values.first,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16)),
                                      ),
                                      Text(
                                          'Action to Mitigate the risk e.g reduce the likelihood',
                                          overflow: TextOverflow.values.first,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12))
                                    ],
                                  ),
                                ),
                                GridColumn(
                                  columnName: 'ContigentAction',
                                  allowEditing: true,
                                  width: 180,
                                  label: Column(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0),
                                        alignment: Alignment.center,
                                        child: Text('Contigent Action',
                                            overflow: TextOverflow.values.first,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16)),
                                      ),
                                      Text(
                                          'Action to be taken if the risk happens',
                                          overflow: TextOverflow.values.first,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12))
                                    ],
                                  ),
                                ),
                                GridColumn(
                                  columnName: 'ProgressionAction',
                                  allowEditing: true,
                                  width: 180,
                                  label: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0),
                                    alignment: Alignment.center,
                                    child: Text('Progression Action',
                                        overflow: TextOverflow.values.first,
                                        style: tableheader),
                                  ),
                                ),
                                GridColumn(
                                  columnName: 'Reason',
                                  allowEditing: true,
                                  width: 150,
                                  label: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0),
                                    alignment: Alignment.center,
                                    child: Text('Remark',
                                        overflow: TextOverflow.values.first,
                                        style: tableheader),
                                  ),
                                ),
                                GridColumn(
                                  columnName: 'TargetDate',
                                  allowEditing: false,
                                  width: 160,
                                  label: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0),
                                    alignment: Alignment.center,
                                    child: Text(
                                        'Target Completion Date Of Risk',
                                        overflow: TextOverflow.values.first,
                                        textAlign: TextAlign.center,
                                        style: tableheader),
                                  ),
                                ),
                                GridColumn(
                                  columnName: 'Status',
                                  allowEditing: false,
                                  width: 150,
                                  label: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0),
                                    alignment: Alignment.center,
                                    child: Text('Status',
                                        overflow: TextOverflow.values.first,
                                        style: tableheader),
                                  ),
                                ),
                                GridColumn(
                                  columnName: 'Add',
                                  autoFitPadding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  allowEditing: false,
                                  width: 120,
                                  label: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    alignment: Alignment.center,
                                    child: Text('Add Row',
                                        overflow: TextOverflow.values.first,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        )
                                        //    textAlign: TextAlign.center,
                                        ),
                                  ),
                                ),
                                GridColumn(
                                  columnName: 'Delete',
                                  autoFitPadding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  allowEditing: false,
                                  width: 120,
                                  label: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    alignment: Alignment.center,
                                    child: Text('Delete Row',
                                        overflow: TextOverflow.values.first,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        )
                                        //    textAlign: TextAlign.center,
                                        ),
                                  ),
                                ),
                              ],
                            );
                          } else {
                            alldata = snapshot.data['data'] as List<dynamic>;
                            _employees.clear();
                            alldata.forEach((element) {
                              _employees
                                  .add(DepotOverviewModel.fromJson(element));
                              _employeeDataSource =
                                  DepotOverviewDatasource(_employees, context);
                              _dataGridController = DataGridController();
                            });
                            return SfDataGrid(
                              source: _employeeDataSource,
                              allowEditing: true,
                              frozenColumnsCount: 2,
                              gridLinesVisibility: GridLinesVisibility.both,
                              headerGridLinesVisibility:
                                  GridLinesVisibility.both,
                              // checkboxColumnSettings:
                              //     DataGridCheckboxColumnSettings(
                              //         showCheckboxOnHeader: false),

                              // showCheckboxColumn: true,
                              selectionMode: SelectionMode.multiple,
                              navigationMode: GridNavigationMode.cell,
                              columnWidthMode: ColumnWidthMode.auto,
                              editingGestureType: EditingGestureType.tap,
                              controller: _dataGridController,

                              // onQueryRowHeight: (details) {
                              //   return details.rowIndex == 0 ? 60.0 : 49.0;
                              // },
                              columns: [
                                GridColumn(
                                  visible: false,
                                  columnName: 'srNo',
                                  autoFitPadding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  allowEditing: true,
                                  label: Container(
                                    alignment: Alignment.center,
                                    child: Text('Sr No',
                                        overflow: TextOverflow.values.first,
                                        style: tableheader
                                        //    textAlign: TextAlign.center,
                                        ),
                                  ),
                                ),
                                GridColumn(
                                  columnName: 'Date',
                                  width: 160,
                                  allowEditing: false,
                                  label: Container(
                                    alignment: Alignment.center,
                                    child: Text('Risk On Date',
                                        overflow: TextOverflow.values.first,
                                        style: tableheader),
                                  ),
                                ),
                                GridColumn(
                                  columnName: 'RiskDescription',
                                  width: 180,
                                  allowEditing: true,
                                  label: Container(
                                    padding: const EdgeInsets.all(8.0),
                                    alignment: Alignment.center,
                                    child: Text('Risk Description',
                                        textAlign: TextAlign.center,
                                        style: tableheader),
                                  ),
                                ),
                                GridColumn(
                                  columnName: 'TypeRisk',
                                  width: 180,
                                  allowEditing: false,
                                  label: Container(
                                    padding: const EdgeInsets.all(8.0),
                                    alignment: Alignment.center,
                                    child: Text('Type', style: tableheader),
                                  ),
                                ),
                                GridColumn(
                                  columnName: 'impactRisk',
                                  width: 150,
                                  allowEditing: false,
                                  label: Container(
                                    alignment: Alignment.center,
                                    child: Text('Impact Risk',
                                        overflow: TextOverflow.values.first,
                                        style: tableheader),
                                  ),
                                ),
                                GridColumn(
                                  columnName: 'Owner',
                                  allowEditing: true,
                                  width: 150,
                                  label: Column(
                                    children: [
                                      Container(
                                        alignment: Alignment.center,
                                        child: Text('Owner',
                                            overflow: TextOverflow.values.first,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16)),
                                      ),
                                      Text('Person Who will manage the risk',
                                          overflow: TextOverflow.values.first,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12))
                                    ],
                                  ),
                                ),
                                GridColumn(
                                  columnName: 'MigratingRisk',
                                  allowEditing: true,
                                  columnWidthMode:
                                      ColumnWidthMode.fitByCellValue,
                                  width: 150,
                                  label: Column(
                                    children: [
                                      Container(
                                        alignment: Alignment.center,
                                        child: Text('Mitigation Action',
                                            overflow: TextOverflow.values.first,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16)),
                                      ),
                                      Text(
                                          'Action to Mitigate the risk e.g reduce the likelihood',
                                          overflow: TextOverflow.values.first,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12))
                                    ],
                                  ),
                                ),
                                GridColumn(
                                  columnName: 'ContigentAction',
                                  allowEditing: true,
                                  width: 180,
                                  label: Column(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0),
                                        alignment: Alignment.center,
                                        child: Text('Contigent Action',
                                            overflow: TextOverflow.values.first,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16)),
                                      ),
                                      Text(
                                          'Action to be taken if the risk happens',
                                          overflow: TextOverflow.values.first,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12))
                                    ],
                                  ),
                                ),
                                GridColumn(
                                  columnName: 'ProgressionAction',
                                  allowEditing: true,
                                  width: 180,
                                  label: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0),
                                    alignment: Alignment.center,
                                    child: Text('Progression Action',
                                        overflow: TextOverflow.values.first,
                                        style: tableheader),
                                  ),
                                ),
                                GridColumn(
                                  columnName: 'Reason',
                                  allowEditing: true,
                                  width: 150,
                                  label: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0),
                                    alignment: Alignment.center,
                                    child: Text('Remark',
                                        overflow: TextOverflow.values.first,
                                        style: tableheader),
                                  ),
                                ),
                                GridColumn(
                                  columnName: 'TargetDate',
                                  allowEditing: false,
                                  width: 160,
                                  label: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0),
                                    alignment: Alignment.center,
                                    child: Text(
                                        'Target Completion Date Of Risk',
                                        overflow: TextOverflow.values.first,
                                        textAlign: TextAlign.center,
                                        style: tableheader),
                                  ),
                                ),
                                GridColumn(
                                  columnName: 'Status',
                                  allowEditing: false,
                                  width: 150,
                                  label: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0),
                                    alignment: Alignment.center,
                                    child: Text('Status',
                                        overflow: TextOverflow.values.first,
                                        style: tableheader),
                                  ),
                                ),
                                GridColumn(
                                  columnName: 'Add',
                                  autoFitPadding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  allowEditing: false,
                                  width: 120,
                                  label: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    alignment: Alignment.center,
                                    child: Text('Add Row',
                                        overflow: TextOverflow.values.first,
                                        style: tableheader
                                        //    textAlign: TextAlign.center,
                                        ),
                                  ),
                                ),
                                GridColumn(
                                  columnName: 'Delete',
                                  autoFitPadding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  allowEditing: false,
                                  width: 120,
                                  label: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    alignment: Alignment.center,
                                    child: Text('Delete Row',
                                        overflow: TextOverflow.values.first,
                                        style: tableheader
                                        //    textAlign: TextAlign.center,
                                        ),
                                  ),
                                ),
                              ],
                            );
                          }
                        },
                      )),
                    ],
                  ),
      ),

      // Column(
      //     children: [
      //       Expanded(
      //         child: Container(
      //           child: Row(
      //             children: [
      //               Container(
      //                 padding: const EdgeInsets.all(8.0),
      //                 width: 500,
      //                 child: Column(
      //                   children: [
      //                     Container(
      //                         padding: const EdgeInsets.all(10),
      //                         decoration: BoxDecoration(
      //                             borderRadius: BorderRadius.circular(10),
      //                             color: blue),
      //                         child: Text(
      //                           'Brief Overview of ${widget.depoName} E-Bus Depot',
      //                           style: TextStyle(
      //                               fontSize: 15,
      //                               fontWeight: FontWeight.bold,
      //                               color: white),
      //                         )),
      //                     const SizedBox(height: 25),
      //                     cards(),
      //                     const SizedBox(height: 20),
      //                   ],
      //                 ),
      //               ),
      //               Expanded(
      //                 child: Column(
      //                   children: [
      //                     Text(
      //                       'E-Bus Depot Name : ${widget.depoName}',
      //                       style: formtext,
      //                     ),
      //                     // Row(
      //                     //   mainAxisAlignment: MainAxisAlignment.center,
      //                     //   children: [
      //                     //     Text(
      //                     //       'Project Manager: ',
      //                     //       style: formtext,
      //                     //     ),
      //                     //     Container(
      //                     //       // width: 250,
      //                     //       height: 35,
      //                     //       child: StreamBuilder(
      //                     //         stream: _stream1,
      //                     //         builder: (context, snapshot) {
      //                     //           // if (snapshot.connectionState ==
      //                     //           //     ConnectionState.waiting) {
      //                     //           //   return Text('');
      //                     //           // }
      //                     //           if (snapshot.hasData) {
      //                     //             managername = snapshot.data!
      //                     //                     .data()
      //                     //                     .toString()
      //                     //                     .contains('ManagerName')
      //                     //                 ? snapshot.data!
      //                     //                         .get('ManagerName') ??
      //                     //                     ''
      //                     //                 : 'Enter Address';
      //                     //             return Padding(
      //                     //               padding:
      //                     //                   const EdgeInsets.only(top: 8),
      //                     //               child: Text(
      //                     //                 managername,
      //                     //                 style: formtext,
      //                     //               ),
      //                     //             );
      //                     //           } else {
      //                     //             return const Text('data');
      //                     //           }
      //                     //         },
      //                     //       ),
      //                     //     ),
      //                     //   ],
      //                     // ),
      //                     Padding(
      //                       padding: const EdgeInsets.all(5.0),
      //                       child: Container(
      //                         padding: const EdgeInsets.all(5),
      //                         decoration: BoxDecoration(
      //                             borderRadius: BorderRadius.circular(10),
      //                             color: blue),
      //                         child: Text('Risk Register',
      //                             style: TextStyle(
      //                                 fontSize: 16,
      //                                 fontWeight: FontWeight.bold,
      //                                 color: white)),
      //                       ),
      //                     ),
      //                     const Padding(
      //                         padding: EdgeInsets.only(top: 12)),
      //                     Expanded(
      //                         child: StreamBuilder(
      //                       stream: _stream,
      //                       builder: (context, snapshot) {
      //                         if (!snapshot.hasData ||
      //                             snapshot.data.exists == false) {
      //                           return SfDataGrid(
      //                             source: _employeeDataSource,
      //                             allowEditing: true,
      //                             frozenColumnsCount: 2,
      //                             gridLinesVisibility:
      //                                 GridLinesVisibility.both,
      //                             headerGridLinesVisibility:
      //                                 GridLinesVisibility.both,
      //                             // checkboxColumnSettings:
      //                             //     DataGridCheckboxColumnSettings(
      //                             //         showCheckboxOnHeader: false),

      //                             // showCheckboxColumn: true,
      //                             selectionMode: SelectionMode.multiple,
      //                             navigationMode: GridNavigationMode.cell,
      //                             columnWidthMode: ColumnWidthMode.auto,
      //                             editingGestureType:
      //                                 EditingGestureType.tap,
      //                             controller: _dataGridController,

      //                             // onQueryRowHeight: (details) {
      //                             //   return details.rowIndex == 0 ? 60.0 : 49.0;
      //                             // },
      //                             columns: [
      //                               GridColumn(
      //                                 visible: false,
      //                                 columnName: 'srNo',
      //                                 autoFitPadding:
      //                                     const EdgeInsets.symmetric(
      //                                         horizontal: 16),
      //                                 allowEditing: true,
      //                                 label: Container(
      //                                   alignment: Alignment.center,
      //                                   child: Text('Sr No',
      //                                       overflow:
      //                                           TextOverflow.values.first,
      //                                       style: tableheader
      //                                       //    textAlign: TextAlign.center,
      //                                       ),
      //                                 ),
      //                               ),
      //                               GridColumn(
      //                                 columnName: 'Date',
      //                                 width: 160,
      //                                 allowEditing: false,
      //                                 label: Container(
      //                                   alignment: Alignment.center,
      //                                   child: Text(
      //                                     'Risk On Date',
      //                                     overflow:
      //                                         TextOverflow.values.first,
      //                                     style: tableheader,
      //                                   ),
      //                                 ),
      //                               ),
      //                               GridColumn(
      //                                 columnName: 'RiskDescription',
      //                                 width: 180,
      //                                 allowEditing: true,
      //                                 label: Container(
      //                                   padding:
      //                                       const EdgeInsets.all(8.0),
      //                                   alignment: Alignment.center,
      //                                   child: Text('Risk Description',
      //                                       textAlign: TextAlign.center,
      //                                       style: tableheader),
      //                                 ),
      //                               ),
      //                               GridColumn(
      //                                 columnName: 'TypeRisk',
      //                                 width: 180,
      //                                 allowEditing: false,
      //                                 label: Container(
      //                                   padding:
      //                                       const EdgeInsets.all(8.0),
      //                                   alignment: Alignment.center,
      //                                   child: Text('Type',
      //                                       style: tableheader),
      //                                 ),
      //                               ),
      //                               GridColumn(
      //                                 columnName: 'impactRisk',
      //                                 width: 150,
      //                                 allowEditing: false,
      //                                 label: Container(
      //                                   alignment: Alignment.center,
      //                                   child: Text('Impact Risk',
      //                                       overflow:
      //                                           TextOverflow.values.first,
      //                                       style: tableheader),
      //                                 ),
      //                               ),
      //                               GridColumn(
      //                                 columnName: 'Owner',
      //                                 allowEditing: true,
      //                                 width: 150,
      //                                 label: Column(
      //                                   children: [
      //                                     Container(
      //                                       alignment: Alignment.center,
      //                                       child: Text('Owner',
      //                                           overflow: TextOverflow
      //                                               .values.first,
      //                                           style: const TextStyle(
      //                                               fontWeight:
      //                                                   FontWeight.bold,
      //                                               fontSize: 16)),
      //                                     ),
      //                                     Text(
      //                                         'Person Who will manage the risk',
      //                                         overflow: TextOverflow
      //                                             .values.first,
      //                                         textAlign: TextAlign.center,
      //                                         style: const TextStyle(
      //                                             color: Colors.red,
      //                                             fontWeight:
      //                                                 FontWeight.bold,
      //                                             fontSize: 12))
      //                                   ],
      //                                 ),
      //                               ),
      //                               GridColumn(
      //                                 columnName: 'MigratingRisk',
      //                                 allowEditing: true,
      //                                 columnWidthMode:
      //                                     ColumnWidthMode.fitByCellValue,
      //                                 width: 150,
      //                                 label: Column(
      //                                   children: [
      //                                     Container(
      //                                       alignment: Alignment.center,
      //                                       child: Text(
      //                                           'Mitigation Action',
      //                                           overflow: TextOverflow
      //                                               .values.first,
      //                                           style: const TextStyle(
      //                                               fontWeight:
      //                                                   FontWeight.bold,
      //                                               fontSize: 16)),
      //                                     ),
      //                                     Text(
      //                                         'Action to Mitigate the risk e.g reduce the likelihood',
      //                                         overflow: TextOverflow
      //                                             .values.first,
      //                                         textAlign: TextAlign.center,
      //                                         style: const TextStyle(
      //                                             color: Colors.red,
      //                                             fontWeight:
      //                                                 FontWeight.bold,
      //                                             fontSize: 12))
      //                                   ],
      //                                 ),
      //                               ),
      //                               GridColumn(
      //                                 columnName: 'ContigentAction',
      //                                 allowEditing: true,
      //                                 width: 180,
      //                                 label: Column(
      //                                   children: [
      //                                     Container(
      //                                       padding: const EdgeInsets
      //                                               .symmetric(
      //                                           horizontal: 16.0),
      //                                       alignment: Alignment.center,
      //                                       child: Text(
      //                                           'Contigent Action',
      //                                           overflow: TextOverflow
      //                                               .values.first,
      //                                           style: const TextStyle(
      //                                               fontWeight:
      //                                                   FontWeight.bold,
      //                                               fontSize: 16)),
      //                                     ),
      //                                     Text(
      //                                         'Action to be taken if the risk happens',
      //                                         overflow: TextOverflow
      //                                             .values.first,
      //                                         textAlign: TextAlign.center,
      //                                         style: const TextStyle(
      //                                             color: Colors.red,
      //                                             fontWeight:
      //                                                 FontWeight.bold,
      //                                             fontSize: 12))
      //                                   ],
      //                                 ),
      //                               ),
      //                               GridColumn(
      //                                 columnName: 'ProgressionAction',
      //                                 allowEditing: true,
      //                                 width: 180,
      //                                 label: Container(
      //                                   padding:
      //                                       const EdgeInsets.symmetric(
      //                                           horizontal: 16.0),
      //                                   alignment: Alignment.center,
      //                                   child: Text('Progression Action',
      //                                       overflow:
      //                                           TextOverflow.values.first,
      //                                       style: tableheader),
      //                                 ),
      //                               ),
      //                               GridColumn(
      //                                 columnName: 'Reason',
      //                                 allowEditing: true,
      //                                 width: 150,
      //                                 label: Container(
      //                                   padding:
      //                                       const EdgeInsets.symmetric(
      //                                           horizontal: 16.0),
      //                                   alignment: Alignment.center,
      //                                   child: Text('Remark',
      //                                       overflow:
      //                                           TextOverflow.values.first,
      //                                       style: tableheader),
      //                                 ),
      //                               ),
      //                               GridColumn(
      //                                 columnName: 'TargetDate',
      //                                 allowEditing: false,
      //                                 width: 160,
      //                                 label: Container(
      //                                   padding:
      //                                       const EdgeInsets.symmetric(
      //                                           horizontal: 16.0),
      //                                   alignment: Alignment.center,
      //                                   child: Text(
      //                                       'Target Completion Date Of Risk',
      //                                       overflow:
      //                                           TextOverflow.values.first,
      //                                       textAlign: TextAlign.center,
      //                                       style: tableheader),
      //                                 ),
      //                               ),
      //                               GridColumn(
      //                                 columnName: 'Status',
      //                                 allowEditing: false,
      //                                 width: 150,
      //                                 label: Container(
      //                                   padding:
      //                                       const EdgeInsets.symmetric(
      //                                           horizontal: 16.0),
      //                                   alignment: Alignment.center,
      //                                   child: Text('Status',
      //                                       overflow:
      //                                           TextOverflow.values.first,
      //                                       style: tableheader),
      //                                 ),
      //                               ),
      //                               GridColumn(
      //                                 columnName: 'Add',
      //                                 autoFitPadding:
      //                                     const EdgeInsets.symmetric(
      //                                         horizontal: 16),
      //                                 allowEditing: false,
      //                                 width: 120,
      //                                 label: Container(
      //                                   padding:
      //                                       const EdgeInsets.symmetric(
      //                                           horizontal: 8.0),
      //                                   alignment: Alignment.center,
      //                                   child: Text('Add Row',
      //                                       overflow:
      //                                           TextOverflow.values.first,
      //                                       style: const TextStyle(
      //                                         fontWeight: FontWeight.bold,
      //                                         fontSize: 16,
      //                                       )
      //                                       //    textAlign: TextAlign.center,
      //                                       ),
      //                                 ),
      //                               ),
      //                               GridColumn(
      //                                 columnName: 'Delete',
      //                                 autoFitPadding:
      //                                     const EdgeInsets.symmetric(
      //                                         horizontal: 16),
      //                                 allowEditing: false,
      //                                 width: 120,
      //                                 label: Container(
      //                                   padding:
      //                                       const EdgeInsets.symmetric(
      //                                           horizontal: 8.0),
      //                                   alignment: Alignment.center,
      //                                   child: Text('Delete Row',
      //                                       overflow:
      //                                           TextOverflow.values.first,
      //                                       style: const TextStyle(
      //                                         fontWeight: FontWeight.bold,
      //                                         fontSize: 16,
      //                                       )
      //                                       //    textAlign: TextAlign.center,
      //                                       ),
      //                                 ),
      //                               ),
      //                             ],
      //                           );
      //                         } else {
      //                           alldata = snapshot.data['data']
      //                               as List<dynamic>;
      //                           _employees.clear();
      //                           alldata.forEach((element) {
      //                             _employees.add(
      //                                 DepotOverviewModel.fromJson(
      //                                     element));
      //                             _employeeDataSource =
      //                                 DepotOverviewDatasource(
      //                                     _employees, context);
      //                             _dataGridController =
      //                                 DataGridController();
      //                           });
      //                           return SfDataGrid(
      //                             source: _employeeDataSource,
      //                             allowEditing: true,
      //                             frozenColumnsCount: 2,
      //                             gridLinesVisibility:
      //                                 GridLinesVisibility.both,
      //                             headerGridLinesVisibility:
      //                                 GridLinesVisibility.both,
      //                             // checkboxColumnSettings:
      //                             //     DataGridCheckboxColumnSettings(
      //                             //         showCheckboxOnHeader: false),

      //                             // showCheckboxColumn: true,
      //                             selectionMode: SelectionMode.multiple,
      //                             navigationMode: GridNavigationMode.cell,
      //                             columnWidthMode: ColumnWidthMode.auto,
      //                             editingGestureType:
      //                                 EditingGestureType.tap,
      //                             controller: _dataGridController,

      //                             // onQueryRowHeight: (details) {
      //                             //   return details.rowIndex == 0 ? 60.0 : 49.0;
      //                             // },
      //                             columns: [
      //                               GridColumn(
      //                                 visible: false,
      //                                 columnName: 'srNo',
      //                                 autoFitPadding:
      //                                     const EdgeInsets.symmetric(
      //                                         horizontal: 16),
      //                                 allowEditing: true,
      //                                 label: Container(
      //                                   alignment: Alignment.center,
      //                                   child: Text('Sr No',
      //                                       overflow:
      //                                           TextOverflow.values.first,
      //                                       style: tableheader
      //                                       //    textAlign: TextAlign.center,
      //                                       ),
      //                                 ),
      //                               ),
      //                               GridColumn(
      //                                 columnName: 'Date',
      //                                 width: 160,
      //                                 allowEditing: false,
      //                                 label: Container(
      //                                   alignment: Alignment.center,
      //                                   child: Text('Risk On Date',
      //                                       overflow:
      //                                           TextOverflow.values.first,
      //                                       style: tableheader),
      //                                 ),
      //                               ),
      //                               GridColumn(
      //                                 columnName: 'RiskDescription',
      //                                 width: 180,
      //                                 allowEditing: true,
      //                                 label: Container(
      //                                   padding:
      //                                       const EdgeInsets.all(8.0),
      //                                   alignment: Alignment.center,
      //                                   child: Text('Risk Description',
      //                                       textAlign: TextAlign.center,
      //                                       style: tableheader),
      //                                 ),
      //                               ),
      //                               GridColumn(
      //                                 columnName: 'TypeRisk',
      //                                 width: 180,
      //                                 allowEditing: false,
      //                                 label: Container(
      //                                   padding:
      //                                       const EdgeInsets.all(8.0),
      //                                   alignment: Alignment.center,
      //                                   child: Text('Type',
      //                                       style: tableheader),
      //                                 ),
      //                               ),
      //                               GridColumn(
      //                                 columnName: 'impactRisk',
      //                                 width: 150,
      //                                 allowEditing: false,
      //                                 label: Container(
      //                                   alignment: Alignment.center,
      //                                   child: Text('Impact Risk',
      //                                       overflow:
      //                                           TextOverflow.values.first,
      //                                       style: tableheader),
      //                                 ),
      //                               ),
      //                               GridColumn(
      //                                 columnName: 'Owner',
      //                                 allowEditing: true,
      //                                 width: 150,
      //                                 label: Column(
      //                                   children: [
      //                                     Container(
      //                                       alignment: Alignment.center,
      //                                       child: Text('Owner',
      //                                           overflow: TextOverflow
      //                                               .values.first,
      //                                           style: const TextStyle(
      //                                               fontWeight:
      //                                                   FontWeight.bold,
      //                                               fontSize: 16)),
      //                                     ),
      //                                     Text(
      //                                         'Person Who will manage the risk',
      //                                         overflow: TextOverflow
      //                                             .values.first,
      //                                         textAlign: TextAlign.center,
      //                                         style: const TextStyle(
      //                                             color: Colors.red,
      //                                             fontWeight:
      //                                                 FontWeight.bold,
      //                                             fontSize: 12))
      //                                   ],
      //                                 ),
      //                               ),
      //                               GridColumn(
      //                                 columnName: 'MigratingRisk',
      //                                 allowEditing: true,
      //                                 columnWidthMode:
      //                                     ColumnWidthMode.fitByCellValue,
      //                                 width: 150,
      //                                 label: Column(
      //                                   children: [
      //                                     Container(
      //                                       alignment: Alignment.center,
      //                                       child: Text(
      //                                           'Mitigation Action',
      //                                           overflow: TextOverflow
      //                                               .values.first,
      //                                           style: const TextStyle(
      //                                               fontWeight:
      //                                                   FontWeight.bold,
      //                                               fontSize: 16)),
      //                                     ),
      //                                     Text(
      //                                         'Action to Mitigate the risk e.g reduce the likelihood',
      //                                         overflow: TextOverflow
      //                                             .values.first,
      //                                         textAlign: TextAlign.center,
      //                                         style: const TextStyle(
      //                                             color: Colors.red,
      //                                             fontWeight:
      //                                                 FontWeight.bold,
      //                                             fontSize: 12))
      //                                   ],
      //                                 ),
      //                               ),
      //                               GridColumn(
      //                                 columnName: 'ContigentAction',
      //                                 allowEditing: true,
      //                                 width: 180,
      //                                 label: Column(
      //                                   children: [
      //                                     Container(
      //                                       padding: const EdgeInsets
      //                                               .symmetric(
      //                                           horizontal: 16.0),
      //                                       alignment: Alignment.center,
      //                                       child: Text(
      //                                           'Contigent Action',
      //                                           overflow: TextOverflow
      //                                               .values.first,
      //                                           style: const TextStyle(
      //                                               fontWeight:
      //                                                   FontWeight.bold,
      //                                               fontSize: 16)),
      //                                     ),
      //                                     Text(
      //                                         'Action to be taken if the risk happens',
      //                                         overflow: TextOverflow
      //                                             .values.first,
      //                                         textAlign: TextAlign.center,
      //                                         style: const TextStyle(
      //                                             color: Colors.red,
      //                                             fontWeight:
      //                                                 FontWeight.bold,
      //                                             fontSize: 12))
      //                                   ],
      //                                 ),
      //                               ),
      //                               GridColumn(
      //                                 columnName: 'ProgressionAction',
      //                                 allowEditing: true,
      //                                 width: 180,
      //                                 label: Container(
      //                                   padding:
      //                                       const EdgeInsets.symmetric(
      //                                           horizontal: 16.0),
      //                                   alignment: Alignment.center,
      //                                   child: Text('Progression Action',
      //                                       overflow:
      //                                           TextOverflow.values.first,
      //                                       style: tableheader),
      //                                 ),
      //                               ),
      //                               GridColumn(
      //                                 columnName: 'Reason',
      //                                 allowEditing: true,
      //                                 width: 150,
      //                                 label: Container(
      //                                   padding:
      //                                       const EdgeInsets.symmetric(
      //                                           horizontal: 16.0),
      //                                   alignment: Alignment.center,
      //                                   child: Text('Remark',
      //                                       overflow:
      //                                           TextOverflow.values.first,
      //                                       style: tableheader),
      //                                 ),
      //                               ),
      //                               GridColumn(
      //                                 columnName: 'TargetDate',
      //                                 allowEditing: false,
      //                                 width: 160,
      //                                 label: Container(
      //                                   padding:
      //                                       const EdgeInsets.symmetric(
      //                                           horizontal: 16.0),
      //                                   alignment: Alignment.center,
      //                                   child: Text(
      //                                       'Target Completion Date Of Risk',
      //                                       overflow:
      //                                           TextOverflow.values.first,
      //                                       textAlign: TextAlign.center,
      //                                       style: tableheader),
      //                                 ),
      //                               ),
      //                               GridColumn(
      //                                 columnName: 'Status',
      //                                 allowEditing: false,
      //                                 width: 150,
      //                                 label: Container(
      //                                   padding:
      //                                       const EdgeInsets.symmetric(
      //                                           horizontal: 16.0),
      //                                   alignment: Alignment.center,
      //                                   child: Text('Status',
      //                                       overflow:
      //                                           TextOverflow.values.first,
      //                                       style: tableheader),
      //                                 ),
      //                               ),
      //                               GridColumn(
      //                                 columnName: 'Add',
      //                                 autoFitPadding:
      //                                     const EdgeInsets.symmetric(
      //                                         horizontal: 16),
      //                                 allowEditing: false,
      //                                 width: 120,
      //                                 label: Container(
      //                                   padding:
      //                                       const EdgeInsets.symmetric(
      //                                           horizontal: 8.0),
      //                                   alignment: Alignment.center,
      //                                   child: Text('Add Row',
      //                                       overflow:
      //                                           TextOverflow.values.first,
      //                                       style: tableheader
      //                                       //    textAlign: TextAlign.center,
      //                                       ),
      //                                 ),
      //                               ),
      //                               GridColumn(
      //                                 columnName: 'Delete',
      //                                 autoFitPadding:
      //                                     const EdgeInsets.symmetric(
      //                                         horizontal: 16),
      //                                 allowEditing: false,
      //                                 width: 120,
      //                                 label: Container(
      //                                   padding:
      //                                       const EdgeInsets.symmetric(
      //                                           horizontal: 8.0),
      //                                   alignment: Alignment.center,
      //                                   child: Text('Delete Row',
      //                                       overflow:
      //                                           TextOverflow.values.first,
      //                                       style: tableheader
      //                                       //    textAlign: TextAlign.center,
      //                                       ),
      //                                 ),
      //                               ),
      //                             ],
      //                           );
      //                         }
      //                       },
      //                     )),
      //                   ],
      //                 ),
      //               ),
      //             ],
      //           ),
      //         ),
      //       ),
      //     ],
      //   ),

      // floatingActionButton: FloatingActionButton(
      //     child: Icon(Icons.add),
      //     onPressed: (() {
      //       _employees.add(
      //         DepotOverviewModel(
      //           srNo: 1,
      //           date: DateFormat('dd-MM-yyyy').format(DateTime.now()),
      //           riskDescription: 'dedd',
      //           typeRisk: 'Material Supply',
      //           impactRisk: 'High',
      //           owner: 'Pratyush',
      //           migrateAction: ' lkmlm',
      //           contigentAction: 'mlkmlk',
      //           progressAction: 'pending',
      //           reason: '',
      //           targetDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
      //           status: 'Close',
      //         ),
      //       );
      //       _employeeDataSource.buildDataGridRows();
      //       _employeeDataSource.updateDatagridSource();
      //     })),
    );
  }

  cards() {
    return Expanded(
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('OverviewCollection')
              .doc(widget.depoName)
              .collection("OverviewFieldData")
              .doc(userId)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Column(children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        OverviewField(
                            'Depots location and Address ', _addressController),
                        OverviewField('No of Buses in Scope', _scopeController),
                        OverviewField(
                            'No. of Charger Required ', _chargerController)
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        OverviewField('Rating of Charger', _ratingController),
                        OverviewField(
                            'Required Sanctioned load', _loadController),
                        OverviewField('Existing Utility Of PowerSource ',
                            _powersourceController)
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   children: [
                        //     Container(
                        //       padding: const EdgeInsets.all(5),
                        //       decoration: BoxDecoration(
                        //           borderRadius: BorderRadius.circular(10),
                        //           color: blue),
                        //       child: Text('Electrical',
                        //           style: TextStyle(
                        //               fontSize: 16,
                        //               fontWeight: FontWeight.bold,
                        //               color: white)),
                        //     ),
                        //   ],
                        // ),

                        OverviewField('Project Manager ',
                            _elctricalManagerNameController),

                        OverviewField('Electrical Engineer',
                            _electricalEngineerController),

                        OverviewField(
                            'Electrical Vendor', _electricalVendorController),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        OverviewField(
                            'Civil Manager', _civilManagerNameController),
                        OverviewField(
                            'Civil Engineer ', _civilEngineerController),
                        OverviewField('Civil Vendor', _civilVendorController),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 200,
                                height: 35,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Details of Survey Report',
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                            color: black),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    ElevatedButton(
                                        onPressed: () async {
                                          result = await FilePicker.platform
                                              .pickFiles(
                                            type: FileType.any,
                                            withData: true,
                                          );

                                          fileBytes =
                                              result!.files.first.bytes!;
                                          if (result == null) {
                                            print("No file selected");
                                          } else {
                                            setState(() {});
                                            result!.files.forEach((element) {
                                              print(element.name);
                                              print(result!.files.first.name);
                                            });
                                          }
                                        },
                                        child: const Text(
                                          'Pick file',
                                          textAlign: TextAlign.end,
                                        )),
                                    SizedBox(width: 10)
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                          width: 160,
                                          height: 35,
                                          decoration: BoxDecoration(
                                              color: lightblue,
                                              border: Border.all(color: grey),
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          child: Row(
                                            children: [
                                              if (result != null)
                                                Expanded(
                                                  child: Text(
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    result!.files.first.name,
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        color: white),
                                                  ),
                                                )
                                            ],
                                          )),
                                      IconButton(
                                          alignment: Alignment.bottomRight,
                                          padding:
                                              const EdgeInsets.only(bottom: 5),
                                          onPressed: () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ViewAllPdf(
                                                            title: '/BOQSurvey',
                                                            cityName: widget
                                                                .cityName!,
                                                            depoName: widget
                                                                .depoName!,
                                                            userId: userId,
                                                            docId: 'survey')));
                                          },
                                          icon:
                                              Icon(Icons.folder, color: yellow))
                                    ],
                                  ),
                                ],
                              ),
                            ]),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 200,
                                height: 35,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'BOQ Electrical',
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                            color: black),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    ElevatedButton(
                                        onPressed: () async {
                                          result1 = await FilePicker.platform
                                              .pickFiles(
                                            type: FileType.any,
                                            withData: true,
                                          );

                                          fileBytes1 =
                                              result1!.files.first.bytes!;
                                          if (result1 == null) {
                                            print("No file selected");
                                          } else {
                                            setState(() {});
                                            result1!.files.forEach((element) {
                                              print(element.name);
                                            });
                                          }
                                        },
                                        child: const Text(
                                          'Pick file',
                                          textAlign: TextAlign.end,
                                        )),
                                    const SizedBox(width: 10),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                          width: 160,
                                          height: 35,
                                          decoration: BoxDecoration(
                                              color: lightblue,
                                              border: Border.all(color: grey),
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          child: Row(
                                            children: [
                                              if (result1 != null)
                                                Expanded(
                                                  child: Text(
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    result1!.files.first.name,
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        color: white),
                                                  ),
                                                )
                                            ],
                                          )),
                                      IconButton(
                                          alignment: Alignment.bottomRight,
                                          padding:
                                              const EdgeInsets.only(bottom: 5),
                                          onPressed: () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ViewAllPdf(
                                                            title:
                                                                '/BOQElectrical',
                                                            cityName: widget
                                                                .cityName!,
                                                            depoName: widget
                                                                .depoName!,
                                                            userId: userId,
                                                            docId:
                                                                'electrical')));
                                          },
                                          icon:
                                              Icon(Icons.folder, color: yellow))
                                    ],
                                  ),
                                ],
                              ),
                            ]),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 200,
                                height: 35,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'BOQ Civil',
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                            color: black),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    ElevatedButton(
                                        onPressed: () async {
                                          result2 = await FilePicker.platform
                                              .pickFiles(
                                            type: FileType.any,
                                            withData: true,
                                          );

                                          fileBytes2 =
                                              result2!.files.first.bytes!;
                                          if (result2 == null) {
                                            print("No file selected");
                                          } else {
                                            setState(() {});
                                            result2!.files.forEach((element) {
                                              print(element.name);
                                              print(result!.files.first.name);
                                            });
                                          }
                                        },
                                        child: const Text(
                                          'Pick file',
                                          textAlign: TextAlign.end,
                                        )),
                                    SizedBox(width: 10),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                          width: 160,
                                          height: 35,
                                          decoration: BoxDecoration(
                                              color: lightblue,
                                              border: Border.all(color: grey),
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          child: Row(
                                            children: [
                                              if (result2 != null)
                                                Expanded(
                                                  child: Text(
                                                    result2!.files.first.name,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        color: white),
                                                  ),
                                                )
                                            ],
                                          )),
                                      IconButton(
                                          alignment: Alignment.bottomRight,
                                          padding:
                                              const EdgeInsets.only(bottom: 5),
                                          onPressed: () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ViewAllPdf(
                                                            title: '/BOQCivil',
                                                            cityName: widget
                                                                .cityName!,
                                                            depoName: widget
                                                                .depoName!,
                                                            userId: userId,
                                                            docId: 'civil')));
                                          },
                                          icon:
                                              Icon(Icons.folder, color: yellow))
                                    ],
                                  ),
                                ],
                              ),
                            ]),
                      ],
                    )
                  ]));
            }
            return LoadingPage();
          },
        ),
      ),
    );
  }

  // overviewDetails(String title, String subtitle) {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //     children: [
  //       Container(
  //         width: 250,
  //         child: Text(
  //           subtitle,
  //           textAlign: TextAlign.start,
  //           style: TextStyle(
  //             fontSize: 16,
  //             fontWeight: FontWeight.bold,
  //           ),
  //         ),
  //       ),
  //       Container(
  //           width: 200,
  //           height: 35,
  //           child: TextFormField(
  //               initialValue: subtitle,
  //               textInputAction: TextInputAction.done,
  //               minLines: 1,
  //               autofocus: false,
  //               textAlign: TextAlign.center,
  //               style: TextStyle(color: black, fontSize: 16),
  //               onChanged: (value) {
  //                 address = value;
  //               },
  //               onSaved: (value) {
  //                 address = value;
  //               })),
  //     ],
  //   );
  // }

  void storeData() {
    Map<String, dynamic> table_data = Map();
    for (var i in _employeeDataSource.dataGridRows) {
      for (var data in i.getCells()) {
        if (data.columnName != 'Add' || data.columnName != 'Delete') {
          table_data[data.columnName] = data.value;
        }
      }
      tabledata2.add(table_data);
      table_data = {};
    }

    FirebaseFirestore.instance
        .collection('OverviewCollectionTable')
        .doc(widget.depoName)
        .collection("OverviewTabledData")
        .doc(userId)
        .set({
      'data': tabledata2,
    }).whenComplete(() async {
      tabledata2.clear();
      if (fileBytes != null) {
        await FirebaseStorage.instance
            .ref(
                'BOQSurvey/${widget.cityName}/${widget.depoName}/$userId/survey/${result!.files.first.name}')
            .putData(
              fileBytes!,
              //  SettableMetadata(contentType: 'application/pdf')
            );
      } else if (fileBytes1 != null) {
        await FirebaseStorage.instance
            .ref(
                'BOQElectrical/${widget.cityName}/${widget.depoName}/$userId/electrical/${result1!.files.first.name}')
            .putData(
              fileBytes1!,
            );
      } else if (fileBytes2 != null) {
        await FirebaseStorage.instance
            .ref(
                'BOQCivil/${widget.cityName}/${widget.depoName}/$userId/civil/${result2!.files.first.name}')
            .putData(
              fileBytes2!,
              //  SettableMetadata(contentType: 'application/pdf')
            );
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text('Data are synced'),
      backgroundColor: blue,
    ));
  }

  void _fetchUserData() async {
    if (isProjectManager) {
      await FirebaseFirestore.instance
          .collection('OverviewCollection')
          .doc(widget.depoName)
          .collection("OverviewFieldData")
          .doc(userId)
          .get()
          .then((ds) {
        setState(() {
          // managername = ds.data()!['ManagerName'];
          _addressController.text = ds.data()!['address'] ?? '';
          _scopeController.text = ds.data()!['scope'] ?? '';
          _chargerController.text = ds.data()!['required'] ?? '';
          _ratingController.text = ds.data()!['charger'] ?? '';
          _loadController.text = ds.data()!['load'] ?? '';
          _powersourceController.text = ds.data()!['powerSource'] ?? '';
          _elctricalManagerNameController.text =
              ds.data()!['ElectricalManagerName'] ?? '';
          _electricalEngineerController.text =
              ds.data()!['ElectricalEng'] ?? '';
          _electricalVendorController.text =
              ds.data()!['ElectricalVendor'] ?? '';
          _civilManagerNameController.text =
              ds.data()!['CivilManagerName'] ?? '';
          _civilEngineerController.text = ds.data()!['CivilEng'] ?? '';
          _civilVendorController.text = ds.data()!['CivilVendor'] ?? '';
        });
      });
      print('Fetch Data running');
    }
  }

  Future<void> getUserId() async {
    await AuthService().getCurrentUserId().then((value) {
      userId = value;
    });
  }

  List<DepotOverviewModel> getEmployeeData() {
    return [
      DepotOverviewModel(
          srNo: 1,
          date: DateFormat('dd-MM-yyyy').format(DateTime.now()),
          riskDescription: '',
          typeRisk: 'Material Supply',
          impactRisk: 'High',
          owner: '',
          migrateAction: ' ',
          contigentAction: '',
          progressAction: '',
          reason: '',
          targetDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
          status: 'Close')
    ];
  }

  Future<void> verifyProjectManager() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('AssignedRole')
        .where('roles', arrayContains: 'Project Manager')
        .get();

    List<dynamic> tempList = querySnapshot.docs.map((e) => e.data()).toList();

    for (int i = 0; i < tempList.length; i++) {
      if (tempList[i]['userId'].toString() == userId.toString()) {
        for (int j = 0; j < tempList[i]['depots'].length; j++) {
          List<dynamic> depot = tempList[i]['depots'];

          if (depot[j].toString() == widget.depoName) {
            print(depot);
            isProjectManager = true;
            setState(() {});
          }
        }
      }
    }
    _fetchUserData();
  }

  OverviewField(String title, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            width: 200,
            child: Text(title, textAlign: TextAlign.start, style: formtext),
          ),
          Container(
            width: 200,
            child: CustomTextField(
              controller: controller,
            ),
          ),
        ],
      ),
    );
  }
}
