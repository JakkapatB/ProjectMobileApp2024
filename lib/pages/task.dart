import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
// import 'package:firebase_database/firebase_database.dart';

class MyTasks {
  final String name;
  final String color;
  bool isSelected;
  final String time;
  final DateTime dateTime;

  MyTasks(
      {required this.name,
      required this.color,
      this.isSelected = false,
      required this.time,
      required this.dateTime});
}

const List<String> listTime = <String>['20', '25', '45', '50'];

Future<void> sendPostRequest(
  String textController,
  String color,
  bool isSelected,
  String time,
) async {
  final url = Uri.parse(
      'https://test-b9609-default-rtdb.asia-southeast1.firebasedatabase.app/task.json');

  final response = await http.post(
    url,
    body: json.encode({
      'name': textController,
      'color': color,
      'isSelected': isSelected,
      'time': time,
      'dateTime': DateTime.now().toString()
    }),
  );
  if (response.statusCode == 200) {
    // ignore: avoid_print
    print('Score posted successfully');

    await fetchTasks(); // Fetch Tasks immediately after posting
  } else {
    // ignore: avoid_print
    print('Failed to post score');
  }
}

List<MyTasks> tasksDB = [];
Future<void> fetchTasks() async {
  final url = Uri.parse(
      'https://test-b9609-default-rtdb.asia-southeast1.firebasedatabase.app/task.json');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    tasksDB.clear(); // Clear existing TasksFB before updating
    final Map<String, dynamic>? data = json.decode(response.body);
    if (data != null) {
      data.forEach((key, value) {
        tasksDB.add(MyTasks(
          name: value['name'],
          color: value['color'],
          isSelected: value['isSelected'],
          time: value['time'],
          dateTime: DateTime.parse(value['dateTime']),
        ));
      });
      // tasksDB.sort((a, b) => b.score.compareTo(a.score));

      // if (mounted) {
      //   setState(() {});
      // }
      tasksDB.sort((a, b) => b.dateTime.compareTo(a.dateTime));
    }
    print('tasksBD $tasksDB');
    print("fetch seccess");
  } else {
    // ignore: avoid_print
    print('Failed to fetch Tasks');
  }
}

class TaskPage extends StatefulWidget {
  const TaskPage({Key? key}) : super(key: key);

  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  late Future<void> _fetchTasksFuture;

