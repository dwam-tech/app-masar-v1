import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:saba2v2/components/UI/section_title.dart';
import 'package:saba2v2/providers/service_category_provider.dart';
import 'package:saba2v2/providers/restaurant_provider.dart';
import 'package:saba2v2/providers/real_estate_provider.dart';
import 'package:saba2v2/widgets/service_card.dart';
import 'package:saba2v2/widgets/restaurant_card.dart';
import 'package:saba2v2/widgets/real_estate_card.dart';

class UserHomeScreen extends StatelessWidget {
  const UserHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الرئيسية'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () => context.go('/notifications'),
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => context.go('/profile'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // شريط البحث
              TextField(
                decoration: InputDecoration(
                  hintText: 'ابحث عن الخدمات أو المنتجات...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              // بانر ترويجي (Slider)
              // Consumer<BannerProvider>(
              //   builder: (context, provider, child) {
              //     return CarouselSlider(
              //       options: CarouselOptions(
              //         height: 150.0,
              //         autoPlay: true,
              //         autoPlayInterval: const Duration(seconds: 3),
              //         enlargeCenterPage: true,
              //         aspectRatio: 16 / 9,
              //         viewportFraction: 0.9,
              //       ),
              //       items: provider.banners.map((bannerUrl) {
              //         return Builder(
              //           builder: (BuildContext context) {
              //             return BannerWidget(
              //               imageUrl: bannerUrl,
              //               title: 'اطلب الآن',
              //               subtitle: 'احصل على أفضل العروض اليوم!',
              //             );
              //           },
              //         );
              //       }).toList(),
              //     );
              //   },
              // ),
              const SizedBox(height: 16.0),
              // أنواع الخدمات
              SizedBox( width: double.infinity, child: const SectionTitle(title: "اختر الخدمة التي تريد")),

              const SizedBox(height: 8.0),
              Consumer<ServiceCategoryProvider>(
                builder: (context, provider, child) {
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, // 3 خدمات في كل سطر
                      crossAxisSpacing: 8.0, // المسافة بين الأعمدة
                      mainAxisSpacing: 8.0, // المسافة بين الصفوف
                      childAspectRatio: 1, // نسبة العرض للارتفاع لكل Card
                    ),
                    itemCount: provider.categories.length,
                    itemBuilder: (context, index) {
                      final category = provider.categories[index];
                      return ServiceCard(
                        imageUrl: category.imageUrl,
                        title: category.title,
                        onTap: () {
                          // توجيه حسب نوع الخدمة
                          if (category.title == 'توصيل') {
                            context.go('/delivery');
                          }
                          if (category.title == 'مطاعم') {
                            context.go('/restaurant-home');
                          }
                          if (category.title == 'عقارات') {
                            context.go('/real-state-home');
                          }
                        },
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 16.0),
              // مطاعم موصى بها
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {},
                    child:const Row(
                      children: [
                        Icon(Icons.arrow_back_ios,color: Colors.orange,size: 18.0,),
                        Text(
                          'المزيد',
                          style: TextStyle(color: Colors.orange),
                        ),
                      ],
                    )
                  ),
                  const Expanded(child: SectionTitle(title: "افضل المطاعم")),
                ],
              ),
              const SizedBox(height: 8.0),
              Consumer<RestaurantProvider>(
                builder: (context, provider, child) {
                  return Column(
                    children: provider.recommendedRestaurants.map((restaurant) {
                      return RestaurantCard(
                        id: restaurant.id,
                        imageUrl: restaurant.imageUrl,
                        name: restaurant.name,
                        category: restaurant.category,
                        location: restaurant.location,
                        onTap: () =>
                            context.go('/restaurant-details/${restaurant.id}'),
                      );
                    }).toList(),
                  );
                },
              ),
              const SizedBox(height: 16.0),
              // عقارات موصى بها
              const Text(
                'عقارات موصى بها',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              // Consumer<RealEstateProvider>(
              //   builder: (context, provider, child) {
              //     return Column(
              //       children: provider.recommendedRealEstates.map((realEstate) {
              //         return RealEstateCard(
              //           imageUrl: realEstate.imageUrl,
              //           title: realEstate.title,
              //           price: realEstate.price,
              //           rating: realEstate.rating,
              //           onTap: () =>
              //               context.go('/real-estate-details/${realEstate.id}'),
              //         );
              //       }).toList(),
              //     );
              //   },
              // ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'الرئيسية'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'المفضلة'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'الحساب'),
        ],
        currentIndex: 0,
        selectedItemColor: Colors.orange,
        onTap: (index) {
          if (index == 1) context.go('/favorites');
          if (index == 2) context.go('/profile');
        },
      ),
    );
  }
}
