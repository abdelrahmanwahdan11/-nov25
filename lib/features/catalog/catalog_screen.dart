import 'package:flutter/material.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/widgets/skeleton.dart';
import '../../data/models/pet.dart';
import '../home/pet_controller.dart';
import '../home/home_discover_screen.dart';

class CatalogScreen extends StatefulWidget {
  final PetController petController;
  const CatalogScreen({super.key, required this.petController});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  final _scroll = ScrollController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    _scroll.addListener(() {
      if (_scroll.position.extentAfter < 200) {
        widget.petController.loadMorePets();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context).t;
    return Scaffold(
      appBar: AppBar(
        title: Text(t('catalog')),
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(context, '/pet/compare'),
            icon: const Icon(Icons.compare_arrows_rounded),
          )
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search pets',
                prefixIcon: const Icon(Icons.search),
              ),
              onChanged: (v) {
                setState(() => _query = v);
                widget.petController.searchPets(v);
              },
            ),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: widget.petController.refreshPets,
        child: StreamBuilder<List<Pet>>(
          stream: widget.petController.petsStream,
          builder: (context, snapshot) {
            if (widget.petController.isLoading) {
              return ListView.builder(
                itemCount: 5,
                itemBuilder: (_, __) => const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Skeleton(height: 120, width: double.infinity),
                ),
              );
            }
            final pets = snapshot.data ?? [];
            return ListView.builder(
              controller: _scroll,
              itemCount: pets.length + 1,
              itemBuilder: (_, i) {
                if (i == pets.length) {
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                final pet = pets[i];
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  leading: Hero(
                    tag: pet.id,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Image.network(pet.imageUrl, width: 70, height: 70, fit: BoxFit.cover),
                    ),
                  ),
                  title: Text(pet.name),
                  subtitle: Text('${pet.breed} · ${pet.ageYears}y'),
                  trailing: IconButton(
                    icon: Icon(pet.isFavorite ? Icons.favorite : Icons.favorite_border, color: pet.isFavorite ? Colors.red : null),
                    onPressed: () => widget.petController.toggleFavorite(pet),
                  ),
                  onTap: () => Navigator.pushNamed(context, '/pet/details', arguments: PetDetailsArgs(pet)),
                  onLongPress: () => widget.petController.selectForCompare(pet),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: StreamBuilder<List<Pet>>(
        stream: widget.petController.compareStream,
        builder: (context, snapshot) {
          final compare = snapshot.data ?? [];
          if (compare.length < 2) return const SizedBox.shrink();
          return FloatingActionButton.extended(
            onPressed: () => Navigator.pushNamed(context, '/pet/compare'),
            icon: const Icon(Icons.balance),
            label: Text('${t('compare')} (${compare.length})'),
          );
        },
      ),
    );
  }
}
