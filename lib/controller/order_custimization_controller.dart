import 'package:get/get.dart';
import 'package:pos/controller/cart_controller.dart';
import 'package:pos/model/SingleVendorRetrieveSize.dart'
    as singleVendorRetrieveSize;
import 'package:pos/model/deals_items_model.dart';
import 'package:pos/model/deals_sizes.dart';
import 'package:pos/model/half_n_half_model.dart';
import 'package:pos/model/single_restaurants_details_model.dart';
import 'package:pos/model/single_vendor_model.dart';
import 'package:pos/model/status_model.dart';
import 'package:pos/model/vendor_banner_model.dart';
import 'package:pos/model/vendor_item_model.dart';
import 'package:pos/retrofit/api_client.dart';
import 'package:pos/retrofit/api_header.dart';
import 'package:pos/retrofit/base_model.dart';
import 'package:pos/retrofit/server_error.dart';
import 'package:pos/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderCustimizationController extends GetxController {
  CartController _cartController = Get.put(CartController());

  RxString strRestaurantsName = ''.obs,
      strRestaurantsAddress = ''.obs,
      strRestaurantsRate = ''.obs,
      strRestaurantsForTwoPerson = ''.obs,
      strRestaurantsType = ''.obs,
      strRestaurantsReview = ''.obs,
      strRestaurantImage = ''.obs;
  SingleRestaurantsDetailsModel? response;
  singleVendorRetrieveSize.SingleVendorRetrieveSizes? singleVendorRetrieveSizes;
  List<singleVendorRetrieveSize.MenuSize> menuSizeList =
      <singleVendorRetrieveSize.MenuSize>[];
  DealsSizes? dealsSizes;
  Future<BaseModel<SingleRestaurantsDetailsModel>> callGetRestaurantsDetails() async {
    final prefs = await SharedPreferences.getInstance();
    String vendorId = prefs.getString(Constants.vendorId.toString()) ?? '';
    try {
      response = await RestClient(await RetroApi().dioData()).singleVendor(
        int.parse(vendorId.toString()),
      );
      if (response!.success) {
        strRestaurantsType.value = response!.data!.vendor!.vendorType;
        strRestaurantsName.value = response!.data!.vendor!.name;
        strRestaurantsForTwoPerson.value = response!.data!.vendor!.forTwoPerson;
        strRestaurantsRate.value = response!.data!.vendor!.rate.toString();
        strRestaurantsReview.value = response!.data!.vendor!.review.toString();
        strRestaurantsAddress.value = response!.data!.vendor!.mapAddress;
        strRestaurantImage.value = response!.data!.vendor!.image;

      } else {
        Constants.toastMessage('Error while getting details');
      }
    } catch (error, stacktrace) {
      print("Exception occurred: $error stackTrace: $stacktrace");
      return BaseModel()..setException(ServerError.withError(error: error));
    }
    return BaseModel()..data = response;
  }

  Future<BaseModel<StatusModel>> status() async {
    final prefs = await SharedPreferences.getInstance();
    String vendorId = prefs.getString(Constants.vendorId.toString()) ?? '';
    StatusModel? response;
    try {
      response = await RestClient(await RetroApi().dioData()).status(
        int.parse(vendorId),
      );
      if (response.success) {
        return BaseModel()..data = response;
      } else {
        Constants.toastMessage('Error while getting details');
      }
    } catch (error, stacktrace) {
      print("Exception occurred: $error stackTrace: $stacktrace");
      return BaseModel()..setException(ServerError.withError(error: error));
    }
    return BaseModel()..data = response;
  }

  getSingleVendorRetrieveSizes(int vendorID, halfNHalfMenuId) async {
    try {
      singleVendorRetrieveSizes = await RestClient(await RetroApi().dioData())
          .singleVendorRetrieveSizes(vendorID, halfNHalfMenuId);
      print(singleVendorRetrieveSizes);
      print("values");
    } catch (e, stk) {
      print("Exception occurred: $e stackTrace: $stk");
    }
  }

  Future<BaseModel<singleVendorRetrieveSize.SingleVendorRetrieveSizes>>
      getSingleVendorRetrieveSizesWithReturnValue( halfNHalfMenuId) async {
    final prefs = await SharedPreferences.getInstance();
    String vendorId = prefs.getString(Constants.vendorId.toString()) ?? '';

    singleVendorRetrieveSize.SingleVendorRetrieveSizes response;
    try {
      response = await RestClient(await RetroApi().dioData())
          .singleVendorRetrieveSizes(int.parse(vendorId.toString()), halfNHalfMenuId);
    } catch (e, stk) {
      print("Exception occurred: $e stackTrace: $stk");
      return BaseModel()..setException(ServerError.withError(error: e));
    }
    return BaseModel()..data = response;
  }

  Future<bool> getSingleVendorRetrieveSize(
      int vendorID, int itemCategoryId, int itemSizeId) async {
    try {
      dealsSizes = await RestClient(await RetroApi().dioData())
          .singleVendorRetrieveSize(vendorID, itemCategoryId, itemSizeId);
    } catch (e, stk) {
      print("Exception occurred: $e stackTrace: $stk");
    }
    return true;
  }

  Future<VendorBanner?> getVendorSlider(int id) async {
    VendorBanner? vendorBanner;
    try {
      vendorBanner =
          await RestClient(await RetroApi().dioData()).vendorSlider(id);
    } catch (e, stk) {
      print("Exception occurred: $e stackTrace: $stk");
    }
    return vendorBanner;
  }

  Future<SingleVendorModel?> getVendorSingle(int id) async {
    SingleVendorModel? singleVendorModel;
    try {
      singleVendorModel =
          await RestClient(await RetroApi().dioData()).vendorSingle(id);
    } catch (e, stk) {
      print("Exception occurred: $e stackTrace: $stk");
    }
    return singleVendorModel;
  }

  Future<DealsItemsModel?> getVendorDeals(int id) async {
    DealsItemsModel? dealsItemsModel;
    try {
      dealsItemsModel =
          await RestClient(await RetroApi().dioData()).vendorDeals(id);
    } catch (e, stk) {
      print("Exception occurred: $e stackTrace: $stk");
    }
    return dealsItemsModel;
  }

  Future<HalfNHalfModel?> getVendorHalfNHalf(int id) async {
    HalfNHalfModel? halfNHalfModel;
    try {
      halfNHalfModel =
          await RestClient(await RetroApi().dioData()).vendorHalfNHalf(id);
    } catch (e, stk) {
      print("Exception occurred: $e stackTrace: $stk");
    }
    return halfNHalfModel;
  }

  Future<BaseModel<VendorItemModel>> getItemCategoryVendor(
      int? restaurantId) async {
    VendorItemModel response;
    try {
      response =
          await RestClient(await RetroApi().dioData()).itemCategoryVendor(
        restaurantId,
      );
      if (response.success) {
      } else {
        Constants.toastMessage('Error while getting details');
      }
    } catch (error, stacktrace) {
      print("Exception occurred: $error stackTrace: $stacktrace");
      return BaseModel()..setException(ServerError.withError(error: error));
    }
    return BaseModel()..data = response;
  }
}
