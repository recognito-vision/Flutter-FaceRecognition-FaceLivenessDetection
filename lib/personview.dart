import 'package:flutter/material.dart';
import 'person.dart';
import 'main.dart';

// ignore: must_be_immutable
class PersonView extends StatefulWidget {
  final List<Person> personList;
  final MyHomePageState homePageState;

  const PersonView(
      {super.key, required this.personList, required this.homePageState});

  @override
  _PersonViewState createState() => _PersonViewState();
}

class _PersonViewState extends State<PersonView> {
  deletePerson(int index) async {
    await widget.homePageState.deletePerson(index);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: widget.personList.length,
        itemBuilder: (BuildContext context, int index) {
          return SizedBox(
              height: 70,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(35.0), // Set corner radius
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(30.0),
                      child: Image.memory(
                        widget.personList[index].faceJpg,
                        width: 60,
                        height: 60,
                      ),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Text(widget.personList[index].name),
                    const Spacer(),
                    IconButton(
                      icon: Image.asset(
                        'assets/ic_delete.png',  // Replace with actual URL
                        width: 22,
                        height: 22,
                      ),
                      onPressed: () => deletePerson(index),
                    ),
                    const SizedBox(
                      width: 8,
                    )
                  ],
                )));
        });
  }
}
