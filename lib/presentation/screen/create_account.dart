import 'package:assistant/manager/auth_bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({Key key}) : super(key: key);

  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  String _email;
  String _password;
  String _rePassword;
  var _formKey = GlobalKey<FormState>();

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('CREATE ACCOUNT'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(keyboardType:TextInputType.emailAddress ,
                    decoration: InputDecoration(
                      labelText: 'Email',
                    ),
                    // style: TextStyle(color: Colors.black),
                    onSaved: (email) => _email = email,
                    validator: (value) {
                      value = value ?? '';
                      if (value.trim().isEmpty) {
                        return 'please enter a Email';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  TextFormField( keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    // style: TextStyle(color: Colors.black),
                    validator: (value) {
                      value = value ?? '';
                      if (value.trim().isEmpty) {
                        return 'please enter a password';
                      } else if (value.length < 6)
                        return 'password must be more than 6 character length';
                      _formKey.currentState.save();
                      if (_password != _rePassword) {
                        return 'the password not matched! check again.';
                      }
                      return null;
                    },
                    onSaved: (password) => _password = password,
                    decoration: InputDecoration(labelText: 'password'),
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  TextFormField( keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    // style: TextStyle(color: Colors.black),
                    validator: (value) {
                      value = value ?? '';
                      if (value.trim().isEmpty) {
                        return 'please enter a password';
                      } else if (value.length < 6) {
                        return 'password must be more than 6 character length';
                      }
                      _formKey.currentState.save();
                      if (_password != _rePassword) {
                        return 'the password not matched! check again.';
                      }
                      return null;
                    },
                    onSaved: (rePassword) => _rePassword = rePassword,
                    decoration: InputDecoration(labelText: 'ReEnter the password'),
                  ),
                  SizedBox(
                    height: 24.0,
                  ),
                  BlocConsumer<AuthBloc, AuthState>(
                    buildWhen: (previous, current) =>
                        current is AuthFailure || current is AuthSuccess,
                    listener: (context, state) {
                      if (state is AuthSuccess) {
                        Navigator.of(context).pushReplacementNamed('/home');
                      } else if (state is AuthFailure) {
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text(state.msg)));
                      }
                    },
                    builder: (context, state) {
                      if (state is AuthInProgress) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(onPressed: null, child: Text('LOGIN')),
                            CircularProgressIndicator(),
                          ],
                        );
                      }
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('LOGIN')),
                          ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState.validate()) {
                                  _formKey.currentState.save();
                                  context
                                      .read<AuthBloc>()
                                      .add(AuthAccountCreated(_email, _password));
                                }
                              },
                              child: Text('CREATE ACCOUNT'))
                        ],
                      );
                    },
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
