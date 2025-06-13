import 'dart:math';
import 'package:flutter/material.dart';
import 'package:saba2v2/screens/business/RealStateScreens/property.dart';

class RealEstateProvider with ChangeNotifier {
  final List<Property> _properties = [];
  final Random _random = Random();

  RealEstateProvider() {
    _generateMockProperties();
  }

  List<Property> get properties => _properties;

  void _generateMockProperties() {
    const addresses = ['التجمع الخامس', 'مدينة نصر', 'الشيخ زايد', '6 أكتوبر'];
    const types = [PropertyType.villa, PropertyType.apartment, PropertyType.office];
    const states = [PropertyState.forSale, PropertyState.forRent];
    const finishStates = [PropertyFinishState.standard, PropertyFinishState.deluxe, PropertyFinishState.superDeluxe];
    const paymentMethods = [PaymentMethod.cash, PaymentMethod.installment, PaymentMethod.mortgage];
    const views = ['شارع رئيسي', 'حديقة', 'نيل'];

    for (int i = 0; i < 10; i++) {
      _properties.add(
        Property(
          id: 'prop_$i',
          address: addresses[_random.nextInt(addresses.length)],
          number: 'الدور ${_random.nextInt(10) + 1}',
          type: types[_random.nextInt(types.length)],
          state: states[_random.nextInt(states.length)],
          finishState: finishStates[_random.nextInt(finishStates.length)],
          features: PropertyFeatures(
            buildYear: 2015 + _random.nextInt(10),
            floor: _random.nextInt(10) + 1,
            view: views[_random.nextInt(views.length)],
            bedrooms: 2 + _random.nextInt(3),
            bathrooms: 1 + _random.nextInt(3),
            length: 50 + _random.nextDouble() * 100,
            width: 10 + _random.nextDouble() * 20,
          ),
          priceInfo: PropertyPriceInfo(
            price: 100000 + _random.nextDouble() * 1000000,
            downPayment: 5000 + _random.nextDouble() * 50000,
            pricePerSquareMeter: 800 + _random.nextDouble() * 2000,
            paymentMethod: paymentMethods[_random.nextInt(paymentMethods.length)],
          ),
          identityInfo: PropertyIdentityInfo(
            externalImageUrl: 'https://via.placeholder.com/300x200?text=External+$i',
            internalImageUrl: 'https://via.placeholder.com/300x200?text=Internal+$i',
            description: 'عقار مميز في موقع متميز مع تشطيبات عالية الجودة.',
          ),
        ),
      );
    }
    notifyListeners();
  }

  Property? getPropertyById(String id) {
    return _properties.firstWhere((property) => property.id == id, orElse: () => null as Property);
  }
}