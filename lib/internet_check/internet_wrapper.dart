import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class InternetWrapper extends StatefulWidget {
  final Widget child;

  const InternetWrapper({super.key, required this.child});

  @override
  State<InternetWrapper> createState() => _InternetWrapperState();
}

class _InternetWrapperState extends State<InternetWrapper> {
  bool hasInternet = true;

  @override
  void initState() {
    super.initState();

    InternetConnectionChecker.instance.onStatusChange.listen((status) {
      final connected = status == InternetConnectionStatus.connected;

      setState(() {
        hasInternet = connected;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,

        if (!hasInternet)
          Container(
            color: Colors.black.withOpacity(0.7),
            child: const Center(
              child: Text(
                "No Internet Connection",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ),
      ],
    );
  }
}