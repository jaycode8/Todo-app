import "package:flutter/material.dart";

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState  extends State<Home>{
  final TextEditingController _taskController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  
  void _showform(BuildContext ctx, int? itemKey) async {
    showModalBottomSheet(
      elevation: 5,
        context: ctx,
        builder: (_) => Container(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(ctx).viewInsets.bottom,
              top: 15,
              left: 15,
              right: 15
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                // controller: _taskController,
                decoration: InputDecoration(hintText: "Task"),
              ),
              SizedBox(height: 20,),
              ElevatedButton(onPressed: null,
                style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.blue)),
                child: Text("create new", style: TextStyle(color: Colors.white),),),
              SizedBox(height: 20,)
            ],
          ),
        )
    );
  }
  
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text("TODO", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showform(context, null),
        shape: CircleBorder(),
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white,),
      ),
    );
  }
}