enum BannersAction {
  initial,
  url,
  mainCategory,
  brand,
  service,
  transaction,
  coupon,
  none,
}

BannersAction getBannersAction(String? value) {
  switch (value) {
    case '':
      return BannersAction.initial;
    case 'openURL':
      return BannersAction.url;
    case 'maincategory':
      return BannersAction.mainCategory;
    case 'brand':
      return BannersAction.brand;
    case 'brandservice':
      return BannersAction.service;
    case 'transaction':
      return BannersAction.transaction;
    case 'coupon':
      return BannersAction.coupon;
    case 'none':
      return BannersAction.none;
    default:
      return BannersAction.initial;
  }
}
