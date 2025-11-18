import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/widgets/skeleton.dart';
import '../../data/models/pet_supply.dart';
import 'supplies_controller.dart';

class SuppliesScreen extends StatefulWidget {
  final SuppliesController controller;
  const SuppliesScreen({super.key, required this.controller});

  @override
  State<SuppliesScreen> createState() => _SuppliesScreenState();
}

class _SuppliesScreenState extends State<SuppliesScreen> {
  @override
  void initState() {
    super.initState();
    widget.controller.load();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context).t;
    return Scaffold(
      appBar: AppBar(
        title: Text(t('supplies')), 
        actions: [
          IconButton(onPressed: widget.controller.load, icon: const Icon(Icons.refresh_rounded)),
        ],
      ),
      body: StreamBuilder<List<PetSupply>>(
        stream: widget.controller.suppliesStream,
        builder: (context, snapshot) {
          final items = snapshot.data ?? [];
          if (widget.controller.isLoading && items.isEmpty) {
            return GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.82,
              ),
              itemCount: 4,
              itemBuilder: (_, __) => const Skeleton(height: 200, width: double.infinity),
            );
          }
          return RefreshIndicator(
            onRefresh: widget.controller.load,
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.82,
              ),
              itemCount: items.length,
              itemBuilder: (_, index) => _SupplyCard(
                supply: items[index],
                onConsume: () => widget.controller.consume(items[index], amount: 2),
                onRestock: () => widget.controller.restock(items[index], amount: 5),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _SupplyCard extends StatelessWidget {
  final PetSupply supply;
  final VoidCallback onRestock;
  final VoidCallback onConsume;
  const _SupplyCard({required this.supply, required this.onRestock, required this.onConsume});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    final t = AppLocalizations.of(context).t;
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 14, offset: const Offset(0, 10))],
        border: Border.all(color: color.withOpacity(0.12)),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Image.network(supply.imageUrl, height: 90, width: double.infinity, fit: BoxFit.cover),
          ).animate().scale(duration: 450.ms, curve: Curves.easeOutBack),
          const SizedBox(height: 8),
          Text(supply.category, style: Theme.of(context).textTheme.labelSmall),
          Text(
            supply.name,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            maxLines: 2,
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(Icons.inventory_2_outlined, size: 16, color: color),
              const SizedBox(width: 6),
              Text('${supply.quantity} ${supply.unit}', style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
          const Spacer(),
          if (supply.lowStock)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(color: Colors.red.withOpacity(0.12), borderRadius: BorderRadius.circular(16)),
              child: Text(t('low_stock'), style: TextStyle(color: Colors.red.shade600)),
            ),
          const SizedBox(height: 8),
          Text(supply.note, maxLines: 2, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 8),
          Row(
            children: [
              IconButton(
                onPressed: onConsume,
                icon: const Icon(Icons.remove_circle_outline),
              ),
              IconButton(
                onPressed: onRestock,
                icon: const Icon(Icons.add_circle_rounded),
              ),
              const Spacer(),
              Icon(Icons.chevron_right, color: Theme.of(context).iconTheme.color)
            ],
          )
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).moveY(begin: 10, end: 0);
  }
}
