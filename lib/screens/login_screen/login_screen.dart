import 'package:do_an_app/controllers/user_controller/user_bloc.dart';
import 'package:do_an_app/screens/cow_add_new_screen/widgets/loading_overlay.dart';
import 'package:do_an_app/screens/custom_dashboard_screen/custom_dashboard_screen.dart';
import 'package:do_an_app/screens/custom_dashboard_screen/utils/dialog.dart';
import 'package:do_an_app/screens/login_screen/utils/validation_utils.dart';
import 'package:do_an_app/screens/register_screen/register_screen.dart';
import 'package:do_an_app/screens/slide_transition/fade_route.dart';
import 'package:do_an_app/screens/slide_transition/slide_right_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;
  late final TextEditingController _email;
  late final TextEditingController _password;
  bool obscure_pass = true;
  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return BlocListener<UserBloc, UserState>(
      listener: (context, state) async {
        if (state is UserLoading) {
          setState(() => _isLoading = true);
        } else {
          setState(() => _isLoading = false);
          if (state is UserLoaded) {
            Future.delayed(const Duration(milliseconds: 300), () {
              // Add a small delay
              Navigator.of(context).pushReplacement(
                SlideRightRoute(page: CustomDashboardScreen()),
              );
            });
          } else if (state is UserError) {
            ShowDialog.showErrorDialog(context, "Login failed", "Invalid email or password.");
          }
        }
      },
      child: Stack(
        children: [
          Scaffold(
              body: Stack(children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/background_image1.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(12.0),
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.black12,
                              blurRadius: 10,
                              offset: Offset(0, 4))
                        ]),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30.0, vertical: 30),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 150,
                            height: 150,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: ClipOval(
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Image.asset(
                                  'assets/cow_icon.jpg',
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Welcome back !',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.normal,
                                color: Color.fromARGB(255, 125, 128, 128)),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 32),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: TextField(
                              controller: _email,
                              enableSuggestions: false,
                              autocorrect: false,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                hintText: 'Enter your email',
                                hintStyle: const TextStyle(
                                    color: Color.fromARGB(255, 125, 128, 128)),
                                border: InputBorder.none,
                                filled: true,
                                fillColor: Colors.transparent,
                                contentPadding: const EdgeInsets.all(15.0),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color:
                                          Colors.transparent), // Default border
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.green,
                                      width: 2.0), // Focus border
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: StatefulBuilder(
                                builder: (context, setState) {
                                  return TextField(
                                    obscureText: obscure_pass,
                                    controller: _password,
                                    enableSuggestions: false,
                                    autocorrect: false,
                                    keyboardType: TextInputType.visiblePassword,
                                    decoration: InputDecoration(
                                        hintText: 'Enter your password',
                                        hintStyle: const TextStyle(
                                            color: Color.fromARGB(
                                                255, 125, 128, 128)),
                                        border: InputBorder.none,
                                        filled: true,
                                        fillColor: Colors.transparent,
                                        contentPadding:
                                            const EdgeInsets.all(15.0),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors
                                                  .transparent), // Default border
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.green,
                                              width: 2.0), // Focus border
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                        ),
                                        suffixIcon: IconButton(
                                            onPressed: () {
                                              setState(() {
                                                obscure_pass = !obscure_pass;
                                              });
                                            },
                                            icon: Icon(obscure_pass
                                                ? Icons.visibility
                                                : Icons.visibility_off))),
                                  );
                                },
                              )),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: () async {
                              if (!ValidationUtils.validateLoginInputs(
                                  context, _email, _password)) {
                                ShowDialog.showErrorDialog(
                                    context,
                                    "Login failed",
                                    "Please enter both email and password");
                                return;
                              }
                              final email = _email.text;
                              final password = _password.text;
                              context.read<UserBloc>().add(LoginUserEvent(
                                  username: email, password: password));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(
                                  255, 115, 190, 191), // Background color
                              minimumSize: const Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40.0),
                              ),
                            ),
                            child: const Text(
                              'Log in',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            "Don't have an account yet? Sign up now",
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.normal,
                                color: Color.fromARGB(255, 125, 128, 128)),
                            textAlign: TextAlign.center,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pushReplacement(
                                FadeRoute(page: const RegisterScreen()),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              minimumSize: const Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40.0),
                              ),
                            ),
                            child: const Text(
                              'Sign up',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
          ])),
          if (_isLoading) LoadingOverlay()
        ],
      ),
    );
  }
}
