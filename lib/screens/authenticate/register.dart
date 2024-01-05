import 'package:algerian_touristic_guide_app/services/auth.dart';
import 'package:algerian_touristic_guide_app/shared/constants.dart';
import 'package:algerian_touristic_guide_app/shared/loading.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  //const Register({super.key});

  final Function toggleView;

  const Register({super.key, required this.toggleView});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  
  String fullName = '';
  String email = '';
  String password = '';
  String confirmPassword = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading ? const Loading() : Scaffold(
      backgroundColor: Colors.green[50],
      appBar: AppBar(
        backgroundColor: Colors.green[400],
        foregroundColor: Colors.white,
        elevation : 0.0,
        title: const Text('Sign up to Algeria Tour'),
        actions:<Widget>[
          TextButton.icon(
            icon: const Icon(Icons.login),
            label: const Text("Sign In"),
            onPressed: (){
              widget.toggleView();
            },
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
          child: Form(
            key: _formKey, //To keep track of our form and its state which helps in validating it.
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
                  decoration: textInputDecoration.copyWith(hintText: 'Full Name', icon: const Icon(Icons.person),),
                  validator: (val) => val!.isEmpty ? 'The full name field cannot be empty!' : null,
                  onChanged: (val) {
                    setState(() {
                      fullName = val;
                    });
                  }
                ),
                const SizedBox(height: 20.0),
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
                  validator: (val) => val!.length < 8  ? 'A password cannot have less than 8 characters!' : null,
                  obscureText: true,
                  onChanged: (val) {
                    setState(() {
                      password = val;
                    });
                  }
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  decoration: textInputDecoration.copyWith(hintText: 'Confirm Password', icon: const Icon(Icons.key),),
                  validator: (val) => val!.length < 8  ? 'A password cannot have less than 8 characters!' : null,
                  obscureText: true,
                  onChanged: (val) {
                    setState(() {
                      confirmPassword = val;
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
                        'Sign Up',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                        ),
                      ),
                      onPressed: () async {
                        if (password == confirmPassword) {
                          if(_formKey.currentState!.validate()){
                            //print('$email | $password');
                            setState(() {
                              loading = true;
                            });
                            dynamic result = await _auth.registerWithEmailAndPassword(email, password, fullName);
                            if(result == null){
                              setState(() {
                                error = 'Please supply a valid email';
                                loading = false;
                              });
                            }
                          }
                        }else{
                          setState(() {
                            error = 'Passwords do not match.';
                          });
                        }
                      }
                    ),
                  ],
                ),
                const SizedBox(height: 12.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(width: 40.0),
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
      ),
    );
  }
}