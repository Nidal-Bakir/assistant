import 'package:assistant/manager/auth_bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Login extends StatefulWidget {
  const Login({Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var _obscureText = true;
  String _email;
  String _password;

  @override
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
            obscureText: _obscureText,
            // style: TextStyle(color: Colors.black),
            validator: (value) {
              value = value ?? '';
              if (value.trim().isEmpty) {
                return 'please enter a password';
              } else if (value.length < 6)
                return 'password must be more than 6 character length';
              return null;
            },
            onSaved: (password) => _password = password,
            decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: Icon(
                    Icons.visibility_rounded,
                    // color: Colors.blueGrey,
                  ),
                  onPressed: () => setState(() {
                    _obscureText = !_obscureText;
                  }),
                ),
                labelText: 'password'),
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
                    TextButton(onPressed: null, child: Text('CREATE ACCOUNT')),
                    CircularProgressIndicator(),
                  ],
                );
              }
              return Row(
                children: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed('/create-account');
                      },
                      child: Text('CREATE ACCOUNT')),
                  ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();
                          context
                              .read<AuthBloc>()
                              .add(AuthLogin(_email, _password));
                        }
                      },
                      child: Text('LOGIN'))
                ],
              );
            },
          )
        ],
      ),
    ));
  }
}
