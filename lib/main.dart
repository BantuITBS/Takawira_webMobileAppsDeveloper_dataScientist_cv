import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:flutter/material.dart';

void main() => runApp(const CVApp());

class CVApp extends StatelessWidget {
  const CVApp({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme.apply(
      fontFamily: 'PlayfairDisplay',
    );

    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'PlayfairDisplay',
        textTheme: textTheme.copyWith(
          headlineSmall: textTheme.headlineSmall?.copyWith(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          headlineMedium: textTheme.headlineMedium?.copyWith(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
          bodyLarge: textTheme.bodyLarge?.copyWith(
            fontSize: 16,
          ),
          bodyMedium: textTheme.bodyMedium?.copyWith(
            fontSize: 14,
          ),
          labelLarge: textTheme.labelLarge?.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        cardTheme: CardThemeData(
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
          color: Colors.white,
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
      home: const CVHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class CVHomePage extends StatefulWidget {
  const CVHomePage({super.key});

  @override
  _CVHomePageState createState() => _CVHomePageState();
}

class _CVHomePageState extends State<CVHomePage> with SingleTickerProviderStateMixin {
  String _currentSection = 'welcome';
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  // Color constants
  final Color _primaryColor = const Color(0xFF2A3F54);
  final Color _secondaryColor = const Color(0xFF1ABB9C);
  final Color _accentColor = const Color(0xFF1ABB9C);
  final Color _lightColor = const Color(0xFFF7F9FC);
  final Color _darkColor = const Color(0xFF1A2A3A);

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _rotationAnimation = Tween<double>(begin: 0.0, end: 0.1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch $url')),
      );
    }
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final uri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch $phoneNumber')),
      );
    }
  }

  Future<void> _openWhatsApp(String phoneNumber) async {
    final cleanedNumber = phoneNumber.replaceAll(RegExp(r'[^0-9+]'), '');
    final uri = Uri.parse('https://wa.me/$cleanedNumber');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch WhatsApp for $phoneNumber')),
      );
    }
  }

  void _updateSection(String section) {
    setState(() {
      _currentSection = section;
    });
  }

  void _handleMenuTap() {
    _animationController.forward().then((_) {
      _animationController.reverse();
      if (_scaffoldKey.currentState!.isDrawerOpen) {
        _scaffoldKey.currentState!.openEndDrawer();
      } else {
        _scaffoldKey.currentState!.openDrawer();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, sizingInformation) {
        final isMobile = sizingInformation.isMobile;

        return Scaffold(
          key: _scaffoldKey,
          appBar: isMobile ? _buildMobileAppBar() : null,
          drawer: isMobile ? _buildDrawer() : null,
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [_lightColor, Colors.white],
              ),
            ),
            child: isMobile ? _buildMobileLayout() : _buildDesktopLayout(),
          ),
        );
      },
    );
  }

  PreferredSizeWidget _buildMobileAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(180),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [_primaryColor, _accentColor],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.4),
              blurRadius: 6,
              offset: const Offset(0, 3),
            )
          ],
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _scaleAnimation.value,
                        child: Transform.rotate(
                          angle: _rotationAnimation.value,
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [_secondaryColor, Colors.white],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: _secondaryColor.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: IconButton(
                              icon: Icon(Icons.menu, color: _primaryColor),
                              onPressed: _handleMenuTap,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  Expanded(
                    child: Text(
                      "Takawira Mazando",
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                "Mobile and Web Developer | Data Scientist",
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontStyle: FontStyle.italic,
                      color: Colors.white.withOpacity(0.9),
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [_lightColor, Colors.white],
          ),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [_primaryColor, _accentColor],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage('assets/profile.jpeg'),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Takawira Mazando',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                  ),
                  Text(
                    'Mobile & Web Developer | Data Scientist',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withOpacity(0.9),
                        ),
                  ),
                ],
              ),
            ),
            _buildDrawerItem(Icons.home, 'Welcome', 'welcome', _lightColor, Colors.red),
            _buildDrawerItem(Icons.person, 'Professional Summary', 'summary', _lightColor, Colors.orange),
            _buildDrawerItem(Icons.build, 'Technical Skills', 'skills', _lightColor, Colors.yellow[700]!),
            _buildDrawerItem(Icons.people, 'Soft Skills', 'soft_skills', _lightColor, Colors.green),
            _buildDrawerItem(Icons.work, 'Professional Experience', 'experience', _lightColor, Colors.blue),
            _buildDrawerItem(Icons.school, 'Education', 'education', _lightColor, Colors.indigo),
            _buildDrawerItem(Icons.card_membership, 'Certifications', 'certifications', _lightColor, Colors.purple),
            _buildDrawerItem(Icons.emoji_events, 'Accomplishments', 'accomplishments', _lightColor, Colors.pink),
            _buildDrawerItem(Icons.people_outline, 'References', 'references', _lightColor, Colors.teal),
            _buildDrawerItem(Icons.folder, 'Projects', 'projects', _lightColor, Colors.cyan),
            _buildDrawerItem(Icons.description, 'Full CV', 'full_cv', _lightColor, _secondaryColor),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileLayout() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Header(
            launchURL: _launchURL,
            makePhoneCall: _makePhoneCall,
            openWhatsApp: _openWhatsApp,
            isMobile: true,
            primaryColor: _primaryColor,
            accentColor: _accentColor,
          ),
          Container(
            padding: const EdgeInsets.all(20),
            child: _getContent(_currentSection),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Column(
      children: [
        Header(
          launchURL: _launchURL,
          makePhoneCall: _makePhoneCall,
          openWhatsApp: _openWhatsApp,
          isMobile: false,
          primaryColor: _primaryColor,
          accentColor: _accentColor,
        ),
        Expanded(
          child: Row(
            children: [
              Container(
                width: 220,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [_lightColor, Colors.white],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 4,
                      offset: const Offset(2, 0),
                    )
                  ],
                ),
                child: ListView(
                  children: [
                    const SizedBox(height: 20),
                    _buildSidebarItem(Icons.home, 'Welcome', 'welcome', Colors.red),
                    _buildSidebarItem(Icons.person, 'Professional Summary', 'summary', Colors.orange),
                    _buildSidebarItem(Icons.build, 'Technical Skills', 'skills', Colors.yellow[700]!),
                    _buildSidebarItem(Icons.people, 'Soft Skills', 'soft_skills', Colors.green),
                    _buildSidebarItem(Icons.work, 'Professional Experience', 'experience', Colors.blue),
                    _buildSidebarItem(Icons.school, 'Education', 'education', Colors.indigo),
                    _buildSidebarItem(Icons.card_membership, 'Certifications', 'certifications', Colors.purple),
                    _buildSidebarItem(Icons.emoji_events, 'Accomplishments', 'accomplishments', Colors.pink),
                    _buildSidebarItem(Icons.people_outline, 'References', 'references', Colors.teal),
                    _buildSidebarItem(Icons.folder, 'Projects', 'projects', Colors.cyan),
                    _buildSidebarItem(Icons.description, 'Full CV', 'full_cv', _secondaryColor),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    child: _getContent(_currentSection),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, String section, Color bgColor, Color iconColor) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _currentSection == section ? _secondaryColor.withOpacity(0.2) : bgColor,
        borderRadius: BorderRadius.circular(8),
        boxShadow: _currentSection == section
            ? [
                BoxShadow(
                  color: _secondaryColor.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                )
              ]
            : null,
      ),
      child: ListTile(
        leading: Icon(icon, color: _currentSection == section ? _secondaryColor : iconColor),
        title: Text(
          title,
          style: TextStyle(
            color: _currentSection == section ? _secondaryColor : Colors.grey[700],
            fontWeight: _currentSection == section ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        onTap: () {
          setState(() => _currentSection = section);
          Navigator.pop(context);
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget _buildSidebarItem(IconData icon, String title, String section, Color iconColor) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _currentSection == section ? _secondaryColor.withOpacity(0.2) : _lightColor,
        borderRadius: BorderRadius.circular(8),
        boxShadow: _currentSection == section
            ? [
                BoxShadow(
                  color: _secondaryColor.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                )
              ]
            : null,
      ),
      child: ListTile(
        leading: Icon(icon, color: _currentSection == section ? _secondaryColor : iconColor),
        title: Text(
          title,
          style: TextStyle(
            color: _currentSection == section ? _secondaryColor : Colors.grey[700],
            fontWeight: _currentSection == section ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        onTap: () => setState(() => _currentSection = section),
      ),
    );
  }

  Widget _getContent(String section) {
    switch (section) {
      case 'welcome':
        return WelcomeContent(
          primaryColor: _primaryColor,
          secondaryColor: _secondaryColor,
          onGetStarted: () => _updateSection('projects'),
        );
      case 'summary':
        return SectionHeader(
          icon: Icons.person,
          title: "Professional Summary",
          primaryColor: _primaryColor,
          secondaryColor: _secondaryColor,
          child: ProfessionalSummaryContent(primaryColor: _primaryColor),
        );
      case 'skills':
        return SectionHeader(
          icon: Icons.build,
          title: "Technical Skills",
          primaryColor: _primaryColor,
          secondaryColor: _secondaryColor,
          child: TechnicalSkillsContent(primaryColor: _primaryColor, secondaryColor: _secondaryColor),
        );
      case 'soft_skills':
        return SectionHeader(
          icon: Icons.people,
          title: "Soft, Leadership, and Interpersonal Skills",
          primaryColor: _primaryColor,
          secondaryColor: _secondaryColor,
          child: SoftSkillsContent(primaryColor: _primaryColor),
        );
      case 'experience':
        return SectionHeader(
          icon: Icons.work,
          title: "Professional Experience",
          primaryColor: _primaryColor,
          secondaryColor: _secondaryColor,
          child: ProfessionalExperienceContent(primaryColor: _primaryColor, secondaryColor: _secondaryColor),
        );
      case 'education':
        return SectionHeader(
          icon: Icons.school,
          title: "Education",
          primaryColor: _primaryColor,
          secondaryColor: _secondaryColor,
          child: EducationContent(primaryColor: _primaryColor),
        );
      case 'certifications':
        return SectionHeader(
          icon: Icons.card_membership,
          title: "Certifications",
          primaryColor: _primaryColor,
          secondaryColor: _secondaryColor,
          child: CertificationsContent(primaryColor: _primaryColor),
        );
      case 'accomplishments':
        return SectionHeader(
          icon: Icons.emoji_events,
          title: "Accomplishments",
          primaryColor: _primaryColor,
          secondaryColor: _secondaryColor,
          child: AccomplishmentsContent(primaryColor: _primaryColor),
        );
      case 'references':
        return SectionHeader(
          icon: Icons.people_outline,
          title: "References",
          primaryColor: _primaryColor,
          secondaryColor: _secondaryColor,
          child: ReferencesContent(primaryColor: _primaryColor),
        );
      case 'projects':
        return SectionHeader(
          icon: Icons.folder,
          title: "Projects Portfolio",
          primaryColor: _primaryColor,
          secondaryColor: _secondaryColor,
          child: ProjectsContent(
            onProjectTap: _showProjectDetails,
            primaryColor: _primaryColor,
            secondaryColor: _secondaryColor,
          ),
        );
      case 'full_cv':
        return FullCVContent(
          launchURL: _launchURL,
          primaryColor: _primaryColor,
          secondaryColor: _secondaryColor,
        );
      default:
        return WelcomeContent(
          primaryColor: _primaryColor,
          secondaryColor: _secondaryColor,
          onGetStarted: () => _updateSection('projects'),
        );
    }
  }

  void _showProjectDetails(Project project) {
    showDialog(
      context: context,
      builder: (BuildContext context) => ProjectDetailsModal(
        project: project,
        primaryColor: _primaryColor,
        secondaryColor: _secondaryColor,
      ),
    );
  }
}

class Header extends StatelessWidget {
  final Future<void> Function(String) launchURL;
  final Future<void> Function(String) makePhoneCall;
  final Future<void> Function(String) openWhatsApp;
  final bool isMobile;
  final Color primaryColor;
  final Color accentColor;

  const Header({
    super.key,
    required this.launchURL,
    required this.makePhoneCall,
    required this.openWhatsApp,
    required this.isMobile,
    required this.primaryColor,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 16 : 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [primaryColor, accentColor],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.4),
            blurRadius: 6,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: isMobile ? _buildMobileHeader(context) : _buildDesktopHeader(context),
    );
  }

  Widget _buildDesktopHeader(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CircleAvatar(
          radius: 40,
          backgroundImage: AssetImage('assets/profile.jpeg'),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Takawira Mazando",
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                "Mobile and Web Developer | Data Scientist",
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontStyle: FontStyle.italic,
                      color: Colors.white.withOpacity(0.9),
                    ),
              ),
            ],
          ),
        ),
        Spacer(),
        PopupMenuButton(
          icon: Icon(Icons.menu, color: Colors.white),
          itemBuilder: (context) => [
            PopupMenuItem(
              child: _buildContactMenuItem(
                context,
                icon: FontAwesomeIcons.envelope,
                text: "mazandotakawira@gmail.com",
                onTap: () => launchURL('mailto:mazandotakawira@gmail.com'),
              ),
            ),
            PopupMenuItem(
              child: _buildContactMenuItem(
                context,
                icon: FontAwesomeIcons.phone,
                text: "+27 672 319 200",
                onTap: () {
                  makePhoneCall("+27672319200");
                  openWhatsApp("+27672319200");
                },
              ),
            ),
            PopupMenuItem(
              child: _buildContactMenuItem(
                context,
                icon: FontAwesomeIcons.linkedin,
                text: "LinkedIn Profile",
                onTap: () => launchURL('www.linkedin.com/in/takawira-mazando-3a775715b'),
              ),
            ),
            PopupMenuItem(
              child: _buildContactMenuItem(
                context,
                icon: FontAwesomeIcons.github,
                text: "github.com/BantuITBS",
                onTap: () => launchURL('https://github.com/BantuITBS'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMobileHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('assets/profile.jpeg'),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Takawira Mazando",
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Mobile and Web Developer | Data Scientist",
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontStyle: FontStyle.italic,
                          color: Colors.white.withOpacity(0.9),
                        ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            PopupMenuButton(
              icon: Icon(Icons.menu, color: Colors.white),
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: _buildContactMenuItem(
                    context,
                    icon: FontAwesomeIcons.envelope,
                    text: "mazandotakawira@gmail.com",
                    onTap: () => launchURL('mailto:mazandotakawira@gmail.com'),
                  ),
                ),
                PopupMenuItem(
                  child: _buildContactMenuItem(
                    context,
                    icon: FontAwesomeIcons.phone,
                    text: "+27 672 319 200",
                    onTap: () {
                      makePhoneCall("+27672319200");
                      openWhatsApp("+27672319200");
                    },
                  ),
                ),
                PopupMenuItem(
                  child: _buildContactMenuItem(
                    context,
                    icon: FontAwesomeIcons.linkedin,
                    text: "LinkedIn Profile",
                    onTap: () => launchURL('www.linkedin.com/in/takawira-mazando-3a775715b'),
                  ),
                ),
                PopupMenuItem(
                  child: _buildContactMenuItem(
                    context,
                    icon: FontAwesomeIcons.github,
                    text: "github.com/BantuITBS",
                    onTap: () => launchURL('https://github.com/BantuITBS'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildContactMenuItem(BuildContext context, {required IconData icon, required String text, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FaIcon(icon, size: 14, color: primaryColor),
          const SizedBox(width: 6),
          Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: primaryColor),
          ),
        ],
      ),
    );
  }
}

class WelcomeContent extends StatelessWidget {
  final Color primaryColor;
  final Color secondaryColor;
  final VoidCallback onGetStarted;

  const WelcomeContent({
    super.key,
    required this.primaryColor,
    required this.secondaryColor,
    required this.onGetStarted,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: secondaryColor.withOpacity(0.6),
                    blurRadius: 25,
                    spreadRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
                gradient: RadialGradient(
                  colors: [Colors.white, secondaryColor],
                  center: Alignment.center,
                  radius: 0.85,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ClipOval(
                  child: Image.asset(
                    'assets/profile.jpeg',
                    width: 108,
                    height: 108,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.person_outline,
                        size: 108,
                        color: primaryColor,
                      );
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 36),
            ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: [primaryColor, secondaryColor],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ).createShader(bounds),
              child: Text(
                "Welcome to My Curriculum Vitae",
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  )
                ],
              ),
              child: Text(
                "Explore my professional journey, skills, and experiences by selecting a section from the sidebar navigation.",
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.grey[700],
                      height: 1.6,
                      fontSize: 16,
                    ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 36),
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: TweenAnimationBuilder(
                duration: const Duration(milliseconds: 300),
                tween: Tween<double>(begin: 1, end: 1),
                builder: (context, double value, child) {
                  return Transform.scale(
                    scale: value,
                    child: child,
                  );
                },
                child: ElevatedButton(
                  onPressed: onGetStarted,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: secondaryColor,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    elevation: 4,
                    shadowColor: secondaryColor.withOpacity(0.4),
                  ),
                  child: const Text(
                    "Get Started",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                3,
                (index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Icon(
                    Icons.circle,
                    size: 8,
                    color: secondaryColor.withOpacity(0.6),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfessionalSummaryContent extends StatelessWidget {
  final Color primaryColor;

  const ProfessionalSummaryContent({super.key, required this.primaryColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Text(
        "Dynamic Mobile and Web Developer and Data Scientist with 15+ years "
        "of experience (2005–2025), I transform data into vibrant insights that drive strategic wins. "
        "Expert in Python, AI/ML, and mobile/web development, with proficiency in JavaScript, TypeScript, "
        "SQL, Dart, and VBA. Led high-impact projects, including a R2.4B inventory optimization for Transnet "
        "and a 76-page Market Research Report for a R2B tender. I spearhead energetic Data Analytics teams, "
        "leveraging Power BI, TensorFlow, Spark, and Hadoop to deliver innovative solutions in supply chain, "
        "auditing, and mobile apps. With experience in lecturing and laboratory science, I excel in stakeholder "
        "engagement, mentoring, and technical reporting. Proficient in Agile, GDPR/POPIA, SCM analytics, and CAATs, "
        "I deliver compliant, impactful solutions.",
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    );
  }
}

class TechnicalSkillsContent extends StatelessWidget {
  final Color primaryColor;
  final Color secondaryColor;

  const TechnicalSkillsContent({
    super.key,
    required this.primaryColor,
    required this.secondaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSkillCategory(
          context,
          icon: FontAwesomeIcons.code,
          title: "Programming Languages",
          skills: [
            "Python 3 (Advanced: backend, AI/ML, analytics, automation)",
            "JavaScript (Moderate: ES6+, front-end)",
            "TypeScript (Component-based UI)",
            "SQL (Advanced: PostgreSQL, T-SQL, query optimization)",
            "Dart (Flutter, mobile apps)",
            "VBA (Excellent: Excel automation)",
            "Bash (Scripting)",
          ],
        ),
        _buildSkillCategory(
          context,
          icon: FontAwesomeIcons.cubes,
          title: "Frameworks & Libraries",
          skills: [
            "Pandas (Data manipulation)",
            "Django (REST APIs, Supabase)",
            "Flask (Lightweight APIs)",
            "FastAPI (High-performance APIs)",
            "TensorFlow (Deep learning)",
            "scikit-learn (Machine learning)",
            "PyTorch (Neural networks)",
            "spaCy (NLP)",
            "transformers (NLP models)",
            "nltk (Text processing)",
            "NumPy (Numerical computing)",
            "Plotly (Interactive visualizations)",
            "Dash (Web dashboards)",
            "Matplotlib (Data visualization)",
            "Seaborn (Statistical visualizations)",
            "openpyxl (Excel automation)",
            "xlwings (Excel integration)",
            "pywin32 (Windows automation)",
            "psycopg2 (PostgreSQL connector)",
            "sqlalchemy (ORM)",
            "Bootstrap 5 (Responsive UI)",
            "jQuery (DOM manipulation)",
            "Select2 (Dynamic dropdowns)",
            "Font Awesome (Icons)",
            "libphonenumber-js (Phone number parsing)",
            "SPSS (Statistical analysis)",
            "SSAS (OLAP cubes)",
            "SSRS (Reporting)",
            "SSIS (Data integration)",
            "SSDT (SQL development)",
            "SSMS (SQL Server management)",
          ],
        ),
        _buildSkillCategory(
          context,
          icon: FontAwesomeIcons.robot,
          title: "AI Tools",
          skills: [
            "Lovable AI (Conversational AI, user engagement)",
            "Grok (AI-driven insights)",
            "Deepseek (Deep learning applications)",
            "MetaAI (AI model integration)",
            "ChatGPT (NLP and automation)",
          ],
        ),
        _buildSkillCategory(
          context,
          icon: FontAwesomeIcons.database,
          title: "Big Data Frameworks",
          skills: [
            "Spark (Distributed computing)",
            "Hadoop (Big Data processing)",
          ],
        ),
        _buildSkillCategory(
          context,
          icon: FontAwesomeIcons.server,
          title: "Databases",
          skills: [
            "PostgreSQL (Supabase, CTEs, window functions)",
            "MySQL (Relational databases)",
            "SQLite (Lightweight databases)",
            "MongoDB (NoSQL)",
            "Firebase Firestore (Real-time NoSQL)",
            "Redis (Caching)",
            "SAP (QM, MM, RE-FX tables)",
          ],
        ),
        _buildSkillCategory(
          context,
          icon: FontAwesomeIcons.chartBar,
          title: "BI & Automation Tools",
          skills: [
            "Power BI (Advanced: Power Query, DAX, MDAX, dashboards)",
            "Power Automate (Workflow automation)",
            "Power Apps (Canvas, Model-Driven apps)",
            "Tableau (Data visualization)",
            "Excel (Advanced: pivot tables, VLOOKUP, INDEX-MATCH, SUMIFS, VBA)",
            "MS Word (Documents)",
            "MS PowerPoint (Presentations)",
            "MS SharePoint (Collaboration)",
            "MS Teams (Communication)",
          ],
        ),
        _buildSkillCategory(
          context,
          icon: FontAwesomeIcons.cloud,
          title: "DevOps & Version Control",
          skills: [
            "Docker (Containerization)",
            "AWS (EC2, S3, Lambda, SageMaker)",
            "Azure (App Service, Cosmos DB)",
            "Supabase (Backend-as-a-Service)",
            "Firebase (Mobile/web backend)",
            "GitHub Actions (CI/CD)",
            "Jenkins (Automation)",
            "Git (GitHub, GitLab, Bitbucket, Azure DevOps)",
          ],
        ),
        _buildSkillCategory(
          context,
          icon: FontAwesomeIcons.lightbulb,
          title: "Methodologies & Concepts",
          skills: [
            "Machine Learning (NLP, predictive analytics, recommendation systems, classification, regression, clustering)",
            "Data Modeling (Relational, dimensional)",
            "ETL/ELT (Data pipelines)",
            "CAATs (Computer Assisted Audit Techniques)",
            "Agile (Scrum, Kanban)",
            "Responsive Design",
            "API Development (REST, WebSockets, GraphQL)",
            "KPI Tracking",
            "Excel Automation",
            "Information Security (GDPR, POPIA)",
            "Auditing Methodologies (Forensic auditing)",
            "SCM Analytics (Supply chain optimization)",
            "LIMS (Laboratory Information Management Systems)",
            "Technical Report Writing",
            "Data Engineering",
          ],
        ),
        _buildSkillCategory(
          context,
          icon: FontAwesomeIcons.tools,
          title: "IDEs & Tools",
          skills: [
            "VS Code (Code editing)",
            "PyCharm (Python development)",
            "Jupyter Notebook (Data analysis)",
            "Jupyter Lab (Interactive computing)",
            "Mito (Excel-like data editing)",
            "Power BI Desktop (BI development)",
            "Supabase Studio (Database management)",
            "Postman (API testing)",
            "pgAdmin (PostgreSQL management)",
            "DBeaver (Database client)",
            "Jira (Project management)",
            "Trello (Task tracking)",
            "Notion (Collaboration)",
            "MS Planner (Task planning)",
            "Chrome DevTools (Web debugging)",
            "Flutter DevTools (Mobile debugging)",
            "Uptime Robot (Monitoring)",
            "Sentry (Error tracking)",
          ],
        ),
      ],
    );
  }

  Widget _buildSkillCategory(
    BuildContext context, {
    required IconData icon,
    required String title,
    required List<String> skills,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: secondaryColor),
              const SizedBox(width: 8),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: skills
                .map(
                  (skill) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: secondaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: secondaryColor.withOpacity(0.3)),
                    ),
                    child: Text(
                      skill,
                      style: TextStyle(color: primaryColor, fontSize: 12),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

class SoftSkillsContent extends StatelessWidget {
  final Color primaryColor;

  const SoftSkillsContent({super.key, required this.primaryColor});

  @override
  Widget build(BuildContext context) {
    return const SkillGrid();
  }
}

class ProfessionalExperienceContent extends StatelessWidget {
  final Color primaryColor;
  final Color secondaryColor;

  const ProfessionalExperienceContent({
    super.key,
    required this.primaryColor,
    required this.secondaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ExperienceCard(
          company: "Entsika Consulting Services, Johannesburg",
          role: "Data Scientist",
          period: "January 2021 – Present",
responsibilities: [
  "Led vibrant Data Analytics teams to deliver 20+ reports and dashboards for finance, healthcare, retail, and manufacturing using Python, SQL, Power BI, Tableau, and Spark.",
  "Built ML models with scikit-learn, TensorFlow, and PyTorch for predictive analytics in inventory, churn, and risk assessment.",
  "Crafted Power BI dashboards with Power Query, DAX, and MDAX, producing a 76-page Market Research Report for a R2B tender.",
  "Applied analytical skills to develop and deploy data models, evaluating and improving existing models to create solutions.",
  "Reviewed business areas to strengthen analytics, enabling strategic planning and supporting decision-making processes with solid data.",
  "Executed simulations on business data to identify financial impacts of decisions and created frameworks for testing model quality.",
  "Developed and refined reporting tools and interfaces for different KPIs to increase transparency and boost staff performance.",
  "Offered value-added insights and recommendations to business leaders using specialized techniques, helping businesses adapt to market changes.",
  "Applied custom models and algorithms to data sets to evaluate and solve diverse company problems.",
  "Filtered and assessed data from different views, searching for patterns indicating problems or opportunities and communicated results to help drive business growth.",
  "Facilitated and executed strategies to educate customers on data analysis and interpretation.",
  "Identified valuable data sources and used process automation tools to automate collection processes and maintain accuracy of collected information.",
  "Collected and validated analytics data from various sources, creating processes and tools for monitoring and analyzing model performance and data accuracy.",
  "Applied advanced analytical approaches and algorithms to evaluate business success factors, impact on company profits and growth potential.",
  "Developed Power BI visualizations and dynamic and static reports for diverse projects in Internal Auditing, SCM, Disaster Management, KPI Tracking.",
  "Mentored and led junior analytics team members, fostering growth in data modeling and BI tools.",
  "Presented reports to stakeholders using data visualization outputs, proposing solutions and strategies to drive business change and solve problems.",
  "Automated workflows with Power Automate, Power Apps, and Python (Pandas, NumPy, openpyxl), integrating Supabase, SAP, and Hadoop.",
  "Applied CAATs and auditing methodologies for GDPR/POPIA compliance.",
  "Engaged in global seminars on Data Analytics and Business Intelligence.",
],
          projects: [
            LinkProject("Transnet Engineering Inventory Optimisation (2022–2023)", "https://link-to-project1.com"),
            LinkProject("Security of Supply – Department of Correctional Services (2022–2024)", "https://link-to-project2.com"),
            LinkProject("Lease Review – Carlton Centre, Transnet Properties (2022–2024)", "https://link-to-project3.com"),
            LinkProject("KwaZulu-Natal Floods Disaster Management (2022–2023)", "https://link-to-project4.com"),
          ],
          primaryColor: primaryColor,
          secondaryColor: secondaryColor,
        ),
        ExperienceCard(
          company: "Info-Tech Business Solutions (iTBS), Johannesburg",
          role: "Mobile and Web Developer & Data Scientist",
          period: "January 2024 – Present",
responsibilities: [
  "Led teams to build AI-powered platforms and mobile apps with Django, Flask, FastAPI, Flutter, and Power BI.",
  "Designed responsive interfaces with HTML5, CSS3, JavaScript, TypeScript, React, Angular, and Vue.js for user engagement.",
  "Built scalable and secure Django applications with RESTful APIs, GraphQL, and JWT authentication.",
  "Developed custom Django models, views, templates, and forms to meet complex business requirements.",
  "Implemented Django ORM for efficient database operations and query optimization.",
  "Utilized Django's built-in authentication and authorization system for secure user management.",
  "Integrated third-party Django packages and libraries (e.g., Django REST framework, Django Channels) to enhance functionality.",
  "Designed and implemented database schema and migrations using Django's migration framework.",
  "Built and consumed APIs using Django REST framework, ensuring API security and performance.",
  "Implemented caching mechanisms (e.g., Redis, Memcached) to improve application performance.",
  "Utilized Celery and RabbitMQ for asynchronous task processing and job queuing.",
  "Implemented real-time functionality using Django Channels and WebSockets.",
  "Developed Flask applications with RESTful APIs, JWT authentication, and database integration (e.g., SQLAlchemy, Flask-SQLAlchemy).",
  "Built microservices with Flask and containerization using Docker.",
  "Implemented frontend functionality using JavaScript, TypeScript, and frameworks like React, Angular, and Vue.js.",
  "Utilized JavaScript libraries like jQuery, Lodash, and Moment.js to enhance frontend functionality.",
  "Implemented responsive design using CSS3, Sass, and Less.",
  "Ensured code quality and best practices through code reviews, testing (unit, integration, and functional tests), and continuous integration.",
  "Deployed applications on cloud platforms (e.g., AWS, Google Cloud, Azure) and containerization using Docker.",
  "Configured and managed applications using environment variables and configuration files.",
  "Implemented monitoring and logging tools (e.g., Prometheus, Grafana, ELK Stack) to track application performance and errors.",
  "Built ML models with scikit-learn, TensorFlow, PyTorch, and AI tools (Lovable AI, Grok) for predictive analytics and NLP.",
  "Integrated Supabase, Firebase, and Power Automate for real-time workflows.",
  "Mentored developers, aligning solutions with business goals via stakeholder collaboration.",
  "Applied Agile and GDPR/POPIA compliance for secure, innovative solutions.",
],
          projects: [
            LinkProject("Performa360 Platform (2024–2025)", ""),
            LinkProject("Customer Churn Prediction System (2025)", ""),
            LinkProject("AfroDating Mobile Application (2024–Present)", ""),
            LinkProject("AI-Powered Web Platform (WebCraft, 2025)", ""),
            LinkProject("AuPair Connect Platform (2025)", ""),
            LinkProject("LandLink Platform (2025)", ""),
            LinkProject("SurroLink Surrogacy Platform (2025)", ""),
          ],
          primaryColor: primaryColor,
          secondaryColor: secondaryColor,
        ),
        ExperienceCard(
          company: "Lucient Engineering & Construction, Witbank",
          role: "Data Scientist / Power BI Developer",
          period: "January 2015 – December 2020",
responsibilities: [
  "Built Power BI dashboards with DAX, MDAX, and Power Query for KPI tracking, equipment servicing, and production monitoring.",
  "Applied ML (scikit-learn, PyTorch, TensorFlow) and statistical models (SPSS, SSAS, R) for equipment failure prediction, anomaly detection, and predictive maintenance.",
  "Integrated ERP data with T-SQL, SSIS, and SSRS, automating with VBA, Python (Pandas, NumPy), and Power Automate.",
  "Created Tableau and Power BI visualizations for operational insights, production planning, and resource allocation.",
  "Conducted EDA for predictive maintenance models, reducing downtime by 10% and increasing overall equipment effectiveness.",
  "Developed and implemented data-driven solutions for mining operations, including geology, production planning, and equipment maintenance.",
  "Analyzed sensor data from mining equipment and machinery to identify trends and patterns.",
  "Collaborated with cross-functional teams to design and implement data-driven strategic planning and decision-making processes.",
  "Mentored staff and aligned analytics with organizational goals, promoting a data-driven culture.",
  "Developed and maintained databases and data systems for mining operations, ensuring data quality and integrity.",
  "Conducted data quality checks and ensured data accuracy, completeness, and consistency.",
  "Applied data mining and machine learning techniques to identify opportunities for process improvement and optimization.",
  "Presented findings and insights to stakeholders, using data visualization and storytelling techniques.",
  "Stayed up-to-date with industry trends and emerging technologies, applying knowledge to improve mining operations and analytics.",
],
          primaryColor: primaryColor,
          secondaryColor: secondaryColor,
        ),
        ExperienceCard(
          company: "Dairiboard Limited, Harare, Zimbabwe",
          role: "Senior Microbiologist / Analyst",
          period: "January 2005 – December 2014",
responsibilities: [
  "Conducted lab tests on inbound, inline, and outbound dairy product samples, ensuring ISO-compliant safety and quality.",
  "Analyzed SAP QM (LIMS) data for crucial product safety and quality insights, identifying trends and areas for improvement.",
  "Presented monthly stakeholder reports on production and quality metrics, highlighting key findings and recommendations.",
  "Developed and updated ISO-aligned SOPs and experimental methodologies for laboratory analysis of dairy products.",
  "Supervised and managed junior staff, conducting KPI reviews, mentoring, and ensuring adherence to laboratory protocols.",
  "Extracted, collated, validated, and analyzed production data for quality control, identifying opportunities for process improvement.",
  "Participated in internal food safety and quality audits, ensuring compliance with regulatory requirements and company standards.",
  "Ensured data met stringent quality control standards, flagging any issues and implementing corrective actions.",
  "Collaborated with production, supply chain, and regulatory affairs teams to align laboratory tests and data initiatives with organizational goals.",
  "Conducted microbiological testing and analysis of dairy products, including pathogen detection and enumeration.",
  "Performed biochemical testing and analysis of dairy products, including compositional analysis and quality control.",
  "Developed and implemented new laboratory methods and techniques to improve testing efficiency and accuracy.",
  "Maintained laboratory equipment and ensured calibration and validation of instruments.",
  "Participated in method validation and verification studies to ensure accuracy and precision of laboratory results.",
  "Collaborated with quality assurance team to develop and implement quality control measures and ensure compliance with regulatory requirements.",
],
          primaryColor: primaryColor,
          secondaryColor: secondaryColor,
        ),
      ],
    );
  }
}

class EducationContent extends StatelessWidget {
  final Color primaryColor;

  const EducationContent({super.key, required this.primaryColor});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        EducationTile(
          degree: "B.Sc. (Hons) in Industrial Microbiology",
          institution: "Midlands State University, Zimbabwe",
          period: "2001 – 2004",
          details: "Completed 36 modules, including data analysis, scientific methodologies, laboratory management, and microbiology research.",
          primaryColor: primaryColor,
        ),
        EducationTile(
          degree: "A-Levels (Sciences)",
          institution: "Guinea Fowl High School, Zimbabwe",
          period: "1999 – 2000",
          details: "Subjects: Mathematics, Chemistry, Biology",
          primaryColor: primaryColor,
        ),
        EducationTile(
          degree: "GCSEs (Ordinary Level)",
          institution: "Mutare Boys High School, Zimbabwe",
          period: "1997 – 1998",
          details: "Subjects: Mathematics, Biology, Physical Sciences, Geography, Metalwork, History, Technical Graphics, French, English Language, Literature in English",
          primaryColor: primaryColor,
        ),
      ],
    );
  }
}

class CertificationsContent extends StatelessWidget {
  final Color primaryColor;

  const CertificationsContent({super.key, required this.primaryColor});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CertificationTile(
          title: "IBM Data Science Professional Certificate",
          issuer: "Coursera",
          period: "2021 – 2022",
          details:
              "10 courses: What is Data Science, Tools for Data Science, Data Science Methodology, Python for Data Science, AI & Development, Python Project for Data Science, Databases & SQL for Data Science, Data Analysis with Python, Data Visualization with Python, Machine Learning with Python, Applied Data Science Capstone",
          verification: "https://coursera.org/verify/specialization/GUSLY3ETUER4",
          primaryColor: primaryColor,
        ),
        CertificationTile(
          title: "Python 3 Programming",
          issuer: "University of Michigan through Coursera",
          period: "2021 – 2022",
          details:
              "5 courses: Python Basics, Data Collection and Processing with Python, Python Functions, Files, and Dictionaries, Python Classes and Inheritance, Python Project: pillow, tesseract, and OpenCV",
          verification: "https://coursera.org/verify/3ZV7F6XK3L3N",
          primaryColor: primaryColor,
        ),
        CertificationTile(
          title: "Data Science Fundamentals with Python and SQL",
          issuer: "IBM, Coursera",
          period: "2021 – 2022",
          details:
              "5 courses: Tools for Data Science, Python for Data Science, AI & Development Python Project for Data Science, Statistics for Data Science with Python, Databases and SQL for Data Science with Python",
          primaryColor: primaryColor,
        ),
      ],
    );
  }
}

class AccomplishmentsContent extends StatelessWidget {
  final Color primaryColor;

  const AccomplishmentsContent({super.key, required this.primaryColor});

  @override
  Widget build(BuildContext context) {
    return AccomplishmentList([
      "Optimized a R2.4B inventory for Transnet, setting a national standard.",
      "Uncovered anomalies in Carlton Centre lease data, driving divestment.",
      "Contributed to KwaZulu-Natal Floods Task Team, shaping National Disaster Response Strategy.",
      "Developed 50+ Power BI dashboards for auditing, supply chain, and KPI tracking.",
    ], primaryColor: primaryColor);
  }
}

class ReferencesContent extends StatelessWidget {
  final Color primaryColor;

  const ReferencesContent({super.key, required this.primaryColor});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ReferenceTile(
          name: "Saildon Sivnanden",
          position: "Associate Director, Entsika Consulting Services",
          contact: "ssinanden@entsika.co.za, +27 794 972 305",
          primaryColor: primaryColor,
        ),
        ReferenceTile(
          name: "Shikar Nunkissor",
          position: "Process Engineer, Entsika Consulting Services",
          contact: "+27 843 428 888",
          primaryColor: primaryColor,
        ),
        ReferenceTile(
          name: "Seiphati Nkuna",
          position: "Business Analyst, Entsika Consulting Services",
          contact: "nkunas@entsika.co.za, +27 787 489 229",
          primaryColor: primaryColor,
        ),
      ],
    );
  }
}

class ProjectsContent extends StatelessWidget {
  final Function(Project) onProjectTap;
  final Color primaryColor;
  final Color secondaryColor;

  const ProjectsContent({
    super.key,
    required this.onProjectTap,
    required this.primaryColor,
    required this.secondaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 6,
                offset: const Offset(0, 3),
              )
            ],
          ),
          child: Text(
            "This portfolio highlights recent projects (2022–2025) from Info-Tech Business Solutions (iTBS) and Entsika Consulting Services, showcasing my expertise as a Python Developer, Data Scientist, and Data Analyst. These initiatives demonstrate strong stakeholder engagement and collaboration capabilities, working closely with clients, executives, and cross-functional teams to deliver innovative, data-driven solutions. With a focus on Advanced Analytics and Power BI, these projects improve business operations and user experiences, driving strategic decisions through actionable insights.",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          "Info-Tech Business Solutions (iTBS) and Entsika Consulting Projects",
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontSize: 18,
                color: primaryColor,
              ),
        ),
        const SizedBox(height: 16),
        ProjectGrid(
          onProjectTap: onProjectTap,
          primaryColor: primaryColor,
          secondaryColor: secondaryColor,
        ),
      ],
    );
  }
}

