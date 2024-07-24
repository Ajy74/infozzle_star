import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../theme/app_theme.dart';
import '../../../../../helpers/images.dart';
import '../../shared_widgets/star_magic/burger_drawer/burger_drawer_view.dart';
import 'free_healing_state.dart';
import 'free_healing_view_model.dart';

class FreeHealingView extends StatelessWidget {
  FreeHealingView({super.key});

  final FreeHealingViewModel viewModel = FreeHealingViewModel();

  @override
  Widget build(BuildContext context) {
    final double size = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      drawer: BurgerDrawerView(),
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: const Text("Free Healing"),
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
      body: BlocBuilder<FreeHealingViewModel, FreeHealingState>(
        bloc: viewModel,
        builder: (_, state) {
          return SingleChildScrollView(
            physics: const ScrollPhysics(),
            child: Column(
              children: [
                Image.asset(Images.healingBanner, width: double.infinity),
                buildIntroduction(size),
                //TODO: ADD VIDEOS HERE
                const SizedBox(height: 20)
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildIntroduction(double size) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: size*0.05),
      child: Column(children: [
        const SizedBox(height: 20),
        Text(
          'Free Healing',
          style: TextStyle(
            fontSize: size*0.1, fontWeight: FontWeight.w400, color: Colors.grey[700]
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: size*0.03),
        Text(
          'One on One Healing Transmissions',
          style: TextStyle(fontSize: size*0.055, fontWeight: FontWeight.w300, color: Colors.grey[900]),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: size*0.035),
        Image.asset(
          Images.healingJerry,
          width: double.infinity,
          height: size*0.52,
          fit: BoxFit.cover,
        ),
        SizedBox(height: size*0.038),
        Text(
          'These short but very potent healing transmissions are a 24/7 healing tool, to be used alongside the other high vibrational healing assets inside Infinity.\n\n'
          'As a loyal Infinity Member we value your health and well-being and so have created these healing videos to assist your earthly journey. These powerful short healing sessions target a range of different issues. Mental, physical and emotional symptoms are addressed and healed.\n\n'
          'You came to this planet to be healthy and fully experience being human and a healthy body, mind and spirit is essential. Open your heart and connect with me in this deep space and we will create an environment where your body does what it was designed to do, and that is heal. New videos are uploaded regularly to empower your health and vitality.',
          style: TextStyle(fontSize: size*0.045, fontWeight: FontWeight.w300),
          textAlign: TextAlign.center,
        ),
      ]),
    );
  }
}
