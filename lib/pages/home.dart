import 'package:flutter/material.dart';
import 'package:untitled/shared/birthday_fns.dart';
import 'package:untitled/shared/birthdays.dart';
import 'package:jiffy/jiffy.dart';


class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  Map monthdays = {
    'Jan': 0, 'Feb': 0+31, 'Mar': 0+31+28, 'Apr': 0+31+28+31, 'May': 0+31+28+31+30, 'June': 0+31+28+31+30+31, 'July': 0+31+28+31+30+31+30, 'Aug': 0+31+28+31+30+31+30+31, 'Sept': 0+31+28+31+30+31+30+31+31, 'Oct': 0+31+28+31+30+31+30+31+31+30, 'Nov': 0+31+28+31+30+31+30+31+31+30+31, 'Dec': 0+31+28+31+30+31+30+31+31+30+31+30,
  };
  late DatabaseHelper dbHelper;
  String name = '';
  int date = 0;
  String month = '';
  String relation = '';
  String newname = '';
  int newdate = 0;
  String newmonth = '';
  String newrelation = '';
  List l = [];
  int X = Jiffy().dayOfYear;
  late List display_l = List.from(l);
  int upper_bound() {
    int mid;
    int low = 0;
    int high = display_l.length;
    while (low < high) {
      mid = (low + (high - low)/2).floor();
      if (X >= display_l[mid].dayth) {
        low = mid + 1;
      }
      else {
        high = mid;
      }
    }
    if(low < display_l.length && display_l[low].dayth <= X) {
      low += 1;
    }
    return low;
  }

  void updateList(String value) {
    setState(() {
      display_l = l.where((element) => element.name!.toLowerCase().contains(value.toLowerCase())).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    dbHelper = DatabaseHelper();
    dbHelper.initDB().whenComplete(() async {
      setState(() {});
      l = await dbHelper.birthdays();
      display_l = l;
    });
  }

  Widget build(BuildContext context) {
    l.sort((a, b) => a.dayth.compareTo(b.dayth));
    display_l.sort((a, b) => a.dayth.compareTo(b.dayth));
    return Scaffold(
      backgroundColor: const Color(0xff333333),
      appBar: AppBar(
        title: const Text('Your Birthday chart', style: TextStyle(fontFamily: 'comfortaa',fontWeight: FontWeight.bold),),
        centerTitle: true,
        backgroundColor: const Color(0xffe21b5a),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: const Color(0xff333333),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 50.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    color: const Color(0xfffbffe3),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 8.0),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          icon: Icon(Icons.search),
                          hintText: 'Search for birthdays',
                        ),
                        onChanged: (val) => updateList(val),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40.0,),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    color: const Color(0xfffbffe3),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 12.0),
                        child: Column(
                          children: [
                            const SizedBox(height: 12.0,),
                            const Text('Upcoming Birthday', style: TextStyle(fontSize: 20.0, fontFamily: 'comfortaa', decoration: TextDecoration.underline),),
                        const SizedBox(height: 20.0,),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: display_l.isEmpty ? const Text('Please add some birthdays!') : Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
                                borderRadius: BorderRadius.circular(15.0)
                            ),
                            child: ExpansionTile(
                              title: Row(
                                children: [
                                  Container(
                                    width: 57.0,
                                    decoration: BoxDecoration(
                                        color: const Color(0xff555555).withOpacity(0.8),
                                        border: Border.all(color: const Color(0xff333333)),
                                        borderRadius: BorderRadius.circular(10.0)
                                    ),
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(7.0),
                                        child: Text('${display_l[upper_bound() == display_l.length ? 0 : upper_bound()].date}', style: const TextStyle(
                                            fontSize: 10.0,
                                            color: Color(0xfffbffe3),
                                            fontWeight: FontWeight.bold
                                        ),),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 20.0,),
                                  Text('${display_l[upper_bound() == display_l.length ? 0 : upper_bound()].name}', style: const TextStyle(color: Colors.black))
                                ],
                              ),
                                children: [
                                Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Date: ${display_l[upper_bound() == display_l.length ? 0 : upper_bound()].date}', textAlign: TextAlign.left,),
                                  Text('Relation: ${display_l[upper_bound() == display_l.length ? 0 : upper_bound()].relation}'),
                                ],
                            ),
                          ),
                          ]
                          ),
                        ),
                        )],
                        ),
                      ),
                      const SizedBox(height: 20.0,)
                    ],
                  ),
                ),
                const SizedBox(height: 40.0,),

                Container(
                  // height: 400,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    color: const Color(0xfffbffe3),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('All Birthdays', style: TextStyle(fontSize: 20.0, fontFamily: 'comfortaa', decoration: TextDecoration.underline),),
                            IconButton(onPressed: () async {
                              name = '';
                              date = 0;
                              month = '';
                              relation = '';
                              await showDialog(context: context, builder: (context) {
                                return Dialog(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                                  elevation: 15,
                                  child: StatefulBuilder(
                                      builder: (BuildContext context, StateSetter setState) {
                                    return Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        children: [
                                          TextFormField(
                                            decoration: const InputDecoration(
                                              hintText: 'Enter Name',
                                            ),
                                            onChanged: (val) =>
                                            name = val,
                                          ),
                                          const SizedBox(height: 20.0,),
                                          DropdownButton(
                                            hint: date == 0
                                                ? Text('Choose Date', style: TextStyle(fontFamily: 'comfortaa',color: Colors.grey[600] as Color,fontSize: 16.0),)
                                                : Text(
                                              '$date',
                                              style: TextStyle(fontFamily: 'comfortaa',color: Colors.grey[600] as Color, fontSize: 16.0),
                                            ),
                                            isExpanded: true,
                                            icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey[600] as Color,),
                                            iconSize: 30.0,
                                            style: TextStyle(fontFamily: 'comfortaa',color: Colors.grey[600] as Color,fontSize: 16.0),
                                            items: [for (int i = 1; i <= 31; i++) i].map(
                                                  (val) {
                                                return DropdownMenuItem<int>(
                                                  value: val,
                                                  child: Text('$val'),
                                                );
                                              },
                                            ).toList(),
                                            onChanged: (val) {
                                              setState(
                                                    () {
                                                  date = val as int;
                                                },
                                              );
                                            },
                                          ),
                                          const SizedBox(height: 20.0,),
                                          DropdownButton(
                                            hint: month == ''
                                                ? Text('Choose Month', style: TextStyle(fontFamily: 'comfortaa', color: Colors.grey[600] as Color,fontSize: 16.0),)
                                                : Text(
                                              month,
                                              style: TextStyle(fontFamily: 'comfortaa',color: Colors.grey[600] as Color, fontSize: 16.0),
                                            ),
                                            isExpanded: true,
                                            icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey[600] as Color,),
                                            iconSize: 30.0,
                                            style: TextStyle(fontFamily: 'comfortaa',color: Colors.grey[600] as Color,fontSize: 16.0),
                                            items: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'June', 'July', 'Aug', 'Sept', 'Oct', 'Nov', 'Dec'].map(
                                                  (val) {
                                                return DropdownMenuItem<String>(
                                                  value: val,
                                                  child: Text(val),
                                                );
                                              },
                                            ).toList(),
                                            onChanged: (val) {
                                              setState(
                                                    () {
                                                  month = val as String;
                                                },
                                              );
                                            },
                                          ),
                                          const SizedBox(height: 20.0,),
                                          DropdownButton(
                                            hint: relation == ''
                                                ? Text('Choose Relation', style: TextStyle(fontFamily: 'comfortaa', color: Colors.grey[600] as Color,fontSize: 16.0),)
                                                : Text(
                                              relation,
                                              style: TextStyle(fontFamily: 'comfortaa',color: Colors.grey[600] as Color, fontSize: 16.0),
                                            ),
                                            isExpanded: true,
                                            icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey[600] as Color,),
                                            iconSize: 30.0,
                                            style: TextStyle(fontFamily: 'comfortaa',color: Colors.grey[600] as Color,fontSize: 16.0),
                                            items: ['Friends', 'Family', 'Professional'].map(
                                                  (val) {
                                                return DropdownMenuItem<String>(
                                                  value: val,
                                                  child: Text(val),
                                                );
                                              },
                                            ).toList(),
                                            onChanged: (val) {
                                              setState(
                                                    () {
                                                  relation = val as String;
                                                },
                                              );
                                            },
                                          ),
                                          const SizedBox(height: 30.0,),
                                          OutlinedButton.icon(onPressed: () async {
                                            await dbHelper.insertBirthday(Birthday(name: name, date: date.toString()+' '+month, relation: relation, dayth: date+monthdays[month] as int));
                                            l = await dbHelper.birthdays();
                                            display_l = await dbHelper.birthdays();
                                            setState(() {
                                            });
                                            Navigator.pop(context);

                                          }, icon: const Icon(Icons.done_rounded), label: const Text('Add'))
                                        ],
                                      ),
                                    );}
                                  )
                                );
                              });
                              setState(() {
                              });
                            }, icon: const Icon(Icons.add)),
                          ],
                        ),
                      ),
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: display_l.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black),
                                  borderRadius: BorderRadius.circular(15.0)
                                ),
                                child: ExpansionTile(
                                  title: Row(
                                    children: [
                                      Container(
                                        width: 57.0,
                                        decoration: BoxDecoration(
                                          color: const Color(0xff555555).withOpacity(0.8),
                                          border: Border.all(color: const Color(0xff333333)),
                                          borderRadius: BorderRadius.circular(10.0)
                                        ),
                                        child: Center(
                                          child: Padding(
                                            padding: const EdgeInsets.all(7.0),
                                            child: Text('${display_l[index].date}', style: const TextStyle(
                                              fontSize: 10.0,
                                              color: Color(0xfffbffe3),
                                              fontWeight: FontWeight.bold
                                            ),),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 20.0,),
                                      Text('${display_l[index].name}', style: const TextStyle(color: Colors.black))
                                    ],
                                  ),
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text('Date: ${display_l[index].date}', textAlign: TextAlign.left,),
                                              Text('Relation: ${display_l[index].relation}'),
                                              // SizedBox(height: 20.0,),
                                            ],
                                          ),
                                          const SizedBox(height: 20.0,),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              OutlinedButton.icon(onPressed: () async {
                                                await dbHelper.deleteBirthday(l[index].name);
                                                l = await dbHelper.birthdays();
                                                display_l = await dbHelper.birthdays();
                                                setState(() {
                                                });
                                              }, icon: const Icon(Icons.delete, size: 18.0,), label: const Text('Delete', style: TextStyle(fontSize: 12.0),)),
                                              const SizedBox(width: 60.0,),
                                              OutlinedButton.icon(onPressed: () async {
                                                newname = display_l[index].name;
                                                newdate = int.parse(display_l[index].date[0] + display_l[index].date[1]);
                                                newmonth = display_l[index].date.substring(2,l[index].date.length);
                                                newrelation = display_l[index].relation;
                                                await showDialog(context: context, builder: (context) {
                                                  return Dialog(
                                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                                                      elevation: 15,
                                                      child: StatefulBuilder(
                                                          builder: (BuildContext context, StateSetter setState) {
                                                            return Padding(
                                                              padding: const EdgeInsets.all(16.0),
                                                              child: Column(
                                                                children: [
                                                                  TextFormField(
                                                                    decoration: InputDecoration(
                                                                      hintText: l[index].name,
                                                                    ),
                                                                    onChanged: (val) =>
                                                                    newname = val,
                                                                  ),
                                                                  const SizedBox(height: 20.0,),
                                                                  DropdownButton(
                                                                    hint: Text('$newdate'),
                                                                    isExpanded: true,
                                                                    icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey[600],),
                                                                    iconSize: 30.0,
                                                                    style: TextStyle(fontFamily: 'comfortaa',color: Colors.grey[600],fontSize: 16.0),
                                                                    items: [for (int i = 1; i <= 31; i++) i].map(
                                                                          (val) {
                                                                        return DropdownMenuItem<int>(
                                                                          value: val,
                                                                          child: Text('$val'),
                                                                        );
                                                                      },
                                                                    ).toList(),
                                                                    onChanged: (val) {
                                                                      setState(
                                                                            () {
                                                                          newdate = val as int;
                                                                        },
                                                                      );
                                                                    },
                                                                  ),
                                                                  const SizedBox(height: 20.0,),
                                                                  DropdownButton(
                                                                    hint: Text(newmonth),
                                                                    isExpanded: true,
                                                                    icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey[600],),
                                                                    iconSize: 30.0,
                                                                    style: TextStyle(fontFamily: 'comfortaa',color: Colors.grey[600],fontSize: 16.0),
                                                                    items: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'June', 'July', 'Aug', 'Sept', 'Oct', 'Nov', 'Dec'].map(
                                                                          (val) {
                                                                        return DropdownMenuItem<String>(
                                                                          value: val,
                                                                          child: Text(val),
                                                                        );
                                                                      },
                                                                    ).toList(),
                                                                    onChanged: (val) {
                                                                      setState(
                                                                            () {
                                                                          newmonth = val as String;
                                                                        },
                                                                      );
                                                                    },
                                                                  ),
                                                                  const SizedBox(height: 20.0,),
                                                                  DropdownButton(
                                                                    hint: Text(newrelation),
                                                                    isExpanded: true,
                                                                    icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey[600] as Color,),
                                                                    iconSize: 30.0,
                                                                    style: TextStyle(fontFamily: 'comfortaa',color: Colors.grey[600] as Color,fontSize: 16.0),
                                                                    items: ['Friends', 'Family', 'Professional'].map(
                                                                          (val) {
                                                                        return DropdownMenuItem<String>(
                                                                          value: val,
                                                                          child: Text(val),
                                                                        );
                                                                      },
                                                                    ).toList(),
                                                                    onChanged: (val) {
                                                                      setState(
                                                                            () {
                                                                          newrelation = val as String;
                                                                        },
                                                                      );
                                                                    },
                                                                  ),
                                                                  const SizedBox(height: 30.0,),
                                                                  OutlinedButton.icon(onPressed: () async {
                                                                    await dbHelper.deleteBirthday(l[index].name);
                                                                    await dbHelper.insertBirthday(Birthday(name: newname, date: newdate.toString() + ' ' + newmonth.trim(), relation: newrelation, dayth: (newdate+monthdays[newmonth.trim()]) as int));
                                                                    l = await dbHelper.birthdays();
                                                                    display_l = await dbHelper.birthdays();
                                                                    Navigator.pop(context);

                                                                  }, icon: const Icon(Icons.done_rounded), label: const Text('Update'))
                                                                ],
                                                              ),
                                                            );
                                                          }
                                                      )
                                                  );
                                                });
                                                setState((){});
                                              }, icon: const Icon(Icons.change_circle, size: 18.0,), label: const Text('Modify', style: TextStyle(fontSize: 12.0),)),
                                            ],
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          }
                      ),
                    ],
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