class FullCVContent extends StatelessWidget {
  final Future<void> Function(String) launchURL;
  final Color primaryColor;
  final Color secondaryColor;

  const FullCVContent({
    super.key,
    required this.launchURL,
    required this.primaryColor,
    required this.secondaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            icon: Icons.person,
            title: "Professional Summary",
            primaryColor: primaryColor,
            secondaryColor: secondaryColor,
            child: Container(
              padding: const EdgeInsets.all(16),
              child: ProfessionalSummaryContent(primaryColor: primaryColor),
            ),
          ),
          SectionHeader(
            icon: Icons.build,
            title: "Technical Skills",
            primaryColor: primaryColor,
            secondaryColor: secondaryColor,
            child: Container(
              padding: const EdgeInsets.all(16),
              child: TechnicalSkillsContent(primaryColor: primaryColor, secondaryColor: secondaryColor),
            ),
          ),
          SectionHeader(
            icon: Icons.people,
            title: "Soft, Leadership, and Interpersonal Skills",
            primaryColor: primaryColor,
            secondaryColor: secondaryColor,
            child: Container(
              padding: const EdgeInsets.all(16),
              child: SoftSkillsContent(primaryColor: primaryColor),
            ),
          ),
          SectionHeader(
            icon: Icons.work,
            title: "Professional Experience",
            primaryColor: primaryColor,
            secondaryColor: secondaryColor,
            child: Container(
              padding: const EdgeInsets.all(16),
              child: ProfessionalExperienceContent(primaryColor: primaryColor, secondaryColor: secondaryColor),
            ),
          ),
          SectionHeader(
            icon: Icons.school,
            title: "Education",
            primaryColor: primaryColor,
            secondaryColor: secondaryColor,
            child: Container(
              padding: const EdgeInsets.all(16),
              child: EducationContent(primaryColor: primaryColor),
            ),
          ),
          SectionHeader(
            icon: Icons.card_membership,
            title: "Certifications",
            primaryColor: primaryColor,
            secondaryColor: secondaryColor,
            child: Container(
              padding: const EdgeInsets.all(16),
              child: CertificationsContent(primaryColor: primaryColor),
            ),
          ),
          SectionHeader(
            icon: Icons.emoji_events,
            title: "Accomplishments",
            primaryColor: primaryColor,
            secondaryColor: secondaryColor,
            child: Container(
              padding: const EdgeInsets.all(16),
              child: AccomplishmentsContent(primaryColor: primaryColor),
            ),
          ),
          SectionHeader(
            icon: Icons.people_outline,
            title: "References",
            primaryColor: primaryColor,
            secondaryColor: secondaryColor,
            child: Container(
              padding: const EdgeInsets.all(16),
              child: ReferencesContent(primaryColor: primaryColor),
            ),
          ),
        ],
      ),
    );
  }
}

