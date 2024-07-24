import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../theme/app_theme.dart';
import '../../../../../helpers/images.dart';
import '../../shared_widgets/star_magic/burger_drawer/burger_drawer_view.dart';

class AboutStarMagicView extends StatelessWidget {
  const AboutStarMagicView({super.key});

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
            centerTitle: true,
            title: const Text("About Star Magic"),
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
                  Image.asset(Images.healingBanner, width: double.infinity),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'Star Magic is an extremely potent healing frequency, an intelligence that has one vision. That is to empower every human being on this planet, to realise their own strength, inner wisdom, divine sovereignty and ultimately, set humanity free.\n\n'
                      'Star Magic flows through every meditation, healing session, light language transmission, chi gong routine, yoga sequence, workshop or training that Jerry and the Star Magic Team delivers.\n\n'
                      'This frequency works on a physical and a metaphysical level, healing mental, physical, emotional and spiritual trauma, not just from this reality, but past lives or parallel realities. The energy that is Star Magic, moves through your cells and into your DNA, and communicates at a subatomic level, bringing trauma (that most healing frequencies don’t or can’t connect with) to the surface to be healed.\n\n'
                      'Jerry has trained thousands of women and men, from across the planet since Star Magic began in 2016. Many of these beautiful souls are healers with decades of experience. They all say Star Magic is different, a much faster, more powerful frequency that not only heals, but lasts. Again, experienced meditators from around the world, are Star Magic Infinity regulars. On a daily basis they return to take on the meditation challenges and elevate their vibration because there is nothing else like it on Earth right now.\n\n'
                      'Star Magic seeks and removes any multidimensional programming, that is affecting the person in this reality right now. The light codes and geometrical data, that create these programs and patterns are deleted and they are exchanged for a new stream of information/light, that empowers the women or man in question. The healing is rapid and works in all arenas, health, relationships and business. There is nothing that the Star Magic Frequency hasn’t healed, from serious life threatening diseases, to broken marriages and businesses on the brink of bankruptcy.\n\n'
                      'Once the root cause is removed, every situation can be turned around and the healing can often be immediate. You will be happy, discover your life purpose, see the joy in all things and live constantly in an elevated state of bliss.\n\n'
                      'Jerry’s vision is to build healing centres around the planet and harness these super-powerful off planet healing frequencies on a grand scale, bring them safely to Earth and create a wave of cosmic energy that expands the consciousness and of every women, man and child and connects us all, as a human family on the frequency of unconditional love.\n\n'
                      'You are powerful and are about to shift in a monumental fashion. Commit to the Star Magic Lifestyle and your life will grow new wings. You will rise like a phoenix and massive energetic firepower will flow through your veins. The question is…\n\n'
                      'Are You Ready?\n\n'
                      'If you want to know how to heal with Star Magic, join our Facilitator Level 1 Training Experience.\n\n'
                      'If you want to live a Star Magic Lifestyle and grow exponentially, then get stuck into Infinity’s high vibrational tool box now.',
                      style: TextStyle(fontSize: 14.0, color: Colors.grey[800]),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
