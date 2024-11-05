import 'package:flutter/material.dart';

import 'ManushPakhi.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("About Screen"),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ManushPakhi(name: "পাপড়ি রহমান", roll: "১", link: "https://scontent.fdac146-1.fna.fbcdn.net/v/t39.30808-6/343733550_235251795762217_7425092038923685941_n.jpg?_nc_cat=109&ccb=1-7&_nc_sid=6ee11a&_nc_eui2=AeG7sMSLLWgvO5UGwVWHD9OSyrWP-FK-5gPKtY_4Ur7mA9txKpAckJqNhW36P37Kd1hntxvbGMlDsPHQPU0EMQXG&_nc_ohc=ap1_m8of7qAQ7kNvgE_13sw&_nc_zt=23&_nc_ht=scontent.fdac146-1.fna&_nc_gid=ApwqxIrVTUIVSZgFD-2UNi4&oh=00_AYDhMYp0anfZlFMs61dTCgVoEEG1MS47AFnC9jZfT2l3bA&oe=671EA679",),
                ManushPakhi(name: "কাব্য মিথুন সাহা", roll: "১৬", link: "https://scontent.fdac146-1.fna.fbcdn.net/v/t39.30808-6/460847984_1874084279741443_542541786013980855_n.jpg?_nc_cat=107&ccb=1-7&_nc_sid=6ee11a&_nc_eui2=AeFjuATBD7pnH2v_Mo-tOhhbFSMGVUpyEikVIwZVSnISKd43rIeUu3uByPObF20Py4p4KDQ9ytNvOcNa_fo3B8jS&_nc_ohc=yk8HhksjcVkQ7kNvgFhN6MH&_nc_zt=23&_nc_ht=scontent.fdac146-1.fna&_nc_gid=A9gP2FIldknG3Jtpzz-zeWc&oh=00_AYAaI62wKm3sA7YJu-1lmrDCSFVC2dbbQNbsDTii5SiKjw&oe=671E9ADC",),
                ManushPakhi(name: "তানজিলা খান", roll: "২৫", link: "https://scontent.fdac146-1.fna.fbcdn.net/v/t39.30808-6/450113475_511040108019343_5870394955275457544_n.jpg?_nc_cat=102&ccb=1-7&_nc_sid=6ee11a&_nc_eui2=AeFNnvjFSnTbL-2L8GxyTrIG4EPZQTuaf8DgQ9lBO5p_wK1bgWgdTK8jYUtI0LZQiebOC3UBMm6FgIjjyv1BCK_E&_nc_ohc=16vvEa_k0aoQ7kNvgE5l-QD&_nc_zt=23&_nc_ht=scontent.fdac146-1.fna&_nc_gid=AD-7ws_jgsnA9lI6X18BtOp&oh=00_AYCjnCWa13EYLAsNKvnw0HEuQMyUG_PQMt_lXOst1HqWCQ&oe=671EA615",),
                ManushPakhi(name: "মুহাইমিনুল ইসলাম নিনাদ", roll: "৪৩", link: "https://scontent.fdac146-1.fna.fbcdn.net/v/t39.30808-6/416161589_3534688013436127_8333611904137685464_n.jpg?_nc_cat=101&ccb=1-7&_nc_sid=6ee11a&_nc_eui2=AeEo0fDfKxxS7Fi5_tjOA0slWHD0UKD9q49YcPRQoP2rj1scQHTumTP2AtsSagPHdx9xawkbl20Ne35Nm9C7YC4W&_nc_ohc=SlgqHcoMpMUQ7kNvgEEDoaF&_nc_zt=23&_nc_ht=scontent.fdac146-1.fna&_nc_gid=ALJgFqylWr6a6NA_-zurst4&oh=00_AYBerWMEKEsRj7S5H4TPV38Z69F4P2k82p7Yh_jmFIT3DA&oe=671E95A4",),
              ],
            ),
          ),
        ));
  }
}
