import 'package:flutter/material.dart';
import 'package:flutter_interview/api/mock.dart';
import 'package:flutter_interview/main.dart';

class DisplayWidget extends StatefulWidget {
  const DisplayWidget({super.key});

  @override
  State<StatefulWidget> createState() => DisplayWidgetState();
}

class DisplayWidgetState extends State<DisplayWidget> {
  final MockApiService mockService = MockApiService();
  final List<MockResult> mockList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder(
            future: mockService.fetchResults(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }
              if (snapshot.hasError) {
                // obviously in a production app we'd handle this better
                return Text(snapshot.error.toString());
              }
              if (snapshot.hasData) {
                for (MockResult element in snapshot.data!) {
                  mockList.add(element);
                }
              }

              return ListView.builder(
                itemExtent: 40,
                itemCount: mockList.length,
                itemBuilder: (context, index) {
                  return ResultViewWidget(
                    result: mockList[index],
                    onTap: () => _showDescriptionEditForm(context, mockList[index], mockService),
                  );
                },
              );
            }),
      ),
    );
  }
}

_showDescriptionEditForm(context, MockResult item, MockApiService service) {
  TextEditingController controller = TextEditingController();

  submitDescription(id, String newDescription) {
    service.patchResult(id, description: newDescription);
  }

  return showModalBottomSheet<void>(
    context: context,
    builder: (BuildContext context) {
      return SizedBox(
        height: 200,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(item.name),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 0),
                child: TextFormField(
                  // controller: controller,
                  initialValue: item.description,
                ),
              ),
              ElevatedButton(
                child: const Text('Submit'),
                onPressed: () {
                  submitDescription(item.id, controller.text);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}
