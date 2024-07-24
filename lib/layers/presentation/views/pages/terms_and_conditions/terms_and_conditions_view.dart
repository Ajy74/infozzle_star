import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../theme/app_theme.dart';
import '../../../../../helpers/images.dart';
import '../../shared_widgets/star_magic/burger_drawer/burger_drawer_view.dart';

class TermsAndConditionsView extends StatelessWidget {
  const TermsAndConditionsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Colors.white),
      child: SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
          drawer: BurgerDrawerView(),
          appBar: AppBar(
            title: const Text("Terms & Conditions"),
            centerTitle: true,
            titleTextStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
            iconTheme: const IconThemeData(color: Colors.white),
            backgroundColor: AppTheme.colors.appBarColor,
            actions: [
              IconButton(
                icon: const Icon(Icons.home_filled),
                onPressed: () {
                  context.go("/home");
                },
              ),
            ],
          ),
          body: SafeArea(
            top: true,
            bottom: true,
            child: SingleChildScrollView(
              physics: const ScrollPhysics(),
              child: Column(
                children: [
                  Image.asset(Images.termsBanner, width: double.infinity),
                  buildText(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildText() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'PLEASE READ THESE TERMS AND CONDITIONS CAREFULLY BEFORE USING THIS SITE',
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800], // Changed text color
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20.0),
          Text(
            'Terms of website use',
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800], // Changed text color
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10.0),
          Text(
            'These terms of use (together with the documents referred to in it) tell you the terms of use on which you may make use of our website, whether as a guest or a registered user. Use of our site includes accessing, browsing, or registering to use our site.\n\n'
            'Please read these terms of use carefully before you start to use our site, as these will apply to your use of our site. We recommend that you print a copy of this for future reference.\n\n'
            'By using our site, you confirm that you accept these terms of use and that you agree to comply with them.\n\n'
            'If you do not agree to these terms of use, you must not use our site.',
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.grey[800], // Changed text color
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20.0),
          Text(
            'Other applicable terms',
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800], // Changed text color
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10.0),
          Text(
            'These terms of use refer to the following additional terms, which also apply to your use of our site. Our Privacy Policy , which sets out the terms on which we process any personal data we collect from you, or that you provide to us. By using our site, you consent to such processing and you warrant that all data provided by you is accurate.Our Acceptable Use Policy, which sets out the permitted uses and prohibited uses of our site. When using our site, you must comply with this Acceptable Use Policy. Our Cookie Policy, which sets out information about the cookies on our site.\n\n'
            'If you purchase goods or healing treatments from our site, our Terms and conditions of supply will apply.',
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.grey[800], // Changed text color
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20.0),
          Text(
            'Information about us',
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800], // Changed text color
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10.0),
          Text(
            'About us is a site operated by Star Magic Healing Limited ("We"). We are registered in England and Wales under company number 09945715 and have our registered office at 3rd Floor, 14 Hanover Street, Hanover Square, London, W1S 1YH. We are a limited company.',
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.grey[800], // Changed text color
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20.0),
          Text(
            'Changes to these terms',
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800], // Changed text color
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10.0),
          Text(
            'We may revise these terms of use at any time by amending this page.\n\n'
            'Please check this page from time to time to take notice of any changes we made, as they are binding on you.',
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.grey[800], // Changed text color
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20.0),
          Text(
            'Changes to our site',
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800], // Changed text color
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10.0),
          Text(
            'We may update our site from time to time, and may change the content at any time. However, please note that any of the content on our site may be out of date at any given time, and we are under no obligation to update it.\n\n'
            'We do not guarantee that our site, or any content on it, will be free from errors or omissions.',
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.grey[800], // Changed text color
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20.0),
          Text(
            'Accessing our site',
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800], // Changed text color
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10.0),
          Text(
            'Our site is made available free of charge.\n\n'
            'We do not guarantee that our site, or any content on it, will always be available or be uninterrupted. Access to our site is permitted on a temporary basis. We may suspend, withdraw, discontinue or change all or any part of our site without notice. We will not be liable to you if for any reason our site is unavailable at any time or for any period.\n\n'
            'You are responsible for making all arrangements necessary for you to have access to our site.\n\n'
            'You are also responsible for ensuring that all persons who access our site through your internet connection are aware of these terms of use and other applicable terms and conditions, and that they comply with them.',
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.grey[800], // Changed text color
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20.0),
          Text(
            'Your account and password',
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800], // Changed text color
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10.0),
          Text(
            'We have the right to disable any user identification code or password, whether chosen by you or allocated by us, at any time, if in our reasonable opinion you have failed to comply with any of the provisions of these terms of use.\n\n'
            'If you know or suspect that anyone other than you knows your user identification code or password, you must promptly notify us at info@starmagichealing.org.',
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.grey[800], // Changed text color
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20.0),
          Text(
            'Intellectual property rights',
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800], // Changed text color
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10.0),
          Text(
            'We are the owner or the licensee of all intellectual property rights in our site, and in the material published on it. Those works are protected by copyright laws and treaties around the world. All such rights are reserved.\n\n'
            'You may print off one copy, and may download extracts, of any page(s) from our site for your personal use and you may draw the attention of others within your organization to content posted on our site.\n\n'
            'You must not modify the paper or digital copies of any materials you have printed off or downloaded in any way, and you must not use any illustrations, photographs, video or audio sequences or any graphics separately from any accompanying text.\n\n'
            'Our status (and that of any identified contributors) as the authors of content on our site must always be acknowledged.\n\n'
            'You must not use any part of the content on our site for commercial purposes without obtaining a license to do so from us or our licensors.\n\n'
            'If you print off, copy or download any part of our site in breach of these terms of use, your right to use our site will cease immediately and you must, at our option, return or destroy any copies of the materials you have made.',
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.grey[800], // Changed text color
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20.0),
          Text(
            'No reliance on information',
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800], // Changed text color
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10.0),
          Text(
            'The content on our site is provided for general information only. It is not intended to amount to advice on which you should rely. You must obtain professional or specialist advice before taking, or refraining from, any action on the basis of the content on our site.\n\n'
            'Although we make reasonable efforts to update the information on our site, we make no representations, warranties or guarantees, whether express or implied, that the content on our site is accurate, complete or up-to-date.',
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.grey[800], // Changed text color
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20.0),
          Text(
            'Limitation of our liability',
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800], // Changed text color
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10.0),
          Text(
            'Nothing in these terms of use excludes or limits our liability for death or personal injury arising from our negligence, or our fraud or fraudulent misrepresentation, or any other liability that cannot be excluded or limited by English law.\n\n'
            'To the fullest extent permitted by law, we exclude all conditions, warranties, representations or other terms which may apply to our site or any content on it, whether express or implied.\n\n'
            'We will not be liable to any user for any loss or damage, whether in contract, tort (including negligence), breach of statutory duty, or otherwise, even if foreseeable, arising under or in connection with: use of, or inability to use, our site; or use of or reliance on any content displayed on our site.\n\n'
            'If you are a business user, please note that in particular, we will not be liable for: loss of profits, sales, business, or revenue; business interruption; loss of anticipated savings; loss of business opportunity, goodwill or reputation; or any indirect or consequential loss or damage.\n\n'
            'If you are a consumer user, please note that we only provide our site for domestic and private use. You agree not to use our site for any commercial or business purposes, and we have no liability to you for any loss of profit, loss of business, business interruption, or loss of business opportunity.\n\n'
            'We will not be liable for any loss or damage caused by a virus, distributed denial-of-service attack, or other technologically harmful material that may infect your computer equipment, computer programs, data or other proprietary material due to your use of our site or to your downloading of any content on it, or on any website linked to it.\n\n'
            'We assume no responsibility for the content of websites linked on our site. Such links should not be interpreted as endorsement by us of those linked websites. We will not be liable for any loss or damage that may arise from your use of them.\n\n'
            'Different limitations and exclusions of liability will apply to liability arising as a result of the supply of any goods to you, which will be set out in our Terms and conditions of supply.',
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.grey[800], // Changed text color
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20.0),
          Text(
            'Uploading content to our site',
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800], // Changed text color
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10.0),
          Text(
            'Whenever you make use of a feature that allows you to upload content to our site, or to make contact with other users of our site, you must comply with the content standards set out in our Acceptable Use Policy.\n\n'
            'You warrant that any such contribution does comply with those standards, and you will be liable to us and indemnify us for any breach of that warranty. If you are a consumer user, this means you will be responsible for any loss or damage we suffer as a result of your breach of warranty.\n\n'
            'Any content you upload to our site will be considered non-confidential and non-proprietary. You retain all of your ownership rights in your content, but you are required to grant us and other users of the Site a limited licence to use, store and copy that content and to distribute and make it available to third parties. The rights you license to us are described in the next paragraph (Rights you licence).\n\n'
            'We also have the right to disclose your identity to any third party who is claiming that any content posted or uploaded by you to our site constitutes a violation of their intellectual property rights, or of their right to privacy.\n\n'
            'We will not be responsible, or liable to any third party, for the content or accuracy of any content posted by you or any other user of our site.\n\n'
            'We have the right to remove any posting you make on our site without reason or warning.\n\n'
            'The views expressed by other users on our site do not represent our views or values.\n\n'
            'You are solely responsible for securing and backing up your content.',
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.grey[800], // Changed text color
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20.0),
          Text(
            'Viruses',
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800], // Changed text color
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10.0),
          Text(
            'We do not guarantee that our site will be secure or free from bugs or viruses.\n\n'
            'You are responsible for configuring your information technology, computer programmes and platform in order to access our site. You should use your own virus protection software.\n\n'
            'You must not misuse our site by knowingly introducing viruses, trojans, worms, logic bombs or other material which is malicious or technologically harmful. You must not attempt to gain unauthorised access to our site, the server on which our site is stored or any server, computer or database connected to our site. You must not attack our site via a denial-of-service attack or a distributed denial-of service attack. By breaching this provision, you would commit a criminal offence under the Computer Misuse Act 1990. We will report any such breach to the relevant law enforcement authorities and we will co-operate with those authorities by disclosing your identity to them. In the event of such a breach, your right to use our site will cease immediately.',
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.grey[800], // Changed text color
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20.0),
          Text(
            'Linking to our site',
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800], // Changed text color
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10.0),
          Text(
            'You may link to our home page, provided you do so in a way that is fair and legal and does not damage our reputation or take advantage of it.\n\n'
            'You must not establish a link in such a way as to suggest any form of association, approval or endorsement on our part where none exists.\n\n'
            'You must not establish a link to our site in any website that is not owned by you.\n\n'
            'Our site must not be framed on any other site, nor may you create a link to any part of our site other than the home page.\n\n'
            'We reserve the right to withdraw linking permission without notice.\n\n'
            'The website in which you are linking must comply in all respects with the content standards set out in our Acceptable Use Policy.\n\n'
            'If you wish to make any use of content on our site other than that set out above, please contact info@starhealingmagic.com.',
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.grey[800], // Changed text color
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20.0),
          Text(
            'Third party links and resources in our site',
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800], // Changed text color
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10.0),
          Text(
            'Where our site contains links to other sites and resources provided by third parties, these links are provided for your information only.\n\n'
            'We have no control over the contents of those sites or resources.',
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.grey[800], // Changed text color
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20.0),
          Text(
            'Applicable law',
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800], // Changed text color
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10.0),
          Text(
            'If you are a consumer, please note that these terms of use, its subject matter and its formation, are governed by EU law. You and we both agree to that the EU courts will have non-exclusive jurisdiction.\n\n'
            'If you are a business, these terms of use, its subject matter and its formation (and any non-contractual disputes or claims) are governed by EU law. We both agree to the exclusive jurisdiction of the European courts.',
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.grey[800], // Changed text color
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20.0),
          Text(
            'Contact us',
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800], // Changed text color
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10.0),
          Text(
            'To contact us, please email on info@starhealingmagic.com',
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.grey[800], // Changed text color
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
