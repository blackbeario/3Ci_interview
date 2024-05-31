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

  submitDescription(id, String newDescription) async {
    var result = await service.patchResult(id, description: newDescription);
    return result;
  }

  return showModalBottomSheet<void>(
    context: context,
    builder: (context) {
      bool success = false;
      String exception = '';

      return StatefulBuilder(builder: (BuildContext context, StateSetter setModalState) {
        controller.text = item.description;

        return SizedBox(
          height: 200,
          child: Center(
            child: success == true
                ? const Text('Success!', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold))
                : exception.isNotEmpty
                    ? Column(children: [
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
                            ],
                          ),
                        ),
                        Text(
                          exception,
                          style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                        )
                      ])
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Wrap(children: [
                            Text(item.name),
                          ]),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(30, 0, 30, 20),
                            child: TextField(
                              controller: controller,
                              decoration: const InputDecoration(hintText: 'add description'),
                            ),
                          ),
                          ElevatedButton(
                            child: const Text('Submit'),
                            onPressed: () async {
                              try {
                                var result = await submitDescription(item.id, controller.text);
                                if (result.description.isNotEmpty) {
                                  setModalState(() => success = true);
                                  Future.delayed(const Duration(seconds: 2), () {
                                    Navigator.pop(context);
                                  });
                                }
                              } catch (e) {
                                setModalState(() => exception = e.toString());
                              }
                            },
                          ),
                        ],
                      ),
          ),
        );
      });
    },
  );
}