  @override
  void initState() {
    super.initState();
    _fetchTasksFuture = fetchTasks();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Poppins'),
      home: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: HexColor('#245798'),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'My Task',
                style: TextStyle(
                    fontSize: 20,
                    color: HexColor('#FFFFFF'),
                    fontWeight: FontWeight.bold),
              ),
              const CircleAvatar(
                backgroundImage: AssetImage('assets/images/cat.jpg'),
              ),
            ],
          ),
        ),
        body: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: HexColor('#245798'),
            image: const DecorationImage(
              image: AssetImage(
                  'assets/images/Star.png'), // Replace with your image asset
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding:
                const EdgeInsets.only(bottom: 20, top: 0, left: 20, right: 20),
            child: Column(
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: const Text(
                        "This smart tool is designed to help you better manage task.",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                        // textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ),

                //
                const SizedBox(
                  height: 10,
                ),
                FutureBuilder<void>(
                  future: _fetchTasksFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return TotalTask(tasksDB: tasksDB);
                    }
                  },
                ),

                const SizedBox(
                  height: 30,
                ),
                const AddMyTask(),
                const SizedBox(
                  height: 20,
                ),
                // MyTaskList(tasksDB: tasksDB),
                FutureBuilder<void>(
                  future: _fetchTasksFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return MyTaskList(tasksDB: tasksDB);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TotalTask extends StatefulWidget {
  final List<MyTasks> tasksDB;
  const TotalTask({Key? key, required this.tasksDB}) : super(key: key);

  @override
  State<TotalTask> createState() => _TotalTaskState();
}

class _TotalTaskState extends State<TotalTask> {
  @override
  Widget build(BuildContext context) {
    int totalTasks = widget.tasksDB.length;
    int completedTasks = widget.tasksDB.where((task) => task.isSelected).length;
    int totalTime = 0;
    widget.tasksDB.forEach((task) {
      totalTime += int.parse(task.time);
    });

    return Row(
      children: [
        Expanded(
          child: Image.asset('assets/images/worktask.png'),
        ),
        SizedBox(
          width: 150,
          child: Padding(
            padding: const EdgeInsets.only(right: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text(
                  'Tasks',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                Text(
                  totalTasks.toString(),
                  style: const TextStyle(
                      fontSize: 34,
                      color: Colors.yellow,
                      fontWeight: FontWeight.bold),
                ),
                const Text(
                  'Completed',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                Text(
                  completedTasks.toString(),
                  style: const TextStyle(
                      fontSize: 34,
                      color: Colors.yellow,
                      fontWeight: FontWeight.bold),
                ),
                const Text(
                  'Time',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                Text(
                  totalTime.toString(),
                  style: const TextStyle(
                      fontSize: 34,
                      color: Colors.yellow,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}

class MyTaskList extends StatefulWidget {
  final List<MyTasks> tasksDB;
  const MyTaskList({Key? key, required this.tasksDB}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MyTaskListState createState() => _MyTaskListState();
}

class _MyTaskListState extends State<MyTaskList> {
  @override
  Widget build(BuildContext context) {
    if (widget.tasksDB.length == 0) {
      return Expanded(child: Text('ไม่มา'));
    }
    return Expanded(
      child: SizedBox(
        height: double.infinity,
        child: ListView.builder(
          itemCount: widget.tasksDB.length,
          itemBuilder: (context, index) {
            final myTask = widget.tasksDB[index];
            final color = HexColor(widget.tasksDB[index].color);
            return Container(
              padding: const EdgeInsets.only(right: 5, left: 3),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(15),
              ),
              key: ValueKey(widget.tasksDB[index]),
              margin: const EdgeInsets.only(bottom: 10),
              // color: Colors.yellow,
              alignment: Alignment.centerLeft,
              height: 70,
              child: LabeledCheckbox(
                label: myTask.name,
                time: myTask.time,
                value: myTask.isSelected,
                onChanged: (bool newValue) {
                  setState(() {
                    myTask.isSelected = newValue;
                  });
                },
                padding: const EdgeInsets.all(0),
              ),
            );
          },
        ),
      ),
    );
  }
}

class LabeledCheckbox extends StatelessWidget {
  final String label;
  final EdgeInsets padding;
  final bool value;
  final ValueChanged<bool> onChanged;
  final String time;

  const LabeledCheckbox({
    super.key,
    required this.label,
    required this.padding,
    required this.value,
    required this.onChanged,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onChanged(!value);
      },
      child: Padding(
        padding: padding,
        child: Row(
          children: <Widget>[
            Transform.scale(
              scale: 2.0,
              child: Checkbox(
                fillColor: MaterialStateProperty.resolveWith((states) {
                  if (!states.contains(MaterialState.selected)) {
                    return Colors.white;
                  }
                  return null;
                }),
                side: const BorderSide(
                  color: Colors.white,
                ),
                shape: const CircleBorder(),
                value: value,
                onChanged: (bool? newValue) {
                  onChanged(newValue!);
                },
                activeColor: Colors.green,
              ),
            ),
            const SizedBox(
              width: 7,
            ),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                ),
                Text('$time minute',
                    style: const TextStyle(color: Colors.white))
              ],
            )),
          ],
        ),
      ),
    );
  }
}

class AddMyTask extends StatelessWidget {
  const AddMyTask({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text('My Tasks',
            style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold)),
        const SizedBox(
          width: 10,
        ),
        Padding(
          padding: const EdgeInsets.all(0),
          child: ElevatedButton(
            onPressed: () {
              // Your button logic here
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return const AddMyTaskDialog(); // Your custom dialog widget
                },
              );
            },
            style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                backgroundColor: HexColor('#FFD700'),
                padding: const EdgeInsets.only(
                    left: 0, right: 0, top: 0, bottom: 0)),
            child: const Icon(Icons.add_rounded, color: Colors.white, size: 45),
          ),
        ),
      ],
    );
  }
}

// ignore: must_be_immutable
class AddMyTaskDialog extends StatefulWidget {
  const AddMyTaskDialog({super.key});

  @override
  State<AddMyTaskDialog> createState() => _AddMyTaskDialogState();
}

class _AddMyTaskDialogState extends State<AddMyTaskDialog> {
  final TextEditingController _textController = TextEditingController();
  double selectedSize = 20;
  Color? selectedColor;
  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      // Adjust the dialog properties as needed
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  void setSelectedValue(String? value) {
    setState(() {
      selectedValue = value;
    });
  }

  Widget _buildColorActionChip(Color color) {
    return ActionChip(
      backgroundColor: color,
      shape: CircleBorder(
        side: BorderSide(
          color: selectedColor == color ? Colors.black : color,
          width: 2,
        ),
      ),
      onPressed: () {
        setState(() {
          selectedColor = color;
        });
      },
      label: SizedBox(
        width: selectedColor == color ? 30 : 20,
        height: selectedColor == color ? 30 : 20,
      ),
    );
  }

  String colorToHex(Color color) {
    return '#${color.red.toRadixString(16).padLeft(2, '0')}${color.green.toRadixString(16).padLeft(2, '0')}${color.blue.toRadixString(16).padLeft(2, '0')}';
  }

  Widget contentBox(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 30, bottom: 10, right: 30, left: 30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'My Task',
            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
          ),
          //
          //
          const SizedBox(height: 10),
          TextField(
            controller: _textController,
            // style: TextStyle(fontSize: 10),
            decoration: const InputDecoration(
                hintText: 'My Task',
                border: OutlineInputBorder(),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 0, horizontal: 10)),
          ),
          const SizedBox(height: 20),
          DropDownTime(
            onSelectedValueChanged: setSelectedValue,
          ),
          const SizedBox(height: 20),
          const Row(
            children: [
              Expanded(
                child: Text(
                  'Color',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              _buildColorActionChip(HexColor('#C56BB9')),
              _buildColorActionChip(HexColor('#1B89D9')),
              _buildColorActionChip(HexColor('#E63232')),
              _buildColorActionChip(HexColor('#FFBD46')),
            ],
          ),

          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow,
              ),
              onPressed: () async {
                if (selectedColor != null && selectedValue != null) {
                  await sendPostRequest(_textController.text,
                      colorToHex(selectedColor!), false, selectedValue!);
                  await fetchTasks();

                  setState(() {});
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pop(); // ปิด dialog
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Error'),
                        content:
                            const Text('Please select a color and a time.'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: const Text(
                'Add Task',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ),

          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text(
                'Cancel',
                style: TextStyle(color: HexColor('#245798')),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DropDownTime extends StatefulWidget {
  final Function(String?) onSelectedValueChanged;
  const DropDownTime({Key? key, required this.onSelectedValueChanged})
      : super(key: key);

  @override
  State<DropDownTime> createState() => _DropDownTimeState();
}

class _DropDownTimeState extends State<DropDownTime> {
  String dropdownValue = listTime.first;
  // String? selectedValue;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField2<String>(
      isExpanded: true,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        // Add more decoration..
      ),
      hint: const Text(
        'Select Time',
        style: TextStyle(fontSize: 16),
      ),
      items: listTime
          .map((item) => DropdownMenuItem<String>(
                value: item,
                child: Text(
                  '$item minute',
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ))
          .toList(),
      validator: (value) {
        if (value == null) {
          return 'Please select Time';
        }
        return null;
      },
      onChanged: (value) {
        setState(() {
          widget.onSelectedValueChanged(value);
        });
      },
      onSaved: (value) {
        widget.onSelectedValueChanged(value);
      },
      buttonStyleData: const ButtonStyleData(
        padding: EdgeInsets.only(right: 8),
      ),
      iconStyleData: const IconStyleData(
        icon: Icon(
          Icons.arrow_drop_down,
          color: Colors.black45,
        ),
        iconSize: 24,
      ),
      dropdownStyleData: DropdownStyleData(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      menuItemStyleData: const MenuItemStyleData(
        padding: EdgeInsets.symmetric(horizontal: 10),
      ),
    );
  }
}
