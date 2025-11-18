import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

class SoftBottomNav extends StatelessWidget {
  final int index;
  final ValueChanged<int> onChanged;
  const SoftBottomNav({super.key, required this.index, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: theme.brightness == Brightness.dark
              ? const Color(0xFF000000)
              : const Color(0xFF262424),
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 20,
              offset: const Offset(0, 12),
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildItem(icon: IconlyBold.home, selected: index == 0, onTap: () => onChanged(0), theme: theme),
            _buildItem(icon: IconlyBold.search, selected: index == 1, onTap: () => onChanged(1), theme: theme),
            _buildItem(icon: IconlyBold.profile, selected: index == 2, onTap: () => onChanged(2), theme: theme),
          ],
        ),
      ),
    );
  }

  Widget _buildItem({
    required IconData icon,
    required bool selected,
    required VoidCallback onTap,
    required ThemeData theme,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? theme.primaryColor.withOpacity(0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Icon(icon, color: selected ? theme.primaryColor : theme.iconTheme.color),
      ),
    );
  }
}
