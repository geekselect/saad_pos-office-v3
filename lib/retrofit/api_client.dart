import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:pos/model/SingleVendorRetrieveSize.dart';
import 'package:pos/model/banner_response.dart';
import 'package:pos/model/customer_data_model.dart';
import 'package:pos/model/deals_items_model.dart';
import 'package:pos/model/deals_sizes.dart';
import 'package:pos/model/half_n_half_model.dart';
import 'package:pos/model/is_address_selected.dart';
import 'package:pos/model/msg_response_model.dart';
import 'package:pos/model/order_setting_api_model.dart';
import 'package:pos/model/report_model.dart';
import 'package:pos/model/reports_by_date_model.dart';
import 'package:pos/model/shift_model.dart';
import 'package:pos/model/single_vendor_model.dart';
import 'package:pos/model/vendor_banner_model.dart';
import 'package:pos/model/vendor_item_model.dart';
import 'package:pos/printer/printer_model.dart';
import 'package:pos/utils/constants.dart';
import 'package:retrofit/retrofit.dart';
import 'package:pos/model/TrackingModel.dart';
import 'package:pos/model/UserAddressListModel.dart';
import 'package:pos/model/app_setting_model.dart';
import 'package:pos/model/balance.dart';
import 'package:pos/model/check_opt_model.dart';
import 'package:pos/model/check_otp_model_for_forgot_password.dart';
import 'package:pos/model/common_res.dart';
import 'package:pos/model/cuisine_vendor_details_model.dart';
import 'package:pos/model/exploreRestaurantsListModel.dart';
import 'package:pos/model/faq_list_model.dart';
import 'package:pos/model/favorite_list_model.dart';
import 'package:pos/model/login_model.dart';
import 'package:pos/model/order_history_list_model.dart';
import 'package:pos/model/order_status.dart';
import 'package:pos/model/payment_setting_model.dart';
import 'package:pos/model/promoCode_model.dart';
import 'package:pos/model/cart_tax_modal.dart';
import 'package:pos/model/register_model.dart';
import 'package:pos/model/search_list_model.dart';
import 'package:pos/model/send_otp_model.dart';
import 'package:pos/model/single_order_details_model.dart';
import 'package:pos/model/top_restaurants_model.dart';
import 'package:pos/model/user_details_model.dart';
import 'package:pos/model/AllCuisinesModel.dart';
import 'package:pos/model/nearByRestaurantsModel.dart';
import 'package:pos/model/vegRestaurantsModel.dart';
import 'package:pos/model/nonVegRestaurantsModel.dart';
import 'package:pos/model/update_address_model.dart';
import 'package:pos/model/single_restaurants_details_model.dart';
import 'package:pos/model/status_model.dart';

import '../model/book_table_model.dart';
import '../model/booked_order_model.dart';

part 'api_client.g.dart';

//@RestApi(baseUrl: 'https://sales.dialameal.co/public/api/')
//@RestApi(baseUrl: 'https://admin.menucart.com.au/api/')
@RestApi(baseUrl: Constants.serverLink)
//Please don't remove "/api/".
abstract class RestClient {
  factory RestClient(Dio dio, {String? baseUrl}) = _RestClient;

  @POST("user_register")
  Future<RegisterModel> register(@Body() Map<String, String?> map);

  @POST("check_otp")
  Future<CheckOTPModel> checkOtp(@Body() Map<String, String> map);

  @POST("check_otp")
  Future<CheckOTPForForgotPasswordModel> checkOtpForForgotPassword(
      @Body() Map<String, String> map);

  @POST("send_otp")
  Future<SendOTPModel> sendOtp(@Body() Map<String, String?> map);

  @POST("user_login")
  Future<LoginModel> userLogin(@Body() Map<String, String> map);

  @POST("update_image")
  Future<CommenRes> updateImage(@Body() Map<String, String?> map);

