import 'package:flutter/material.dart';
import '../../core/theme/paint_app_colors.dart';
import '../../core/widgets/paint_app_button.dart';

class HomeUserDashboard extends StatelessWidget {
  final String userType;
  final VoidCallback onNavigateToProductCatalog;
  final VoidCallback onNavigateToColorSwap;

  const HomeUserDashboard({
    super.key,
    required this.userType,
    required this.onNavigateToProductCatalog,
    required this.onNavigateToColorSwap,
  });

  @override
  Widget build(BuildContext context) {
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
                _getUserTypeIcon(userType),
                color: PaintAppColors.getUserTypeColor(userType),
                size: screenWidth > 1200 ? 26 : 24,
              ),
              SizedBox(width: screenWidth * 0.015), // Responsive spacing
              Text(
                '${_getUserTypeLabel(userType)} Dashboard',
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
          _buildUserTypeContent(context),
        ],
      ),
    );
  }

  Widget _buildUserTypeContent(BuildContext context) {
    switch (userType) {
      case 'contractor':
        return _buildContractorDashboard(context);
      case 'company':
        return _buildCompanyDashboard(context);
      case 'homeowner':
        return _buildHomeownerDashboard(context);
      default:
        return _buildRegularUserDashboard(context);
    }
  }

  Widget _buildContractorDashboard(BuildContext context) {
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
          onPressed: onNavigateToProductCatalog,
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

  Widget _buildCompanyDashboard(BuildContext context) {
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

  Widget _buildHomeownerDashboard(BuildContext context) {
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

  Widget _buildRegularUserDashboard(BuildContext context) {
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
          onPressed: onNavigateToColorSwap,
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
            color: PaintAppColors.getUserTypeColor(userType),
            size: 24,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: PaintAppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: PaintAppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
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
