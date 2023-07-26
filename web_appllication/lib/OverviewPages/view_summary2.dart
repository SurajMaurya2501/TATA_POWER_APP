import 'dart:convert';
import 'dart:html' as html;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import '../widgets/custom_appbar.dart';
import 'package:pdf/widgets.dart' as pw;

class View_Summary extends StatefulWidget {

  String? userId;
  String? cityName;
  String? depoName;
  String? id;
  View_Summary({
    super.key,
    this.userId,
    this.cityName,
    required this.depoName,
    this.id,
  });


  @override
  State<View_Summary> createState() => _View_SummaryState();
}

class _View_SummaryState extends State<View_Summary> {

  List<dynamic> temp = [];

  //Daily Project Row List for view summary
  List<List<dynamic>> rowList = [];

  List<dynamic> rowList2 = [];

  //Daily Project Date List of all users for row.builder
  List<dynamic> totalDate = [];

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
    await getRows();
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
              text: ' ${widget.cityName}/ ${widget.depoName} / Daily Report',
              userid: widget.userId,
            ),
            preferredSize: const Size.fromHeight(50)),
        body: FutureBuilder<List<List<dynamic>>>(
          future: fetchData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return  Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const[
                    CircularProgressIndicator(),
                    Text('Collecting Data...',
                    style: TextStyle(
                      fontSize: 16,
                    ),)
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
                  child: Text('No data available'),
                );
              }

              return Center(
                child: SingleChildScrollView(
                  child: DataTable(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey[300]!,
                        width: 1.0,
                      ),
                    ),
                    columnSpacing: 120.0,
                    headingRowColor: MaterialStateColor.resolveWith((states) => Colors.blue[900]!),
                    headingTextStyle: const TextStyle(
                      color: Colors.white
                    ),
                    columns: const [
                      DataColumn(label: Text('UserID',)),
                      DataColumn(label: Text('Download')),
                      DataColumn(label: Text('Date')),
                    ],
                    rows: data.map(
                          (rowData) {
                        return DataRow(
                          cells: [
                            DataCell(Text(rowData[0])),
                            DataCell(
                              ElevatedButton(
                                onPressed: () {
                                  _generatePDF(rowData[0], rowData[2]);
                                },
                                child: const Text('Pdf'),
                              )
                            ),
                            DataCell(Text(rowData[2])),
                          ],
                        );
                      },
                    ).toList(),
                  ),
                ),
              );
            }

            return Container();
          },
        ),
      ),
    );
  }
  
  Future<void> getRows() async{


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

      List<dynamic> monthList = querySnapshot2.docs.map((e) => e.id).toList();

      for(int j = 0 ; j<monthList.length ; j++){
        rowList.add([
          userIdList[i],
          'PDF',
          monthList[j]
        ]);
      }

    }
    print(rowList);
  }



  Future<void> _generatePDF(String user_id,String date) async {


    final cellStyle = pw.TextStyle(
        color: PdfColors.black,
        fontSize: 11,
      fontWeight: pw.FontWeight.bold
    );

    final profileImage = pw.MemoryImage(
      (await rootBundle.load('assets/tata_power_logo.png')).buffer.asUint8List(),
    );

    List<List<dynamic>> tableData = [ ['Progress', 'ActivityDetails', 'TypeOfActivity','Status']];
    List<List<dynamic>> fieldData = [ ['Details','Values'] ,
      ['Installation Date', '05-10-2023'] , ['Enegization Date' , '08-07-2023'] , ['On Boarding Date' , '10-12-2023']
      , ['TPNo : ', '10'],['Rev :' , '10 March 2023'],
      ['Bus Depot Location :', 'BMTC KR Puram-29'],
      ['Address :' , 'Blue House #202'], ['Contact no / Mail Id :' , '3561515453' ],
      ['Latitude & Longitude :' , '230\'North 320\'South'],
      ['State :','Maharashtra'] , ['Charger Type : ', '230 KW Double Gun'] ,
      ['Conducted By :' , 'Ravichandran']
    ];

    List<dynamic> userData = [];

    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('SafetyChecklistTable2')
        .doc('${widget.depoName}')
        .collection('userId')
        .doc(user_id)
        .collection('date')
        .doc(date).get();

    Map<String,dynamic> docData = documentSnapshot.data() as Map<String,dynamic>;
    if(docData.isNotEmpty){
      userData.addAll(docData['data']);
      for(Map<String,dynamic> mapData in userData){
        tableData.add([
          mapData['srNo'],
          mapData['Details'],
          mapData['Status'],
          mapData['Remark']
        ]);
      }
    }
    
    final pdf = pw.Document(pageMode: PdfPageMode.outlines);

    pdf.addPage(pw.MultiPage(

        pageFormat: PdfPageFormat.a4,
        orientation: pw.PageOrientation.portrait,
        crossAxisAlignment: pw.CrossAxisAlignment.start,

        header: (pw.Context context) {

          return pw.Container(
              alignment: pw.Alignment.centerRight,
              margin: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
              padding: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
              decoration: const pw.BoxDecoration(
                  border: pw.Border(
                      bottom: pw.BorderSide(width: 0.5, color: PdfColors.grey))),
              child:  pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: <pw.Widget>[
                    pw.Container(
                      decoration:  pw.BoxDecoration(
                        color: PdfColor.fromHex('#F9F7F7'),
                      ),
                      margin: const pw.EdgeInsets.only(bottom: 10, top: 20),
                      padding: const pw.EdgeInsets.fromLTRB(10, 4, 10, 4),
                      child: pw.Text(
                        'Safety Report', textScaleFactor: 1,
                      ),
                    ),
                    pw.Container(
                      width: 100,
                      height: 100,
                      child: pw.Image(profileImage),
                    ),
                  ]
              ),
          );
        },

        footer: (pw.Context context) {
          return pw.Container(
              alignment: pw.Alignment.centerRight,
              margin: const pw.EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
              child: pw.Text(
                'User ID - ${user_id}',
                  // 'Page ${context.pageNumber} of ${context.pagesCount}',
                  style: pw.Theme.of(context)
                      .defaultTextStyle
                      .copyWith(color: PdfColors.black)));
        },

        build: (pw.Context context) => <pw.Widget>[
          pw.Column(
                children : [

                  ]),

          pw.SizedBox(
              height: 10
          ),


      pw.Table.fromTextArray(
        cellHeight: 18.0,
        context: context,
        cellPadding: const pw.EdgeInsets.only(left: 5.0,right: 5.0,top: 10.0,bottom: 10.0),
        cellStyle: cellStyle,
        data: fieldData ,
      ),
        ],
    ),

    );

    pdf.addPage(
      pw.Page(
        build: (context) {
        return pw.Table.fromTextArray(
            data:tableData,
        );

        },
      )
    );

    final List<int> pdfData = await pdf.save();
    const String pdfPath = 'MonthlyData.pdf';

    // Save the PDF file to device storage
    if (kIsWeb) {
      final blob = html.Blob([pdfData], 'application/pdf');
      final url = html.Url.createObjectUrlFromBlob(blob);
      html.window.open(url, '_blank');
      html.Url.revokeObjectUrl(url);
      // final anchor = AnchorElement(
      //     href: "data:application/octet-stream;base64,${base64Encode(pdfData)}")
      //   ..setAttribute("download", pdfPath)
      //   ..click();
    } else {
      print('Sorry it is not ready for mobile platform');
    }
      // // For mobile platforms
      // final String dir = (await getApplicationDocumentsDirectory()).path;
      // final String path = '$dir/$pdfPath';
      // final File file = File(path);
      // await file.writeAsBytes(pdfData);
      //
      // // Open the PDF file for preview or download
      // OpenFile.open(file.path);
    }



}
