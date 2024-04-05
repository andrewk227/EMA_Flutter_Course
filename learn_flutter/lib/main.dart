import 'package:flutter/material.dart';

enum Gender{
  Male , Female
}
enum Level{
  First , Second , Third , Fourth
}
void main() {
  runApp(MaterialApp(
      title: 'Flutter Assignment 1',
      theme:ThemeData(
        primaryColor: Colors.blue,
        brightness: Brightness.light,
      ),
      home: const RegisterPage(),
    ));
}

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  Gender? _gender;
  Level? _level;
  final _formKey = GlobalKey<FormState>();
  final ScrollController scrollController = ScrollController();
  final _passwordController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text("Register Page" , style: TextStyle(color: Colors.white),),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        child: Form(
          key:_formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(child: Text("Become a Member" , style: TextStyle(fontWeight: FontWeight.bold),)),
                TextFormField(
                decoration: const InputDecoration(
                prefixIcon: Icon(Icons.person_2_outlined) ,
                contentPadding: EdgeInsets.all(10),
                hintText: "Name",
               ), 
               validator: (value) {
                 if(value == null || value.isEmpty){
                  return "This Field is mandatory";
                 }
                 return null;
               },
              ),
              const Padding(padding:EdgeInsets.all(10),child:  Text("Gender:", style: TextStyle(fontWeight: FontWeight.bold),)),
              RadioListTile(title:const Text("Male"),value: Gender.Male, groupValue: _gender, onChanged: (value){
                setState(() {
                  _gender = value;
                }); 
              }),
              RadioListTile(title:const Text("Female") ,value: Gender.Female, groupValue: _gender, onChanged: (value){
                setState(() {
                  _gender = value;
                }); 
              }),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty)
                  {
                    return "This Field is mandatory";
                  }
                  RegExp exp = RegExp(r'(\d{8}@stud.fci-cu.edu.eg)');
                  if(exp.hasMatch(value))
                  {
                    return null;
                  }
                  return "Invalid Email";
                },
                decoration: const InputDecoration(
                prefixIcon: Icon(Icons.email) ,
                contentPadding: EdgeInsets.all(10),
                hintText: "Email",
               ), 
              ),
              TextFormField(
                validator:(value) {
                  if (value == null || value.isEmpty)
                  {
                    return "This Field is Mandatory";
                  }
                  return null;
                },
                decoration: const InputDecoration(
                prefixIcon: Icon(Icons.card_membership) ,
                contentPadding: EdgeInsets.all(10),
                hintText: "ID",
               ),keyboardType: TextInputType.number, 
              ),
              const Padding(padding:EdgeInsets.all(10),child:  Text("Level:", style: TextStyle(fontWeight: FontWeight.bold),)),
              RadioListTile(title:const Text("First Level") ,value: Level.First, groupValue: _level, onChanged: (value){
                setState((){
                  _level = value;
                });
              }),
              RadioListTile(title:const Text("Second Level"),value: Level.Second, groupValue: _level, onChanged:(value){
                setState(() {
                  _level = value;
                });
              } ),
              RadioListTile(title:const Text("Third Level"),value: Level.Third, groupValue: _level, onChanged: (value){
                setState(() {
                  _level = value;
                });}
                ),
              RadioListTile(title:const Text("Fourth Level"),value: Level.Fourth, groupValue: _level, onChanged:(value){
                setState(() {
                  _level = value;
                }); }
                ),
              TextFormField(
                validator: (value) {
                 if(value == null || value.length < 8){
                  return "Require atleast 8 Characters";
                 }
                 return null;
               },
               controller: _passwordController,
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                decoration: const InputDecoration(
                prefixIcon: Icon(Icons.lock) ,
                contentPadding: EdgeInsets.all(10),
                hintText: "Password",
               ), 
              ),
              TextFormField(
                validator: (value) {
                 if(value == null || value.length < 8){
                  return "Require atleast 8 Characters";
                 }
                 if (value != _passwordController.text){
                  return "Confirmation password doesn't match the password";
                 }
                 return null;
               },
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                decoration: const InputDecoration(
                prefixIcon: Icon(Icons.lock_clock_outlined) ,
                contentPadding: EdgeInsets.all(10),
                hintText: "Confirm Password",
               ), 
              ),
              Center(
                child: ElevatedButton(onPressed: (){
                  if(_formKey.currentState!.validate()){
                    print("Sa7 kda");
                  }
                }, child:const Text("Register")),
              )
            ],
          ),
        ),
      ),
    );
  }
}
