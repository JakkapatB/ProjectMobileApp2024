import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyTasks {
  final String id;
  final String name;
  final String color;
  bool isSelected;
  final int time;
  final DateTime dateTime;

  MyTasks(
      {required this.id,
      required this.name,
      required this.color,
      this.isSelected = false,
      required this.time,
      required this.dateTime});
}

final Future<FirebaseApp> firebase = Firebase.initializeApp();
CollectionReference _taskCollection =
    FirebaseFirestore.instance.collection("Tasks");

Future<void> sendPostRequest(
  String textController,
  String color,
  bool isSelected,
) async {
  await _taskCollection.add({
    'name': textController,
    'color': color,
    'isSelected': isSelected,
    'time': 0,
    'dateTime': DateTime.now(),
  });

  // ignore: avoid_print
  print('Task added successfully');
}

class TaskPage extends StatefulWidget {
  const TaskPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  late User _user;
  late Stream<QuerySnapshot> _taskStream;

  Future<void> deleteTask(MyTasks task) async {
    try {
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(_user.uid)
          .collection("Tasks")
          .doc(task.id)
          .delete();
      // ignore: avoid_print
      print('Task deleted successfully');
    } catch (e) {
      // ignore: avoid_print
      print('Error deleting task: $e');
    }
  }

  Future<void> updateTaskSelection(MyTasks task, bool newValue) async {
    try {
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(_user.uid)
          .collection("Tasks")
          .doc(task.id)
          .update({'isSelected': newValue});
      // ignore: avoid_print
      print('Task selection updated successfully');
    } catch (e) {
      // ignore: avoid_print
      print('Error updating task selection: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    // _fetchTasksFuture = fetchTasks();
    _user = FirebaseAuth.instance.currentUser!;
    _taskCollection = FirebaseFirestore.instance
        .collection("Users")
        .doc(_user.uid)
        .collection("Tasks");
    _taskStream = FirebaseFirestore.instance
        .collection("Users")
        .doc(_user.uid)
        .collection("Tasks")
        .snapshots();
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
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: _taskStream,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        List<MyTasks> tasks = [];
                        final data = snapshot.data!.docs;
                        tasks = data.map((doc) {
                          return MyTasks(
                            id: doc.id,
                            name: doc['name'],
                            color: doc['color'],
                            isSelected: doc['isSelected'],
                            time: doc['time'],
                            dateTime: doc['dateTime'].toDate(),
                          );
                        }).toList();
                        return TotalTask(tasksDB: tasks);
                      }
                    },
                  ),
                ),

                const SizedBox(
                  height: 30,
                ),
                const AddMyTask(),
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: _taskStream,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        List<MyTasks> tasks = [];
                        final data = snapshot.data!.docs;
                        tasks = data.map((doc) {
                          return MyTasks(
                            id: doc.id,
                            name: doc['name'],
                            color: doc['color'],
                            isSelected: doc['isSelected'],
                            time: doc['time'],
                            dateTime: doc['dateTime'].toDate(),
                          );
                        }).toList();
                        // tasks.sort((a, b) => b.dateTime.compareTo(a.dateTime));
                        tasks.sort((a, b) {
                          if (a.isSelected == b.isSelected) {
                            return b.dateTime.compareTo(a.dateTime);
                          }
                          return a.isSelected ? 1 : -1;
                        });
                        return MyTaskList(
                          tasksDB: tasks,
                          deleteTask: deleteTask,
                          updateTaskSelection: updateTaskSelection,
                        );
                      }
                    },
                  ),
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
    for (var task in widget.tasksDB) {
      totalTime += task.time;
    }

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
  final Function(MyTasks) deleteTask;
  final Function(MyTasks, bool) updateTaskSelection;

  const MyTaskList(
      {Key? key,
      required this.tasksDB,
      required this.deleteTask,
      required this.updateTaskSelection})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MyTaskListState createState() => _MyTaskListState();
}

class _MyTaskListState extends State<MyTaskList> {
  @override
  Widget build(BuildContext context) {
    if (widget.tasksDB.isEmpty) {
      return Expanded(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 105,
            width: 105,
            child: Expanded(
              child: Image.asset('assets/images/taskempty.png'),
            ),
          ),
          const Text(
            "No tasks yet!",
            style: TextStyle(
                fontSize: 22, color: Colors.white, fontWeight: FontWeight.w500),
          )
        ],
      ));
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
              alignment: Alignment.centerLeft,
              height: 75,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: LabeledCheckbox(
                      label: myTask.name,
                      time: myTask.time.toString(),
                      value: myTask.isSelected,
                      onChanged: (bool newValue) {
                        setState(() {
                          myTask.isSelected = newValue;
                          widget.updateTaskSelection(myTask, newValue);
                        });
                      },
                      padding: const EdgeInsets.all(0),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    color: const Color.fromRGBO(229, 229, 229, 1),
                    iconSize: 30,
                    onPressed: () {
                      widget.deleteTask(myTask);
                    },
                  ),
                ],
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
              scale: 2.2,
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
          const SizedBox(height: 30),
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
              _buildColorActionChip(HexColor('#e89602')),
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
                if (selectedColor != null) {
                  await sendPostRequest(
                    _textController.text,
                    colorToHex(selectedColor!),
                    false,
                  );
                  // await fetchTasks();

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
