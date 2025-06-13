import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:saba2v2/models/order_model.dart';
import 'package:go_router/go_router.dart';
import 'package:saba2v2/widgets/notification_badge.dart';
import 'package:saba2v2/widgets/restaurant_availability_switch.dart';
import 'package:saba2v2/widgets/order_card.dart';
import 'package:saba2v2/screens/business/ResturantScreens/order_details_screen.dart';

class ResturantHomeScreen extends StatefulWidget {
  const ResturantHomeScreen({super.key});

  @override
  State<ResturantHomeScreen> createState() => _ResturantHomeScreenState();
}

class _ResturantHomeScreenState extends State<ResturantHomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isAvailableForOrders = true;
  
  // بيانات تجريبية للطلبات
  List<OrderModel> _orders = [];
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadOrders();
    
    // إضافة مستمع للتغييرات في التبويب المحدد
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {});
      }
    });
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  
  // تحميل بيانات الطلبات (محاكاة لجلب البيانات من الخادم)
  void _loadOrders() {
    // هنا سيتم استبدال هذا بطلب API حقيقي
    _orders = [
      // طلبات قيد الانتظار
      OrderModel(
        id: "377",
        customerName: "كريم محمد",
        customerImage: "assets/images/user_avatar.jpg",
        orderTime: DateTime.now().subtract(const Duration(minutes: 15)),
        totalAmount: 2800,
        status: "قيد الانتظار",
        items: [
          OrderItem(
            name: "بيتزا مشروم 2x",
            image: "assets/images/pizza.jpg",
            price: 1800,
            quantity: 2,
          ),
          OrderItem(
            name: "بيتزا بيبروني 2x",
            image: "assets/images/pizza.jpg",
            price: 1000,
            quantity: 2,
          ),
        ],
      ),
      OrderModel(
        id: "376",
        customerName: "أحمد علي",
        customerImage: "assets/images/user_avatar.jpg",
        orderTime: DateTime.now().subtract(const Duration(minutes: 30)),
        totalAmount: 1500,
        status: "قيد الانتظار",
        items: [
          OrderItem(
            name: "برجر لحم",
            image: "assets/images/burger.png",
            price: 1500,
            quantity: 1,
          ),
        ],
      ),
      OrderModel(
        id: "375",
        customerName: "سارة أحمد",
        customerImage: "assets/images/user_avatar.jpg",
        orderTime: DateTime.now().subtract(const Duration(minutes: 45)),
        totalAmount: 3200,
        status: "قيد الانتظار",
        items: [
          OrderItem(
            name: "دجاج مشوي",
            image: "assets/images/chicken.jpg",
            price: 2200,
            quantity: 1,
          ),
          OrderItem(
            name: "سلطة خضراء",
            image: "assets/images/salad.jpg",
            price: 500,
            quantity: 1,
          ),
          OrderItem(
            name: "عصير برتقال",
            image: "assets/images/juice.jpg",
            price: 500,
            quantity: 1,
          ),
        ],
      ),
      
      // طلبات قيد التنفيذ
      OrderModel(
        id: "374",
        customerName: "محمد حسن",
        customerImage: "assets/images/user_avatar.jpg",
        orderTime: DateTime.now().subtract(const Duration(hours: 1)),
        totalAmount: 4500,
        status: "قيد التنفيذ",
        items: [
          OrderItem(
            name: "مشاوي مشكلة",
            image: "assets/images/grill.jpg",
            price: 3500,
            quantity: 1,
          ),
          OrderItem(
            name: "أرز بخاري",
            image: "assets/images/rice.jpg",
            price: 1000,
            quantity: 1,
          ),
        ],
      ),
      OrderModel(
        id: "373",
        customerName: "فاطمة محمود",
        customerImage: "assets/images/user_avatar.jpg",
        orderTime: DateTime.now().subtract(const Duration(hours: 1, minutes: 15)),
        totalAmount: 2000,
        status: "قيد التنفيذ",
        items: [
          OrderItem(
            name: "كريب دجاج",
            image: "assets/images/crepe.jpg",
            price: 1200,
            quantity: 1,
          ),
          OrderItem(
            name: "كريب لحم",
            image: "assets/images/crepe.jpg",
            price: 800,
            quantity: 1,
          ),
        ],
      ),
      
      // طلبات منتهية
      OrderModel(
        id: "372",
        customerName: "عمر خالد",
        customerImage: "assets/images/user_avatar.jpg",
        orderTime: DateTime.now().subtract(const Duration(hours: 3)),
        totalAmount: 1800,
        status: "منتهية",
        items: [
          OrderItem(
            name: "شاورما دجاج",
            image: "assets/images/shawarma.jpg",
            price: 1200,
            quantity: 1,
          ),
          OrderItem(
            name: "بطاطس",
            image: "assets/images/fries.jpg",
            price: 600,
            quantity: 1,
          ),
        ],
      ),
      OrderModel(
        id: "371",
        customerName: "ليلى سعيد",
        customerImage: "assets/images/user_avatar.jpg",
        orderTime: DateTime.now().subtract(const Duration(hours: 4)),
        totalAmount: 3500,
        status: "منتهية",
        items: [
          OrderItem(
            name: "بيتزا سوبريم",
            image: "assets/images/pizza.jpg",
            price: 2500,
            quantity: 1,
          ),
          OrderItem(
            name: "كوكا كولا",
            image: "assets/images/coke.jpg",
            price: 500,
            quantity: 2,
          ),
        ],
      ),
      OrderModel(
        id: "370",
        customerName: "يوسف أحمد",
        customerImage: "assets/images/user_avatar.jpg",
        orderTime: DateTime.now().subtract(const Duration(hours: 5)),
        totalAmount: 2700,
        status: "منتهية",
        items: [
          OrderItem(
            name: "برجر دجاج",
            image: "assets/images/burger.png",
            price: 1200,
            quantity: 1,
          ),
          OrderItem(
            name: "برجر لحم",
            image: "assets/images/burger.png",
            price: 1500,
            quantity: 1,
          ),
        ],
      ),
    ];
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }
  
  // بناء شريط التطبيق
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text(
        "الرئيسية",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 0,
      actions: [
        Stack(
          alignment: Alignment.topRight,
          children: [
            IconButton(
              icon: const Icon(Icons.message_outlined),
              onPressed: () {
                // التنقل إلى صفحة الرسائل
              },
            ),
            const NotificationBadge(count: "5"),
          ],
        ),
        Stack(
          alignment: Alignment.topRight,
          children: [
            IconButton(
              icon: const Icon(Icons.notifications_outlined),
              onPressed: () {
                context.push("/NotificationsScreen");
              },
            ),
            const NotificationBadge(count: "3"),
          ],
        ),
      ],
    );
  }
  
  // بناء محتوى الشاشة
  Widget _buildBody() {
    return Column(
      children: [
        // مفتاح تبديل حالة المطعم
        RestaurantAvailabilitySwitch(
          isAvailable: _isAvailableForOrders,
          onChanged: (value) {
            setState(() {
              _isAvailableForOrders = value;
            });
          },
        ),
        
        // شريط التبويب
        _buildTabBar(),
        
        // محتوى التبويب
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              // قائمة الطلبات قيد الانتظار
              _buildOrdersList(
                _orders.where((order) => order.status == "قيد الانتظار").toList()
              ),
              
              // قائمة الطلبات قيد التنفيذ
              _buildOrdersList(
                _orders.where((order) => order.status == "قيد التنفيذ").toList()
              ),
              
              // قائمة الطلبات المنتهية
              _buildOrdersList(
                _orders.where((order) => order.status == "منتهية").toList()
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  // بناء شريط التبويب
  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Colors.grey,
            width: 0.5,
          ),
        ),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.orange,
              width: 3.0,
            ),
          ),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: Colors.orange,
        unselectedLabelColor: Colors.grey,
        labelStyle: const TextStyle(fontWeight: FontWeight.bold),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
        tabs: [
          Tab(
            child: Container(
              decoration: BoxDecoration(
                color: _tabController.index == 0 ? Colors.orange.withOpacity(0.1) : Colors.transparent,
                borderRadius: BorderRadius.circular(4),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: const Text("قيد الانتظار"),
            ),
          ),
          Tab(
            child: Container(
              decoration: BoxDecoration(
                color: _tabController.index == 1 ? Colors.orange.withOpacity(0.1) : Colors.transparent,
                borderRadius: BorderRadius.circular(4),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: const Text("قيد التنفيذ"),
            ),
          ),
          Tab(
            child: Container(
              decoration: BoxDecoration(
                color: _tabController.index == 2 ? Colors.orange.withOpacity(0.1) : Colors.transparent,
                borderRadius: BorderRadius.circular(4),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: const Text("منتهية"),
            ),
          ),
        ],
      ),
    );
  }
  
  // بناء شريط التنقل السفلي
  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: 0,
      selectedItemColor: Colors.orange,
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: "الرئيسية",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today),
          label: "القائمة",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.bar_chart),
          label: "الإحصائيات",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.menu),
          label: "المزيد",
        ),
      ],
    );
  }
  
  // بناء قائمة الطلبات
  Widget _buildOrdersList(List<OrderModel> orders) {
    if (orders.isEmpty) {
      return const Center(
        child: Text(
          "لا توجد طلبات",
          style: TextStyle(fontSize: 16),
        ),
      );
    }
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return OrderCard(
          order: order,
          onViewDetails: _showOrderDetails,
        );
      },
    );
  }
  
  // عرض تفاصيل الطلب
  void _showOrderDetails(OrderModel order) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrderDetailsScreen(order: order),
      ),
    );
  }
}