class Project {
  final String title;
  final String description;
  final String role;
  final List<String> contributions;
  final List<String> outcomes;
  final String imagePath;

  const Project({
    required this.title,
    required this.description,
    required this.role,
    required this.contributions,
    required this.outcomes,
    required this.imagePath,
  });
}

const List<Project> projects = [
  Project(
    title: "Performa360 Platform",
    description:
        "As a key contributor, I helped develop Performa360, a performance management platform that streamlines employee goal-setting, performance evaluations, and talent development. By engaging with business leaders and end-users, I ensured the platform met organizational needs through intuitive applications, AI-powered chat support, and interactive dashboards.",
    role: "Python Developer & Data Analyst",
    contributions: [
      "Collaborated with HR teams and executives to design user-friendly interfaces for tracking goals and training progress, aligning with business objectives.",
      "Partnered with cross-functional teams to integrate Power BI dashboards, visualizing performance metrics for actionable insights.",
      "Engaged stakeholders to implement AI-driven chat features, providing real-time support and personalized recommendations.",
      "Worked with IT teams to develop secure login systems, ensuring safe access for employees and managers."
    ],
    outcomes: [
      "Reduced performance review time by 30% through streamlined processes co-designed with stakeholders.",
      "Improved user engagement by 25% with intuitive design, informed by user feedback.",
      "Empowered organizations with Advanced Analytics and Power BI, driving strategic alignment through collaborative insights."
    ],
    imagePath: "assets/performa360.jpeg",
  ),
  Project(
    title: "AfroDating Mobile Application",
    description:
        "I contributed to AfroDating, a mobile app connecting people of African descent worldwide through location-based matching. By engaging with users and marketing teams, I ensured a culturally sensitive platform that enhances user connectivity and engagement.",
    role: "Mobile Developer & Data Analyst",
    contributions: [
      "Collaborated with user focus groups to develop responsive iOS and Android interfaces, ensuring seamless experiences.",
      "Worked with analytics teams to build Power BI dashboards, tracking engagement and performance metrics.",
      "Partnered with developers to integrate real-time chat and notification features, enhancing user connectivity."
    ],
    outcomes: [
      "Successfully launched on App Store and Google Play, achieving strong adoption through stakeholder-driven design.",
      "Increased user retention by 15% with culturally tailored features, informed by user feedback.",
      "Delivered actionable insights via Advanced Analytics, supporting platform growth through team collaboration."
    ],
    imagePath: "assets/afrodating.jpeg",
  ),
  Project(
    title: "AI-Powered Web Platform (WebCraft)",
    description: "Developed a comprehensive web platform using AI technologies to streamline business processes and enhance user experiences.",
    role: "Full Stack Developer & Data Scientist",
    contributions: [
      "Designed and implemented responsive front-end interfaces using Flutter and React",
      "Developed RESTful APIs and backend services using Django and FastAPI",
      "Integrated AI capabilities for content generation and user recommendations",
      "Implemented real-time data processing and analytics features"
    ],
    outcomes: [
      "Reduced development time by 40% through reusable component architecture",
      "Improved user engagement by 35% with personalized content recommendations",
      "Achieved 99.9% uptime through robust cloud infrastructure and monitoring"
    ],
    imagePath: "assets/webcraft.jpeg",
  ),
  Project(
    title: "Transnet Engineering Inventory Optimisation",
    description:
        "Led the development of a data-driven inventory optimization solution for Transnet, managing a R2.4B inventory to enhance supply chain efficiency and reduce costs.",
    role: "Data Scientist & Python Developer",
    contributions: [
      "Led vibrant Data Analytics team to deliver inventory optimization reports using Python, SQL, and Power BI.",
      "Built predictive models with scikit-learn and TensorFlow for inventory demand forecasting.",
      "Integrated SAP data with Python (Pandas, NumPy) and Power Automate for real-time analytics.",
      "Collaborated with stakeholders to align solutions with supply chain objectives."
    ],
    outcomes: [
      "Optimized R2.4B inventory, setting a national standard for efficiency.",
      "Reduced inventory costs by 15% through predictive analytics.",
      "Improved supply chain decision-making with actionable Power BI dashboards."
    ],
    imagePath: "assets/TE.jpeg",
  ),
  Project(
    title: "AuPair Connect Platform",
    description: "Built a platform connecting families with qualified au pairs, featuring advanced matching algorithms and secure communication tools.",
    role: "Mobile & Web Developer",
    contributions: [
      "Developed cross-platform mobile applications using Flutter",
      "Implemented secure messaging and video call features",
      "Created matching algorithm based on family needs and au pair qualifications",
      "Integrated payment processing and background check services"
    ],
    outcomes: [
      "Successfully matched over 500 families with qualified au pairs",
      "Achieved 4.8/5 user satisfaction rating",
      "Reduced matching time from weeks to days through algorithmic optimization"
    ],
    imagePath: "assets/aupair_connect.jpeg",
  ),
  Project(
    title: "LandLink Platform",
    description: "Developed a real estate platform connecting landowners with potential developers and investors, featuring advanced property search and analytics.",
    role: "Full Stack Developer & Data Analyst",
    contributions: [
      "Created property search with advanced filters and map integration",
      "Developed analytics dashboard for property valuation and market trends",
      "Implemented secure document sharing and electronic signature capabilities",
      "Built recommendation engine for matching properties with investor preferences"
    ],
    outcomes: [
      "Facilitated over R50M in property transactions",
      "Reduced property search time by 70% through intelligent filtering",
      "Provided data-driven insights for investment decisions"
    ],
    imagePath: "assets/landlink.jpeg",
  ),
  Project(
    title: "SurroLink Surrogacy Platform",
    description: "Created a sensitive and secure platform connecting intended parents with surrogate mothers, providing support throughout the surrogacy journey.",
    role: "Full Stack Developer",
    contributions: [
      "Developed secure messaging and medical record sharing system",
      "Created matching algorithm based on medical compatibility and preferences",
      "Implemented calendar and scheduling system for medical appointments",
      "Built support community features with moderated forums"
    ],
    outcomes: [
      "Successfully facilitated over 100 surrogacy matches",
      "Maintained 100% data security and HIPAA compliance",
      "Received recognition from fertility clinics for improving the matching process"
    ],
    imagePath: "assets/surrolink.jpeg",
  ),
];

