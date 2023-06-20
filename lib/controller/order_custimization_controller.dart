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
import 'package:pos/pages/modifiers/modifier_controller.dart';
import 'package:pos/pages/pos/Paymmmm/linkly_controller.dart';
import 'package:pos/retrofit/api_client.dart';
import 'package:pos/retrofit/api_header.dart';
import 'package:pos/retrofit/base_model.dart';
import 'package:pos/retrofit/server_error.dart';
import 'package:pos/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderCustimizationController extends GetxController {
  CartController _cartController = Get.put(CartController());

  RxInt strRestaurantModifier = 0.obs;
  RxInt strRestaurantLinkly = 0.obs;
  RxString strRestaurantsName = ''.obs,
      strRestaurantsAddress = ''.obs,
      strRestaurantsRate = ''.obs,
      strRestaurantsForTwoPerson = ''.obs,
      strRestaurantsType = ''.obs,
      strRestaurantsReview = ''.obs,
      strRestaurantImage = ''.obs;

  Rx<SingleRestaurantsDetailsModel> response = SingleRestaurantsDetailsModel(success: false).obs;
  singleVendorRetrieveSize.SingleVendorRetrieveSizes? singleVendorRetrieveSizes;
  List<singleVendorRetrieveSize.MenuSize> menuSizeList =
      <singleVendorRetrieveSize.MenuSize>[];
  DealsSizes? dealsSizes;
  Future<BaseModel<SingleRestaurantsDetailsModel>> callGetRestaurantsDetails() async {
    final prefs = await SharedPreferences.getInstance();
    String vendorId = prefs.getString(Constants.vendorId.toString()) ?? '';
    try {
      await RestClient(await RetroApi().dioData()).singleVendor(
        int.parse(vendorId.toString()),
      ).then((value) {
        if (value.success == true) {
          response.value = value;
          strRestaurantsType.value = response.value.data!.vendor!.vendorType;
          strRestaurantsName.value = response.value.data!.vendor!.name;
          strRestaurantsForTwoPerson.value =
              response.value.data!.vendor!.forTwoPerson;
          strRestaurantsRate.value =
              response.value.data!.vendor!.rate.toString();
          strRestaurantsReview.value =
              response.value.data!.vendor!.review.toString();
          strRestaurantsAddress.value = response.value.data!.vendor!.mapAddress;
          strRestaurantImage.value = response.value.data!.vendor!.image;
          strRestaurantModifier.value = response.value.data!.vendor!.modifiers;
          strRestaurantLinkly.value = response.value.data!.vendor!.linkly;

          if (response.value.data!.vendor!.modifiers == 1) {
            print("call modifier");
            ModifierDataController _modifierDataController = Get.put(
                ModifierDataController());
          } else {
            print("no call");
          }
          if (response.value.data!.vendor!.linkly == 1) {
            print("call linkly");
            LinklyDataController _linklyDataController = Get.put(
                LinklyDataController());
          } else {
            print("no call linkly");
          }

        } else {
          Constants.toastMessage('Error while getting details');
        }
      });
    } catch (error, stacktrace) {
      print("Exception occurred: $error stackTrace: $stacktrace");
      return BaseModel()..setException(ServerError.withError(error: error));
    }
    return BaseModel()..data = response.value;
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
