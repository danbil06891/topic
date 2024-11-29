import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hiv/screens/auth/sign_up_screen.dart';
import 'package:hiv/controller/auth_controller.dart';
import 'package:hiv/utils/snippet.dart';
import 'package:hiv/utils/widgets/topic_text_field.dart';
import 'package:hiv/constact/color_constant.dart';
import 'package:hiv/utils/dialogs.dart';
import 'package:hiv/utils/responsive_view.dart';
import 'package:hiv/utils/widgets/format_widget.dart';
import 'package:hiv/utils/widgets/standart_widget.dart';
import 'package:hiv/utils/widgets/topic_loader_button.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final AuthController _authController = Get.find();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TopicColor.black,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Image(
                    height: 120,
                    width: 140,
                    image: AssetImage('assets/images/logo.png')),
              ),
              const GeneralText(
                text: 'Email',
              ),
              verticalGap(8),
              TopicTextField(
                controller: emailController,
                validator: emailValidator,
              ),
              verticalGap(12),
              const GeneralText(
                text: 'Password',
              ),
              verticalGap(8),
              TopicTextField(
                maxLine: 1,
                controller: passwordController,
                validator: passwordValidator,
                isVisible: true,
                suffixIcon: Icons.visibility,
                suffixIcon2: Icons.visibility_off,
              ),
              verticalGap(30),
              SizedBox(
                height: 45,
                width: context.screenWidth,
                child: TopicLoaderButton(
                  btnText: 'Sign in',
                  radius: 10,
                  color: TopicColor.primary,
                  onTap: () async {
                    try {
                      if (formKey.currentState!.validate()) {
                        await _authController.signIn(
                          emailController.text.trim(),
                          passwordController.text.trim(),
                        );
                      }
                    } catch (e) {
                      showMessage('Signin Failed',
                          'Please check your details and try again.');
                    }
                  },
                ),
              ),
              verticalGap(20),
              Center(
                child: TextButton(
                  onPressed: () {
                    Get.to(() => const SignUpScreen());
                  },
                  child: Text(
                    "Don't have an account? Sign Up",
                    style: textDesigner(14, TopicColor.lightGrey,
                        fontWeight: FontWeight.w400),
                  ),
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
