import 'package:employee_base/main.dart';
import 'package:flutter/material.dart';

class ModalBottomSheet extends StatefulWidget {
  final refreshItems;
  final itemKey;
  const ModalBottomSheet(
      {super.key, required this.refreshItems, required this.itemKey});
  @override
  State<ModalBottomSheet> createState() => _ModalBottomSheetState();
}

List<Map<String, dynamic>> items = [];
String? gender;
bool isActive = false;
final empName = TextEditingController();
final empYoe = TextEditingController();
final empAge = TextEditingController();

class _ModalBottomSheetState extends State<ModalBottomSheet> {
  //method to add a new item in the Database.
  Future<void> addEmoployee(Map<String, Object?> map) async {
    await employee_Base.add(map);
    widget.refreshItems();
  }

  // method to update the item in the Database.
  Future<void> updateEmployee(int key, var item) async {
    await employee_Base.put(key, item);
    widget.refreshItems();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Card(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: empName,
                keyboardType: TextInputType.name,
                decoration: const InputDecoration(label: Text('Employee Name')),
              ),
              TextField(
                controller: empYoe,
                keyboardType: TextInputType.number,
                decoration:
                    const InputDecoration(label: Text('Years of Experience')),
              ),
              TextField(
                controller: empAge,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(label: Text('Age')),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                      flex: 1,
                      child: Container(
                          // width: MediaQuery.of(context),
                          padding: const EdgeInsets.only(left: 5),
                          child: const Text('Choose Gender'))),
                  Expanded(
                    flex: 2,
                    child: RadioListTile(
                      contentPadding: const EdgeInsets.all(0),
                      title: const Text("Male"),
                      value: "Male",
                      groupValue: gender,
                      onChanged: (value) {
                        setState(() {
                          gender = value.toString();
                        });
                      },
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: RadioListTile(
                      contentPadding: const EdgeInsets.all(0),
                      title: const FittedBox(child: Text("Female")),
                      value: "Female",
                      groupValue: gender,
                      onChanged: (value) {
                        setState(() {
                          gender = value.toString();
                        });
                      },
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: RadioListTile(
                      contentPadding: const EdgeInsets.all(0),
                      title: const Text("Other"),
                      value: "other",
                      groupValue: gender,
                      onChanged: (value) {
                        setState(() {
                          gender = value.toString();
                        });
                      },
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  const Text('Is Employee Active ?'),
                  Checkbox(
                    value: isActive,
                    onChanged: (value) {
                      setState(() {
                        isActive = value!;
                      });
                    },
                  )
                ],
              ),
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: ElevatedButton(
                    onPressed: () async {
                      if (widget.itemKey != null) {
                        updateEmployee(widget.itemKey, {
                          "name": empName.text,
                          "yoe": empYoe.text,
                          "age": empAge.text,
                          "gender": gender,
                          "isActive": isActive,
                        });
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Employee Data Updated !')));
                      } else {
                        if(((empName.text.isEmpty  || empYoe.text.isEmpty || empAge.text.isEmpty)) ) 
                        {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Fields Cannot Be Empty')));
                        }
                        else
                        {

                        addEmoployee({
                          "name": empName.text,
                          "yoe": empYoe.text,
                          "age": empAge.text,
                          "gender": gender,
                          "isActive": isActive,
                        });
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Employee added successfully !')));
                        }
                      }

                      Navigator.pop(context);

                      empName.clear();
                      empYoe.clear();
                      empAge.clear();
                      isActive = false;
                    },
                    style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      // side: BorderSide(color: Colors.red)
                    ))),
                    child: const Text('Submit')),
              ),
            ],
          )),
    );
  }
}
