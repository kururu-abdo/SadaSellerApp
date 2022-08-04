

import 'package:sixvalley_vendor_app/data/model/response/language_model.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';

class AppConstants {

  static const String APP_NAME = 'Joseeder Seller App';
  static const String BASE_URL = 'https://joseeder.com';
  static const String LOGIN_URI = '/api/v2/seller/auth/login';
  static const String CONFIG_URI = '/api/v1/config';
  static const String SELLER_URI = '/api/v2/seller/seller-info';
  static const String USER_EARNINGS_URI = '/api/v2/seller/monthly-earning';
  static const String SELLER_AND_BANK_UPDATE = '/api/v2/seller/seller-update';
  static const String SHOP_URI = '/api/v2/seller/shop-info';
  static const String SHOP_UPDATE = '/api/v2/seller/shop-update';
  static const String MESSAGE_URI = '/api/v2/seller/messages/list';
  static const String SEND_MESSAGE_URI = '/api/v2/seller/messages/send';
  static const String ORDER_LIST_URI = '/api/v2/seller/orders/list';
  static const String ORDER_DETAILS = '/api/v2/seller/orders/';
  static const String UPDATE_ORDER_STATUS = '/api/v2/seller/orders/order-detail-status/';
  static const String BALANCE_WITHDRAW = '/api/v2/seller/balance-withdraw';
  static const String CANCEL_BALANCE_REQUEST = '/api/v2/seller/close-withdraw-request';
  static const String TRANSACTIONS_URI = '/api/v2/seller/transactions';
  static const String SELLER_PRODUCT_URI = '/api/v1/seller/';
  static const String STOCK_OUT_PRODUCT_URI = '/api/v2/seller/products/stock-out-list?limit=10&offset=';
  static const String PRODUCT_REVIEW_URI = '/api/v2/seller/shop-product-reviews';
  static const String ATTRIBUTE_URI = '/api/v1/attributes';
  static const String BRAND_URI = '/api/v1/brands/';
  static const String CATEGORY_URI = '/api/v1/categories/';
  static const String SUB_CATEGORY_URI = '/api/v1/categories/childes/';
  static const String SUB_SUB_CATEGORY_URI = '/api/v1/categories/childes/childes/';
  static const String ADD_PRODUCT_URI = '/api/v2/seller/products/add';
  static const String UPLOAD_PRODUCT_IMAGE_URI = '/api/v2/seller/products/upload-images';
  static const String UPDATE_PRODUCT_URI = '/api/v2/seller/products/update';
  static const String DELETE_PRODUCT_URI = '/api/v2/seller/products/delete';
  static const String MONTHLY_COMMISSION_GIVEN_URI = '/api/v2/seller/monthly-commission-given';
  static const String EDIT_PRODUCT_URI = '/api/v2/seller/products/edit';
  static const String ADD_SHIPPING_URI = '/api/v2/seller/shipping-method/add';
  static const String UPDATE_SHIPPING_URI = '/api/v2/seller/shipping-method/update';
  static const String EDIT_SHIPPING_URI = '/api/v2/seller/shipping-method/edit';
  static const String DELETE_SHIPPING_URI = '/api/v2/seller/shipping-method/delete';
  static const String GET_SHIPPING_URI = '/api/v2/seller/shipping-method/list';
  static const String GET_DELIVERY_MAN_URI = '/api/v2/seller/seller-delivery-man';
  static const String ASSIGN_DELIVERY_MAN_URI = '/api/v2/seller/orders/assign-delivery-man';
  static const String TOKEN_URI = '/api/v2/seller/cm-firebase-token';
  static const String REFUND_LIST_URI = '/api/v2/seller/refund/list';
  static const String REFUND_ITEM_DETAILS = '/api/v2/seller/refund/refund-details';
  static const String REFUND_REQ_STATUS_UPDATE = '/api/v2/seller/refund/refund-status-update';
  static const String SHOW_SHIPPING_COST_URI = '/api/v2/seller/shipping/all-category-cost';
  static const String SET_CATEGORY_WISE_SHIPPING_COST_URI = '/api/v2/seller/shipping/set-category-cost';
  static const String SET_SHIPPING_METHOD_TYPE_URI = '/api/v2/seller/shipping/selected-shipping-method';
  static const String GET_SHIPPING_METHOD_TYPE_URI = '/api/v2/seller/shipping/get-shipping-method';
  static const String THIRD_PARTY_DELIVERY_MAN_ASSIGN = '/api/v2/seller/orders/assign-third-party-delivery';
  static const String FORGET_PASSWORD_URI = '/api/v2/seller/auth/forgot-password';
  static const String VERIFY_OTP_URI = '/api/v2/seller/auth/verify-otp';
  static const String RESET_PASSWORD_URI = '/api/v2/seller/auth/reset-password';
  static const String PAYMENT_STATUS_UPDATE = '/api/v2/seller/orders/update-payment-status';



  static const String PENDING = 'pending';
  static const String CONFIRMED = 'confirmed';
  static const String PROCESSING = 'processing';
  static const String PROCESSED = 'processed';
  static const String DELIVERED = 'delivered';
  static const String FAILED = 'failed';
  static const String RETURNED = 'returned';
  static const String CANCELLED = 'canceled';
  static const String OUT_FOR_DELIVERY = 'out_for_delivery';
  static const String APPROVED = 'approved';
  static const String REJECTED = 'rejected';
  static const String DONE = 'refunded';



  static const String ORDER_WISE = 'order_wise';
  static const String PRODUCT_WISE = 'product_wise';
  static const String CATEGORY_WISE = 'category_wise';



  static const String THEME = 'theme';
  static const String CURRENCY = 'currency';
  static const String SHIPPING_TYPE = 'shipping_type';
  static const String TOKEN = 'token';
  static const String COUNTRY_CODE = 'country_code';
  static const String LANGUAGE_CODE = 'language_code';
  static const String CART_LIST = 'cart_list';
  static const String USER_ADDRESS = 'user_address';
  static const String USER_PASSWORD = 'user_password';
  static const String USER_NUMBER = 'user_number';
  static const String SEARCH_ADDRESS = 'search_address';
  static const String TOPIC = 'six_valley_seller';
  static const String USER_EMAIL = 'user_email';
  static const String LANG_KEY = 'lang';

  static List<LanguageModel> languages = [
    LanguageModel(imageUrl: Images.united_kindom, languageName: 'English', countryCode: 'US', languageCode: 'en'),
    LanguageModel(imageUrl: Images.arabic, languageName: 'Arabic', countryCode: 'SA', languageCode: 'ar'),
  ];
}
