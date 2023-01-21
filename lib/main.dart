import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:contacts_service/contacts_service.dart';

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

  var name = [];
  void addList(p){
    setState(() {
      name.add(p);
    });
  }

  void getPermission() async{
    var status = await Permission.contacts.status;
    if(status.isGranted){
      var contacts = await ContactsService.getContacts(withThumbnails: false);
      setState((){
        name = contacts;
      });
    }else if(status.isDenied){
      print('거절됨');
      Permission.contacts.request();
    }
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
      appBar: AppBar(
        actions: [
          IconButton(onPressed: ()=>getPermission(), icon: const Icon(Icons.contacts)),
        ],
      ),
      body: ListView.builder(itemCount: name.length,itemBuilder: (context,i){
        return ListTile(
          leading: const Icon(Icons.people),
          title: Text(name[i].givenName ?? '이름없음'),
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
            var newContact = Contact();
            newContact.givenName = textEditingController.text;
            ContactsService.addContact(newContact);
            addList(newContact);
            Navigator.pop(context);
          }
        }, child: const Text('Ok')),
      ],
    );
  }
}
