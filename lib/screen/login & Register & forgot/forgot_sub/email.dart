import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:orah_pharmacy/screen/login%20&%20Register%20&%20forgot/forgot_sub/verifyOtp.dart';
import 'package:orah_pharmacy/services/api.dart';
import 'package:orah_pharmacy/widget/custom_button.dart';
import 'package:orah_pharmacy/widget/custom_textfield.dart';
import 'package:orah_pharmacy/widget/flushbar.dart';

class ForgotEmail extends StatefulWidget {
  const ForgotEmail({super.key});

  @override
  State<ForgotEmail> createState() => _ForgotEmailState();
}

class _ForgotEmailState extends State<ForgotEmail> {
  @override
  void initState() {
    super.initState();
    //fetchCustomersEmails();
  }

  final TextEditingController emailcontroller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  List customersEmail = [];
  String generatedOTP = '';
  bool isloading = false;

//ab iska kohe kam nahi hai..........
  // Future<void> fetchCustomersEmails() async {
  //   var res = await Api.customersEmails(email: emailcontroller.text);
  //   if (res['code_status'] == true) {
  //     setState(() {
  //       customersEmail = res['message'];
  //     });
  //     //print(" Customer list $customersEmail");
  //   }
  // }

  void checkEmail() async {
    setState(() {
      isloading = true;
    });
    var res = await Api.customersEmails(email: emailcontroller.text);
    if (res['code_status'] == true) {
      setState(() {
        customersEmail = res['message'];
      });
      print(
          "nahi haiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii${customersEmail}");
      //print(" Customer list $customersEmail");
    }
    String inputEmail = emailcontroller.text.toLowerCase();
    bool isEmailAvailable = customersEmail
        .any((element) => element["email"].toLowerCase() == inputEmail);
    print(inputEmail);

    generatedOTP = generateRandomOTP();

    if (isEmailAvailable) {
      await sendOTPEmail(emailcontroller.text, generatedOTP);
      setState(() {
        isloading = false;
      });
    } else {
      FlushBar.flushBarMessage(message: "Invalid Email", context: context);
      print("jcdanancancnacannscjsns  ${isEmailAvailable}");
      setState(() {
        isloading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;

    return SafeArea(
        child: Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: mq.width * 0.04,
          vertical: mq.height * 0.03,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_back_ios_new_rounded),
                  ),
                  SizedBox(width: 10),
                  Text(
                    "Forget Password",
                    style: Theme.of(context).textTheme.headlineSmall,
                  )
                ],
              ),
              SizedBox(height: mq.height * 0.04),
              CustomTextField(
                controller: emailcontroller,
                hintText: 'Enter Email',
                filled: true,
                validate: (value) {
                  if (value!.isEmpty) {
                    return ("Please Enter Your Email");
                  }
                  return null;
                },
              ),
              SizedBox(height: mq.height * 0.03),
              CustomButton(
                isloading: isloading,
                onTap: () async {
                  if (_formKey.currentState!.validate()) {
                    checkEmail();
                  }
                },
                buttonText: 'Send Otp',
                sizeWidth: double.infinity,
                sizeHeight: 65,
              ),
            ],
          ),
        ),
      ),
    ));
  }

  String generateRandomOTP() {
    // Generate a random 6-digit OTP
    Random random = Random();
    return random.nextInt(999999).toString().padLeft(6, '0');
  }

  Future<void> sendOTPEmail(String toEmail, String otp) async {
    final smtpServer = SmtpServer(
      'smtp.hostinger.com',
      username: 'no-reply@orah.pk',
      password: 'Zohaib5541@',
      ssl: true,
      port: 465,
      allowInsecure: true,
    );

    final message = Message()
      ..from = Address('no-reply@orah.pk', 'Orah Life')
      ..recipients.add(toEmail)
      ..subject = 'OTP for Your App'
      ..html = _buildOTPEmailBody(otp);

    try {
      final sendReport = await send(message, smtpServer);
      SchedulerBinding.instance.addPostFrameCallback((_) {
        FlushBar.flushbarmessagegreen(message: 'Otp Send', context: context);
      });
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VerifyOtp(
              Otp: generatedOTP,
              email: emailcontroller.text,
            ),
          ));
      print('Message sent: ' + sendReport.toString());
    } catch (e) {
      FlushBar.flushbarmessagegreen(message: '$e', context: context);
    }
  }

  static String _buildOTPEmailBody(String otp) {
    return """
   
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css" integrity="sha384-xOolHFLEh07PJGoPkLv1IbcEPTNtaed2xpHsD9ESMhqIYd0nLMwNLD69Npy4HI+N" crossorigin="anonymous">


    <style>
        .row-logo{
            display: flex;
            flex-direction: row;
            justify-content: center !important;
            background-color: #fff;
            margin-bottom: 50px !important;
        }

        .content-row > *{
            font-family: Arial, Helvetica, sans-serif;
        }

        /* .content-row p{
            padding-right: 200px !important;
        } */
        .content-row{
            display: flex;
            flex-direction: column;
            background-color: #f5f4f4;
            padding: 20px 20px ;
            border-radius: 20px;
        }

        .content-row p{
            font-family: Arial, Helvetica, sans-serif;
        }

        .otp-field{
            background-color: #18A99E;
            padding: 10px 0px !important;
            border-radius: 25px !important;
            text-align: center;
            width: 50%;
            color: #fff !important;
            text-align: center;
            transform: translate( 50%, 50%) !important ;
        
        }

        .content-row::nth-child(3) {
            display: flex ;
            flex-direction: row;
            justify-content: center;

        }

    </style>


</head>
<body>
    
<div class="container">
    <div class="row">
        <div class="col-sm-12 row-logo">
            <a href=""> <img src="https://orah.pk/wp-content/uploads/2023/10/orah-logo-color-new-300x135-1.png" width="200px" alt=""></a>
            
        
        </div>
    </div>
    <div class="row">
        <div class="col-sm-3"></div>
        <div class="col-sm-6 content-row">
            <p>
                We sent you this email because you have requested of a password reset.<br> <br>
                Use this OTP CODE mentioned below to verify your email address. 
            
            </p>
            <p class="otp-field">
                <span> <b>$otp</b></span>
            </p>
        </div>
        <div class="col-sm-3"></div>
    </div>
</div>    
</body>

<script src="https://cdn.jsdelivr.net/npm/jquery@3.5.1/dist/jquery.slim.min.js" integrity="sha384-DfXdz2htPH0lsSSs5nCTpuj/zy4C+OGpamoFVy38MVBnE+IbbVYUew+OrCXaRkfj" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-Fy6S3B9q64WdZWQUiU+q4/2Lc9npb8tCaSX9FK7E8HnRr0Jz8D6OP9dO5Vg3Q9ct" crossorigin="anonymous"></script>
</html>
    """;
  }
}
