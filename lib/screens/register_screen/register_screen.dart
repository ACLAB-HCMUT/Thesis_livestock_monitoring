import 'package:do_an_app/controllers/user_controller/user_bloc.dart';
import 'package:do_an_app/screens/cow_add_new_screen/widgets/loading_overlay.dart';
import 'package:do_an_app/screens/login_screen/login_screen.dart';
import 'package:do_an_app/screens/custom_dashboard_screen/utils/dialog.dart';
import 'package:do_an_app/screens/register_screen/utils/validation_utils.dart';
import 'package:do_an_app/screens/slide_transition/fade_route.dart';
import 'package:do_an_app/screens/slide_transition/slide_right_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _isLoading = false;
  late final TextEditingController _fullname;
  late final TextEditingController _email;
  late final TextEditingController _password;
  late final TextEditingController _password_retype;
  bool obscure_pass = true;
  bool obscure_passre = true;

  @override
  void initState() {
    _fullname = TextEditingController();
    _email = TextEditingController();
    _password = TextEditingController();
    _password_retype = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _fullname.dispose();
    _email.dispose();
    _password.dispose();
    _password_retype.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        if (state is UserLoading) {
          setState(() => _isLoading = true);
        } else {
          setState(() => _isLoading = false);
          if (state is UserLoaded) {
            Future.delayed(const Duration(milliseconds: 300), () {
              // Add a small delay
              Navigator.of(context).pushReplacement(
                SlideRightRoute(page: const LoginScreen()),
              );
              ShowDialog.showSuccessfulDialog(
                  context, "Registration successful. Please login to continue.");
            });
          } else if (state is UserError) {
            ShowDialog.showErrorDialog(
                context, "Registration failed", state.message);
          }
        }
      },
      child: Stack(
        children: [
          Scaffold(
              body: Stack(
            children: [
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
                                    'assets/cow_icon2.jpg',
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Sign Up',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.normal,
                                  color: Color.fromARGB(255, 125, 128, 128)),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: TextField(
                                controller: _fullname,
                                enableSuggestions: false,
                                autocorrect: false,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  hintText: 'Enter your name',
                                  hintStyle: const TextStyle(
                                      color:
                                          Color.fromARGB(255, 125, 128, 128)),
                                  border: InputBorder.none,
                                  filled: true,
                                  fillColor: Colors.transparent,
                                  contentPadding: const EdgeInsets.all(15.0),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors
                                            .transparent), // Default border
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
                              child: TextField(
                                controller: _email,
                                enableSuggestions: false,
                                autocorrect: false,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  hintText: 'Enter your email',
                                  hintStyle: const TextStyle(
                                      color:
                                          Color.fromARGB(255, 125, 128, 128)),
                                  border: InputBorder.none,
                                  filled: true,
                                  fillColor: Colors.transparent,
                                  contentPadding: const EdgeInsets.all(15.0),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors
                                            .transparent), // Default border
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
                                      controller: _password,
                                      enableSuggestions: false,
                                      autocorrect: false,
                                      obscureText: obscure_pass,
                                      keyboardType:
                                          TextInputType.visiblePassword,
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
                            const SizedBox(height: 16),
                            Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                child: StatefulBuilder(
                                    builder: (context, setState) {
                                  return TextField(
                                    obscureText: obscure_passre,
                                    controller: _password_retype,
                                    enableSuggestions: false,
                                    autocorrect: false,
                                    keyboardType: TextInputType.visiblePassword,
                                    decoration: InputDecoration(
                                      hintText: 'Retype your password',
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
                                        icon: Icon(
                                          obscure_passre
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                        ),
                                        onPressed: () {
                                          //print(_password_retype.text);
                                          //print(obscure_passre);
                                          setState(() {
                                            obscure_passre = !obscure_passre;
                                          });
                                        },
                                      ),
                                    ),
                                  );
                                })),
                            const SizedBox(height: 24),
                            ElevatedButton(
                              onPressed: () async {
                                final fullname = _fullname.text.trim();
                                final email = _email.text.trim();
                                final password = _password.text.trim();
                                final retypePassword =
                                    _password_retype.text.trim();
                                if (!ValidationUtils.validateRegisterInputs(
                                    context,
                                    _fullname,
                                    _email,
                                    _password,
                                    _password_retype)) {
                                  ShowDialog.showErrorDialog(
                                      context,
                                      "Registration failed",
                                      "Please fill in all information.");
                                  return;
                                }

                                if (password != retypePassword) {
                                  ShowDialog.showErrorDialog(
                                      context,
                                      "Registration failed",
                                      "Password invalid.");
                                  return;
                                }
                                context.read<UserBloc>().add(CreateUserEvent(
                                    username: email,
                                    password: password,
                                    fullname: fullname,
                                    global_address: 0));
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
                                'Sign up',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              "Already registered? Login here!",
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
                                  color: Color.fromARGB(255, 125, 128, 128)),
                              textAlign: TextAlign.center,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pushReplacement(
                                    FadeRoute(page: const LoginScreen()));
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                minimumSize: const Size(double.infinity, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40.0),
                                ),
                              ),
                              child: const Text(
                                'Log in',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )),
          if (_isLoading) LoadingOverlay()
        ],
      ),
    );
  }
}
