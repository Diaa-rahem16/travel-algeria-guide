import 'package:algerian_touristic_guide_app/services/auth.dart';
import 'package:algerian_touristic_guide_app/shared/constants.dart';
import 'package:algerian_touristic_guide_app/shared/loading.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  //const SignIn({super.key});

  final Function toggleView;

  const SignIn({super.key, required this.toggleView});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  // TextField state
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading ? const Loading() : Scaffold(
      backgroundColor: Colors.green[50],
      appBar: AppBar(
        backgroundColor: Colors.green[400],
        foregroundColor: Colors.white,
        elevation : 0.0,
        title: const Text('Sign in to Algeria Tour'),
        actions:<Widget>[
          TextButton.icon(
            icon: const Icon(Icons.person),
            label: const Text("Sign up"),
            onPressed: (){
              widget.toggleView();
            },
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
            ),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              const SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'ALGERIA ',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 40.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'TOUR',
                    style: TextStyle(
                      color: Colors.green[800],
                      fontSize: 40.0,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30.0),
              TextFormField(    
                decoration: textInputDecoration.copyWith(hintText: 'Email', icon: const Icon(Icons.email),),  
                validator: (val) => val!.isEmpty ? 'The email field cannot be empty!' : null,          
                onChanged: (val) {
                  setState(() {
                    email = val;
                  });
                }
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                decoration: textInputDecoration.copyWith(hintText: 'Password', icon: const Icon(Icons.key),),
                obscureText: true,
                validator: (val) => val!.length < 8  ? 'A password cannot have less than 8 characters!' : null,
                onChanged: (val) {
                  setState(() {
                    password = val;
                  });
                }
              ),
              const SizedBox(height: 30.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(width: 40.0),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color?>(Colors.green[400]),
                      fixedSize: MaterialStateProperty.all(const Size(200.0, 50.0)),
                    ),
                    child: const Text(
                      'Sign in',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                      ),
                    ),
                    onPressed: () async {
                      if(_formKey.currentState!.validate()){
                        //print('$email | $password');
                        setState(() {
                          loading = true;
                        });
                        dynamic result = await _auth.signInWithEmailAndPassword(email, password);
                        if(result == null){
                          setState(() {
                            loading = false;
                            error = 'Could not sign in with those credentials.';
                            //'If you do not have an account, please sign up first.';
                          });
                        }
                      }
                    }
                  ),
                ],
              ),
              const SizedBox(height: 12.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(width: 45.0),
                  Text(
                    error,
                    style: const TextStyle(
                      color: Color.fromARGB(248, 180, 8, 8),
                      fontSize: 14.0,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}