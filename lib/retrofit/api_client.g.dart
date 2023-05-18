// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_client.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps

class _RestClient implements RestClient {
  _RestClient(this._dio, {this.baseUrl}) {
    baseUrl ??= 'https://v4.ozfoodz.com.au/api/pos/';
    // baseUrl ??= 'https://v3.ozfoodz.com.au/api/pos/';
  }

  final Dio _dio;

  String? baseUrl;

  @override
  Future<RegisterModel> register(map) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(map);
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<RegisterModel>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, 'user_register',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = RegisterModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<CheckOTPModel> checkOtp(map) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(map);
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<CheckOTPModel>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, 'check_otp',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = CheckOTPModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<CheckOTPForForgotPasswordModel> checkOtpForForgotPassword(map) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(map);
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<CheckOTPForForgotPasswordModel>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, 'check_otp',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = CheckOTPForForgotPasswordModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<SendOTPModel> sendOtp(map) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(map);
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<SendOTPModel>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, 'send_otp',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = SendOTPModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<LoginModel> userLogin(map) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(map);
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<LoginModel>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, 'user_login',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = LoginModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<CommenRes> updateImage(map) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(map);
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<CommenRes>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, 'update_image',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = CommenRes.fromJson(_result.data!);
    return value;
  }

  @override
  Future<UserDetailsModel> user() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<UserDetailsModel>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, 'user',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = UserDetailsModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<CommenRes> updateUser(map) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(map);
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<CommenRes>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, 'update_user',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = CommenRes.fromJson(_result.data!);
    return value;
  }

  @override
  Future<FAQListModel> faq() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<FAQListModel>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, 'faq',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = FAQListModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<OrderSettingModel> orderSetting(id) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<OrderSettingModel>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, 'order_setting/${id}',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = OrderSettingModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<BookTableModel> getTables(vendorId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};

    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<OrderSettingModel>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, 'table/${vendorId}',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = BookTableModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<AllCuisinesModel> allCuisine() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<AllCuisinesModel>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, 'cuisine',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = AllCuisinesModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<PaymentSettingModel> paymentSetting() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<PaymentSettingModel>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, 'payment_setting',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = PaymentSettingModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<NearByRestaurantModel> nearBy() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<NearByRestaurantModel>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, 'near_by',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = NearByRestaurantModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<TopRestaurantsListModel> topRest() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<TopRestaurantsListModel>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, 'top_rest',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = TopRestaurantsListModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<ExploreRestaurantListModel> exploreRest() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<ExploreRestaurantListModel>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, 'explore_rest',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = ExploreRestaurantListModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<CommenRes> favorite(map) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(map);
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<CommenRes>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, 'faviroute',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = CommenRes.fromJson(_result.data!);
    return value;
  }

  @override
  Future<CommenRes> bookOrder(map) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = map;
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<CommenRes>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, 'book_order',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = CommenRes.fromJson(_result.data!);
    return value;
  }

  @override
  Future<CommenRes> addAddress(map) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(map);
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<CommenRes>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, 'add_address',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = CommenRes.fromJson(_result.data!);
    return value;
  }

  @override
  Future<String?> applyPromoCode(map) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(map);
    final _result = await _dio.fetch<String>(_setStreamType<String>(
        Options(method: 'POST', headers: _headers, extra: _extra)
            .compose(_dio.options, 'apply_promo_code',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data;
    return value;
  }

  @override
  Future<SearchListModel> search(map) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(map);
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<SearchListModel>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, 'search',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = SearchListModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<CommenRes> addFeedback(map) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = map;
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<CommenRes>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, 'add_feedback',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = CommenRes.fromJson(_result.data!);
    return value;
  }

  @override
  Future<CommenRes> addReview(map) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = map;
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<CommenRes>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, 'add_review',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = CommenRes.fromJson(_result.data!);
    return value;
  }

  @override
  Future<BookedOrderModel> getBookTableData(map) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = map;
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<CommenRes>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, 'booked_table_vendor',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = BookedOrderModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<UserAddressListModel> userAddress() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<UserAddressListModel>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, 'user_address',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = UserAddressListModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<OrderHistoryListModel> showOrder() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<OrderHistoryListModel>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, 'show_order1',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = OrderHistoryListModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<OrderStatus> userOrderStatus() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<OrderStatus>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, 'user_order_status',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = OrderStatus.fromJson(_result.data!);
    return value;
  }

  @override
  Future<UpdateAddressModel> updateAddress(id, map) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(map);
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<UpdateAddressModel>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, 'update_address/${id}',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = UpdateAddressModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<PromoCodeModel> promoCode(id) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<PromoCodeModel>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, 'promo_code/${id}',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = PromoCodeModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<SingleOrderDetailsModel> singleOrder(id) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<SingleOrderDetailsModel>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, 'single_order/${id}',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = SingleOrderDetailsModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<VendorBanner> vendorSlider(id) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<VendorBanner>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, 'slider/${id}',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = VendorBanner.fromMap(_result.data!);
    return value;
  }

  @override
  Future<SingleVendorModel> vendorSingle(id) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<SingleVendorModel>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, 'single/${id}',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = SingleVendorModel.fromMap(_result.data!);
    return value;
  }

  @override
  Future<DealsItemsModel> vendorDeals(id) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<DealsItemsModel>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, 'deals/${id}',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = DealsItemsModel.fromMap(_result.data!);
    return value;
  }

  @override
  Future<HalfNHalfModel?> vendorHalfNHalf(id) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>?>(
        _setStreamType<HalfNHalfModel>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, 'half_n_half/${id}',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value =
        _result.data == null ? null : HalfNHalfModel.fromMap(_result.data!);
    return value;
  }

  @override
  Future<CommenRes> cancelOrder(map) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(map);
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<CommenRes>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, 'cancel_order',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = CommenRes.fromJson(_result.data!);
    return value;
  }

  @override
  Future<CommenRes> refund(map) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(map);
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<CommenRes>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, 'refund',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = CommenRes.fromJson(_result.data!);
    return value;
  }

  @override
  Future<CommenRes> bankDetails(map) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(map);
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<CommenRes>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, 'bank_details',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = CommenRes.fromJson(_result.data!);
    return value;
  }

  @override
  Future<TrackingModel> tracking(id) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<TrackingModel>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, 'tracking/${id}',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = TrackingModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<CommenRes> removeAddress(id) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<CommenRes>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, 'remove_address/${id}',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = CommenRes.fromJson(_result.data!);
    return value;
  }

  @override
  Future<MsgResModel> pickAddress(id) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<MsgResModel>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, 'pick_address/${id}',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = MsgResModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<IsAddressSelectedModel> isAddressSelected() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<IsAddressSelectedModel>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, 'is_address_selected',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = IsAddressSelectedModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<StatusModel> status(id) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<StatusModel>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, 'vendor_status/${id}',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = StatusModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<CartTaxModal> getTax() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<CartTaxModal>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, 'tax',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = CartTaxModal.fromJson(_result.data!);
    return value;
  }

  @override
  Future<SingleRestaurantsDetailsModel> singleVendor(id) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<SingleRestaurantsDetailsModel>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, 'single_vendor/${id}',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value =
        SingleRestaurantsDetailsModel.fromJson(jsonEncode(_result.data!));
    return value;
  }

  @override
  Future<SingleVendorRetrieveSizes> singleVendorRetrieveSizes(
      id, halfNHalfMenuId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<SingleVendorRetrieveSizes>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options,
                    'single_vendor_retrieve_sizes/${id}/${halfNHalfMenuId}',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = SingleVendorRetrieveSizes.fromMap(_result.data!);
    return value;
  }

  @override
  Future<DealsSizes> singleVendorRetrieveSize(
      id, itemCategoryId, itemSizeId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(_setStreamType<
        DealsSizes>(Options(
            method: 'GET', headers: _headers, extra: _extra)
        .compose(_dio.options,
            'single_vendor_retrieve_size/${id}/${itemCategoryId}/${itemSizeId}',
            queryParameters: queryParameters, data: _data)
        .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = DealsSizes.fromMap(_result.data!);
    return value;
  }

  @override
  Future<FavoriteListModel> restFavorite() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<FavoriteListModel>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, 'rest_faviroute',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = FavoriteListModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<AppSettingModel> setting() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<AppSettingModel>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, 'setting',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = AppSettingModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<CommenRes> changeForgot(map) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(map);
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<CommenRes>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, 'user_forgot_password',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = CommenRes.fromJson(_result.data!);
    return value;
  }

  @override
  Future<CommenRes> changePassword(map) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(map);
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<CommenRes>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, 'user_change_password',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = CommenRes.fromJson(_result.data!);
    return value;
  }

  @override
  Future<ExploreRestaurantListModel> filter(map) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(map);
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<ExploreRestaurantListModel>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, 'filter',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = ExploreRestaurantListModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<CuisineVendorDetailsModel> cuisineVendor(id) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<CuisineVendorDetailsModel>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, 'cuisine_vendor/${id}',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = CuisineVendorDetailsModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<VendorItemModel> itemCategoryVendor(id) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<VendorItemModel>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, 'item_categories_vendor/${id}',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = VendorItemModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<Balance> getBalanceHistory() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<Balance>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, 'user_balance',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = Balance.fromJson(_result.data!);
    return value;
  }

  @override
  Future<CommenRes> getWalletBalance() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<CommenRes>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, 'wallet_balance',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = CommenRes.fromJson(_result.data!);
    return value;
  }

  @override
  Future<BannerResponse> getBanner() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<BannerResponse>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, 'banner',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = BannerResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<CommenRes> addBalance(map) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(map);
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<CommenRes>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, 'add_balance',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = CommenRes.fromJson(_result.data!);
    return value;
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }

  @override
  Future<CommenRes> completeSpecificTakeawayOrder(Map<String, dynamic> map) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(map);
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<CommenRes>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, 'takwawaycom',
                queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = CommenRes.fromJson(_result.data!);
    return value;
  }

  @override
  Future<CommenRes> completeTakeawayOrder(Map<String, dynamic> map) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(map);
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<CommenRes>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, 'completeTakeawayOrder',
                queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = CommenRes.fromJson(_result.data!);
    return value;
  }

  ///Pos Cash Reports
  // @override
  // Future<ReportCardModel> cashPosCardAmount(int? id) async {
  //   const _extra = <String, dynamic>{};
  //   final queryParameters = <String, dynamic>{};
  //   queryParameters.removeWhere((k, v) => v == null);
  //   final _headers = <String, dynamic>{};
  //   final _data = <String, dynamic>{};
  //   final _result = await _dio.fetch<Map<String, dynamic>>(
  //       _setStreamType<ReportCardModel>(
  //           Options(method: 'GET', headers: _headers, extra: _extra)
  //               .compose(_dio.options, 'cashcardamount/${id}/card',
  //               queryParameters: queryParameters, data: _data)
  //               .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
  //   final value = ReportCardModel.fromJson(_result.data!);
  //   return value;
  // }
  //
  // @override
  // Future<ReportCashModel> cashPosCashAmount(int? id) async {
  //   const _extra = <String, dynamic>{};
  //   final queryParameters = <String, dynamic>{};
  //   queryParameters.removeWhere((k, v) => v == null);
  //   final _headers = <String, dynamic>{};
  //   final _data = <String, dynamic>{};
  //   final _result = await _dio.fetch<Map<String, dynamic>>(
  //       _setStreamType<ReportCashModel>(
  //           Options(method: 'GET', headers: _headers, extra: _extra)
  //               .compose(_dio.options, 'cashcardamount/${id}/cash',
  //               queryParameters: queryParameters, data: _data)
  //               .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
  //   final value = ReportCashModel.fromJson(_result.data!);
  //   return value;
  // }
  ///End
  @override
  Future<ReportModel> reportsCall(int? id, int? user_id) async {
    @override
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<ReportModel>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, 'possalesingleuser/${id}/${user_id}',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = ReportModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<ReportByDateModel> reportsApiByDate(Map<String, dynamic> map) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(map);
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<ReportByDateModel>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, 'possalebydate',
                queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = ReportByDateModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<PrinterModel> printerData(int? id) async {
    @override
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<PrinterModel>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, 'Pos-print-data/${id}',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = PrinterModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<CommenRes> updatePrinterData(Map<String, dynamic> map, int id) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(map);
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<CommenRes>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, 'Pos-print-data-post/$id',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = CommenRes.fromJson(_result.data!);
    return value;
  }

  @override
  Future customerDataCall(int? vendorId, int user_id) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<CustomerDataModel>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, 'Pos-User-record/${vendorId}/${user_id}',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = CustomerDataModel.fromJson(_result.data!);
    return value;
  }

  // @override
  // Future printerData(int? id) async {
  //   @override
  //   const _extra = <String, dynamic>{};
  //   final queryParameters = <String, dynamic>{};
  //   // queryParameters.removeWhere((k, v) => v == null);
  //   final _headers = <String, dynamic>{};
  //   final _data = <String, dynamic>{};
  //   final _result = await _dio.fetch<Map<String, dynamic>>(_setStreamType(
  //       Options(method: 'GET', headers: _headers, extra: _extra)
  //           .compose(_dio.options, 'vendor/printerdata/${id}',
  //               queryParameters: queryParameters, data: _data)
  //           .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
  //   print("result printer ------------${_result.data}");
  //   return _result.data;
  // }
}
