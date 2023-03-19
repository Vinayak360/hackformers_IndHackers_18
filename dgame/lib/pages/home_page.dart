import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../main.dart';
import '../utils/buttons.dart';

class HOME extends StatefulWidget {
  const HOME({Key? key}) : super(key: key);

  @override
  State<HOME> createState() => _HOMEState();
}

class _HOMEState extends State<HOME> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
          child: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height / 2,
            width: MediaQuery.of(context).size.height / 2,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/animations/transformer2.gif'),
                fit: BoxFit.fill,
              ),
              //border: BorderSide(width: 2.9),
              //borderRadius: BorderRadius.circular(210),
            ),
            //child: Image.asset('asset/animations/transformer2.gif'),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "ETHFORMERS",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontFamily: 'PressStart2P',
            ),
          ),
          Expanded(
            child: Center(
              child: FancyButton(
                child: Text(
                  "Play",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontFamily: 'PressStart2P',
                  ),
                ),
                size: 35,
                color: Color(0xFFCA3034),
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => GamePage(),
                      ));
                },
              ),
            ),
          ),

          AnimatedBuilder(
            animation: _animation,
            builder: (BuildContext context, Widget? child) {
              return Opacity(
                opacity: _animation.value,
                child: Text(
                  "Swipe to view Market-Place-->",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontFamily: 'PressStart2P',
                  ),
                ),
              );
            },
          ),

          SizedBox(
            height: 80,
          )
          // FancyButton(
          //   child: Text(
          //     "Your Amazing Text",
          //   ),
          //   size: 18,
          //   color: Color(0xFFCA3034),
          // ),
          //
          // Text("Play",style: TextStyle(fontFamily: 'PressStart2P')),
        ],
      )),
    );
  }
}
