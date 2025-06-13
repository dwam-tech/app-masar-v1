enum PropertyType { villa, apartment, office }
enum PropertyState { forSale, forRent }
enum PropertyFinishState { standard, deluxe, superDeluxe }
enum PaymentMethod { cash, installment, mortgage }

class PropertyFeatures {
  final int buildYear;
  final int floor;
  final String view;
  final int bedrooms;
  final int bathrooms;
  final double length;
  final double width;

  PropertyFeatures({
    required this.buildYear,
    required this.floor,
    required this.view,
    required this.bedrooms,
    required this.bathrooms,
    required this.length,
    required this.width,
  });
}

class PropertyPriceInfo {
  final double price;
  final double downPayment;
  final double pricePerSquareMeter;
  final PaymentMethod paymentMethod;

  PropertyPriceInfo({
    required this.price,
    required this.downPayment,
    required this.pricePerSquareMeter,
    required this.paymentMethod,
  });
}

class PropertyIdentityInfo {
  final String externalImageUrl;
  final String internalImageUrl;
  final String description;

  PropertyIdentityInfo({
    required this.externalImageUrl,
    required this.internalImageUrl,
    required this.description,
  });
}

class Property {
  final String id;
  final String address;
  final String number;
  final PropertyType type;
  final PropertyState state;
  final PropertyFinishState finishState;
  final PropertyFeatures features;
  final PropertyPriceInfo priceInfo;
  final PropertyIdentityInfo identityInfo;

  Property({
    required this.id,
    required this.address,
    required this.number,
    required this.type,
    required this.state,
    required this.finishState,
    required this.features,
    required this.priceInfo,
    required this.identityInfo,
  });
}