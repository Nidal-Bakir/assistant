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

  Widget build(BuildContext context) {
    var _formKey = GlobalKey<FormState>();
    return Scaffold(
        body: Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
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
          TextFormField(
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
          TextFormField(
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
                              .add(AuthCreateAccount(_email, _password));
                        }
                      },
                      child: Text('CREATE ACCOUNT'))
                ],
              );
            },
          )
        ],
      ),
    ));
  }
}
