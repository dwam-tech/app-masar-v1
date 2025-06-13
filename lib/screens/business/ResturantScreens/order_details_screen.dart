import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:saba2v2/models/order_model.dart';
import 'package:saba2v2/widgets/order_item_card.dart';
import 'package:saba2v2/widgets/status_badge.dart';
import 'dart:ui' as ui; // Explicit import for TextDirection

// AppTheme class for consistent theming
class AppTheme {
  static ThemeData get theme => ThemeData(
        primaryColor: const Color(0xFFFF6D00),
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.orange,
          accentColor: const Color(0xFFFF8A00),
          backgroundColor: Colors.white,
        ),
        scaffoldBackgroundColor: Colors.white,
        textTheme: const TextTheme(
          headlineMedium: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          bodyMedium: TextStyle(fontSize: 14),
          labelMedium: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFF6D00),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            elevation: 2,
          ),
        ),
      );

  static Color getStatusColor(String status) {
    switch (status) {
      case "قيد الانتظار":
        return Colors.orange;
      case "قيد التنفيذ":
        return Colors.blue;
      case "منتهية":
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}

// AnimatedScaleButton with nullable onPressed
class AnimatedScaleButton extends StatefulWidget {
  final VoidCallback? onPressed; // Nullable
  final Widget child;

  const AnimatedScaleButton({super.key, this.onPressed, required this.child});

  @override
  _AnimatedScaleButtonState createState() => _AnimatedScaleButtonState();
}

class _AnimatedScaleButtonState extends State<AnimatedScaleButton> {
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: widget.onPressed != null ? (_) => setState(() => _scale = 0.95) : null,
      onTapUp: widget.onPressed != null
          ? (_) {
              setState(() => _scale = 1.0);
              widget.onPressed!();
            }
          : null,
      onTapCancel: widget.onPressed != null ? () => setState(() => _scale = 1.0) : null,
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 100),
        child: ElevatedButton(
          onPressed: widget.onPressed,
          child: widget.child,
        ),
      ),
    );
  }
}

class OrderDetailsScreen extends StatefulWidget {
  final OrderModel order;

  const OrderDetailsScreen({super.key, required this.order});

  @override
  _OrderDetailsScreenState createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  bool _isExecuting = false;

  void _executeOrder() async {
    setState(() => _isExecuting = true);
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("فشل تنفيذ الطلب: $e")),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isExecuting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.theme,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("تفاصيل الطلب"),
          centerTitle: true,
          elevation: 1,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Directionality(
          textDirection: ui.TextDirection.rtl, // Corrected to lowercase rtl
          child: Column(
            children: [
              _buildOrderInfo(),
              _buildItemsHeader(),
              Expanded(child: _buildItemsList()),
              _buildTotalSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            spreadRadius: 2,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Row(
                  children: [
                    const Icon(Icons.access_time, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Semantics(
                        label: "وقت الطلب",
                        child: Text(
                          DateFormat('dd/MM/yyyy - hh:mm a').format(widget.order.orderTime),
                          style: Theme.of(context).textTheme.labelMedium,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              StatusBadge(
                status: widget.order.status,
                color: AppTheme.getStatusColor(widget.order.status),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Semantics(
                  label: "رقم الطلب",
                  child: Text(
                    "رقم الطلب: #${widget.order.id}",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              Flexible(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () {
                        // Retry loading image (placeholder for future implementation)
                      },
                      child: CircleAvatar(
                        radius: 16,
                        backgroundImage: AssetImage(widget.order.customerImage),
                        onBackgroundImageError: (exception, stackTrace) {
                          debugPrint("Failed to load image: $exception");
                        },
                        child: const Icon(Icons.person, size: 16, color: Colors.grey),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Semantics(
                        label: "اسم العميل",
                        child: Text(
                          widget.order.customerName,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildItemsHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          Text(
            "عناصر الطلب",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
          ),
          const SizedBox(width: 8),
          Text(
            "(${widget.order.items.length})",
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  fontSize: 14,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemsList() {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      cacheExtent: 1000,
      itemCount: widget.order.items.length,
      itemBuilder: (context, index) {
        final item = widget.order.items[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: OrderItemCard(item: item),
        );
      },
    );
  }

  Widget _buildTotalSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white,
            Colors.grey[50]!,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            spreadRadius: 2,
            blurRadius: 6,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AnimatedScaleButton(
            onPressed: _isExecuting ? null : _executeOrder,
            child: _isExecuting
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                    ),
                  )
                : const Row(
                    children: [
                      Icon(Icons.check_circle_outline),
                      SizedBox(width: 8),
                      Text("تنفيذ الطلب"),
                    ],
                  ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "الإجمالي",
                style: Theme.of(context).textTheme.labelMedium,
              ),
              Semantics(
                label: "الإجمالي",
                child: Text(
                  "${widget.order.totalAmount.toStringAsFixed(0)} ج.م",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Theme.of(context).primaryColor,
                      ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}