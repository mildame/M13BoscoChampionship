import 'package:flutter/material.dart';

/*void main() {
  runApp(
    const MaterialApp(home: NFLStackOverflowPage()), // use MaterialApp
  );
}*/

const double _matcheHeight = 80;
const double _matchWidth = 140;
const double _matchRightPadding = 20;
const double _minMargin = 5;

class NFLStackOverflowPage extends StatelessWidget {
  const NFLStackOverflowPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: _PageContent(
        matchupsLenghtList: [6, 4, 2, 1], // Enfrontaments en cascada
        teamsToMatch: ["T1", "T2", "T3", "T4", "T5", "T6"],
        //TODO: RANDOM GEN FOR INDEX, DISCARD TWO EACH PROGRESSION, STORE THEM IN A ORDERED LIST, DO NOT REPEAT TEAMS (DELETE IT FROM LIST WHEN THEY LOOSE),
        //BOTTON PARA GENERAR MATCHUPS CON SETSTATE() I GUESS
      ),
    );
  }
}

class _PageContent extends StatefulWidget {
  final List<int> matchupsLenghtList;
  final List<String> teamsToMatch;
  const _PageContent({
    Key? key,
    required this.matchupsLenghtList,
    required this.teamsToMatch,
  }) : super(key: key);

  @override
  State<_PageContent> createState() => _PageContentState();
}

class _PageContentState extends State<_PageContent> {
  List<double> breakpoints = [];
  List<double> verticalMargins = [];
  late ScrollController controller;

  @override
  void initState() {
    controller = ScrollController();
    populateVerticalMargins();
    populateBreakPoints();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      calculateVerticalMargins();
      calculateBreakpoints();
    });
    controller.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  void populateVerticalMargins() {
    verticalMargins = widget.matchupsLenghtList.map((e) => 0.0).toList();
  }

  void populateBreakPoints() {
    breakpoints = widget.matchupsLenghtList.map((e) => 0.0).toList();
  }

  void calculateBreakpoints() {
    breakpoints = List.generate(widget.matchupsLenghtList.length, (index) {
      return index * (_matchWidth + _matchRightPadding);
    });

    setState(() {});
  }

  void calculateVerticalMargins() {
    verticalMargins = List.generate(widget.matchupsLenghtList.length, (index) {
      final matchLenght = widget.matchupsLenghtList[index];
      final heightOfmatchups = matchLenght * _matcheHeight;
      final verticalMargin = (MediaQuery.of(context).size.height -
              heightOfmatchups) /
          (matchLenght +
              1); // if matchups lenght is 4 we have 5 spaces that need to have this height
      return verticalMargin;
    });

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: controller,
      scrollDirection: Axis.horizontal,
      slivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              final margin = _getMargin(index: index);
              return Container(
                color: const Color.fromARGB(255, 169, 94, 89), //DEBUG COLOR
                margin:
                    EdgeInsets.only(right: _matchRightPadding, bottom: margin),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    widget.matchupsLenghtList[index],
                    (index) => Container(
                      margin: EdgeInsets.only(top: margin),
                      child: const MatchWidget(),
                    ),
                  ),
                ),
              );
            },
            childCount: widget.matchupsLenghtList.length,
          ),
        ),
      ],
    );
  }

  double _getMargin({required int index}) {
    final initialMargin = verticalMargins[index];
    double verticalMarginMultiplier = 1;
    if (index > 0) {
      final previousBreakpoint = breakpoints[index - 1]; //Example: 0
      final currentBreakPoint = breakpoints[index]; //Example: 200
      final currentScrollOffset = controller.offset; // Ex: 180
      if (currentScrollOffset >= currentBreakPoint) {
        verticalMarginMultiplier = 0;
      } else if (currentScrollOffset <= previousBreakpoint) {
        verticalMarginMultiplier = 1;
      } else {
        final gap = currentBreakPoint - previousBreakpoint; // Ex 200 - 0
        final currentExtend =
            currentScrollOffset - previousBreakpoint; // Ex: 180 - 0
        verticalMarginMultiplier =
            1 - currentExtend / gap; // Ex: 1 - 180 / 200 = 1 - 0.9 = 0.1
      }
    }
    final marginAndverticalMarginMultiplier =
        initialMargin * verticalMarginMultiplier; // Ex: 40 * 0.1 = 4

    double margin = initialMargin;

    //Set _minMargin value if marginAndverticalMarginMultiplier is less than _minMargin
    if (marginAndverticalMarginMultiplier >= _minMargin) {
      margin = marginAndverticalMarginMultiplier;
    } else if (initialMargin < _minMargin && initialMargin > 0) {
      margin = initialMargin;
    } else {
      margin = _minMargin;
    }
    return margin;
  }
}

class MatchWidget extends StatelessWidget {
  const MatchWidget({Key? key}) : super(key: key);

  @override //TEAMS
  Widget build(BuildContext context) {
    return Container(
      height: _matcheHeight,
      width: _matchWidth,
      color: Colors.black,
      //child: Text(data),
    );
  }
}
