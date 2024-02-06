import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class Focusfood extends StatelessWidget {
  const Focusfood({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Poppins',
        // canvasColor: Colors.black87,
      ),
      home: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: HexColor('#245798'),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Focus Food',
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
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MyDateTimeLine(),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 30, bottom: 30),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        CardBreakfast(),
                        SizedBox(
                          height: 10,
                        ),
                        CardLunch(),
                        SizedBox(
                          height: 10,
                        ),
                        CardDinner(),
                      ],
                    ),
                  ),
                )
              ],
            ),
          )
          //`selectedDate` the new date selected.
          ,
        ),
      ),
    );
  }
}

class MyDateTimeLine extends StatefulWidget {
  const MyDateTimeLine({super.key});

  @override
  _MyDateTimeLineState createState() => _MyDateTimeLineState();
}

class _MyDateTimeLineState extends State<MyDateTimeLine> {
  @override
  Widget build(BuildContext context) {
    return EasyDateTimeLine(
      initialDate: DateTime.now(),
      onDateChange: (selectedDate) {
        // [selectedDate] the new date selected.
      },
      activeColor: HexColor('#C56BB9'),
      headerProps: EasyHeaderProps(
        // monthPickerType: MonthPickerType.non,
        monthStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        selectedDateFormat: SelectedDateFormat.fullDateDMonthAsStrY,
        selectedDateStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      dayProps: EasyDayProps(
        inactiveDayNumStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        activeDayNumStyle: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        inactiveDayStrStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: HexColor('#8D8B8D'),
        ),
        activeDayStrStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        inactiveDayDecoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          color: Colors.white,
        ),
        width: 65,
        height: 100,
        todayNumStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        todayStrStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: HexColor('#8D8B8D'),
        ),
        todayHighlightStyle: TodayHighlightStyle.withBackground,
        todayHighlightColor: Colors.white,
        dayStructure: DayStructure.dayNumDayStr,
      ),
    );
  }
}

class CardBreakfast extends StatefulWidget {
  const CardBreakfast({Key? key}) : super(key: key);

  @override
  _CardBreakfastState createState() => _CardBreakfastState();
}

class _CardBreakfastState extends State<CardBreakfast> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
          // padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          width: MediaQuery.of(context).size.width,
          height: 120,
          child: Row(
            children: [
              Container(
                width: 250,
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 10, bottom: 5, left: 10, right: 0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Breakfast',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        Text(
                          'Recommended 830-1170 Cal',
                          style: TextStyle(
                              fontSize: 14, color: HexColor('#8D8B8D')),
                        ),

                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                              primary: Colors.yellow, onPrimary: Colors.black),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AddBreakfastDialog(); // Your custom dialog widget
                              },
                            );
                          },
                          label: Text("Add",
                              style: TextStyle(color: Colors.black)),
                          icon: Icon(Icons.add), //icon data for elevated button
                        ) //la
                      ]),
                ),
              ),
              Container(
                width: 120,
                height: 100,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/BraekFastFood.png'))),
              )
            ],
          )),
    );
  }
}

class AddBreakfastDialog extends StatelessWidget {
  const AddBreakfastDialog({super.key});

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
            'BreakFast',
            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Add Food',
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
                hintText: 'Food',
                border: OutlineInputBorder(),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 0, horizontal: 10)),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Calories',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          DropDownCalories(),
          SizedBox(
            height: 10,
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
                'Add Food',
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

class CardLunch extends StatefulWidget {
  const CardLunch({Key? key}) : super(key: key);

  @override
  _CardLunchState createState() => _CardLunchState();
}

class _CardLunchState extends State<CardLunch> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
          // padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          width: MediaQuery.of(context).size.width,
          height: 120,
          child: Row(
            children: [
              Container(
                width: 120,
                height: 100,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/LunchFood.png'))),
              ),
              Container(
                width: 250,
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 10, bottom: 5, left: 10, right: 0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Breakfast',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        Text(
                          'Recommended 255-370 Cal',
                          style: TextStyle(
                              fontSize: 14, color: HexColor('#8D8B8D')),
                        ),

                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                              primary: Colors.yellow, onPrimary: Colors.black),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AddLunchDialog(); // Your custom dialog widget
                              },
                            );
                          },
                          label: Text("Add",
                              style: TextStyle(color: Colors.black)),
                          icon: Icon(Icons.add), //icon data for elevated button
                        ) //la
                      ]),
                ),
              ),
            ],
          )),
    );
  }
}

class AddLunchDialog extends StatelessWidget {
  const AddLunchDialog({super.key});

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
            'Lunch',
            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Add Food',
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
                hintText: 'Food',
                border: OutlineInputBorder(),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 0, horizontal: 10)),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Calories',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          DropDownCalories(),
          SizedBox(
            height: 10,
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
                'Add Food',
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

class CardDinner extends StatefulWidget {
  const CardDinner({Key? key}) : super(key: key);

  @override
  _CardDinnerState createState() => _CardDinnerState();
}

class _CardDinnerState extends State<CardDinner> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
          // padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          width: MediaQuery.of(context).size.width,
          height: 120,
          child: Row(
            children: [
              Container(
                width: 250,
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 10, bottom: 5, left: 10, right: 0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Dinner',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        Text(
                          'Recommended 255-370 Cal',
                          style: TextStyle(
                              fontSize: 14, color: HexColor('#8D8B8D')),
                        ),

                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                              primary: HexColor('#33D142'),
                              onPrimary: Colors.white),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AddDinnerDialog(); // Your custom dialog widget
                              },
                            );
                          },
                          label: Text("Success",
                              style: TextStyle(color: Colors.white)),
                          icon:
                              Icon(Icons.check), //icon data for elevated button
                        ) //la
                      ]),
                ),
              ),
              Container(
                width: 120,
                height: 100,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/BraekFastFood.png'))),
              )
            ],
          )),
    );
  }
}

class AddDinnerDialog extends StatelessWidget {
  const AddDinnerDialog({super.key});

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
            'Dinner',
            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Add Food',
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
                hintText: 'Food',
                border: OutlineInputBorder(),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 0, horizontal: 10)),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Calories',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          DropDownCalories(),
          SizedBox(
            height: 10,
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
                'Add Food',
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

class DropDownCalories extends StatefulWidget {
  const DropDownCalories({super.key});

  @override
  State<DropDownCalories> createState() => _DropDownCaloriesState();
}

class _DropDownCaloriesState extends State<DropDownCalories> {
  String dropdownValue = list.first;
  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField2<String>(
      isExpanded: true,
      decoration: InputDecoration(
        // Add Horizontal padding using menuItemStyleData.padding so it matches
        // the menu padding when button's width is not specified.
        contentPadding: const EdgeInsets.symmetric(vertical: 0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        // Add more decoration..
      ),
      hint: const Text(
        'Select Calories',
        style: TextStyle(fontSize: 16),
      ),
      items: list
          .map((item) => DropdownMenuItem<String>(
                value: item,
                child: Text(
                  item,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ))
          .toList(),
      validator: (value) {
        if (value == null) {
          return 'Please select gender.';
        }
        return null;
      },
      onChanged: (value) {
        //Do something when selected item is changed.
      },
      onSaved: (value) {
        selectedValue = value.toString();
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

const List<String> list = <String>['25-50', '50-75', '75-100', '100-125'];
