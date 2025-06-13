import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saba2v2/components/UI/section_title.dart';
import 'package:saba2v2/providers/real_estate_provider.dart';
import 'property.dart';

class PropertyDetailsScreen extends StatelessWidget {
  final String propertyId;

  const PropertyDetailsScreen({super.key, required this.propertyId});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RealEstateProvider>(context, listen: false);
    final property = provider.getPropertyById(propertyId);

    if (property == null) {
      return const Scaffold(
        body: Center(child: Text('العقار غير موجود')),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          property.address,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // الصور
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.white,
              ),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    child: Image.network(
                      property.identityInfo.externalImageUrl,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
                    child: Image.network(
                      property.identityInfo.internalImageUrl,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _buildDetailsCard('تفاصيل العقار', [
              _buildInfoRow('النوع', _getPropertyTypeString(property.type)),
              _buildInfoRow('الحالة', _getPropertyStateString(property.state)),
              _buildInfoRow('التشطيب', _getPropertyFinishStateString(property.finishState)),
              _buildInfoRow('الرقم', property.number),
            ]),
            const SizedBox(height: 16),
            _buildDetailsCard('المواصفات', [
              _buildInfoRow('سنة البناء', property.features.buildYear.toString()),
              _buildInfoRow('الدور', property.features.floor.toString()),
              _buildInfoRow('الإطلالة', property.features.view),
              _buildInfoRow('عدد الغرف', property.features.bedrooms.toString()),
              _buildInfoRow('عدد الحمامات', property.features.bathrooms.toString()),
              _buildInfoRow('الطول', '${property.features.length.toStringAsFixed(1)} م'),
              _buildInfoRow('العرض', '${property.features.width.toStringAsFixed(1)} م'),
            ]),
            const SizedBox(height: 16),
            _buildDetailsCard('معلومات السعر', [
              _buildInfoRow('السعر', '${property.priceInfo.price.toStringAsFixed(0)} ج.م'),
              _buildInfoRow('المقدم', '${property.priceInfo.downPayment.toStringAsFixed(0)} ج.م'),
              _buildInfoRow('سعر المتر', '${property.priceInfo.pricePerSquareMeter.toStringAsFixed(0)} ج.م'),
              _buildInfoRow('طريقة الدفع', _getPaymentMethodString(property.priceInfo.paymentMethod)),
            ]),
            const SizedBox(height: 16),
            _buildDetailsCard('الوصف', [
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  property.identityInfo.description,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  textAlign: TextAlign.right,
                ),
              ),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsCard(String title, List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SectionTitle(title: title),
          const SizedBox(height: 8),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  String _getPropertyTypeString(PropertyType type) {
    switch (type) {
      case PropertyType.villa:
        return 'فيلا';
      case PropertyType.apartment:
        return 'شقة';
      case PropertyType.office:
        return 'مكتب إداري';
    }
  }

  String _getPropertyStateString(PropertyState state) {
    switch (state) {
      case PropertyState.forSale:
        return 'جاهز للبيع';
      case PropertyState.forRent:
        return 'جاهز للإيجار';
    }
  }

  String _getPropertyFinishStateString(PropertyFinishState finishState) {
    switch (finishState) {
      case PropertyFinishState.standard:
        return 'جديد';
      case PropertyFinishState.deluxe:
        return 'لوكس';
      case PropertyFinishState.superDeluxe:
        return 'سوبر لوكس';
    }
  }

  String _getPaymentMethodString(PaymentMethod method) {
    switch (method) {
      case PaymentMethod.cash:
        return 'كاش';
      case PaymentMethod.installment:
        return 'تقسيط';
      case PaymentMethod.mortgage:
        return 'تمويل عقاري';
    }
  }
}