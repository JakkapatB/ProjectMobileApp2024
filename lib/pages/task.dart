import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';

class TaskPage extends StatelessWidget {
  const TaskPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Poppins'),
      home: Scaffold(
          resizeToAvoidBottomInset: false,
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
              padding: const EdgeInsets.only(
                  bottom: 20, top: 0, left: 20, right: 20),
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
                    height: 30,
                  ),
                  const AddTask(),
                  const SizedBox(
                    height: 20,
                  ),
                  const TaskList(),
                  const SizedBox(
                    height: 30,
                  ),

                  const AddMyWork(),

                  const SizedBox(
                    height: 20,
                  ),
                  const MyWorkList(),
                  // MyWidget()
                ],
              ),
            ),
          )),
    );
  }
}

class Task {
  final String taskName;
  final String amount;
  final String startDate;
  final Color backgroundIcon;

  Task(
      {required this.taskName,
      required this.amount,
      required this.startDate,
      required this.backgroundIcon});
}

final List<Task> myTaskData = [
  Task(
    taskName: "HomeWork",
    amount: '2',
    startDate: '5/2/2567',
    backgroundIcon: Colors.green,
  ),
  Task(
    taskName: "Project",
    amount: '100',
    startDate: '1/2/2567',
    backgroundIcon: Colors.yellow,
  ),
  Task(
    taskName: "Run100KM",
    amount: '4',
    startDate: '20/1/2567',
    backgroundIcon: Colors.red,
  ),
];

class TaskList extends StatefulWidget {
  const TaskList({Key? key}) : super(key: key);

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  // Generating dummy data
  // final List myData = List.generate(3, (index) => '$index');

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: myTaskData.length,
        // list item builder
        itemBuilder: (BuildContext ctx, index) {
          final task = myTaskData[index];
          return InkWell(
            onTap: () {
              // Handle item click here
              print('Item clicked: ${task.taskName}');
            },
            child: Container(
              key: ValueKey(myTaskData[index]),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              margin: const EdgeInsets.only(right: 10),
              // padding: const EdgeInsets.all(10),
              // color: Colors.white,
              width: 160,
              // alignment: Alignment.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.only(
                        top: 10, bottom: 10, right: 10, left: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: task
                                .backgroundIcon, // Set your desired background color here
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(
                                12), // Adjust padding as needed
                            child: Icon(
                              Icons.mood,
                              color: Colors.white,
                              size: 30,
                            ), // Set your desired icon color
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          task.taskName,
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          'amount: ${task.amount}',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          '${task.startDate}',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class MyWorkList extends StatefulWidget {
  const MyWorkList({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyWorkListState createState() => _MyWorkListState();
}

class _MyWorkListState extends State<MyWorkList> {
  // Generating dummy data
  // final List<String> myWorkData = List.generate(5, (index) => 'Task $index');
  // bool _isSelected = false;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        height: double.infinity,
        child: ListView.builder(
          itemCount: myWorkData.length,
          itemBuilder: (context, index) {
            final myWork = myWorkData[index];
            return Container(
              padding: const EdgeInsets.only(right: 5, left: 3),
              decoration: BoxDecoration(
                color: myWork.myworkListColor,
                borderRadius: BorderRadius.circular(15),
              ),
              key: ValueKey(myWorkData[index]),
              margin: const EdgeInsets.only(bottom: 10),
              // color: Colors.yellow,
              alignment: Alignment.centerLeft,
              height: 55,
              // child: Text(
              //   myWorkData[index],
              //   style: const TextStyle(color: Colors.white, fontSize: 20),
              // ),
              child: LabeledCheckbox(
                label: myWork.myworkName,
                value: myWork.isSelectedMyWork,
                onChanged: (bool newValue) {
                  setState(() {
                    myWork.isSelectedMyWork = newValue;
                  });
                },
                padding: const EdgeInsets.all(0),
              ),
            );
            // return ListTile(
            //   title: Text(myWorkData[index],
            //       style: TextStyle(color: Colors.white)),
            // );
          },
        ),
      ),
    );
  }
}

class LabeledCheckbox extends StatelessWidget {
  const LabeledCheckbox({
    super.key,
    required this.label,
    required this.padding,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final EdgeInsets padding;
  final bool value;
  final ValueChanged<bool> onChanged;

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
              scale: 1.9,
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
                shape: CircleBorder(),
                value: value,
                onChanged: (bool? newValue) {
                  onChanged(newValue!);
                },
                activeColor: Colors.green,
              ),
            ),
            SizedBox(
              width: 7,
            ),
            Expanded(
                child: Text(
              label,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.white),
            )),
          ],
        ),
      ),
    );
  }
}

