import 'package:flutter/material.dart';

class ShowWaitWidgetNew extends StatelessWidget {
  final String? title;
  final bool topBorder;
  final Color? appBarBackgroundColor;
  const ShowWaitWidgetNew({super.key, this.title, this.topBorder = false, this.appBarBackgroundColor = Colors.white});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: topBorder ? BorderRadius.vertical(top: Radius.circular(12)) : null,
        ),
        padding: EdgeInsets.all(10),
        child: Center(
          child:
              title != null
                  ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircularProgressIndicator(color: Colors.amber),
                      Padding(padding: EdgeInsets.all(16), child: Text(title!, textScaler: TextScaler.linear(1.0))),
                    ],
                  )
                  : CircularProgressIndicator(color: Colors.red),
        ),
      ),
    );
  }
}
