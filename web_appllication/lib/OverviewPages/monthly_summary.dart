import 'dart:async';
import 'dart:convert';
import 'dart:html' as html ;
import 'dart:ui';
import 'package:printing/printing.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:web_appllication/OverviewPages/safety_checklist.dart';
import '../widgets/custom_appbar.dart';
import 'package:pdf/widgets.dart' as pw;

class MonthlySummary extends StatefulWidget {

  final String? userId;
  final String? cityName;
  final String? depoName;
  final String? id;
  const MonthlySummary({
    super.key,
    this.userId,
    this.cityName,
    required this.depoName,
    this.id
  });


  @override
  State<MonthlySummary> createState() => _MonthlySummaryState();
}

class _MonthlySummaryState extends State<MonthlySummary> {

  List<dynamic> temp = [];

  //Daily Project Row List for view summary
  List<List<dynamic>> rowList = [];

  // Daily project available user ID List
  List<dynamic> presentUser = [];

  //All user id list
  List<dynamic> userList = [];

  // Daily Project data entry date list
  List<dynamic> userEntryDate = [];

  // Daily Project data according to entry date
  List<dynamic> dailyProjectData = [];


  @override
  void initState() {
    setState(() {});
    super.initState();
  }

  Future<List<List<dynamic>>> fetchData() async {
    await getMonthlyData();
    return rowList;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: PreferredSize(
          // ignore: sort_child_properties_last
            child: CustomAppBar(
              text: ' ${widget.cityName}/ ${widget.depoName} / Monthly Report',
              userid: widget.userId,
            ),
            preferredSize: const Size.fromHeight(50)),
        body: FutureBuilder<List<List<dynamic>>>(
          future: fetchData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      CircularProgressIndicator(),
                      Text('Collecting Data...',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  )
              );
            } else if (snapshot.hasError) {
              return const Center(
                child: Text('Error fetching data'),
              );
            } else if (snapshot.hasData) {
              final data = snapshot.data!;

              if (data.isEmpty) {
                return const Center(
                  child: Text('No Data Available for Selected Depo',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),),
                );
              }

              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SingleChildScrollView(
                           child: SizedBox(
                             width: MediaQuery.of(context).size.width*0.66,
                             child: DataTable(
                                  showBottomBorder: true,
                                  sortAscending: true,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey[600]!,
                                      width: 1.0,
                                    ),
                                  ),
                                  columnSpacing: 150.0,
                                  headingRowColor: MaterialStateColor.resolveWith((states) => Colors.blue[800]!),
                                  headingTextStyle: const TextStyle(
                                      color: Colors.white
                                  ),
                                  columns: const [
                                    DataColumn(
                                        label: Text('User_ID',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                    ),)),
                                    DataColumn(
                                        label: Text('Monthly Report Data',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                        ))),
                                    DataColumn(
                                        label: Text('PDF Download',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                            ))),
                                    DataColumn(
                                        label: Text('Date',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                        ))),
                                  ],
                                  rows: data.map(
                                        (rowData) {
                                      return DataRow(
                                        cells: [
                                          DataCell(Text(rowData[0])),
                                          DataCell(
                                              ElevatedButton(
                                                onPressed: () {
                                                  _generatePDF(rowData[0], rowData[2],1);
                                                },
                                                child: const Text('View Report'),
                                              )
                                          ),
                                          DataCell(
                                              ElevatedButton(
                                                onPressed: () {
                                                  _generatePDF(rowData[0], rowData[2],2);
                                                },
                                                child: const Text('Download'),
                                              )
                                          ),
                                          DataCell(Text(rowData[2])),
                                        ],
                                      );
                                    },
                                  ).toList(),
                                ),
                           ),
                          ),
                  ],
                ),
              );
            }

            return Container();
          },
        ),
      ),
    );

  }

  Future<void> getMonthlyData() async{
      QuerySnapshot querySnapshot1 = await FirebaseFirestore.instance
          .collection('MonthlyProjectReport2')
          .doc('${widget.depoName}')
          .collection('userId').get();
      List<dynamic> userIdList = querySnapshot1.docs.map((e) => e.id).toList();
      for(int i=0 ; i< userIdList.length ; i++){

        QuerySnapshot querySnapshot2 = await FirebaseFirestore.instance
            .collection('MonthlyProjectReport2')
            .doc('${widget.depoName}')
            .collection('userId')
            .doc('${userIdList[i]}')
            .collection('Monthly Data').get();

        List<dynamic> monthlyDate = querySnapshot2.docs.map((e) => e.id).toList();
        for(int j=0 ; j<monthlyDate.length ; j++){
          rowList.add([
            userIdList[i],
            'PDF',
            monthlyDate[j],
          ]
          );
        }
      }
  }



  Future<void> _generatePDF(String userId,String date, int decision) async {

    List<dynamic> imageUrls = [];
    List<List<dynamic>> allData = [];


    String path = 'gs://tp-zap-solz.appspot.com/SafetyChecklist/Bengaluru/BMTC KR Puram-29/JT4610/1';
    ListResult result = await FirebaseStorage.instance.ref().child(path).listAll();
    print('Result : ${result.items}');

    for (var item in result.items) {
      String downloadUrl = await item.getDownloadURL();
      imageUrls.add(downloadUrl);
    }

    final myImage = await networkImage(imageUrls[0]);

    print('Firestorage List : ${imageUrls.length} $imageUrls');

    final List<pw.TableRow> rows = [];

    for (int i = 0; i < allData.length; i++) {
      if(imageUrls[i].isEmpty){
        imageUrls[i] = [];
      }
      final row = pw.TableRow(children: [
        pw.Text('${allData[i]}'),
        pw.Container(
          padding: pw.EdgeInsets.all(8.0),
          child: pw.Image(height: 100,width: 100,await networkImage(imageUrls[i]))
        )
      ]);
      rows.add(row);
    }

    final profileImage = pw.MemoryImage(
      (await rootBundle.load('assets/Tata-Power.jpeg')).buffer.asUint8List(),
    );

    final headerStyle = pw.TextStyle(
        fontSize: 12,
        fontWeight: pw.FontWeight.bold
    );

    const cellStyle = pw.TextStyle(
        color: PdfColors.black,
        fontSize: 11,
    );

    List<dynamic> userData = [];
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('MonthlyProjectReport2')
        .doc('${widget.depoName}')
        .collection('userId')
        .doc(userId)
        .collection('Monthly Data')
        .doc(date).get();

    Map<String,dynamic> docData = documentSnapshot.data() as Map<String,dynamic>;
    if(docData.isNotEmpty){
      userData.addAll(docData['data']);
      for(Map<String,dynamic> mapData in userData){
        allData.add([
          mapData['ActivityDetails'].toString().trim() == 'null' ||
              mapData['ActivityDetails'].toString().trim() == 'Null' ? '' : mapData['ActivityDetails'],
          mapData['Progress'].toString().trim() == 'null' ||
              mapData['Progress'].toString().trim() == 'Null' ? '' : mapData['Progress'],
          mapData['Status'].toString().trim() == 'null' ||
              mapData['Status'].toString().trim() == 'Null' ? '' : mapData['Status'],
          mapData['Action'].toString().trim() == 'null' ||
              mapData['Action'].toString().trim() == 'Null' ? '' : mapData['Action'],
        ]);
      }
    }


    final pdf = pw.Document(pageMode: PdfPageMode.outlines);
    final fontData1 = await rootBundle.load('fonts/IBMPlexSans-SemiBold.ttf');
    final fontData2 = await rootBundle.load('fonts/IBMPlexSans-Bold.ttf');

    pdf.addPage(pw.MultiPage(
      theme:pw.ThemeData.withFont(
        base: pw.Font.ttf(fontData1),
        bold: pw.Font.ttf(fontData2),
      ),
        pageFormat: PdfPageFormat.a4,
        orientation: pw.PageOrientation.portrait,
        crossAxisAlignment: pw.CrossAxisAlignment.start,

        //Header part of PDF
        header: (pw.Context context) {
          return pw.Container(
              alignment: pw.Alignment.centerRight,
              margin: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
              padding: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
              decoration: const pw.BoxDecoration(
                  border: pw.Border(
                      bottom: pw.BorderSide(width: 0.5, color: PdfColors.grey))),
              child: pw.Column(children: [

                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Monthly Report', textScaleFactor: 2,
                    style: const pw.TextStyle(
                      color: PdfColors.blue700
                    )),
                    pw.Container(
                      width: 100,
                      height: 100,
                      child: pw.Image(myImage),
                    ),
                  ]
                ),

              ])
          );
        },

        footer: (pw.Context context) {
          return pw.Container(
              alignment: pw.Alignment.centerRight,
              margin: const pw.EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
              child: pw.Text(
                'User ID - $userId',
                  style: pw.Theme.of(context)
                      .defaultTextStyle
                      .copyWith(color: PdfColors.black)));
        },

        build: (pw.Context context) => <pw.Widget>[

          pw.Column(
                children: [
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('Place:  ${widget.cityName}/${widget.depoName}', textScaleFactor: 1.1,),
                      pw.Text('Date:  $date ', textScaleFactor: 1.1,)
                    ]
                  ),
                  pw.SizedBox(
                    height: 20
                  )
                ]
              ),

          pw.Table.fromTextArray(
            columnWidths: {
              0: const pw.FixedColumnWidth(250),
              1: const pw.FixedColumnWidth(250),
              2: const pw.FixedColumnWidth(250),
              3: const pw.FixedColumnWidth(250),
            },
            headers: ['Activity Details', 'Progress', 'Status','Next Month Action Plan'],
            headerStyle: headerStyle,
            headerHeight: 8,
            cellHeight:8.0,
            cellStyle: cellStyle,
            context: context,
            data: allData,
          ),

          pw.Table(
            children: rows
          ),

          pw.Padding(padding: const pw.EdgeInsets.all(10)),
        ]));

    final pdfData = await pdf.save();
    const String pdfPath = 'MonthlyReport.pdf';

    // Save the PDF file to device storage
    if (kIsWeb) {
      if(decision == 1 ){
        final blob = html.Blob([pdfData], 'application/pdf');
        final url = html.Url.createObjectUrlFromBlob(blob);
        html.window.open(url, '_blank');
        html.Url.revokeObjectUrl(url);
      }
      else if (decision == 2){
        final anchor = html.AnchorElement(
            href: "data:application/octet-stream;base64,${base64Encode(pdfData)}")
          ..setAttribute("download", pdfPath)
          ..click();
      }

    } else {
      //Write code so that it can be downloaded in android
      print('Sorry it is not ready for mobile platform');
    }
  }




}
