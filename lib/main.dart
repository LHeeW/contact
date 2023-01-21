import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
      home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  List<String> name = [];
  void addList(p){
    setState(() {
      name.add(p);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: (){
          showDialog(context: context, builder: (context){
            return DialogUI(addList: addList);
          });
        },
      ),
      appBar: AppBar(),
      body: ListView.builder(itemCount: name.length,itemBuilder: (context,i){
        return ListTile(
          leading: const Icon(Icons.people),
          title: Text(name[i]),
        );
      }),
    );
  }
}


class DialogUI extends StatelessWidget {
  DialogUI({Key? key,this.addList}) : super(key: key);
  final addList;

  String inputText = '';
  final TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Contact'),
      content: TextField(
        controller: textEditingController,
      ),
      actions: [
        TextButton(onPressed: ()=>Navigator.pop(context), child: const Text('Cancel')),
        TextButton(onPressed: (){
          if(textEditingController.text != ''){
            addList(textEditingController.text);
            Navigator.pop(context);
          }
        }, child: const Text('Ok')),
      ],
    );
  }
}