class ProjectGrid extends StatelessWidget {
  final Function(Project) onProjectTap;
  final Color primaryColor;
  final Color secondaryColor;

  const ProjectGrid({
    super.key,
    required this.onProjectTap,
    required this.primaryColor,
    required this.secondaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, sizingInformation) {
        final crossAxisCount = sizingInformation.isMobile ? 1 : 2;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.9,
            mainAxisExtent: 300,
          ),
          itemCount: projects.length,
          itemBuilder: (context, index) {
            return ProjectCard(
              project: projects[index],
              onTap: onProjectTap,
              primaryColor: primaryColor,
              secondaryColor: secondaryColor,
            );
          },
        );
      },
    );
  }
}

class ProjectCard extends StatelessWidget {
  final Project project;
  final Function(Project) onTap;
  final Color primaryColor;
  final Color secondaryColor;

  const ProjectCard({
    super.key,
    required this.project,
    required this.onTap,
    required this.primaryColor,
    required this.secondaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
      child: InkWell(
        onTap: () => onTap(project),
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                child: project.imagePath.isNotEmpty
                    ? Image.asset(
                        project.imagePath,
                        width: double.infinity,
                        height: 180,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: secondaryColor.withOpacity(0.1),
                            child: Center(
                              child: Icon(Icons.business_center, size: 50, color: primaryColor),
                            ),
                          );
                        },
                      )
                    : Container(
                        color: secondaryColor.withOpacity(0.1),
                        child: Center(
                          child: Icon(Icons.business_center, size: 50, color: primaryColor),
                        ),
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    project.title,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    project.description,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProjectDetailsModal extends StatelessWidget {
  final Project project;
  final Color primaryColor;
  final Color secondaryColor;

  const ProjectDetailsModal({
    super.key,
    required this.project,
    required this.primaryColor,
    required this.secondaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(20),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
      child: Container(
        padding: const EdgeInsets.all(20),
        constraints: const BoxConstraints(maxWidth: 600),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      project.title,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: primaryColor),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: primaryColor),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(12)),
                child: Container(
                  height: 200,
                  width: double.infinity,
                  child: project.imagePath.isNotEmpty
                      ? Image.asset(
                          project.imagePath,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: secondaryColor.withOpacity(0.1),
                              child: Center(
                                child: Icon(Icons.business_center, size: 60, color: primaryColor),
                              ),
                            );
                          },
                        )
                      : Container(
                          color: secondaryColor.withOpacity(0.1),
                          child: Center(
                            child: Icon(Icons.business_center, size: 60, color: primaryColor),
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 16),
              Text(project.description, style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: 16),
              Text(
                "Role:",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontSize: 18,
                      color: primaryColor,
                    ),
              ),
              const SizedBox(height: 8),
              Text(project.role, style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: 16),
              Text(
                "Contributions:",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontSize: 18,
                      color: primaryColor,
                    ),
              ),
              const SizedBox(height: 8),
              BulletList(project.contributions, primaryColor: primaryColor),
              const SizedBox(height: 16),
              Text(
                "Outcomes:",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontSize: 18,
                      color: primaryColor,
                    ),
              ),
              const SizedBox(height: 8),
              BulletList(project.outcomes, primaryColor: primaryColor),
            ],
          ),
        ),
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color primaryColor;
  final Color secondaryColor;
  final Widget? child;

  const SectionHeader({
    super.key,
    required this.icon,
    required this.title,
    required this.primaryColor,
    required this.secondaryColor,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [primaryColor, secondaryColor],
            ),
          ),
          child: Row(
            children: [
              Icon(icon, color: Colors.white),
              const SizedBox(width: 12),
              Text(
                title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white),
              ),
            ],
          ),
        ),
        if (child != null) child!,
      ],
    );
  }
}

