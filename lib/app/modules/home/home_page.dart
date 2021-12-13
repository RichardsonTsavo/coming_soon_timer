import 'package:coming_soon/app/modules/home/components/flip_card.dart';
import 'package:coming_soon/app/modules/home/home_store.dart';
import 'package:coming_soon/app/shared/utils/style.dart';
import 'package:flutter/material.dart';

import 'package:responsive_builder/responsive_builder.dart';

class HomePage extends StatefulWidget {
  final String title;
  const HomePage({Key? key, this.title = "Home"}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomeStore store = HomeStore();
  ConstStyle constStyle = ConstStyle();

  @override
  void initState() {
    store.setList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(builder: (context, sizingInformation) =>
        LayoutBuilder(builder: (context, constraints) => Scaffold(
      backgroundColor: constStyle.primaryColor,
      body: Center(
        child: Wrap(
          alignment: WrapAlignment.spaceEvenly,
          children: [
            SizedBox(
              width: sizingInformation.isDesktop?constraints.maxWidth/2:constraints.maxWidth,
              height: sizingInformation.isDesktop?constraints.maxHeight:constraints.maxHeight/2,
              child: Padding(
                padding: sizingInformation.isDesktop?EdgeInsets.zero
                    :const EdgeInsets.symmetric(horizontal: 20.0,vertical: 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Timer para o ano novo",
                        style: TextStyle(
                            fontSize: sizingInformation.isDesktop?
                            constraints.maxWidth*0.03:constraints.maxWidth*0.08,
                            color: constStyle.secundaryColor
                        ),textAlign: TextAlign.center,),
                    const SizedBox(
                      height: 15,
                    ),
                    SizedBox(
                      width: sizingInformation.isDesktop?constraints.maxWidth*0.4:constraints.maxWidth,
                      child: Text("Lorem Ipsum is simply dummy text of the printing and typesetting"
                          " industry. Lorem Ipsum has been the industry's standard dummy text"
                          " ever since the 1500s, when an unknown printer took a galley of"
                          " type and scrambled it to make a type specimen book.",
                        style: TextStyle(
                            fontSize: sizingInformation.isDesktop?
                            constraints.maxWidth*0.01:constraints.maxWidth*0.03,
                            color: constStyle.secundaryColor
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        FlipPanel.builder(
                          itemBuilder: (context, index) {
                            return Container(
                              alignment: Alignment.center,
                              width: sizingInformation.isDesktop?constraints.maxWidth*0.11:constraints.maxWidth*0.2,
                              height: 128.0,
                              decoration: BoxDecoration(
                                color: constStyle.secundaryColor,
                                borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                              ),
                              child: Text(
                                '${store.days[index]}',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: sizingInformation.isDesktop?constraints.maxWidth*0.05:constraints.maxWidth*0.10,
                                    color: constStyle.primaryColor),
                              ),
                            );
                          },
                          itemsCount: store.days.length,
                          period: const Duration(days: 1),
                          loop: -1,
                          direction: FlipDirection.down,
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        FlipPanel.builder(
                          itemBuilder: (context, index) => Container(
                            alignment: Alignment.center,
                            width: sizingInformation.isDesktop?constraints.maxWidth*0.08:constraints.maxWidth*0.18,
                            height: 128.0,
                            decoration: BoxDecoration(
                              color: constStyle.secundaryColor,
                              borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                            ),
                            child: Text(
                              '${store.hours[index]}',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: sizingInformation.isDesktop?constraints.maxWidth*0.05:constraints.maxWidth*0.10,
                                  color: constStyle.primaryColor),
                            ),
                          ),
                          itemsCount: store.hours.length,
                          period: const Duration(hours: 1),
                          loop: -1,
                          direction: FlipDirection.down,
                          startIndex: store.getCurrentIndex(list: 1),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        FlipPanel.builder(
                          itemBuilder: (context, index) => Container(
                            alignment: Alignment.center,
                              width: sizingInformation.isDesktop?constraints.maxWidth*0.08:constraints.maxWidth*0.18,
                            height: 128.0,
                            decoration: BoxDecoration(
                              color: constStyle.secundaryColor,
                              borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                            ),
                            child: Text(
                              '${store.minutes[index]}',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: sizingInformation.isDesktop?constraints.maxWidth*0.05:constraints.maxWidth*0.10,
                                  color: constStyle.primaryColor),
                            ),
                          ),
                          itemsCount: store.minutes.length,
                          period: const Duration(minutes: 1),
                          loop: -1,
                          direction: FlipDirection.down,
                          startIndex: store.getCurrentIndex(list: 2),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        FlipPanel.builder(
                          itemBuilder: (context, index) => Container(
                            alignment: Alignment.center,
                              width: sizingInformation.isDesktop?constraints.maxWidth*0.08:constraints.maxWidth*0.18,
                            height: 128.0,
                            decoration: BoxDecoration(
                              color: constStyle.secundaryColor,
                              borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                            ),
                            child: Text(
                              '${store.seconds[index]}',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: sizingInformation.isDesktop?constraints.maxWidth*0.05:constraints.maxWidth*0.10,
                                  color: constStyle.primaryColor),
                            ),
                          ),
                          itemsCount: store.seconds.length,
                          period: const Duration(milliseconds: 1000),
                          loop: -1,
                          direction: FlipDirection.down,
                          startIndex: store.getCurrentIndex(list: 3),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Image.asset(constStyle.imageFireworks,
              width: sizingInformation.isDesktop?
              constraints.maxWidth/3:constraints.maxWidth/2,)
          ],
        ),
      ),
    )));
  }
}