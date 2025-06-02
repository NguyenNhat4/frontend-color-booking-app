import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/auth/bloc/auth_bloc.dart';
import 'package:mobile/auth/bloc/auth_event.dart';
import 'package:mobile/profile/bloc/profile_bloc.dart';
import 'package:mobile/profile/bloc/profile_event.dart';
import 'package:mobile/profile/repositories/user_repository.dart';
import 'package:mobile/profile/screens/profile_screen.dart';
import 'package:mobile/features/image_processing/screens/image_upload_screen.dart';
import 'package:mobile/features/product_catalog/presentation/screens/vietnamese_product_screen.dart';
import 'package:mobile/core/theme/paint_app_colors.dart';
import 'package:mobile/core/widgets/paint_app_button.dart';

class HomeScreen extends StatefulWidget {
  final String username;

  const HomeScreen({super.key, required this.username});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _colorController;

  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _colorAnimation;

  // Mock user type - in real app this would come from user data
  String _userType = 'homeowner'; // contractor, homeowner, company, regular

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimations();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _colorController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
    );

    _colorAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _colorController, curve: Curves.easeInOut),
    );
  }

  void _startAnimations() {
    _fadeController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      _slideController.forward();
    });
    Future.delayed(const Duration(milliseconds: 500), () {
      _colorController.repeat(reverse: true);
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _colorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isDesktop = screenWidth > 1200;
    final isTablet = screenWidth > 768 && screenWidth <= 1200;
    final isMobile = screenWidth <= 768;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: PaintAppColors.warmGradient),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: isDesktop ? _buildDesktopLayout() : _buildMobileLayout(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopLayout() {
    final screenWidth = MediaQuery.of(context).size.width;
    final sidebarWidth =
        screenWidth * 0.25; // 25% of screen width, min 280, max 350
    final responsiveSidebarWidth = sidebarWidth.clamp(280.0, 350.0);

    return Row(
      children: [
        // Left sidebar for desktop
        Container(
          width: responsiveSidebarWidth,
          decoration: BoxDecoration(
            gradient: PaintAppColors.getUserTypeGradient(_userType),
          ),
          child: _buildDesktopSidebar(),
        ),

        // Main content area
        Expanded(
          child: CustomScrollView(
            slivers: [
              // Desktop app bar
              _buildDesktopAppBar(),

              // Main content
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(
                    screenWidth * 0.025,
                  ), // Responsive padding (2.5% of screen width)
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top row: Featured collections and quick stats
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(flex: 2, child: _buildFeaturedCollections()),
                          SizedBox(
                            width: screenWidth * 0.025,
                          ), // Responsive spacing
                          Expanded(flex: 1, child: _buildQuickStats()),
                        ],
                      ),

                      SizedBox(
                        height: screenWidth * 0.03,
                      ), // Responsive spacing
                      // Quick Actions Header
                      _buildSectionHeader(
                        'Quick Actions',
                        'Everything you need at your fingertips',
                      ),

                      SizedBox(
                        height: screenWidth * 0.02,
                      ), // Responsive spacing
                      // Feature Cards Grid (4 columns for desktop)
                      _buildDesktopFeatureGrid(),

                      SizedBox(
                        height: screenWidth * 0.03,
                      ), // Responsive spacing
                      // Bottom row: User dashboard and room transformations
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(flex: 1, child: _buildUserDashboard()),
                          SizedBox(
                            width: screenWidth * 0.025,
                          ), // Responsive spacing
                          Expanded(flex: 2, child: _buildRoomTransformations()),
                        ],
                      ),

                      SizedBox(
                        height: screenWidth * 0.025,
                      ), // Responsive spacing
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return CustomScrollView(
      slivers: [
        // Custom App Bar with Hero Section
        _buildHeroAppBar(),

        // Main Content
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.all(
              MediaQuery.of(context).size.width * 0.06,
            ), // Responsive padding (6% of screen width)
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Featured Paint Collections
                _buildFeaturedCollections(),

                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.08,
                ), // Responsive spacing
                // Quick Actions Header
                _buildSectionHeader(
                  'Quick Actions',
                  'Everything you need at your fingertips',
                ),

                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.05,
                ), // Responsive spacing
                // Feature Cards Grid
                _buildFeatureCardsGrid(),

                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.08,
                ), // Responsive spacing
                // Recent Activity / User Type Dashboard
                _buildUserDashboard(),

                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.08,
                ), // Responsive spacing
                // Sample Room Transformations
                _buildRoomTransformations(),

                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.06,
                ), // Responsive spacing
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeroAppBar() {
    return SliverAppBar(
      expandedHeight: 220,
      floating: false,
      pinned: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      actions: [
        _buildAppBarAction(Icons.notifications_outlined, 'Notifications', () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Notifications coming soon!')),
          );
        }),
        const SizedBox(width: 8),
        _buildAppBarAction(
          Icons.person_outline,
          'Profile',
          () => _navigateToProfile(context),
        ),
        const SizedBox(width: 8),
        _buildAppBarAction(
          Icons.logout_outlined,
          'Logout',
          () => context.read<AuthBloc>().add(LoggedOut()),
        ),
        const SizedBox(width: 16),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: PaintAppColors.getUserTypeGradient(_userType),
          ),
          child: Stack(
            children: [
              // Animated background pattern
              _buildAnimatedBackground(),

              // Content
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 60,
                    ), // Account for status bar and app bar
                    // User Avatar and Info
                    Row(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: PaintAppColors.surface,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: PaintAppColors.shadowMedium,
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              widget.username[0].toUpperCase(),
                              style: TextStyle(
                                color: PaintAppColors.getUserTypeColor(
                                  _userType,
                                ),
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 16),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Welcome back!',
                                style: TextStyle(
                                  color: PaintAppColors.textInverse.withOpacity(
                                    0.9,
                                  ),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                widget.username,
                                style: const TextStyle(
                                  color: PaintAppColors.textInverse,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: PaintAppColors.surface.withOpacity(
                                    0.2,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  _getUserTypeLabel(_userType),
                                  style: const TextStyle(
                                    color: PaintAppColors.textInverse,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBarAction(
    IconData icon,
    String tooltip,
    VoidCallback onPressed,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: PaintAppColors.surface.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: IconButton(
        icon: Icon(icon, color: PaintAppColors.textInverse, size: 20),
        onPressed: onPressed,
        tooltip: tooltip,
      ),
    );
  }

  Widget _buildAnimatedBackground() {
    return AnimatedBuilder(
      animation: _colorAnimation,
      builder: (context, child) {
        return Positioned.fill(
          child: CustomPaint(
            painter: HomeBackgroundPainter(_colorAnimation.value, _userType),
          ),
        );
      },
    );
  }

  Widget _buildFeaturedCollections() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          'Featured Collections',
          'Trending paint colors chosen by professionals',
        ),

        const SizedBox(height: 16),

        SizedBox(
          height:
              MediaQuery.of(context).size.width > 768
                  ? 140
                  : 120, // Responsive height
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _getFeaturedColors().length,
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.008,
            ), // Responsive padding
            itemBuilder: (context, index) {
              final colorData = _getFeaturedColors()[index];
              return _buildColorCard(colorData);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildColorCard(Map<String, dynamic> colorData) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth =
        screenWidth > 1200
            ? 120.0
            : screenWidth > 768
            ? 110.0
            : 100.0;
    final cardMargin = screenWidth * 0.015; // Responsive margin
    final borderRadius = screenWidth > 768 ? 18.0 : 16.0;

    return Container(
      width: cardWidth,
      margin: EdgeInsets.only(right: cardMargin.clamp(12.0, 20.0)),
      decoration: BoxDecoration(
        color: colorData['color'],
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: (colorData['color'] as Color).withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(screenWidth * 0.015), // Responsive padding
            decoration: BoxDecoration(
              color: PaintAppColors.surface.withOpacity(0.95),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(borderRadius),
                bottomRight: Radius.circular(borderRadius),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min, // Prevent overflow
              children: [
                Text(
                  colorData['name'],
                  style: TextStyle(
                    fontSize:
                        screenWidth > 768 ? 12 : 10, // Responsive font size
                    fontWeight: FontWeight.w600,
                    color: PaintAppColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: screenWidth * 0.003), // Responsive spacing
                Text(
                  colorData['code'],
                  style: TextStyle(
                    fontSize:
                        screenWidth > 768 ? 10 : 9, // Responsive font size
                    color: PaintAppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: PaintAppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: TextStyle(fontSize: 16, color: PaintAppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildFeatureCardsGrid() {
    final features = _getFeatures();
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount =
        screenWidth > 1200
            ? 4
            : screenWidth > 768
            ? 3
            : 2;
    final spacing =
        screenWidth * 0.015; // Responsive spacing (1.5% of screen width)
    final aspectRatio =
        screenWidth > 1200
            ? 1.2
            : screenWidth > 768
            ? 1.1
            : 0.8; // Taller cards for mobile to fit content

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: spacing.clamp(12.0, 24.0),
        mainAxisSpacing: spacing.clamp(12.0, 24.0),
        childAspectRatio: aspectRatio,
      ),
      itemCount: features.length,
      itemBuilder: (context, index) {
        final feature = features[index];
        return _buildPremiumFeatureCard(feature);
      },
    );
  }

  Widget _buildDesktopFeatureGrid() {
    final features = _getFeatures();
    final screenWidth = MediaQuery.of(context).size.width;
    final spacing = screenWidth * 0.02; // Responsive spacing for desktop
    final aspectRatio = screenWidth > 1400 ? 1.3 : 1.2;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: spacing.clamp(16.0, 32.0),
        mainAxisSpacing: spacing.clamp(16.0, 32.0),
        childAspectRatio: aspectRatio,
      ),
      itemCount: features.length,
      itemBuilder: (context, index) {
        final feature = features[index];
        return _buildPremiumFeatureCard(feature);
      },
    );
  }

  Widget _buildPremiumFeatureCard(Map<String, dynamic> feature) {
    return GestureDetector(
      onTap: feature['onTap'],
      child: Container(
        decoration: BoxDecoration(
          gradient: feature['gradient'],
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: (feature['color'] as Color).withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Background pattern
            Positioned.fill(
              child: CustomPaint(
                painter: FeatureCardBackgroundPainter(feature['color']),
              ),
            ),

            // Content
            Padding(
              padding: EdgeInsets.all(
                MediaQuery.of(context).size.width > 768
                    ? MediaQuery.of(context).size.width * 0.04
                    : MediaQuery.of(context).size.width * 0.025,
              ), // Responsive padding - smaller for mobile
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon
                  Container(
                    width:
                        MediaQuery.of(context).size.width > 1200
                            ? 52
                            : MediaQuery.of(context).size.width > 768
                            ? 48
                            : 36, // Smaller for mobile
                    height:
                        MediaQuery.of(context).size.width > 1200
                            ? 52
                            : MediaQuery.of(context).size.width > 768
                            ? 48
                            : 36, // Smaller for mobile
                    decoration: BoxDecoration(
                      color: PaintAppColors.surface.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(
                        MediaQuery.of(context).size.width > 768 ? 14 : 10,
                      ),
                    ),
                    child: Icon(
                      feature['icon'],
                      size:
                          MediaQuery.of(context).size.width > 1200
                              ? 26
                              : MediaQuery.of(context).size.width > 768
                              ? 24
                              : 18, // Smaller for mobile
                      color: PaintAppColors.textInverse,
                    ),
                  ),

                  const Spacer(),

                  // Title
                  Text(
                    feature['title'],
                    style: TextStyle(
                      fontSize:
                          MediaQuery.of(context).size.width > 1200
                              ? 20
                              : MediaQuery.of(context).size.width > 768
                              ? 18
                              : 14, // Smaller for mobile
                      fontWeight: FontWeight.bold,
                      color: PaintAppColors.textInverse,
                    ),
                  ),

                  SizedBox(
                    height:
                        MediaQuery.of(context).size.width *
                        0.004, // Reduced spacing
                  ), // Responsive spacing
                  // Subtitle
                  Text(
                    feature['subtitle'],
                    style: TextStyle(
                      fontSize:
                          MediaQuery.of(context).size.width > 1200
                              ? 15
                              : MediaQuery.of(context).size.width > 768
                              ? 14
                              : 11, // Smaller for mobile
                      color: PaintAppColors.textInverse.withOpacity(0.8),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserDashboard() {
    final screenWidth = MediaQuery.of(context).size.width;
    final padding = screenWidth * 0.04; // Responsive padding

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(padding.clamp(16.0, 32.0)),
      decoration: BoxDecoration(
        color: PaintAppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: PaintAppColors.shadowMedium,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                _getUserTypeIcon(_userType),
                color: PaintAppColors.getUserTypeColor(_userType),
                size: screenWidth > 1200 ? 26 : 24,
              ),
              SizedBox(width: screenWidth * 0.015), // Responsive spacing
              Text(
                '${_getUserTypeLabel(_userType)} Dashboard',
                style: TextStyle(
                  fontSize: screenWidth > 1200 ? 22 : 20,
                  fontWeight: FontWeight.bold,
                  color: PaintAppColors.textPrimary,
                ),
              ),
            ],
          ),

          SizedBox(height: screenWidth * 0.025), // Responsive spacing
          // User type specific content
          _buildUserTypeContent(),
        ],
      ),
    );
  }

  Widget _buildUserTypeContent() {
    switch (_userType) {
      case 'contractor':
        return _buildContractorDashboard();
      case 'company':
        return _buildCompanyDashboard();
      case 'homeowner':
        return _buildHomeownerDashboard();
      default:
        return _buildRegularUserDashboard();
    }
  }

  Widget _buildContractorDashboard() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildDashboardStat('Projects', '12', Icons.work_outline),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.02,
            ), // Responsive spacing
            Expanded(
              child: _buildDashboardStat(
                'Savings',
                '25%',
                Icons.savings_outlined,
              ),
            ),
          ],
        ),
        SizedBox(
          height: MediaQuery.of(context).size.width * 0.02,
        ), // Responsive spacing
        PaintAppButton(
          text: 'View Contractor Prices',
          onPressed: () => _navigateToProductCatalog(context),
          variant: PaintAppButtonVariant.outline,
          size: PaintAppButtonSize.medium,
          isFullWidth: true,
          icon: const Icon(
            Icons.price_check,
            size: 18,
            color: PaintAppColors.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildCompanyDashboard() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildDashboardStat(
                'Orders',
                '48',
                Icons.shopping_cart_outlined,
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.02,
            ), // Responsive spacing
            Expanded(
              child: _buildDashboardStat(
                'Volume',
                '2.5k L',
                Icons.inventory_outlined,
              ),
            ),
          ],
        ),
        SizedBox(
          height: MediaQuery.of(context).size.width * 0.02,
        ), // Responsive spacing
        PaintAppButton(
          text: 'Enterprise Portal',
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Enterprise features coming soon!')),
            );
          },
          variant: PaintAppButtonVariant.outline,
          size: PaintAppButtonSize.medium,
          isFullWidth: true,
          icon: const Icon(
            Icons.business,
            size: 18,
            color: PaintAppColors.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildHomeownerDashboard() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildDashboardStat('Rooms', '3', Icons.home_outlined),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.02,
            ), // Responsive spacing
            Expanded(
              child: _buildDashboardStat('Colors', '8', Icons.palette_outlined),
            ),
          ],
        ),
        SizedBox(
          height: MediaQuery.of(context).size.width * 0.02,
        ), // Responsive spacing
        PaintAppButton(
          text: 'Color Inspiration',
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Color inspiration coming soon!')),
            );
          },
          variant: PaintAppButtonVariant.outline,
          size: PaintAppButtonSize.medium,
          isFullWidth: true,
          icon: const Icon(
            Icons.lightbulb_outline,
            size: 18,
            color: PaintAppColors.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildRegularUserDashboard() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildDashboardStat('Swaps', '5', Icons.swap_horiz),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.02,
            ), // Responsive spacing
            Expanded(
              child: _buildDashboardStat(
                'Favorites',
                '12',
                Icons.favorite_outline,
              ),
            ),
          ],
        ),
        SizedBox(
          height: MediaQuery.of(context).size.width * 0.02,
        ), // Responsive spacing
        PaintAppButton(
          text: 'Get Started',
          onPressed: () => _navigateToColorSwap(context),
          variant: PaintAppButtonVariant.outline,
          size: PaintAppButtonSize.medium,
          isFullWidth: true,
          icon: const Icon(
            Icons.play_arrow,
            size: 18,
            color: PaintAppColors.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildDashboardStat(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: PaintAppColors.backgroundAccent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: PaintAppColors.getUserTypeColor(_userType),
            size: 24,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: PaintAppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: PaintAppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildRoomTransformations() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          'Room Transformations',
          'See the magic of color in action',
        ),

        const SizedBox(height: 16),

        SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _getRoomTransformations().length,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            itemBuilder: (context, index) {
              final room = _getRoomTransformations()[index];
              return _buildRoomCard(room);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRoomCard(Map<String, dynamic> room) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth =
        screenWidth > 1200
            ? 320.0
            : screenWidth > 768
            ? 300.0
            : 280.0;
    final cardMargin = screenWidth * 0.015; // Responsive margin

    return Container(
      width: cardWidth,
      margin: EdgeInsets.only(right: cardMargin.clamp(12.0, 20.0)),
      decoration: BoxDecoration(
        color: PaintAppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: PaintAppColors.shadowMedium,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Before/After Split View
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                gradient: LinearGradient(
                  colors: [
                    room['beforeColor'] as Color,
                    room['afterColor'] as Color,
                  ],
                ),
              ),
              child: Stack(
                children: [
                  // "BEFORE" and "AFTER" labels
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: PaintAppColors.surface.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'BEFORE',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: PaintAppColors.textPrimary,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: PaintAppColors.surface.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'AFTER',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: PaintAppColors.textPrimary,
                        ),
                      ),
                    ),
                  ),
                  // Center divider
                  Positioned(
                    top: 0,
                    bottom: 0,
                    left: 140,
                    child: Container(width: 2, color: PaintAppColors.surface),
                  ),
                ],
              ),
            ),
          ),

          // Room Info
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  room['name'],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: PaintAppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  room['description'],
                  style: TextStyle(
                    fontSize: 14,
                    color: PaintAppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopSidebar() {
    return Column(
      children: [
        const SizedBox(height: 40),

        // User Avatar and Info
        Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: PaintAppColors.surface,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: PaintAppColors.shadowMedium,
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    widget.username[0].toUpperCase(),
                    style: TextStyle(
                      color: PaintAppColors.getUserTypeColor(_userType),
                      fontWeight: FontWeight.bold,
                      fontSize: 32,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              Text(
                'Welcome back!',
                style: TextStyle(
                  color: PaintAppColors.textInverse.withOpacity(0.9),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                widget.username,
                style: const TextStyle(
                  color: PaintAppColors.textInverse,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 8),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: PaintAppColors.surface.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  _getUserTypeLabel(_userType),
                  style: const TextStyle(
                    color: PaintAppColors.textInverse,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),

        const Spacer(),

        // Navigation Actions
        Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              _buildSidebarAction(
                Icons.notifications_outlined,
                'Notifications',
                () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Notifications coming soon!')),
                  );
                },
              ),
              const SizedBox(height: 12),
              _buildSidebarAction(
                Icons.person_outline,
                'Profile',
                () => _navigateToProfile(context),
              ),
              const SizedBox(height: 12),
              _buildSidebarAction(
                Icons.logout_outlined,
                'Logout',
                () => context.read<AuthBloc>().add(LoggedOut()),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSidebarAction(
    IconData icon,
    String label,
    VoidCallback onPressed,
  ) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: PaintAppColors.surface.withOpacity(0.15),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: PaintAppColors.textInverse, size: 20),
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(
                color: PaintAppColors.textInverse,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopAppBar() {
    final screenWidth = MediaQuery.of(context).size.width;
    final searchBarWidth = (screenWidth * 0.25).clamp(
      200.0,
      400.0,
    ); // Responsive search bar
    final horizontalPadding = screenWidth * 0.02; // 2% of screen width
    final logoSize = screenWidth > 1400 ? 52.0 : 48.0; // Responsive logo size

    return SliverAppBar(
      expandedHeight: 80, // Reduced height to fix overflow
      floating: false,
      pinned: true,
      backgroundColor: PaintAppColors.surface,
      elevation: 2,
      automaticallyImplyLeading: false,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            color: PaintAppColors.surface,
            boxShadow: [
              BoxShadow(
                color: PaintAppColors.shadowLight,
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding.clamp(16.0, 48.0),
              vertical: 16, // Reduced vertical padding
            ),
            child: Row(
              children: [
                // App Logo
                Container(
                  width: logoSize,
                  height: logoSize,
                  decoration: BoxDecoration(
                    gradient: PaintAppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.palette,
                    size: logoSize * 0.5, // Proportional icon size
                    color: PaintAppColors.textInverse,
                  ),
                ),

                SizedBox(width: screenWidth * 0.01), // Responsive spacing

                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min, // Prevent overflow
                    children: [
                      Text(
                        'Color Swap',
                        style: TextStyle(
                          fontSize:
                              screenWidth > 1400
                                  ? 26
                                  : 22, // Responsive font size
                          fontWeight: FontWeight.bold,
                          color: PaintAppColors.textPrimary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        'Professional Paint Solutions',
                        style: TextStyle(
                          fontSize:
                              screenWidth > 1400
                                  ? 14
                                  : 12, // Responsive font size
                          color: PaintAppColors.textSecondary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // Search bar
                Container(
                  width: searchBarWidth,
                  height: 40, // Slightly reduced height
                  decoration: BoxDecoration(
                    color: PaintAppColors.backgroundSecondary,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: PaintAppColors.borderLight,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: searchBarWidth * 0.05,
                      ), // Responsive padding
                      Icon(
                        Icons.search,
                        color: PaintAppColors.textSecondary,
                        size: 18, // Slightly smaller icon
                      ),
                      SizedBox(
                        width: searchBarWidth * 0.04,
                      ), // Responsive spacing
                      Expanded(
                        child: Text(
                          'Search colors, products...',
                          style: TextStyle(
                            color: PaintAppColors.textSecondary,
                            fontSize: 14, // Slightly smaller font
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickStats() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: PaintAppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: PaintAppColors.shadowMedium,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.analytics_outlined,
                color: PaintAppColors.getUserTypeColor(_userType),
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                'Quick Stats',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: PaintAppColors.textPrimary,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          _buildQuickStatItem('Projects', '12', Icons.work_outline),
          const SizedBox(height: 16),
          _buildQuickStatItem('Colors Used', '24', Icons.palette_outlined),
          const SizedBox(height: 16),
          _buildQuickStatItem('Savings', '25%', Icons.savings_outlined),

          const SizedBox(height: 20),

          PaintAppButton(
            text: 'View Details',
            onPressed: () => _navigateToProfile(context),
            variant: PaintAppButtonVariant.outline,
            size: PaintAppButtonSize.small,
            isFullWidth: true,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStatItem(String label, String value, IconData icon) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: PaintAppColors.getUserTypeColor(_userType).withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: PaintAppColors.getUserTypeColor(_userType),
            size: 20,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: PaintAppColors.textPrimary,
                ),
              ),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: PaintAppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Navigation methods
  void _navigateToProfile(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (context) => BlocProvider(
              create:
                  (context) =>
                      ProfileBloc(userRepository: UserRepository())
                        ..add(LoadProfile()),
              child: const ProfileScreen(),
            ),
      ),
    );
  }

  void _navigateToColorSwap(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const ImageUploadScreen()));
  }

  void _navigateToProductCatalog(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VietnameseProductScreen.withBloc(),
      ),
    );
  }

  // Data methods
  List<Map<String, dynamic>> _getFeaturedColors() {
    return [
      {
        'name': 'Ocean Breeze',
        'code': '#87CEEB',
        'color': const Color(0xFF87CEEB),
      },
      {
        'name': 'Sunset Orange',
        'code': '#FFA500',
        'color': const Color(0xFFFFA500),
      },
      {
        'name': 'Forest Green',
        'code': '#228B22',
        'color': const Color(0xFF228B22),
      },
      {
        'name': 'Royal Purple',
        'code': '#663399',
        'color': const Color(0xFF663399),
      },
      {
        'name': 'Warm Cream',
        'code': '#FFF8DC',
        'color': const Color(0xFFFFF8DC),
      },
    ];
  }

  List<Map<String, dynamic>> _getFeatures() {
    return [
      {
        'title': 'Browse Products',
        'subtitle': 'Explore our premium paint catalog',
        'icon': Icons.palette,
        'color': PaintAppColors.paintTeal,
        'gradient': LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            PaintAppColors.paintTeal,
            PaintAppColors.lighten(PaintAppColors.paintTeal, 0.1),
          ],
        ),
        'onTap': () => _navigateToProductCatalog(context),
      },
      {
        'title': 'Color Swap',
        'subtitle': 'Visualize colors on your photos',
        'icon': Icons.camera_alt,
        'color': PaintAppColors.paintGreen,
        'gradient': LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            PaintAppColors.paintGreen,
            PaintAppColors.lighten(PaintAppColors.paintGreen, 0.1),
          ],
        ),
        'onTap': () => _navigateToColorSwap(context),
      },
      {
        'title': 'My Profile',
        'subtitle': 'Manage your account & preferences',
        'icon': Icons.person,
        'color': PaintAppColors.paintPurple,
        'gradient': LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            PaintAppColors.paintPurple,
            PaintAppColors.lighten(PaintAppColors.paintPurple, 0.1),
          ],
        ),
        'onTap': () => _navigateToProfile(context),
      },
      {
        'title': 'Color Trends',
        'subtitle': 'Discover trending colors',
        'icon': Icons.trending_up,
        'color': PaintAppColors.paintYellow,
        'gradient': LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            PaintAppColors.paintYellow,
            PaintAppColors.lighten(PaintAppColors.paintYellow, 0.1),
          ],
        ),
        'onTap': () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Color trends coming soon!')),
          );
        },
      },
    ];
  }

  List<Map<String, dynamic>> _getRoomTransformations() {
    return [
      {
        'name': 'Living Room Makeover',
        'description': 'From dull to vibrant with Ocean Breeze',
        'beforeColor': const Color(0xFFE5E5E5),
        'afterColor': const Color(0xFF87CEEB),
      },
      {
        'name': 'Bedroom Refresh',
        'description': 'Cozy transformation with Warm Cream',
        'beforeColor': const Color(0xFFDDDDDD),
        'afterColor': const Color(0xFFFFF8DC),
      },
      {
        'name': 'Kitchen Revival',
        'description': 'Modern update with Forest Green accent',
        'beforeColor': const Color(0xFFF0F0F0),
        'afterColor': const Color(0xFF228B22),
      },
    ];
  }

  String _getUserTypeLabel(String userType) {
    switch (userType) {
      case 'contractor':
        return 'Contractor';
      case 'homeowner':
        return 'Homeowner';
      case 'company':
        return 'Company';
      default:
        return 'Customer';
    }
  }

  IconData _getUserTypeIcon(String userType) {
    switch (userType) {
      case 'contractor':
        return Icons.construction;
      case 'homeowner':
        return Icons.home;
      case 'company':
        return Icons.business;
      default:
        return Icons.person;
    }
  }
}

/// Custom painter for animated home background
class HomeBackgroundPainter extends CustomPainter {
  final double animationValue;
  final String userType;

  HomeBackgroundPainter(this.animationValue, this.userType);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    final userColor = PaintAppColors.getUserTypeColor(userType);

    // Animated circles
    paint.color = userColor.withOpacity(0.1 * animationValue);
    canvas.drawCircle(
      Offset(size.width * 0.8, size.height * 0.3),
      50 + (animationValue * 20),
      paint,
    );

    paint.color = userColor.withOpacity(0.05 * (1 - animationValue));
    canvas.drawCircle(
      Offset(size.width * 0.2, size.height * 0.7),
      30 + (animationValue * 15),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// Custom painter for feature card backgrounds
class FeatureCardBackgroundPainter extends CustomPainter {
  final Color color;

  FeatureCardBackgroundPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Subtle pattern
    paint.color = color.withOpacity(0.1);

    final path = Path();
    path.moveTo(size.width * 0.7, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height * 0.3);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