  @GET("user")
  Future<UserDetailsModel> user();

  @POST("update_user")
  Future<CommenRes> updateUser(@Body() Map<String, String> map);

  @GET("faq")
  Future<FAQListModel> faq();

  @GET("order_setting/{id}")
  Future<OrderSettingModel> orderSetting(
    @Path() int? id,
  );
  @GET("table/{vendorId}")
  Future<BookTableModel> getTables(
    @Path() int? vendorId,
  );

  @GET("cuisine")
  Future<AllCuisinesModel> allCuisine();

  @GET("payment_setting")
  Future<PaymentSettingModel> paymentSetting();

  @GET("near_by")
  Future<NearByRestaurantModel> nearBy();

  @GET("top_rest")
  Future<TopRestaurantsListModel> topRest();

  // @GET("veg_rest")
  // Future<VegRestaurantModel> vegRest();
  //
  // @GET("nonveg_rest")
  // Future<NonVegRestaurantModel> nonVegRest();

  @GET("explore_rest")
  Future<ExploreRestaurantListModel> exploreRest();

  @POST("faviroute")
  Future<CommenRes> favorite(@Body() Map<String, String> map);

  @POST("takwawaycom")
  Future<CommenRes> completeSpecificTakeawayOrder(@Body() Map<String, dynamic> map);

  @POST("completeTakeawayOrder")
  Future<CommenRes> completeTakeawayOrder(@Body() Map<String, dynamic> map);

  @POST("book_order")
  Future<CommenRes> bookOrder(
    @Body() map,
  );

  @POST("newPosCashCard")
  Future<ReportModel> reportsCall(
      @Body() map);

  @POST("add_address")
  Future<CommenRes> addAddress(@Body() Map<String, String> map);

  @POST("apply_promo_code")
  Future<String?> applyPromoCode(@Body() Map<String, String> map);

  @POST("search")
  Future<SearchListModel> search(@Body() Map<String, String> map);

  @POST("add_feedback")
  Future<CommenRes> addFeedback(
    @Body() map,
  );

  @POST("add_review")
  Future<CommenRes> addReview(
    @Body() map,
  );
  @POST("booked_table_vendor")
  Future<BookedOrderModel> getBookTableData(
    @Body() map,
  );

  @GET("user_address")
  Future<UserAddressListModel> userAddress();

  @GET("show_order")
  Future<OrderHistoryListModel> showOrder();

  @GET("user_order_status")
  Future<OrderStatus> userOrderStatus();

  @POST("update_address/{id}")
  Future<UpdateAddressModel> updateAddress(
      @Path() int? id, @Body() Map<String, String?> map);

  @GET("promo_code/{id}")
  Future<PromoCodeModel> promoCode(
    @Path() int? id,
  );

  @GET("single_order/{id}")
  Future<SingleOrderDetailsModel> singleOrder(
    @Path() int? id,
  );

  ///For pos cash and pos card reports
  // @GET("cashcardamount/{id}/cash")
  // Future cashPosCashAmount(
  //     @Path() int? id,
  //     );
  //
  // @GET("cashcardamount/{id}/card")
  // cashPosCardAmount(
  //     @Path() int? id,
  //     );
  ///End
  // @GET("possalesingleuser/{id}/{user_id}")
  // Future reportsCall(
  //   @Path() int? id,
  //   @Path() int? user_id,
  // );

  @POST("posTotalSaleByShiftCodeDate")
  Future<ReportByDateModel> reportsApiByDate(@Body() Map<String, dynamic> map);

  @GET("Pos-User-record/{vendorId}/{user_id}")
  Future customerDataCall(@Path() int? vendorId, int user_id);

  @GET("Pos-print-data/{id}")
  Future<PrinterModel> printerData(@Path() int? id);

  @POST("Pos-print-data-post/{id}")
  Future<CommenRes> updatePrinterData(@Body() Map<String, dynamic> map, int id);

