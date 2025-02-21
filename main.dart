import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Task{
  String title;
  bool isCompleted;

  Task({required this.title, this.isCompleted = false});
}

class TaskProvider extends ChangeNotifier {
  final List<Task> _tasks = [];

  List<Task> get tasks => _tasks;

  void addTask(String title) {
    final task = Task(title: title);
    _tasks.add(task);
    notifyListeners();
  }

  void toggleTask(Task task) {
    task.isCompleted = !task.isCompleted;
    notifyListeners();
  }

  void deleteTask(Task task) {
    _tasks.remove(task);
    notifyListeners();
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TaskProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: ToDoScreen(),
      ),
    );
  }
}

class ToDoScreen extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('To_Do'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'All',),
              Tab(text: 'Completed',),
              Tab(text: 'Pending',)
            ],
          ),
        ),
        body: TabBarView(children: [
          _buildTaskList(taskProvider.tasks),
          _buildTaskList(taskProvider.tasks.where((task) => task.isCompleted).toList()),
          _buildTaskList(taskProvider.tasks.where((task) => !task.isCompleted).toList())
        ]
        ),
        floatingActionButton: FloatingActionButton(onPressed: (){
          showDialog(context: context,
              builder: (context) => AlertDialog(
                title: Text('New Task'),
                content: TextField(controller: _controller,),
                actions: [
                  TextButton(onPressed: (){
                    taskProvider.addTask(_controller.text);
                    _controller.clear();
                    Navigator.pop(context);
                  }, child: Text('Add'))
                ],
              )
          );
        },child: Icon(Icons.add)
        ),
      ),
    );
  }
}

Widget _buildTaskList(List<Task> tasks) {
  return ListView.builder(itemCount: tasks.length,
      itemBuilder: (context,index){
         final task = tasks[index];
         return ListTile(
           title: Text(task.title,style: TextStyle(
             decoration: task.isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
           ),),
           leading: Checkbox(value: task.isCompleted, onChanged: (value){
             Provider.of<TaskProvider>(context, listen: false).toggleTask(task);
           }),
           trailing: IconButton(onPressed: (){
             Provider.of<TaskProvider>(context, listen: false).deleteTask(task);
           }, icon: Icon(Icons.delete, color: Colors.red,)),
         );
      }
      );
}