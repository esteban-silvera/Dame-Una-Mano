import 'package:dame_una_mano/features/authentication/providers/providers.dart';
import 'package:dame_una_mano/features/authentication/screens/screens.dart';
import 'package:dame_una_mano/features/authentication/widgets/widgets.dart';
import 'package:flutter/material.dart';

class AuthenticationTabs extends StatefulWidget {
  final void Function(String email, String password) onLogin;
  final void Function(
          String email, String password, String? name, String? lastName)?
      onRegister;
  final bool isLoginForm;

  const AuthenticationTabs({
    Key? key,
    required this.onLogin,
    this.onRegister,
    required this.isLoginForm,
  }) : super(key: key);

  @override
  _AuthenticationTabsState createState() => _AuthenticationTabsState();
}

class _AuthenticationTabsState extends State<AuthenticationTabs>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController registerEmailController = TextEditingController();
  final TextEditingController registerPasswordController =
      TextEditingController();
  final GlobalKey<FormState> registerFormKey = GlobalKey<FormState>();
  LoginProvider loginProvider = LoginProvider();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFFA7701)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: TabBar(
              controller: _tabController,
              tabs: [
                Tab(
                  text: widget.isLoginForm ? 'Iniciar sesión' : 'Registrarse',
                ),
                Tab(
                  text: widget.isLoginForm ? 'Registrarse' : 'Iniciar sesión',
                ),
              ],
              indicator: BoxDecoration(
                color: const Color(0xFFFA7701),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 7,
                      offset: const Offset(0, 1)),
                ],
              ),
              labelColor: const Color(0xFFf5f5f5),
              unselectedLabelColor: const Color.fromARGB(255, 11, 11, 11),
              indicatorSize: TabBarIndicatorSize.tab,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.6,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color.fromARGB(224, 249, 247, 249),
            ),
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildLoginForm(formKey),
                _buildRegisterForm(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginForm(GlobalKey<FormState> formKey) {
    return SingleChildScrollView(
      child: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 20),
              const CustomText(
                text: 'Bienvenido otra vez',
                color: Color.fromARGB(255, 10, 10, 10),
                fontSize: 24.0,
                fontWeight: FontWeight.w400,
              ),
              const SizedBox(height: 10),
              const CustomText(
                text: 'Por favor complete sus datos',
                color: Color(0xFF43c7ff),
                fontSize: 20.0,
                fontWeight: FontWeight.w300,
                alignment: TextAlign.left,
              ),
              TextFormField(
                controller: emailController,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  labelText: 'Email',
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xFF43c7ff)),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  formKey.currentState!.save();
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: passwordController,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xFF43c7ff)),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  formKey.currentState!.save();
                  return null;
                },
                obscureText: true,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: formLogin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFA7701),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  textStyle: const TextStyle(color: Colors.black),
                ),
                child: const Text('Iniciar Sesión'),
              ),
              const SizedBox(height: 30),
              const CustomText(
                text: 'Olvido la contraseña?',
                color: Color.fromARGB(255, 0, 0, 0),
                fontSize: 20.0,
                fontWeight: FontWeight.w200,
                alignment: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRegisterForm() {
    return SingleChildScrollView(
      child: Form(
        key: registerFormKey,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            // Para que los elementos se expandan horizontalmente
            children: [
              const SizedBox(height: 10),
              const CustomText(
                text: 'Crea una cuenta',
                color: Color.fromARGB(255, 10, 10, 10),
                fontSize: 26.0,
                fontWeight: FontWeight.w400,
              ),
              const SizedBox(height: 5),
              const CustomText(
                text: 'Empecemos por llenar los siguientes datos',
                color: Color(0xFF43c7ff),
                fontSize: 18.0,
                fontWeight: FontWeight.w300,
                alignment: TextAlign.left,
              ),
              const SizedBox(height: 5),
              TextFormField(
                controller: nameController,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  labelText: 'Nombre',
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xFF43c7ff)),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: lastNameController,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  labelText: 'Apellido',
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xFF43c7ff)),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: registerEmailController,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  labelText: 'Email',
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xFF43c7ff)),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: registerPasswordController,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xFF43c7ff)),
                  ),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  formRegister();
                },
                style: ElevatedButton.styleFrom(
                  textStyle:
                      const TextStyle(color: Color.fromARGB(255, 250, 249, 249)),
                  backgroundColor: const Color(0xFFFA7701),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text('Registrarse'),
              ),
              const SizedBox(height: 30),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LoginScreen(
                              onLogin: (String email, String password) {},
                            )),
                  );
                },
                child: const CustomText(
                  text: 'Ya tienes una cuenta?',
                  color: Color.fromARGB(255, 6, 6, 6),
                  fontSize: 20.0,
                  fontWeight: FontWeight.w200,
                  alignment: TextAlign.center,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> formLogin() async {
    if (formKey.currentState!.validate()) {
      final email = emailController.text;
      final password = passwordController.text;
      final loginData = {'email': email, 'password': password};
      bool respuesta = await loginProvider.loginUsuario(loginData);
      if (respuesta) {
        AppDialogs.showDialog2(context, "usuario autenticado", [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, 'home');
            },
            child: const Text("OK"),
          )
        ]);
      } else {
        AppDialogs.showDialog1(context, 'no se pudo iniciar');
      }
    } else {
      AppDialogs.showDialog1(context, 'no se pudo validar');
    }
  }

  Future<void> formRegister() async {
    if (registerFormKey.currentState!.validate()) {
      final name = nameController.text;
      final lastName = lastNameController.text;
      final email = registerEmailController.text;
      final password = registerPasswordController.text;

      // Crear un mapa con la información del usuario
      Map<String, String> formData = {
        'name': name,
        'lastname': lastName,
        'email': email,
        'password': password,
      };

      bool respuesta = await RegisterProvider().registrarUsuario(formData);
      if (respuesta) {
        // Registro con exito
        AppDialogs.showDialog1(context, 'usuario registrado con exito');
      } else {
        // Error al registrar el usuario
        AppDialogs.showDialog1(context, 'ola');
      }
    } else {
      AppDialogs.showDialog1(context, 'no se pudo validar');
    }
  }
}
