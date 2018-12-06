import 'dart:async';

import 'package:flutter/material.dart';

import '../github/pullrequest.dart';
import '../github/issue.dart';
import '../github/label.dart';
import '../github/timeline.dart';
import '../github/graphql.dart';
import '../pages/prtimelineview.dart';
import '../pages/issuetimelineview.dart';

// Tile for either PR or Issue
class IssueTile extends StatelessWidget {
  // one will be null
  final Issue issue;
  final PullRequest pr;

  IssueTile(this.issue, this.pr);

  @override
  Widget build(BuildContext context) {
    if (issue == null) {
      return Card(
          child: ListTile(
              contentPadding: EdgeInsets.all(1.0),
              leading: Text("${pr.number}"),
              title: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("${pr.title}"),
                  Text(
                    "Opened by ${pr.author}",
                    style: TextStyle(fontSize: 12.0),
                  ),
                  LabelTile(pr.labels)
                ],
              ),
              onTap: () {
                // call query that displays page with the PR's info
                Future<List<TimelineItem>> timelines = getPRTimeline(pr);
                // display them
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PRTimelineView(timelines, pr),
                  ),
                );
              }));
    } else {
      return Card(
          child: ListTile(
              leading: Text("${issue.number}"),
              title: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("${issue.title}"),
                  Text(
                    "Opened by ${issue.author}",
                    style: TextStyle(fontSize: 12.0),
                  ),
                  LabelTile(issue.labels)
                ],
              ),
              onTap: () {
                // call query that displays page with the PR's info
                Future<List<TimelineItem>> timelines = getIssueTimeline(issue);
                // display them
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => IssueTimelineView(timelines, issue),
                  ),
                );
              }));
    }
  }
}

class LabelTile extends StatelessWidget {
  final List<Label> labels;

  LabelTile(this.labels);

  Widget getLabelWidgets() {
    List<Widget> l = new List<Widget>();

    for (var i = 0; i < labels.length; i++) {
      l.add(LabelWidget(labels[i]));
    }

    return Wrap(children: l);
  }

  @override
  Widget build(BuildContext context) {
    return getLabelWidgets();
  }
}

class LabelWidget extends StatelessWidget {
  final Label label;

  LabelWidget(this.label);

  @override
  Widget build(BuildContext context) {
    var colorInt = int.parse(label.colorHex, radix: 16);
    return Chip(
      backgroundColor: Color(colorInt).withOpacity(1.0),
      label:
          Text(label.labelName, style: TextStyle(fontWeight: FontWeight.bold)),
    );
  }
}
