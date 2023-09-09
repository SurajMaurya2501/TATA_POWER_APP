import 'package:flutter/material.dart';
import 'package:web_appllication/widgets/custom_appbar.dart';
import '../style.dart';

class EasyMonitoring extends StatefulWidget {
  String? cityName;
  String? depoName;
  EasyMonitoring({super.key, required this.cityName, required this.depoName});

  @override
  State<EasyMonitoring> createState() => _EasyMonitoringState();
}

class _EasyMonitoringState extends State<EasyMonitoring> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: CustomAppBar(
          showDepoBar: true,
          toEasyMonitoring: true,
          cityName: widget.cityName,
          haveSummary: false,
          text: '${widget.cityName} / ${widget.depoName} / Testing Report ',
        ),
      ),
      body: const Center(
        child: Text(
          'Easy Monitoring of O & M Are \n Under Process',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
      ),
    );
  }
}
