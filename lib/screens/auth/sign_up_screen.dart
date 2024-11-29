import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hiv/constact/color_constant.dart';
import 'package:hiv/screens/auth/sign_in_screen.dart';
import 'package:hiv/controller/auth_controller.dart';
import 'package:hiv/models/user_model.dart';
import 'package:hiv/utils/dialogs.dart';
import 'package:hiv/utils/responsive_view.dart';
import 'package:hiv/utils/widgets/format_widget.dart';
import 'package:hiv/utils/widgets/standart_widget.dart';
import 'package:hiv/utils/widgets/topic_loader_button.dart';
import 'package:hiv/utils/widgets/topic_text_field.dart';


class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
final AuthController _authController = Get.find();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TopicColor.black,
      body: SingleChildScrollView(
        padding:
            const EdgeInsets.only(left: 15, right: 15, top: 50, bottom: 10),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Image(
                    height: 120,
                    width: 140,
                    image: AssetImage('assets/images/logo.png')),
              ),
              const GeneralText(
                text: 'Name',
              ),
              verticalGap(5),
              TopicTextField(),
              verticalGap(8),
              const GeneralText(
                text: 'Email',
              ),
              verticalGap(5),
              TopicTextField(),
              verticalGap(8),
              const GeneralText(
                text: 'Username',
              ),
              verticalGap(2),
              TopicTextField(),
              verticalGap(8),
              const GeneralText(
                text: 'Country Code',
              ),
              verticalGap(2),
              TopicTextField(),
              verticalGap(8),
              const GeneralText(
                text: 'Phone Number',
              ),
              verticalGap(2),
              TopicTextField(),
              verticalGap(8),
              const GeneralText(
                text: 'Date of birth',
              ),
              verticalGap(2),
              TopicTextField(),
              verticalGap(8),
              const GeneralText(
                text: 'Password',
              ),
              verticalGap(2),
              TopicTextField(),
              verticalGap(8),
              verticalGap(30),
              SizedBox(
                height: 45,
                width: context.screenWidth,
                child: TopicLoaderButton(
                  btnText: 'Register',
                  radius: 10,
                  color: TopicColor.primary,
                  onTap: () async {
                    try {
                      if (formKey.currentState!.validate()) {

                         UserModel userModel = UserModel(
                            uid: '',
                            name: nameController.text,
                            email: emailController.text,
                            phone: phoneController.text);
                        await _authController.signUp(
                          userModel,
                          passwordController.text.trim(),
                        );
                        if (!mounted) return;
                        if (_authController.isLoggedIn) {
                          Get.offAll(()=> const SignInScreen());
                        }
                        
                       
                        

                        
                      }
                    } catch (e) {
                      showMessage('Registration Failed',
                          'Please check your details and try again.');
                    }
                  },
                ),
              ),
               Center(
                 child: TextButton(
                               onPressed: () {
                  Get.to(SignInScreen());
                               },
                               child: Text("Already have an account? Sign In"),
                             ),
               ),
            ],
          ),
        ),
      ),
    );
  }
}

class GeneralText extends StatelessWidget {
  const GeneralText({super.key, this.text = ''});
  final String? text;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Text(
        text!,
        style:
            textDesigner(14, TopicColor.lightGrey, fontWeight: FontWeight.w400),
      ),
    );
  }
}

