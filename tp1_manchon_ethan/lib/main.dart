import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(textTheme: GoogleFonts.barlowTextTheme()),
      title: 'Flutter Demo',
      home: const PortfolioPage(),
    );
  }
}

class PortfolioPage extends StatelessWidget {
  const PortfolioPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              ProfileHeader(
                backgroundImage: 'assets/images/background.jpg',
                profileImage: 'assets/images/profil.jpg',
              ),
              const SizedBox(height: 0),
              SizedBox(
                height: 140,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      left: 20,
                      top: 0,
                      child: InfoCard(
                        name: 'Ethan Manchon',
                        birthDate: '14/02/2005',
                        city: 'Limoges, France',
                        profession: 'Développeur Flutter Junior',
                      ),
                    ),
                    Positioned(
                      right: 8,
                      top: 0,
                      child: QrCard(
                        qrCodeImage: 'assets/images/qrcode.png',
                        label: 'Vers LinkedIn',
                      ),
                    ),
                  ],
                ),
              ),
              AboutCard(
                aboutText:
                    'Je suis un développeur Flutter junior avec une solide expérience en création d\'applications performantes et esthétiques. Toujours avide d\'apprendre de nouvelles technologies, je m\'efforce de rester à la pointe des tendances du secteur pour offrir des solutions innovantes et efficaces.',
              ),
              const SizedBox(height: 40),
              const TechIconsRow(),
              const SizedBox(height: 40),
              Image.asset('assets/images/logo.png', width: 25),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileHeader extends StatefulWidget {
  final String backgroundImage;
  final String profileImage;

  const ProfileHeader({
    super.key,
    required this.backgroundImage,
    required this.profileImage,
  });

  @override
  State<ProfileHeader> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader> {
  bool like = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Image de fond
          Container(
            height: 300,
            width: double.infinity,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(0)),
              image: DecorationImage(
                image: AssetImage(widget.backgroundImage),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withAlpha(0),
                    Colors.black.withAlpha(200),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          // Bouton Like en haut à droite
          Positioned(
            top: 250,
            right: 55,
            child: IconButton(
              icon: Icon(
                Icons.thumb_up,
                color: like ? Colors.blue : Colors.white,
                size: 30,
              ),
              onPressed: () {
                // Action du bouton
                setState(() {
                  if (!like) {
                    like = true;
                  } else {
                    like = false;
                  }
                });
                like
                    ? ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Vous avez aimé ce profil!'),
                        ),
                      )
                    : ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Vous n\'aimez pas ce profil!'),
                        ),
                      );
              },
            ),
          ),
          // Bouton  en haut à droite
          Positioned(
            top: 250,
            right: 10,
            child: IconButton(
              icon: Icon(Icons.share, color: Colors.white, size: 30),
              onPressed: () async {
                await Clipboard.setData(
                  const ClipboardData(
                    text: 'https://www.linkedin.com/in/ethan-manchon/',
                  ),
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Liens du profil copié!')),
                );
              },
            ),
          ),
          // Photo de profil qui déborde en bas
          Positioned(
            bottom: 0,
            child: Transform.translate(
              offset: const Offset(-50, 60),
              child: Container(
                height: 250,
                width: 250,
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(50),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                    image: AssetImage(widget.profileImage),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  final String name;
  final String birthDate;
  final String city;
  final String profession;

  const InfoCard({
    super.key,
    required this.name,
    required this.birthDate,
    required this.city,
    required this.profession,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(50),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
        gradient: const LinearGradient(
          colors: [
            Color.fromRGBO(76, 186, 186, 1),
            Color.fromRGBO(40, 136, 226, 1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          InfoField(label: 'Date de naissance:', value: birthDate),
          InfoField(label: 'Ville:', value: city),
          InfoField(label: 'Profession:', value: profession),
        ],
      ),
    );
  }
}

class InfoField extends StatelessWidget {
  final String label;
  final String value;

  const InfoField({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: Colors.grey.shade200)),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class QrCard extends StatelessWidget {
  final String qrCodeImage;
  final String label;

  const QrCard({super.key, required this.qrCodeImage, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(qrCodeImage, width: 100),
        Text(
          label,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 14,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }
}

class AboutCard extends StatelessWidget {
  final String aboutText;

  const AboutCard({super.key, required this.aboutText});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(50),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
        gradient: const LinearGradient(
          colors: [
            Color.fromRGBO(49, 59, 59, 1),
            Color.fromRGBO(40, 45, 49, 1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            aboutText,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class TechIconsRow extends StatelessWidget {
  const TechIconsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TechIcon(
            icon: FontAwesomeIcons.flutter,
            gradientColors: [
              Color(0xFFEA842B),
              Color.fromARGB(255, 237, 171, 114),
            ],
            url: 'https://flutter.dev',
          ),
          TechIcon(
            icon: FontAwesomeIcons.angular,
            gradientColors: [
              Color(0xffdd0031),
              Color.fromARGB(255, 239, 100, 79),
            ],
            url: 'https://angular.dev',
          ),
          TechIcon(
            icon: FontAwesomeIcons.react,
            gradientColors: [
              Color(0xFF43D6FF),
              Color.fromARGB(255, 130, 223, 250),
            ],
            url: 'https://react.dev',
          ),
          TechIcon(
            icon: FontAwesomeIcons.wordpress,
            gradientColors: [
              Color(0xfff05032),
              Color.fromARGB(255, 248, 130, 100),
            ],
            url: 'https://wordpress.org',
          ),
          TechIcon(
            icon: FontAwesomeIcons.vuejs,
            gradientColors: [
              Color(0xff764abc),
              Color.fromARGB(255, 130, 100, 223),
            ],
            url: 'https://vuejs.org',
          ),
        ],
      ),
    );
  }
}

class TechIcon extends StatelessWidget {
  final IconData icon;
  final List<Color> gradientColors;
  final String url;

  const TechIcon({
    super.key,
    required this.icon,
    required this.gradientColors,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        }
      },
      child: Container(
        width: 60,
        height: 60,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(30),
              blurRadius: 4,
              offset: const Offset(0, 4),
            ),
          ],
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: FaIcon(icon, color: Colors.white),
      ),
    );
  }
}
