import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pizza_app/components/cart_app_bar_action.dart';
import 'package:pizza_app/components/menu_item_card.dart';
import 'package:pizza_app/screens/auth/blocs/sing_in_bloc/sing_in_bloc.dart';
import 'package:pizza_app/screens/cart/blocs/cart_bloc.dart';
import 'package:pizza_app/screens/cart/views/cart_screen.dart';
import 'package:pizza_app/screens/category/views/category_screen.dart';
import 'package:pizza_app/screens/home/blocs/get_pizza_bloc/get_pizza_bloc.dart';
import 'package:pizza_repository/pizza_repository.dart';

class LandingScreen extends StatefulWidget {
  final String initialCategory;
  const LandingScreen({this.initialCategory = 'All', super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  late String _selectedCategory;

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.initialCategory;
  }

  static const _categories = [
    ('All', '🍽️'),
    ('pizza', '🍕'),
    ('beverage', '🥤'),
    ('starter', '🥗'),
    ('dessert', '🍰'),
  ];

  static const _categoryLabels = {
    'pizza': 'Pizzas',
    'beverage': 'Beverages',
    'starter': 'Starters',
    'dessert': 'Desserts',
  };

  void _goToCart(BuildContext context) {
    final cartBloc = context.read<CartBloc>();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            BlocProvider.value(value: cartBloc, child: const CartScreen()),
      ),
    );
  }

  void _goToCategory(
      BuildContext context, String category, List<Pizza> items) {
    final cartBloc = context.read<CartBloc>();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: cartBloc,
          child: CategoryScreen(
            categoryName: _categoryLabels[category] ?? category,
            items: items,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Row(
          children: [
            Image.asset('assets/8.png', scale: 14),
            const SizedBox(width: 5),
            const Text(
              'MENU',
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 30),
            ),
          ],
        ),
        actions: [
          CartAppBarAction(onPressed: () => _goToCart(context)),
          IconButton(
            onPressed: () =>
                context.read<SingInBloc>().add(SingOutRequired()),
            icon: const Icon(CupertinoIcons.square_arrow_right),
          ),
        ],
      ),
      body: BlocBuilder<GetPizzaBloc, GetPizzaState>(
        builder: (context, state) {
          if (state is GetPizzaLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is GetPizzaFailure) {
            return const Center(child: Text('Failed to load menu.'));
          }
          if (state is! GetPizzaSuccess) return const SizedBox();

          final allItems = state.pizzas;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Category chips
              SizedBox(
                height: 52,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: _categories.map((cat) {
                    final key = cat.$1;
                    final emoji = cat.$2;
                    final label =
                        key == 'All' ? 'All' : (_categoryLabels[key] ?? key);
                    final selected = _selectedCategory == key;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text('$emoji  $label'),
                        selected: selected,
                        onSelected: (_) =>
                            setState(() => _selectedCategory = key),
                        selectedColor:
                            Theme.of(context).colorScheme.primary,
                        labelStyle: TextStyle(
                          color: selected ? Colors.white : Colors.black87,
                          fontWeight: FontWeight.w600,
                        ),
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(color: Colors.grey.shade300),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 8),

              // Content
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: _selectedCategory == 'All'
                      ? _AllSectionsView(
                          key: const ValueKey('all'),
                          allItems: allItems,
                          categoryLabels: _categoryLabels,
                          onSeeAll: (cat, items) =>
                              _goToCategory(context, cat, items),
                        )
                      : _FilteredGridView(
                          key: ValueKey(_selectedCategory),
                          items: allItems
                              .where((p) =>
                                  p.category == _selectedCategory)
                              .toList(),
                        ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ---------- All Sections (Landing "home") ----------

class _AllSectionsView extends StatelessWidget {
  final List<Pizza> allItems;
  final Map<String, String> categoryLabels;
  final void Function(String category, List<Pizza> items) onSeeAll;

  const _AllSectionsView({
    required this.allItems,
    required this.categoryLabels,
    required this.onSeeAll,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(bottom: 24),
      children: categoryLabels.entries.map((entry) {
        final items =
            allItems.where((p) => p.category == entry.key).toList();
        return _CategorySection(
          title: entry.value,
          items: items,
          onSeeAll: () => onSeeAll(entry.key, items),
        );
      }).toList(),
    );
  }
}

// ---------- Single Category Section ----------

class _CategorySection extends StatelessWidget {
  final String title;
  final List<Pizza> items;
  final VoidCallback onSeeAll;

  const _CategorySection({
    required this.title,
    required this.items,
    required this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 8, 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: onSeeAll,
                child: const Text('See All →'),
              ),
            ],
          ),
        ),
        if (items.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text('Coming soon!',
                style: TextStyle(color: Colors.grey.shade500)),
          )
        else
          SizedBox(
            height: 266,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, i) =>
                  MenuItemCard(pizza: items[i], isCompact: true),
            ),
          ),
        const SizedBox(height: 8),
      ],
    );
  }
}

// ---------- Filtered Grid ----------

class _FilteredGridView extends StatelessWidget {
  final List<Pizza> items;

  const _FilteredGridView({required this.items, super.key});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Center(
        child: Text('No items here yet.',
            style: TextStyle(color: Colors.grey.shade500)),
      );
    }
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 13,
          mainAxisSpacing: 16,
          childAspectRatio: 9 / 16),
      itemCount: items.length,
      itemBuilder: (context, i) => MenuItemCard(pizza: items[i]),
    );
  }
}
