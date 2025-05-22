import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:carousel_slider/carousel_slider.dart';


import 'NavigationsBar.dart';
import 'Product_card.dart';
import 'clothing_categories_screen.dart';
import 'profile_screen.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});


  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CarouselSliderController _controller = CarouselSliderController();
  late final PageController _pageController;
  int _currentImageIndex = 0;
  int  _currentIndex =0;
  String query = '';
  String? selectedGender;
  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  final List<String> sliderImages = [
    'assets/images/home_bild1.jpg',
    'assets/images/home_bild2.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: TextField(
          onChanged: (value) => setState(() => query = value),
          decoration: InputDecoration(
            hintText: 'Search...',
            prefixIcon: Icon(Iconsax.search_normal_copy, color: Colors.brown),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(color: Colors.brown, width: 1),
            ),

            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.brown, width: 1.4),
              borderRadius: BorderRadius.circular(40),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
      ),
      body: ListView(
          padding: const EdgeInsets.only(top: 16),
          children: [
            CarouselSlider(
              options: CarouselOptions(
                height: 150,
                autoPlay: false,                 // automatisches Scrollen
                autoPlayInterval: const Duration(seconds: 5),
                enlargeCenterPage: true,
                viewportFraction: 0.9,
                onPageChanged: (idx, _) {
                  setState(() => _currentImageIndex = idx);
                },
              ),
            items: sliderImages.map((path) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    path,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
              );
            }).toList(),
          ),

          //kleine Indikatoren unter dem Slider
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: sliderImages.asMap().entries.map((entry) {
              return Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentImageIndex == entry.key
                      ? Colors.brown
                      : Colors.grey.shade300,
                ),
              );
            }).toList(),
          ),

          const Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 0, 8),
            child: Text(
              'Category',
              style: TextStyle(fontSize: 24, color: Colors.black),
            ),
          ),

          const BuildCategory(), // <-- hier die Kategorien-Leiste
          Padding(
            padding: const EdgeInsets.all(12),
            child: GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.75,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: const [
                ProductCard(),
                ProductCard(),
                ProductCard(),
                ProductCard(),
                ProductCard(),
                ProductCard(),
              ],
            ),
          ),
        ],
      ),

      bottomNavigationBar: NavigationsBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (idx) => setState(() => _currentIndex = idx),
       // onTap: (idx) => currentIndex = idx,

      ),

    );
  }
}