class SkillGrid extends StatelessWidget {
  const SkillGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, sizingInformation) {
        final isMobile = sizingInformation.isMobile;

        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            SkillItem(
              icon: Icons.group,
              text: "Team Leadership: Guided cross-functional teams of developers, analysts, and scientists to achieve project goals, fostering collaboration and innovation.",
              width: isMobile ? double.infinity : 300,
            ),
            SkillItem(
              icon: Icons.assignment,
              text: "Project Management: Oversaw end-to-end delivery of complex technical projects, ensuring timely completion within budget and scope.",
              width: isMobile ? double.infinity : 300,
            ),
            SkillItem(
              icon: Icons.timeline,
              text: "Strategic Planning: Aligned technical solutions with business objectives, driving organizational success in data-driven initiatives.",
              width: isMobile ? double.infinity : 300,
            ),
            SkillItem(
              icon: Icons.handshake,
              text: "Stakeholder Engagement: Communicated effectively with clients, executives, and cross-industry partners to align on project goals and deliverables.",
              width: isMobile ? double.infinity : 300,
            ),
            SkillItem(
              icon: Icons.lightbulb,
              text: "Problem-Solving: Developed innovative solutions to complex technical and analytical challenges in development and scientific contexts.",
              width: isMobile ? double.infinity : 300,
            ),
            SkillItem(
              icon: Icons.comment,
              text: "Communication: Delivered clear, concise presentations and technical reports to diverse audiences, including students and industry stakeholders.",
              width: isMobile ? double.infinity : 300,
            ),
            SkillItem(
              icon: Icons.school,
              text: "Mentoring and Lecturing: Mentored junior developers and analysts, and lectured on data science and microbiology, fostering professional and academic growth.",
              width: isMobile ? double.infinity : 300,
            ),
            SkillItem(
              icon: Icons.cached,
              text: "Adaptability: Thrived in fast-paced, dynamic environments, adapting to new technologies and scientific methodologies.",
              width: isMobile ? double.infinity : 300,
            ),
            SkillItem(
              icon: Icons.access_time,
              text: "Time Management: Prioritized tasks and managed deadlines effectively across development, analytics, and laboratory projects.",
              width: isMobile ? double.infinity : 300,
            ),
            SkillItem(
              icon: Icons.mediation,
              text: "Conflict Resolution: Mediated team disputes to ensure cohesive collaboration and maintain project momentum.",
              width: isMobile ? double.infinity : 300,
            ),
            SkillItem(
              icon: Icons.gavel,
              text: "Decision-Making: Made data-driven decisions to optimize outcomes in software development, data analysis, and laboratory operations.",
              width: isMobile ? double.infinity : 300,
            ),
            SkillItem(
              icon: Icons.people_alt,
              text: "Collaboration: Built strong interdisciplinary partnerships with developers, scientists, and business teams to drive project success.",
              width: isMobile ? double.infinity : 300,
            ),
            SkillItem(
              icon: Icons.psychology,
              text: "Emotional Intelligence: Leveraged empathy and interpersonal awareness to build trust and rapport in professional and academic settings.",
              width: isMobile ? double.infinity : 300,
            ),
          ],
        );
      },
    );
  }
}

class SkillItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final double width;

  const SkillItem({
    super.key,
    required this.icon,
    required this.text,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: Colors.blue[700]),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: Theme.of(context).textTheme.bodyMedium)),
        ],
      ),
    );
  }
}

class ExperienceCard extends StatelessWidget {
  final String company;
  final String role;
  final String period;
  final List<String> responsibilities;
  final List<LinkProject>? projects;
  final Color primaryColor;
  final Color secondaryColor;

  const ExperienceCard({
    super.key,
    required this.company,
    required this.role,
    required this.period,
    required this.responsibilities,
    this.projects,
    required this.primaryColor,
    required this.secondaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              company,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              "$role • $period",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[700]),
            ),
            const SizedBox(height: 12),
            Text("Responsibilities:", style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            BulletList(responsibilities, primaryColor: primaryColor),
            if (projects != null && projects!.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text("Key Projects:", style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              BulletList(projects!.map((p) => "${p.name}: ${p.url}").toList(), primaryColor: primaryColor),
            ],
          ],
        ),
      ),
    );
  }
}

class EducationTile extends StatelessWidget {
  final String degree;
  final String institution;
  final String period;
  final String details;
  final Color primaryColor;

  const EducationTile({
    super.key,
    required this.degree,
    required this.institution,
    required this.period,
    required this.details,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Icon(Icons.school, color: primaryColor),
        title: Text(degree, style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(institution, style: Theme.of(context).textTheme.bodyMedium),
            Text(period, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[600])),
            const SizedBox(height: 6),
            if (details.isNotEmpty) Text(details, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}

class CertificationTile extends StatelessWidget {
  final String title;
  final String issuer;
  final String period;
  final String details;
  final String? verification;
  final Color primaryColor;

  const CertificationTile({
    super.key,
    required this.title,
    required this.issuer,
    required this.period,
    required this.details,
    this.verification,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Icon(Icons.card_membership, color: primaryColor),
        title: Text(title, style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(issuer, style: Theme.of(context).textTheme.bodyMedium),
            Text(period, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[600])),
            const SizedBox(height: 6),
            if (details.isNotEmpty) Text(details, style: Theme.of(context).textTheme.bodyMedium),
            if (verification != null)
              GestureDetector(
                onTap: () => launchUrl(Uri.parse(verification!)),
                child: Text(
                  "Verification: $verification",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class AccomplishmentList extends StatelessWidget {
  final List<String> items;
  final Color primaryColor;

  const AccomplishmentList(this.items, {super.key, required this.primaryColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: items
            .map((e) => Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.check_circle, size: 16, color: primaryColor),
                      const SizedBox(width: 8),
                      Expanded(child: Text(e, style: Theme.of(context).textTheme.bodyMedium)),
                    ],
                  ),
                ))
            .toList(),
      ),
    );
  }
}

class ReferenceTile extends StatelessWidget {
  final String name;
  final String position;
  final String contact;
  final Color primaryColor;

  const ReferenceTile({
    super.key,
    required this.name,
    required this.position,
    required this.contact,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Icon(Icons.person, color: primaryColor),
        title: Text(name, style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(position, style: Theme.of(context).textTheme.bodyMedium),
            Text(contact, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[600])),
          ],
        ),
      ),
    );
  }
}

class LinkProject {
  final String name;
  final String url;

  const LinkProject(this.name, this.url);
}

class BulletList extends StatelessWidget {
  final List<String> items;
  final Color primaryColor;

  const BulletList(this.items, {super.key, required this.primaryColor});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items
          .map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.circle, size: 8, color: primaryColor),
                    const SizedBox(width: 8),
                    Expanded(child: Text(item, style: Theme.of(context).textTheme.bodyMedium)),
                  ],
                ),
              ))
          .toList(),
    );
  }
}