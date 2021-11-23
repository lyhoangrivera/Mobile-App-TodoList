import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Todo List',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: ChangeNotifierProvider<ListProvider>(
          create: (context) => ListProvider(),
          child: MyHomePage()),
    );
  }
}

class MyHomePage extends StatefulWidget
{
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
{
  late GlobalKey<FormState> _formKey;
  late TextEditingController _controller;
  var taskItems;
  int counter = 0;
  late DynamicList listClass;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _formKey = GlobalKey();
    _controller = TextEditingController();
    taskItems = Provider.of<ListProvider>(context, listen: false);
    listClass = DynamicList(taskItems.list);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueGrey.shade700,
          centerTitle: true,
          title: Text("Make Today A Productive Day"),
        ),
        body: Container(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: _formKey,
                  child: TextFormField(
                    controller: _controller,
                    onSaved: (val) {
                      taskItems.addItem(val);
                    },
                    validator: (val) {
                      if (val!.length > 0) {
                        return null;
                      } else
                        return 'Please add a task';
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    if(_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                    }
                  },
                  child: Text('Add'),
                ),
              ),
              Consumer<ListProvider>(builder: (context, provider, listTile){
                return Expanded(
                  child: ListView.builder(
                    itemCount: listClass.list.length,
                    itemBuilder: buildList,
                  ),
                );
              }),
            ],
          ),
        )
    );
  }

  Widget buildList(BuildContext context, int index) {
    counter ++;
    return Dismissible(
        key: Key(counter.toString()),
        direction: DismissDirection.startToEnd,
        onDismissed: (direction) {
          taskItems.deleteItem(index);
        },
        child: Container(
          margin: EdgeInsets.all(4),
          decoration: BoxDecoration(
              border: Border.all(
                color: Colors.blueGrey,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(10)),
          child: ListTile(
            title: Text(listClass.list[index].toString()),
            trailing: Icon(Icons.keyboard_arrow_right),
          ),
        )
    );
  }
}

class ListProvider with ChangeNotifier
{
  List<String> list = [];

  void addItem(String item) {
    list.add(item);
    notifyListeners();
  }

  void deleteItem(int index) {
    list.removeAt(index);
    notifyListeners();
  }
}

class DynamicList
{
  List<String> _list = [];
  DynamicList(this._list);
  List get list => _list;
}