class MyWork {
  final String myworkName;
  final Color myworkListColor;
  bool isSelectedMyWork;

  MyWork({
    required this.myworkName,
    required this.myworkListColor,
    this.isSelectedMyWork = false,
  });
}

final List<MyWork> myWorkData = [
  MyWork(
    myworkName: "Mobile Application",
    myworkListColor: HexColor('#C56BB9'),
    isSelectedMyWork: false,
  ),
  MyWork(
    myworkName: "Database",
    myworkListColor: HexColor('#1B89D9'),
    isSelectedMyWork: false,
  ),
  MyWork(
    myworkName: "Software Engineer",
    myworkListColor: HexColor('#E63232'),
    isSelectedMyWork: false,
  ),
  MyWork(
    myworkName: "Operating System",
    myworkListColor: HexColor('#FFBD46'),
    isSelectedMyWork: false,
  ),
];

class AddTask extends StatelessWidget {
  const AddTask({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text('Tasks',
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
                  return AddTaskDialog(); // Your custom dialog widget
                },
              );
            },
            style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),

                // RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                // Button color
                backgroundColor: HexColor('#C56BB9'),
                // Splash color
                // foregroundColor: Colors.cyan,
                padding: const EdgeInsets.only(
                    left: 0, right: 0, top: 0, bottom: 0)),
            child: const Icon(Icons.add_rounded, color: Colors.white, size: 45),
          ),
        ),
      ],
    );
  }
}

class AddTaskDialog extends StatelessWidget {
  const AddTaskDialog({super.key});

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

  Widget contentBox(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 30, bottom: 10, right: 30, left: 30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //Text(
          //   'Custom Dialog Title',
          //   style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          // ),
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(10),
              color: Colors.green, // Set your desired background color here
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0), // Adjust padding as needed
              child: Icon(
                Icons.mood,
                color: Colors.white,
                size: 40,
              ), // Set your desired icon color
            ),
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Add Task',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 5),
          TextField(
            // style: TextStyle(fontSize: 10),
            decoration: InputDecoration(
                hintText: 'My Task',
                border: OutlineInputBorder(),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 0, horizontal: 10)),
          ),
          SizedBox(height: 20),
          Row(
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
          SizedBox(height: 10),
          // MaterialColorPicker(
          //   // onColorChange: (Color color) {
          //   //   // Handle color changes
          //   // },
          //   // selectedColor: Colors.red,
          //   colors: [
          //     Colors.red,
          //     Colors.deepOrange,
          //     Colors.yellow,
          //     Colors.lightGreen
          //   ],
          // ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              ActionChip(
                backgroundColor: Colors.red,
                shape: CircleBorder(
                  side: BorderSide(
                    color: Colors.red,
                    width: 1.0,
                  ),
                ),
                onPressed: () {
                  // Do something when red swatch is selected
                },
                label: SizedBox(width: 20, height: 20),
              ),
              // SizedBox(width: 10,),
              ActionChip(
                backgroundColor: Colors.yellow,
                shape: CircleBorder(
                  side: BorderSide(
                    color: Colors.yellow,
                    width: 1.0,
                  ),
                ),
                onPressed: () {
                  // Do something when blue swatch is selected
                },
                label: SizedBox(width: 20, height: 20),
              ),
              // SizedBox(width: 10,),
              ActionChip(
                backgroundColor: Colors.green,
                shape: CircleBorder(
                  side: BorderSide(
                    color: Colors.green,
                    width: 1.0,
                  ),
                ),
                onPressed: () {
                  // Do something when green swatch is selected
                },
                label: SizedBox(width: 20, height: 20),
              ),
              ActionChip(
                backgroundColor: Colors.blue,
                shape: CircleBorder(
                  side: BorderSide(
                    color: Colors.blue,
                    width: 1.0,
                  ),
                ),
                onPressed: () {
                  // Do something when green swatch is selected
                },
                label: SizedBox(width: 20, height: 20),
              ),
            ],
          ),
          SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow,
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text(
                'Create',
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

class AddMyWork extends StatelessWidget {
  const AddMyWork({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text('My Work',
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
                  return AddMyWorkDialog(); // Your custom dialog widget
                },
              );
            },
            style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),

                // RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                // Button color
                backgroundColor: HexColor('#FFD700'),
                // Splash color
                // foregroundColor: Colors.cyan,
                padding: const EdgeInsets.only(
                    left: 0, right: 0, top: 0, bottom: 0)),
            child: const Icon(Icons.add_rounded, color: Colors.white, size: 45),
          ),
        ),
      ],
    );
  }
}