  // @GET("vendor/printerdata/{id}")
  // Future printerData(@Path() int? id);

  @GET("slider/{id}")
  Future<VendorBanner> vendorSlider(
    @Path() int? id,
  );
  @GET("single/{id}")
  Future<SingleVendorModel> vendorSingle(
    @Path() int? id,
  );
  @GET("deals/{id}")
  Future<DealsItemsModel> vendorDeals(
    @Path() int? id,
  );
  @GET("half_n_half/{id}")
  Future<HalfNHalfModel?> vendorHalfNHalf(
    @Path() int? id,
  );

  @POST("cancel_order")
  Future<CommenRes> cancelOrder(@Body() Map<String, String> map);

  @POST("paymentSwitch")
  Future<CommenPaymentSwitchRes> paymentSwitchOrder(@Body() Map<String, String> map);

  @POST("refund")
  Future<CommenRes> refund(@Body() Map<String, String> map);

  @POST("bank_details")
  Future<CommenRes> bankDetails(@Body() Map<String, String> map);

  @GET("tracking/{id}")
  Future<TrackingModel> tracking(
    @Path() int? id,
  );

  @GET("remove_address/{id}")
  Future<CommenRes> removeAddress(@Path() int? id);

  @GET("pick_address/{id}")
  Future<MsgResModel> pickAddress(@Path() int? id);

  @GET("is_address_selected")
  Future<IsAddressSelectedModel> isAddressSelected();

  @GET("vendor_status/{id}")
  Future<StatusModel> status(
    @Path() int? id,
  );

  @GET("tax")
  Future<CartTaxModal> getTax();

  @GET("single_vendor/{id}")
  Future<SingleRestaurantsDetailsModel> singleVendor(@Path() int? id);

  @GET("single_vendor_retrieve_sizes/{id}/{halfNHalfMenuId}")
  Future<SingleVendorRetrieveSizes> singleVendorRetrieveSizes(
      @Path() int? id, int halfNHalfMenuId);

  @GET("single_vendor_retrieve_size/{id}/{itemCategoryId}/{itemSizeId}")
  Future<DealsSizes> singleVendorRetrieveSize(
      @Path() int? id, int itemCategoryId, int itemSizeId);

  @GET("createShift")
  Future<MsgResModel> createShift(@Body() Map<String, dynamic> map);

  @GET("getAllShifts/{vendorId}/{userId}")
  Future<ListShiftModel> getAllShifts(
      @Path() int? vendorId, int userId);

  @GET("getCurrentShift/{userId}")
  Future<MsgResModel> getCurrentShift(
      @Path() int userId);

  @POST("closeShift")
  Future<MsgResModel> closeShift(@Body() Map<String, dynamic> map);

  @POST("selectShift")
  Future<MsgResModel> selectShift(@Body() Map<String, dynamic> map);

  @POST("rest_faviroute")
  Future<FavoriteListModel> restFavorite();

  @GET("setting")
  Future<AppSettingModel> setting();

  @POST("user_forgot_password")
  Future<CommenRes> changeForgot(@Body() Map<String, String> map);

  @POST("user_change_password")
  Future<CommenRes> changePassword(@Body() Map<String, String> map);

  @POST("filter")
  Future<ExploreRestaurantListModel> filter(@Body() Map<String, String?> map);

  @GET("cuisine_vendor/{id}")
  Future<CuisineVendorDetailsModel> cuisineVendor(@Path() int? id);

  @GET("item_categories_vendor/{id}")
  Future<VendorItemModel> itemCategoryVendor(@Path() int? id);

  @GET("user_balance")
  Future<Balance> getBalanceHistory();

  @GET("wallet_balance")
  Future<CommenRes> getWalletBalance();

  @GET("banner")
  Future<BannerResponse> getBanner();

  @POST("add_balance")
  Future<CommenRes> addBalance(@Body() Map<String, String?> map);
}
