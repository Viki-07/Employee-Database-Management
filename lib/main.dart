import 'package:employee_base/modalsheet.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dummy_list.dart';
import 'package:is_first_run/is_first_run.dart';

bool? firstRun;
void main() async {
// initializing the Hive Flutter instance
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('Employee_base');
// initializing the first run variable that checks if app runs for the first time
  firstRun = await IsFirstRun.isFirstRun();
  runApp(const MyApp());
}

//declaring Hive instance
final employee_Base = Hive.box('Employee_base');

//method to show Dialog Box for entry & updation of data in the Hive Database.
void showFormDialog(BuildContext context, var refreshItems, currentItemKey) {
  if (currentItemKey == null) {
    empName.clear();
    empAge.clear();
    empYoe.clear();
    gender = null;
    isActive = false;
  }
  if (currentItemKey != null) {
    final existingElement =
        items.firstWhere((element) => element["key"] == currentItemKey);
    empName.text = existingElement["name"];
    empAge.text = existingElement["age"];
    empYoe.text = existingElement["yoe"];
    gender = existingElement["gender"];
    isActive = existingElement["isActive"];
  }
  showModalBottomSheet(
      elevation: 20,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return ModalBottomSheet(
          refreshItems: refreshItems,
          itemKey: currentItemKey,
        );
      });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.brown,
      ),
      home: const MyHomePage(title: 'Employee Base'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
//method for deleting items from the Database
  Future<void> deleteItem(int key) async {
    await employee_Base.delete(key);
    refreshItems();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Employee Data deleted !')));
  }

// this method converts DataBase items into a list for UI implementation.
  void refreshItems() {
    final data = employee_Base.keys.map((key) {
      final item = employee_Base.get(key);
      return {
        "key": key,
        "name": item["name"],
        "yoe": item["yoe"],
        "age": item["age"],
        "gender": item["gender"],
        "isActive": item["isActive"]
      };
    }).toList();
    setState(() {
      items = data.reversed.toList();
    });
  }

  @override
  void initState() {
    super.initState();
    // here it is being checked if app is running for the first time
    //if so then load some Dummy data to the DataBase.
    if (firstRun!) {
      for (int i = 0; i < dummyList.length; i++) {
        employee_Base.add(dummyList[i]);
      }
    }
    refreshItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final currentItem = items[index];
              String isActive = currentItem["isActive"] ? "Yes" : "No";
              var bgColor = (currentItem["isActive"] &&
                      (int.parse(currentItem["yoe"]) > 5))
                  ? (Colors.green[200])
                  : Colors.brown[200];
              return Container(
                padding: EdgeInsets.all(5),
                child: Card(
                  color: bgColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    //set border radius more than 50% of height and width to make circle
                  ),
                  elevation: 3,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    child: Row(children: [
                      Expanded(
                        flex: 8,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    flex: 4,
                                    child: Text(
                                      currentItem["name"],
                                      textAlign: TextAlign.left,
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Expanded(
                                      flex: 5,
                                      child: Text(currentItem["gender"])),
                                ],
                              ),
                              const Padding(padding: EdgeInsets.only(top: 10)),
                              Row(children: [
                                Expanded(
                                    child: Text(
                                        '${"Age: " + currentItem["age"]} years'),),
                                Expanded(
                                    child: Text(
                                        '${"YOE: " + currentItem["yoe"]} years')),
                                Expanded(child: Text("Active: $isActive")),
                              ]),
                            ]),
                      ),
                      Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            Row(children: [
                              Expanded(
                                child: IconButton(
                                    onPressed: () =>
                                        deleteItem(currentItem["key"]),
                                    icon: const Icon(Icons.delete)),
                              ),
                              Expanded(
                                child: IconButton(
                                    onPressed: () => showFormDialog(context,
                                        refreshItems, currentItem["key"]),
                                    icon: const Icon(Icons.edit)),
                              )
                            ]),
                          ],
                        ),
                      )
                    ]),
                  ),
                ),
              );
            }),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: (() => showFormDialog(context, refreshItems, null)),
          label: const Text('Add'),
          icon: const Icon(Icons.add),
        ));
  }
}