class AddMyWorkDialog extends StatelessWidget {
  const AddMyWorkDialog({super.key});

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

  Widget contentBox(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 30, bottom: 10, right: 30, left: 30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'My Work',
            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
          ),
          // Container(
          //   decoration: BoxDecoration(
          //     shape: BoxShape.rectangle,
          //     borderRadius: BorderRadius.circular(10),
          //     color: Colors.green, // Set your desired background color here
          //   ),
          //   child: Padding(
          //     padding: const EdgeInsets.all(8.0), // Adjust padding as needed
          //     child: Icon(
          //       Icons.mood,
          //       color: Colors.white,
          //       size: 40,
          //     ), // Set your desired icon color
          //   ),
          // ),
          SizedBox(height: 20),
          // Row(
          //   children: [
          //     Expanded(
          //       child: Text(
          //         'Add My Work',
          //         style: TextStyle(
          //           fontSize: 14,
          //           fontWeight: FontWeight.w500,
          //         ),
          //       ),
          //     ),
          //   ],
          // ),
          SizedBox(height: 10),
          TextField(
            // style: TextStyle(fontSize: 10),
            decoration: InputDecoration(
                hintText: 'My Work',
                border: OutlineInputBorder(),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 0, horizontal: 10)),
          ),
          SizedBox(height: 20),
          Row(
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
          SizedBox(height: 10),
          // MaterialColorPicker(
          //   // onColorChange: (Color color) {
          //   //   // Handle color changes
          //   // },
          //   // selectedColor: Colors.red,
          //   colors: [
          //     Colors.red,
          //     Colors.deepOrange,
          //     Colors.yellow,
          //     Colors.lightGreen
          //   ],
          // ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              ActionChip(
                backgroundColor: Colors.red,
                shape: CircleBorder(
                  side: BorderSide(
                    color: Colors.red,
                    width: 1.0,
                  ),
                ),
                onPressed: () {
                  // Do something when red swatch is selected
                },
                label: SizedBox(width: 20, height: 20),
              ),
              // SizedBox(width: 10,),
              ActionChip(
                backgroundColor: Colors.yellow,
                shape: CircleBorder(
                  side: BorderSide(
                    color: Colors.yellow,
                    width: 1.0,
                  ),
                ),
                onPressed: () {
                  // Do something when blue swatch is selected
                },
                label: SizedBox(width: 20, height: 20),
              ),
              // SizedBox(width: 10,),
              ActionChip(
                backgroundColor: Colors.green,
                shape: CircleBorder(
                  side: BorderSide(
                    color: Colors.green,
                    width: 1.0,
                  ),
                ),
                onPressed: () {
                  // Do something when green swatch is selected
                },
                label: SizedBox(width: 20, height: 20),
              ),
              ActionChip(
                backgroundColor: Colors.blue,
                shape: CircleBorder(
                  side: BorderSide(
                    color: Colors.blue,
                    width: 1.0,
                  ),
                ),
                onPressed: () {
                  // Do something when green swatch is selected
                },
                label: SizedBox(width: 20, height: 20),
              ),
            ],
          ),
          SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow,
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text(
                'Add Work',
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
