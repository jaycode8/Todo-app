import "package:flutter/material.dart";
import "package:todo_app/db_helper.dart";

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState  extends State<Home>{
  List<Map<String, dynamic>> _todos = [];
  final TextEditingController _taskController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  bool _isLoading = true;
  void _refreshTodo() async{
    final data = await SQLHelper.getItems();
    setState(() {
      _todos = data;
      _isLoading = false;
    });
  }

  Future<void> _addItem() async{
    await SQLHelper.createItem(_taskController.text,  _descriptionController.text);
    _refreshTodo();
  }
  Future<void> _updateItem(int id) async{
    await SQLHelper.updateItem(id, _taskController.text, _descriptionController.text);
    _refreshTodo();
  }
  Future<void> _deleteItem(int id) async{
    await SQLHelper.deleteItem(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Successfully deleted the task")));
    _refreshTodo();
  }
  void _showForm(int? id) async{
    if(id != null){
      final existingTodo = _todos.firstWhere((element) => element['id'] == id);
      _taskController.text = existingTodo['title'];
      _descriptionController.text = existingTodo['description'];
    }
    showModalBottomSheet(
        elevation: 5,
        context: context,
        isScrollControlled: true,
        builder: (_) => Container(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + 120,
              top: 15,
              left: 15,
              right: 15
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _taskController,
                decoration: const InputDecoration(hintText: "Task"),
              ),
              const SizedBox(height: 10.0,),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(hintText: "Description"),
              ),
              const SizedBox(height: 20,),
              ElevatedButton(
                onPressed: () async{
                  if(id == null){
                    await _addItem();
                  }
                  if(id != null){
                    await _updateItem(id);
                  }
                  _taskController.text = '';
                  _descriptionController.text = '';
                  Navigator.of(context).pop();
                },
                style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.blue)),
                child: Text(id == null ? "create new" : "update task", style: const TextStyle(color: Colors.white),),),
              const SizedBox(height: 10,)
            ],
          ),
        )
    );
  }
  @override
  void initState(){
    super.initState();
    _refreshTodo();
  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text("TODO", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
      ),
      body: ListView.builder(
        itemCount: _todos.length,
        itemBuilder: (context, index) => Card(
          color: Colors.orange[200],
          margin: const EdgeInsets.all(5.0),
          child: ListTile(
            title: Text(_todos[index]['title']),
            subtitle: Text(_todos[index]['description']),
            trailing: SizedBox(
              width: 100.0,
              child: Row(
                children: [
                  IconButton(
                      onPressed: () => _showForm(_todos[index]['id']),
                      icon: const Icon(Icons.edit)
                  ),
                  IconButton(
                      onPressed: () => _deleteItem(_todos[index]['id']),
                      icon: const Icon(Icons.delete)
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showForm(null),
        shape: const CircleBorder(),
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white,),
      ),
    );
  }
}