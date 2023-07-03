// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:pos/config/screen_config.dart';
// import 'package:pos/controller/cart_controller.dart';
// import 'package:pos/model/cart_master.dart';
// import 'package:pos/utils/constants.dart';
//
// ///1st
// // class ModifiersOnly extends StatefulWidget {
// //   ModifierModel modifierModel;
// //
// //   ModifiersOnly({
// //     Key? key,
// //     required this.modifierModel,
// //   }) : super(key: key);
// //
// //   @override
// //   State<ModifiersOnly> createState() => _ModifiersOnlyState();
// // }
// //
// // class _ModifiersOnlyState extends State<ModifiersOnly> {
// //   CartController _cartController = Get.find<CartController>();
// //
// //   List<int> selectedModifiers = [];
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return ListView.builder(
// //         itemCount: widget.modifierModel.modifiers!.length,
// //         shrinkWrap: true,
// //         itemBuilder: (context, modifierIndex) {
// //           return Column(children: [
// //             Text(
// //               widget.modifierModel.modifiers![modifierIndex].modifierType.toString(),
// //               style: TextStyle(
// //                 fontWeight: FontWeight.w800,
// //                 color: Color(Constants.colorTheme),
// //                 fontSize: 17,
// //               ),
// //             ),
// //             ListView.builder(
// //                 padding: EdgeInsets.zero,
// //                 shrinkWrap: true,
// //                 physics: const NeverScrollableScrollPhysics(),
// //                 itemCount: widget.modifierModel
// //                     .modifiers![modifierIndex].modifierDetails!.length,
// //                 itemBuilder: (context, modifierDetailIndex) {
// //               return CheckboxListTile(
// //                   checkColor: selectedModifiers.contains(modifierDetailIndex) ? Color(Constants.colorTheme) : null,
// //                   title: Text(widget.modifierModel
// //                       .modifiers![modifierIndex].modifierDetails![modifierDetailIndex].modifierName.toString()),
// //                   subtitle: Text("Price "+double.parse(widget.modifierModel
// //                       .modifiers![modifierIndex].modifierDetails![modifierDetailIndex].modifierPrice.toString()).toStringAsFixed(2)),
// //                 onChanged: (bool? value) {
// //                   setState(() {
// //                     if (value == true) {
// //                       selectedModifiers.add(modifierDetailIndex);
// //                     } else {
// //                       selectedModifiers.remove(modifierDetailIndex);
// //                     }
// //                   });
// //                 },
// //                 value: selectedModifiers.contains(modifierDetailIndex),);
// //                 })
// //           ]);
// //         });
// //   }
// // }
//
// ///Second
// // class ModifiersOnly extends StatefulWidget {
// //   ModifierModel modifierModel;
// //
// //   ModifiersOnly({
// //     Key? key,
// //     required this.modifierModel,
// //   }) : super(key: key);
// //
// //   @override
// //   State<ModifiersOnly> createState() => _ModifiersOnlyState();
// // }
// //
// // class _ModifiersOnlyState extends State<ModifiersOnly> {
// //   CartController _cartController = Get.find<CartController>();
// //
// //   Map<int, int> selectedModifiers = {}; // Map to store selected indices per modifier type
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return ListView.builder(
// //       itemCount: widget.modifierModel.modifiers!.length,
// //       shrinkWrap: true,
// //       itemBuilder: (context, modifierIndex) {
// //         var modifierType = widget.modifierModel.modifiers![modifierIndex].modifierType;
// //         return Column(
// //           children: [
// //             Text(
// //               modifierType.toString(),
// //               style: TextStyle(
// //                 fontWeight: FontWeight.w800,
// //                 color: Color(Constants.colorTheme),
// //                 fontSize: 17,
// //               ),
// //             ),
// //             ListView.builder(
// //               padding: EdgeInsets.zero,
// //               shrinkWrap: true,
// //               physics: const NeverScrollableScrollPhysics(),
// //               itemCount: widget.modifierModel.modifiers![modifierIndex].modifierDetails!.length,
// //               itemBuilder: (context, modifierDetailIndex) {
// //                 var modifierDetail =
// //                 widget.modifierModel.modifiers![modifierIndex].modifierDetails![modifierDetailIndex];
// //                 return CheckboxListTile(
// //                   checkColor: selectedModifiers.containsKey(modifierIndex) &&
// //                       selectedModifiers[modifierIndex] == modifierDetailIndex
// //                       ? Color(Constants.colorTheme)
// //                       : null,
// //                   title: Text(modifierDetail.modifierName.toString()),
// //                   subtitle: Text("Price " +
// //                       double.parse(modifierDetail.modifierPrice.toString()).toStringAsFixed(2)),
// //                   onChanged: (bool? value) {
// //                     setState(() {
// //                       if (value == true) {
// //                         selectedModifiers[modifierIndex] = modifierDetailIndex;
// //                       } else {
// //                         selectedModifiers.remove(modifierIndex);
// //                       }
// //                     });
// //                   },
// //                   value: selectedModifiers.containsKey(modifierIndex) &&
// //                       selectedModifiers[modifierIndex] == modifierDetailIndex,
// //                 );
// //               },
// //             )
// //           ],
// //         );
// //       },
// //     );
// //   }
// // }
//
// ///Third Without Data
// // class ModifiersOnly extends StatefulWidget {
// //   ModifierModel modifierModel;
// //
// //   ModifiersOnly({
// //     Key? key,
// //     required this.modifierModel,
// //   }) : super(key: key);
// //
// //   @override
// //   State<ModifiersOnly> createState() => _ModifiersOnlyState();
// // }
// //
// // class _ModifiersOnlyState extends State<ModifiersOnly> {
// //   CartController _cartController = Get.find<CartController>();
// //
// //   Map<int, List<int>> selectedModifiers = {}; // Map to store selected indices per modifier type
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return ListView.builder(
// //       itemCount: widget.modifierModel.modifiers!.length,
// //       shrinkWrap: true,
// //       itemBuilder: (context, modifierIndex) {
// //         var modifierType = widget.modifierModel.modifiers![modifierIndex].modifierType;
// //         return Column(
// //           children: [
// //             Text(
// //               modifierType.toString(),
// //               style: TextStyle(
// //                 fontWeight: FontWeight.w800,
// //                 color: Color(Constants.colorTheme),
// //                 fontSize: 17,
// //               ),
// //             ),
// //             ListView.builder(
// //               padding: EdgeInsets.zero,
// //               shrinkWrap: true,
// //               physics: const NeverScrollableScrollPhysics(),
// //               itemCount: widget.modifierModel.modifiers![modifierIndex].modifierDetails!.length,
// //               itemBuilder: (context, modifierDetailIndex) {
// //                 var modifierDetail =
// //                 widget.modifierModel.modifiers![modifierIndex].modifierDetails![modifierDetailIndex];
// //                 return CheckboxListTile(
// //                   checkColor: selectedModifiers.containsKey(modifierIndex) &&
// //                       selectedModifiers[modifierIndex]!.contains(modifierDetailIndex)
// //                       ? Color(Constants.colorTheme)
// //                       : null,
// //                   title: Text(modifierDetail.modifierName.toString()),
// //                   subtitle: Text("Price " +
// //                       double.parse(modifierDetail.modifierPrice.toString()).toStringAsFixed(2)),
// //                   onChanged: (bool? value) {
// //                     setState(() {
// //                       if (value == true) {
// //                         if (!selectedModifiers.containsKey(modifierIndex)) {
// //                           selectedModifiers[modifierIndex] = [modifierDetailIndex];
// //                         } else {
// //                           selectedModifiers[modifierIndex]!.add(modifierDetailIndex);
// //                         }
// //                       } else {
// //                         selectedModifiers[modifierIndex]!.remove(modifierDetailIndex);
// //                         if (selectedModifiers[modifierIndex]!.isEmpty) {
// //                           selectedModifiers.remove(modifierIndex);
// //                         }
// //                       }
// //                     });
// //                   },
// //                   value: selectedModifiers.containsKey(modifierIndex) &&
// //                       selectedModifiers[modifierIndex]!.contains(modifierDetailIndex),
// //                 );
// //               },
// //             )
// //           ],
// //         );
// //       },
// //     );
// //   }
// // }
//
// ///Third With data
// // class ModifiersOnly extends StatefulWidget {
// //   ModifierModel modifierModel;
// //
// //   ModifiersOnly({
// //     Key? key,
// //     required this.modifierModel,
// //   }) : super(key: key);
// //
// //   @override
// //   State<ModifiersOnly> createState() => _ModifiersOnlyState();
// // }
// //
// // class _ModifiersOnlyState extends State<ModifiersOnly> {
// //   CartController _cartController = Get.find<CartController>();
// //
// //   Map<int, List<ModifierDetail>> selectedModifiers = {}; // Map to store selected items per modifier type
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return ListView.builder(
// //       itemCount: widget.modifierModel.modifiers!.length,
// //       shrinkWrap: true,
// //       itemBuilder: (context, modifierIndex) {
// //         var modifierType = widget.modifierModel.modifiers![modifierIndex].modifierType;
// //         return Column(
// //           children: [
// //             Text(
// //               modifierType.toString(),
// //               style: TextStyle(
// //                 fontWeight: FontWeight.w800,
// //                 color: Color(Constants.colorTheme),
// //                 fontSize: 17,
// //               ),
// //             ),
// //             ListView.builder(
// //               padding: EdgeInsets.zero,
// //               shrinkWrap: true,
// //               physics: const NeverScrollableScrollPhysics(),
// //               itemCount: widget.modifierModel.modifiers![modifierIndex].modifierDetails!.length,
// //               itemBuilder: (context, modifierDetailIndex) {
// //                 var modifierDetail =
// //                 widget.modifierModel.modifiers![modifierIndex].modifierDetails![modifierDetailIndex];
// //                 return CheckboxListTile(
// //                   checkColor: selectedModifiers.containsKey(modifierIndex) &&
// //                       selectedModifiers[modifierIndex]!.contains(modifierDetail)
// //                       ? Color(Constants.colorTheme)
// //                       : null,
// //                   title: Text(modifierDetail.modifierName.toString()),
// //                   subtitle: Text("Price " +
// //                       double.parse(modifierDetail.modifierPrice.toString()).toStringAsFixed(2)),
// //                   onChanged: (bool? value) {
// //                     setState(() {
// //                       if (value == true) {
// //                         if (!selectedModifiers.containsKey(modifierIndex)) {
// //                           selectedModifiers[modifierIndex] = [modifierDetail];
// //                         } else {
// //                           selectedModifiers[modifierIndex]!.add(modifierDetail);
// //                         }
// //                       } else {
// //                         selectedModifiers[modifierIndex]!.remove(modifierDetail);
// //                         if (selectedModifiers[modifierIndex]!.isEmpty) {
// //                           selectedModifiers.remove(modifierIndex);
// //                         }
// //                       }
// //                     });
// //                   },
// //                   value: selectedModifiers.containsKey(modifierIndex) &&
// //                       selectedModifiers[modifierIndex]!.contains(modifierDetail),
// //                 );
// //               },
// //             )
// //           ],
// //         );
// //       },
// //     );
// //   }
// // }
//
// ///Forth
// // class ModifiersOnly extends StatefulWidget {
// //   ModifierModel modifierModel;
// //
// //
// //   ModifiersOnly({
// //     Key? key,
// //     required this.modifierModel,
// //   }) : super(key: key);
// //
// //   @override
// //   State<ModifiersOnly> createState() => _ModifiersOnlyState();
// // }
// //
// // class _ModifiersOnlyState extends State<ModifiersOnly> {
// //   Map<int, List<int>> selectedModifiers = {};
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Column(
// //       children: [
// //         const Text(
// //           "Modifiers",
// //           style: TextStyle(
// //             fontWeight: FontWeight.w800,
// //             color: Colors.black,
// //             fontSize: 20,
// //           ),
// //         ),
// //         const SizedBox(height: 5),
// //         ListView.builder(
// //           itemCount: widget.modifierModel.modifiers!.length,
// //           shrinkWrap: true,
// //           itemBuilder: (context, modifierIndex) {
// //             var modifierType = widget.modifierModel.modifiers![modifierIndex].modifierType;
// //             var modifierDetails = widget.modifierModel.modifiers![modifierIndex].modifierDetails!;
// //             return ExpansionTile(
// //               title: Text(
// //                 modifierType.toString(),
// //                 style: TextStyle(
// //                   fontWeight: FontWeight.w800,
// //                   color: Color(Constants.colorTheme),
// //                   fontSize: 17,
// //                 ),
// //               ),
// //               children: [
// //                 ListView.builder(
// //                   padding: EdgeInsets.zero,
// //                   shrinkWrap: true,
// //                   physics: const NeverScrollableScrollPhysics(),
// //                   itemCount: modifierDetails.length,
// //                   itemBuilder: (context, modifierDetailIndex) {
// //                     var modifierDetail = modifierDetails[modifierDetailIndex];
// //                     return CheckboxListTile(
// //                       checkColor: selectedModifiers.containsKey(modifierIndex) &&
// //                           selectedModifiers[modifierIndex]!.contains(modifierDetailIndex)
// //                           ? Color(Constants.colorTheme)
// //                           : null,
// //                       title: Text(modifierDetail.modifierName.toString()),
// //                       subtitle: Text("Price " +
// //                           double.parse(modifierDetail.modifierPrice.toString()).toStringAsFixed(2)),
// //                       onChanged: (bool? value) {
// //                         setState(() {
// //                           if (value == true) {
// //                             if (!selectedModifiers.containsKey(modifierIndex)) {
// //                               selectedModifiers[modifierIndex] = [modifierDetailIndex];
// //                             } else {
// //                               selectedModifiers[modifierIndex]!.add(modifierDetailIndex);
// //                             }
// //                           } else {
// //                             selectedModifiers[modifierIndex]!.remove(modifierDetailIndex);
// //                             if (selectedModifiers[modifierIndex]!.isEmpty) {
// //                               selectedModifiers.remove(modifierIndex);
// //                             }
// //                           }
// //                         });
// //                       },
// //                       value: selectedModifiers.containsKey(modifierIndex) &&
// //                           selectedModifiers[modifierIndex]!.contains(modifierDetailIndex),
// //                     );
// //                   },
// //                 ),
// //               ],
// //             );
// //           },
// //         ),
// //       ],
// //     );
// //   }
// // }
//
// ///Fifth
// // class ModifiersOnly extends StatefulWidget {
// //   ModifierModel modifierModel;
// //   Function(List<Modifier>) onModifiersSelected; // Callback function to handle selected modifiers
// //
// //   ModifiersOnly({
// //     Key? key,
// //     required this.modifierModel,
// //     required this.onModifiersSelected,
// //   }) : super(key: key);
// //
// //   @override
// //   State<ModifiersOnly> createState() => _ModifiersOnlyState();
// // }
// //
// // class _ModifiersOnlyState extends State<ModifiersOnly> {
// //   List<Modifier> selectedModifiers = [];
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Column(
// //       children: [
// //         const Text(
// //           "Modifiers",
// //           style: TextStyle(
// //             fontWeight: FontWeight.w800,
// //             color: Colors.black,
// //             fontSize: 20,
// //           ),
// //         ),
// //         const SizedBox(height: 5),
// //         ListView.builder(
// //           itemCount: widget.modifierModel.modifiers!.length,
// //           shrinkWrap: true,
// //           itemBuilder: (context, modifierIndex) {
// //             var modifierType = widget.modifierModel.modifiers![modifierIndex].modifierType;
// //             var modifierDetails = widget.modifierModel.modifiers![modifierIndex].modifierDetails!;
// //             return ExpansionTile(
// //               title: Text(
// //                 modifierType.toString(),
// //                 style: TextStyle(
// //                   fontWeight: FontWeight.w800,
// //                   color: Color(Constants.colorTheme),
// //                   fontSize: 17,
// //                 ),
// //               ),
// //               children: [
// //                 ListView.builder(
// //                   padding: EdgeInsets.zero,
// //                   shrinkWrap: true,
// //                   physics: const NeverScrollableScrollPhysics(),
// //                   itemCount: modifierDetails.length,
// //                   itemBuilder: (context, modifierDetailIndex) {
// //                     var modifierDetail = modifierDetails[modifierDetailIndex];
// //                     return CheckboxListTile(
// //                       checkColor: selectedModifiers.contains(modifierDetail)
// //                           ? Color(Constants.colorTheme)
// //                           : null,
// //                       title: Text(modifierDetail.modifierName.toString()),
// //                       subtitle: Text(
// //                         "Price " +
// //                             double.parse(modifierDetail.modifierPrice.toString()).toStringAsFixed(2),
// //                       ),
// //                       onChanged: (bool? value) {
// //                         setState(() {
// //                           if (value == true) {
// //                             selectedModifiers.add(widget.modifierModel.modifiers![modifierIndex]);
// //                           } else {
// //                             selectedModifiers.remove(widget.modifierModel.modifiers![modifierIndex]);
// //                           }
// //
// //                           // Pass the selected modifiers to the callback function
// //                           widget.onModifiersSelected(selectedModifiers);
// //                         });
// //                       },
// //                       value: selectedModifiers.contains(widget.modifierModel.modifiers![modifierIndex]),
// //                     );
// //                   },
// //                 ),
// //               ],
// //             );
// //           },
// //         ),
// //       ],
// //     );
// //   }
// // }
//
// ///Sixth /// Fifth is not perfect
// // class ModifiersOnly extends StatefulWidget {
// //   ModifierModel modifierModel;
// //   Function(List<Modifier>) onModifiersSelected;
// //   List<Modifier> cartModifiers;
// //   // Callback function to handle selected modifiers
// //
// //   ModifiersOnly({
// //     Key? key,
// //     required this.modifierModel,
// //     required this.onModifiersSelected,
// //     required this.cartModifiers,
// //   }) : super(key: key);
// //
// //   @override
// //   State<ModifiersOnly> createState() => _ModifiersOnlyState();
// // }
// //
// // class _ModifiersOnlyState extends State<ModifiersOnly> {
// //   Map<int, List<ModifierDetail>> selectedModifiers = {};
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     initializeSelectedModifiers();
// //   }
// //
// //
// //   void initializeSelectedModifiers() {
// //     for (var cartModifier in widget.cartModifiers) {
// //       var modifierIndex = widget.modifierModel.modifiers!.indexWhere((modifier) {
// //         return modifier.modifierType.toString() == cartModifier.modifierType;
// //       });
// //
// //       if (modifierIndex != -1) {
// //         var modifierDetails = widget.modifierModel.modifiers![modifierIndex].modifierDetails!;
// //         var selectedModifierDetails = cartModifier.modifierDetails;
// //
// //         List<ModifierDetail> selectedIndexes = [];
// //
// //         for (var selectedModifierDetail in selectedModifierDetails!) {
// //           var modifierDetailIndex = modifierDetails.indexWhere((modifierDetail) {
// //             return modifierDetail.modifierName == selectedModifierDetail.modifierName;
// //           });
// //
// //           if (modifierDetailIndex != -1) {
// //             selectedIndexes.add(modifierDetails[modifierDetailIndex]);
// //           }
// //         }
// //
// //         if (selectedIndexes.isNotEmpty) {
// //           selectedModifiers[modifierIndex] = selectedIndexes;
// //         }
// //       }
// //     }
// //   }
// //
// //
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return  widget.modifierModel.modifiers!.isEmpty ? Container(
// //       child: Center(
// //         child: Text("No Modifiers"),
// //       ),
// //
// //     ): SingleChildScrollView(
// //       child: Column(
// //         children: [
// //           const Text(
// //             "Modifiers",
// //             style: TextStyle(
// //               fontWeight: FontWeight.w800,
// //               color: Colors.black,
// //               fontSize: 20,
// //             ),
// //           ),
// //           const SizedBox(height: 5),
// //            ListView.builder(
// //             itemCount: widget.modifierModel.modifiers!.length,
// //             shrinkWrap: true,
// //             itemBuilder: (context, modifierIndex) {
// //               var modifierType = widget.modifierModel.modifiers![modifierIndex].modifierType;
// //               var modifierDetails = widget.modifierModel.modifiers![modifierIndex].modifierDetails!;
// //               return ExpansionTile(
// //                 title: Text(
// //                   modifierType.toString(),
// //                   style: TextStyle(
// //                     fontWeight: FontWeight.w800,
// //                     color: Color(Constants.colorTheme),
// //                     fontSize: 17,
// //                   ),
// //                 ),
// //                 children: [
// //                   ListView.builder(
// //                     padding: EdgeInsets.zero,
// //                     shrinkWrap: true,
// //                     physics: const NeverScrollableScrollPhysics(),
// //                     itemCount: modifierDetails.length,
// //                     itemBuilder: (context, modifierDetailIndex) {
// //                       var modifierDetail = modifierDetails[modifierDetailIndex];
// //                       return CheckboxListTile(
// //                         checkColor: selectedModifiers.containsKey(modifierIndex) &&
// //                             selectedModifiers[modifierIndex]!.contains(modifierDetail)
// //                             ? Color(Constants.colorTheme)
// //                             : null,
// //                         title: Text(modifierDetail.modifierName.toString()),
// //                         subtitle: Text(
// //                           "Price " +
// //                               double.parse(modifierDetail.modifierPrice.toString()).toStringAsFixed(2),
// //                         ),
// //                         onChanged: (bool? value) {
// //                           setState(() {
// //                             if (value == true) {
// //                               if (!selectedModifiers.containsKey(modifierIndex)) {
// //                                 selectedModifiers[modifierIndex] = [modifierDetail];
// //                               } else {
// //                                 selectedModifiers[modifierIndex]!.add(modifierDetail);
// //                               }
// //                             } else {
// //                               selectedModifiers[modifierIndex]!.remove(modifierDetail);
// //                               if (selectedModifiers[modifierIndex]!.isEmpty) {
// //                                 selectedModifiers.remove(modifierIndex);
// //                               }
// //                             }
// //
// //                             dynamic data = convertToModifiersList(selectedModifiers);
// //                             // Pass the selected modifiers to the callback function
// //                             widget.onModifiersSelected(data);
// //                           });
// //                         },
// //                         value: selectedModifiers.containsKey(modifierIndex) &&
// //                             selectedModifiers[modifierIndex]!.contains(modifierDetail),
// //                       );
// //                     },
// //                   ),
// //                 ],
// //               );
// //             },
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// //
// // ///First
// //   // List<Modifier> convertToModifiersList(Map<int, List<ModifierDetail>> selectedModifiers) {
// //   //   List<Modifier> modifiersList = [];
// //   //
// //   //   selectedModifiers.forEach((modifierIndex, modifierDetailIndices) {
// //   //     List<ModifierDetail> modifierDetails = modifierDetailIndices.map((modifierDetailIndex) {
// //   //       return widget.modifierModel.modifiers![modifierIndex].modifierDetails![modifierDetailIndex];
// //   //     }).toList();
// //   //
// //   //     Modifier modifier = Modifier(
// //   //       modifierType: widget.modifierModel.modifiers![modifierIndex].modifierType.toString(),
// //   //       modifierDetails: modifierDetails,
// //   //     );
// //   //     modifiersList.add(modifier);
// //   //   });
// //   //
// //   //   return modifiersList;
// //   // }
// //
// //   ///Second
// //   // List<Modifier> convertToModifiersList(Map<int, List<int>> selectedModifiers) {
// //   //   List<Modifier> modifiersList = [];
// //   //
// //   //   selectedModifiers.forEach((modifierIndex, modifierDetailIndices) {
// //   //     List<ModifierDetail> modifierDetails = modifierDetailIndices.map((modifierDetailIndex) {
// //   //       return widget.modifierModel.modifiers![modifierIndex].modifierDetails![modifierDetailIndex];
// //   //     }).toList();
// //   //
// //   //     Modifier modifier = Modifier(
// //   //       modifierType: widget.modifierModel.modifiers![modifierIndex].modifierType.toString(),
// //   //       modifierDetails: modifierDetails,
// //   //     );
// //   //     modifiersList.add(modifier);
// //   //   });
// //   //
// //   //   return modifiersList;
// //   // }
// //
// // ///Third
// //   List<Modifier> convertToModifiersList(Map<int, List<ModifierDetail>> selectedModifiers) {
// //     List<Modifier> modifiersList = [];
// //
// //     selectedModifiers.forEach((modifierIndex, modifierDetails) {
// //       Modifier modifier = Modifier(
// //         modifierType: widget.modifierModel.modifiers![modifierIndex].modifierType.toString(),
// //         modifierDetails: modifierDetails,
// //       );
// //       modifiersList.add(modifier);
// //     });
// //
// //     return modifiersList;
// //   }
// //
// // }
//
// ///Seventh
// ///// modifier.modifierType.toString().toLowerCase().contains(query.toLowerCase()) ||
// ///First
// // void filterModifiers(String query) {
// //   if (query.isEmpty) {
// //     setState(() {
// //       filteredModifiers = List.from(widget.modifierModel.modifiers!);
// //       isExpandedList = List.filled(widget.modifierModel.modifiers!.length, false);
// //     });
// //   } else {
// //     setState(() {
// //       filteredModifiers = widget.modifierModel.modifiers!
// //           .where((modifier) =>
// //       modifier.modifierType.toString().toLowerCase().contains(query.toLowerCase()) ||
// //           modifier.modifierDetails!
// //               .any((modifierDetail) => modifierDetail.modifierName!.toLowerCase().contains(query.toLowerCase())))
// //           .toList();
// //       isExpandedList = List.filled(filteredModifiers.length, true);
// //     });
// //   }
// // }
//
// ///Second
// //   void filterModifiers(String query) {
// //     if (query.isEmpty) {
// //       setState(() {
// //         filteredModifiers = List.from(widget.modifierModel.modifiers!);
// //         isExpandedList = List.filled(widget.modifierModel.modifiers!.length, false);
// //       });
// //     } else {
// //       setState(() {
// //         filteredModifiers = widget.modifierModel.modifiers!
// //             .where((modifier) =>
// //             modifier.modifierDetails!
// //                 .any((modifierDetail) =>
// //                 modifierDetail.modifierName!.toLowerCase().contains(query.toLowerCase())))
// //             .toList();
// //         isExpandedList = List.filled(filteredModifiers.length, true);
// //         for (var modifier in widget.modifierModel.modifiers!) {
// //           if (!filteredModifiers.contains(modifier)) {
// //             modifier.modifierDetails!.clear();
// //           } else {
// //             modifier.modifierDetails!.removeWhere((modifierDetail) =>
// //             !modifierDetail.modifierName!.toLowerCase().contains(query.toLowerCase()));
// //           }
// //         }
// //       });
// //     }
// //   }
// class ModifiersOnly extends StatefulWidget {
//   ModifierModel modifierModel;
//   Function(List<Modifier>) onModifiersSelected;
//   List<Modifier> cartModifiers;
//
//   ModifiersOnly({
//     Key? key,
//     required this.modifierModel,
//     required this.onModifiersSelected,
//     required this.cartModifiers,
//   }) : super(key: key);
//
//   @override
//   State<ModifiersOnly> createState() => _ModifiersOnlyState();
// }
//
// class _ModifiersOnlyState extends State<ModifiersOnly> {
//   Map<int, List<ModifierDetail>> selectedModifiers = {};
//   TextEditingController searchController = TextEditingController();
//   List<Modifier> filteredModifiers = [];
//   List<bool> isExpandedList = [];
//
//   @override
//   void initState() {
//     super.initState();
//     initializeSelectedModifiers();
//     filteredModifiers = List.from(widget.modifierModel.modifiers!);
//     isExpandedList = List.filled(widget.modifierModel.modifiers!.length, false);
//   }
//
//   void initializeSelectedModifiers() {
//     // Iterate through the cartModifiers and populate the selectedModifiers map
//     for (var cartModifier in widget.cartModifiers) {
//       var modifierIndex = widget.modifierModel.modifiers!.indexWhere((modifier) {
//         return modifier.modifierType.toString() == cartModifier.modifierType;
//       });
//
//       if (modifierIndex != -1) {
//         var modifierDetails = widget.modifierModel.modifiers![modifierIndex].modifierDetails!;
//         var selectedModifierDetails = cartModifier.modifierDetails;
//
//         List<ModifierDetail> selectedIndexes = [];
//
//         for (var selectedModifierDetail in selectedModifierDetails!) {
//           var modifierDetailIndex = modifierDetails.indexWhere((modifierDetail) {
//             return modifierDetail.modifierName == selectedModifierDetail.modifierName;
//           });
//
//           if (modifierDetailIndex != -1) {
//             selectedIndexes.add(modifierDetails[modifierDetailIndex]);
//           }
//         }
//
//         if (selectedIndexes.isNotEmpty) {
//           selectedModifiers[modifierIndex] = selectedIndexes;
//         }
//       }
//     }
//   }
// ///First New
//   // void filterModifiers(String query) {
//   //   if (query.isEmpty) {
//   //     setState(() {
//   //       filteredModifiers = List.from(widget.modifierModel.modifiers!);
//   //       isExpandedList = List.filled(widget.modifierModel.modifiers!.length, false);
//   //     });
//   //   } else {
//   //     setState(() {
//   //       filteredModifiers = widget.modifierModel.modifiers!
//   //           .where((modifier) =>
//   //       modifier.modifierType.toString().toLowerCase().contains(query.toLowerCase()) ||
//   //           modifier.modifierDetails!
//   //               .any((modifierDetail) =>
//   //               modifierDetail.modifierName!.toLowerCase().contains(query.toLowerCase())))
//   //           .toList();
//   //       isExpandedList = List.filled(filteredModifiers.length, true);
//   //       for (var modifier in widget.modifierModel.modifiers!) {
//   //         if (!filteredModifiers.contains(modifier)) {
//   //           modifier.modifierDetails!.clear();
//   //         } else {
//   //           modifier.modifierDetails!.removeWhere((modifierDetail) =>
//   //           !modifierDetail.modifierName!.toLowerCase().contains(query.toLowerCase()));
//   //         }
//   //       }
//   //     });
//   //   }
//   // }
//
//   ///Second New
//   // void filterModifiers(String query) {
//   //   if (query.isEmpty) {
//   //     setState(() {
//   //       filteredModifiers = List.from(widget.modifierModel.modifiers!);
//   //       isExpandedList = List.filled(widget.modifierModel.modifiers!.length, false);
//   //     });
//   //   } else {
//   //     setState(() {
//   //       filteredModifiers = widget.modifierModel.modifiers!
//   //           .where((modifier) =>
//   //           modifier.modifierDetails!
//   //               .any((modifierDetail) =>
//   //               modifierDetail.modifierName!.toLowerCase().contains(query.toLowerCase())))
//   //           .toList();
//   //       isExpandedList = List.filled(filteredModifiers.length, true);
//   //       for (var modifier in widget.modifierModel.modifiers!) {
//   //         if (!filteredModifiers.contains(modifier)) {
//   //           modifier.modifierDetails!.clear();
//   //         } else {
//   //           modifier.modifierDetails!.removeWhere((modifierDetail) =>
//   //           !modifierDetail.modifierName!.toLowerCase().contains(query.toLowerCase()));
//   //         }
//   //       }
//   //     });
//   //   }
//   // }
//
//   ///Third New
//
//   // Define a backup of the original modifier details
//   List<List<ModifierDetail>> originalModifierDetails = [];
//
//   void filterModifiers(String query) {
//     setState(() {
//       if (query.isEmpty) {
//         // Restore the original modifier details
//         for (var i = 0; i < widget.modifierModel.modifiers!.length; i++) {
//           var modifier = widget.modifierModel.modifiers![i];
//           modifier.modifierDetails = List.from(originalModifierDetails[i]);
//         }
//         filteredModifiers = List.from(widget.modifierModel.modifiers!);
//         isExpandedList = List.filled(widget.modifierModel.modifiers!.length, false);
//       } else {
//         // Update the filteredModifiers list based on the search query
//         filteredModifiers = widget.modifierModel.modifiers!
//             .where((modifier) =>
//             modifier.modifierDetails!
//                 .any((modifierDetail) =>
//                 modifierDetail.modifierName!.toLowerCase().contains(query.toLowerCase())))
//             .toList();
//         isExpandedList = List.filled(filteredModifiers.length, true);
//
//         // Backup the original modifier details if it hasn't been done yet
//         if (originalModifierDetails.isEmpty) {
//           originalModifierDetails = widget.modifierModel.modifiers!
//               .map((modifier) => List<ModifierDetail>.from(modifier.modifierDetails!))
//               .toList();
//         }
//
//         // Modify the modifier details based on the search query
//         for (var modifier in widget.modifierModel.modifiers!) {
//           if (!filteredModifiers.contains(modifier)) {
//             modifier.modifierDetails!.clear();
//           } else {
//             modifier.modifierDetails!.removeWhere((modifierDetail) =>
//             !modifierDetail.modifierName!.toLowerCase().contains(query.toLowerCase()));
//           }
//         }
//       }
//     });
//   }
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return widget.modifierModel.modifiers!.isEmpty
//         ? Container(
//       child: Center(
//         child: Text("No Modifiers"),
//       ),
//     )
//         : SingleChildScrollView(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Stack(
//             alignment: Alignment.centerRight,
//             children: [
//               Align(
//                 alignment: Alignment.center,
//                 child: Text(
//                   "Modifiers",
//                   style: TextStyle(
//                     fontWeight: FontWeight.w800,
//                     color: Colors.black,
//                     fontSize: 20,
//                   ),
//                 ),
//               ),
//               IconButton(
//                 onPressed: () {
//                   Get.back();
//                 },
//                 icon: Icon(Icons.clear),
//               ),
//             ],
//           ),
//
//           TextField(
//             controller: searchController,
//             onChanged: (value) {
//               filterModifiers(value);
//             },
//             decoration: InputDecoration(
//               hintText: 'Search modifiers...',
//             ),
//           ),
//           const SizedBox(height: 10),
//           ListView.builder(
//             padding: EdgeInsets.zero,
//             itemCount: filteredModifiers.length,
//             shrinkWrap: true,
//             physics: const NeverScrollableScrollPhysics(),
//             itemBuilder: (context, modifierIndex) {
//               var modifierType = filteredModifiers[modifierIndex].modifierType;
//               var modifierDetails = filteredModifiers[modifierIndex].modifierDetails!;
//               return Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   InkWell(
//                     child: Container(
//                       padding: EdgeInsets.symmetric(vertical: 4),
//                       child: Text(
//                         modifierType.toString(),
//                         style: TextStyle(
//                           fontWeight: FontWeight.w800,
//                           color: Color(Constants.colorTheme),
//                           fontSize: 18,
//                         ),
//                       ),
//                     ),
//                     onTap: () {
//                       setState(() {
//                         isExpandedList[modifierIndex] = !isExpandedList[modifierIndex];
//                       });
//                     },
//                   ),
//                   if (isExpandedList[modifierIndex])
//                     ListView.builder(
//                       padding: EdgeInsets.zero,
//                       shrinkWrap: true,
//                       physics: const NeverScrollableScrollPhysics(),
//                       itemCount: modifierDetails.length,
//                       itemBuilder: (context, modifierDetailIndex) {
//                         var modifierDetail = modifierDetails[modifierDetailIndex];
//                         return InkWell(
//                           splashColor: Colors.transparent,
//                           highlightColor: Colors.transparent,
//                           hoverColor: Colors.transparent,
//                           onTap: () {
//                             setState(() {
//                               bool isSelected = selectedModifiers.containsKey(modifierIndex) &&
//                                   selectedModifiers[modifierIndex]!.contains(modifierDetail);
//
//                               if (isSelected) {
//                                 selectedModifiers[modifierIndex]!.remove(modifierDetail);
//                                 if (selectedModifiers[modifierIndex]!.isEmpty) {
//                                   selectedModifiers.remove(modifierIndex);
//                                 }
//                               } else {
//                                 if (!selectedModifiers.containsKey(modifierIndex)) {
//                                   selectedModifiers[modifierIndex] = [modifierDetail];
//                                 } else {
//                                   selectedModifiers[modifierIndex]!.add(modifierDetail);
//                                 }
//                               }
//
//                               dynamic data = convertToModifiersList(selectedModifiers);
//                               widget.onModifiersSelected(data);
//                             });
//                           },
//                           child: Row(
//                             children: [
//                               Transform.scale(
//                                 scale: 1,
//                                 child: Checkbox(
//                                   visualDensity: VisualDensity.adaptivePlatformDensity,
//                                   checkColor: selectedModifiers.containsKey(modifierIndex) &&
//                                       selectedModifiers[modifierIndex]!.contains(modifierDetail)
//                                       ? Color(Constants.colorTheme)
//                                       : null,
//                                   value: selectedModifiers.containsKey(modifierIndex) &&
//                                       selectedModifiers[modifierIndex]!.contains(modifierDetail),
//                                   onChanged: (bool? value) {
//                                     setState(() {
//                                       if (value == true) {
//                                         if (!selectedModifiers.containsKey(modifierIndex)) {
//                                           selectedModifiers[modifierIndex] = [modifierDetail];
//                                         } else {
//                                           selectedModifiers[modifierIndex]!.add(modifierDetail);
//                                         }
//                                       } else {
//                                         selectedModifiers[modifierIndex]!.remove(modifierDetail);
//                                         if (selectedModifiers[modifierIndex]!.isEmpty) {
//                                           selectedModifiers.remove(modifierIndex);
//                                         }
//                                       }
//
//                                       dynamic data = convertToModifiersList(selectedModifiers);
//                                       widget.onModifiersSelected(data);
//                                     });
//                                   },
//                                 ),
//                                 ),
//                               SizedBox(width: 10),
//                               Text(modifierDetail.modifierName.toString()),
//                               SizedBox(width: 10),
//                               Text(double.parse(modifierDetail.modifierPrice.toString()).toStringAsFixed(2)),
//                             ],
//                           ),
//                         );
//                       },
//                     ),
//
//                 ],
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }
//
//   List<Modifier> convertToModifiersList(Map<int, List<ModifierDetail>> selectedModifiers) {
//     List<Modifier> modifiersList = [];
//
//     selectedModifiers.forEach((modifierIndex, modifierDetails) {
//       Modifier modifier = Modifier(
//         modifierType: widget.modifierModel.modifiers![modifierIndex].modifierType.toString(),
//         modifierDetails: modifierDetails,
//       );
//       modifiersList.add(modifier);
//     });
//
//     return modifiersList;
//   }
// }
//
//
// ///Seventh With expansion tile but not working properly
// // class _ModifiersOnlyState extends State<ModifiersOnly> {
// //   Map<int, List<ModifierDetail>> selectedModifiers = {};
// //   TextEditingController searchController = TextEditingController();
// //   List<Modifier> filteredModifiers = [];
// //   List<bool> isExpandedList = [];
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     initializeSelectedModifiers();
// //     filteredModifiers = List.from(widget.modifierModel.modifiers!);
// //     isExpandedList = List.filled(widget.modifierModel.modifiers!.length, false);
// //   }
// //
// //   void initializeSelectedModifiers() {
// //     // Iterate through the cartModifiers and populate the selectedModifiers map
// //     for (var cartModifier in widget.cartModifiers) {
// //       var modifierIndex = widget.modifierModel.modifiers!.indexWhere((modifier) {
// //         return modifier.modifierType.toString() == cartModifier.modifierType;
// //       });
// //
// //       if (modifierIndex != -1) {
// //         var modifierDetails = widget.modifierModel.modifiers![modifierIndex].modifierDetails!;
// //         var selectedModifierDetails = cartModifier.modifierDetails;
// //
// //         List<ModifierDetail> selectedIndexes = [];
// //
// //         for (var selectedModifierDetail in selectedModifierDetails!) {
// //           var modifierDetailIndex = modifierDetails.indexWhere((modifierDetail) {
// //             return modifierDetail.modifierName == selectedModifierDetail.modifierName;
// //           });
// //
// //           if (modifierDetailIndex != -1) {
// //             selectedIndexes.add(modifierDetails[modifierDetailIndex]);
// //           }
// //         }
// //
// //         if (selectedIndexes.isNotEmpty) {
// //           selectedModifiers[modifierIndex] = selectedIndexes;
// //         }
// //       }
// //     }
// //   }
// //
// //   void filterModifiers(String query) {
// //     if (query.isEmpty) {
// //       setState(() {
// //         filteredModifiers = List.from(widget.modifierModel.modifiers!);
// //         isExpandedList = List.filled(widget.modifierModel.modifiers!.length, false);
// //       });
// //     } else {
// //       setState(() {
// //         filteredModifiers = widget.modifierModel.modifiers!
// //             .where((modifier) =>
// //         modifier.modifierType.toString().toLowerCase().contains(query.toLowerCase()) ||
// //             modifier.modifierDetails!
// //                 .any((modifierDetail) => modifierDetail.modifierName!.toLowerCase().contains(query.toLowerCase())))
// //             .toList();
// //         isExpandedList = List.filled(filteredModifiers.length, true);
// //       });
// //     }
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return widget.modifierModel.modifiers!.isEmpty
// //         ? Container(
// //       child: Center(
// //         child: Text("No Modifiers"),
// //       ),
// //     )
// //         : SingleChildScrollView(
// //       child: Column(
// //         children: [
// //           TextField(
// //             controller: searchController,
// //             onChanged: (value) {
// //               filterModifiers(value);
// //             },
// //             decoration: InputDecoration(
// //               hintText: 'Search modifiers...',
// //             ),
// //           ),
// //           const SizedBox(height: 10),
// //           const Text(
// //             "Modifiers",
// //             style: TextStyle(
// //               fontWeight: FontWeight.w800,
// //               color: Colors.black,
// //               fontSize: 20,
// //             ),
// //           ),
// //           const SizedBox(height: 5),
// //           ListView.builder(
// //             padding: EdgeInsets.zero,
// //             itemCount: filteredModifiers.length,
// //             shrinkWrap: true,
// //             physics: const NeverScrollableScrollPhysics(),
// //             itemBuilder: (context, modifierIndex) {
// //               var modifierType = filteredModifiers[modifierIndex].modifierType;
// //               var modifierDetails = filteredModifiers[modifierIndex].modifierDetails!;
// //               return Column(
// //                 children: [
// //                   ExpansionTile(
// //                     title: Text(
// //                       modifierType.toString(),
// //                       style: TextStyle(
// //                         fontWeight: FontWeight.w800,
// //                         color: Color(Constants.colorTheme),
// //                         fontSize: 17,
// //                       ),
// //                     ),
// //                     initiallyExpanded: isExpandedList[modifierIndex],
// //                     onExpansionChanged: (expanded) {
// //                       setState(() {
// //                         isExpandedList[modifierIndex] = expanded;
// //                       });
// //                     },
// //                     children: [
// //                       ListView.builder(
// //                         padding: EdgeInsets.zero,
// //                         shrinkWrap: true,
// //                         physics: const NeverScrollableScrollPhysics(),
// //                         itemCount: modifierDetails.length,
// //                         itemBuilder: (context, modifierDetailIndex) {
// //                           var modifierDetail = modifierDetails[modifierDetailIndex];
// //                           return ListTile(
// //                             dense: true,
// //                             contentPadding: EdgeInsets.symmetric(horizontal: 20),
// //                             title: Row(
// //                               children: [
// //                                 Text(modifierDetail.modifierName.toString()),
// //                                 SizedBox(width: 10),
// //                                 Text(double.parse(modifierDetail.modifierPrice.toString()).toStringAsFixed(2)),
// //                                 SizedBox(width: 10),
// //                                 Transform.scale(
// //                                   scale: 0.8,
// //                                   child: Checkbox(
// //                                     visualDensity: VisualDensity.adaptivePlatformDensity,
// //                                     checkColor: selectedModifiers.containsKey(modifierIndex) &&
// //                                         selectedModifiers[modifierIndex]!.contains(modifierDetail)
// //                                         ? Color(Constants.colorTheme)
// //                                         : null,
// //                                     value: selectedModifiers.containsKey(modifierIndex) &&
// //                                         selectedModifiers[modifierIndex]!.contains(modifierDetail),
// //                                     onChanged: (bool? value) {
// //                                       setState(() {
// //                                         if (value == true) {
// //                                           if (!selectedModifiers.containsKey(modifierIndex)) {
// //                                             selectedModifiers[modifierIndex] = [modifierDetail];
// //                                           } else {
// //                                             selectedModifiers[modifierIndex]!.add(modifierDetail);
// //                                           }
// //                                         } else {
// //                                           selectedModifiers[modifierIndex]!.remove(modifierDetail);
// //                                           if (selectedModifiers[modifierIndex]!.isEmpty) {
// //                                             selectedModifiers.remove(modifierIndex);
// //                                           }
// //                                         }
// //
// //                                         dynamic data = convertToModifiersList(selectedModifiers);
// //                                         widget.onModifiersSelected(data);
// //                                       });
// //                                     },
// //                                   ),
// //                                 ),
// //                               ],
// //                             ),
// //                           );
// //                         },
// //                       ),
// //                     ],
// //                   ),
// //                 ],
// //               );
// //             },
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   List<Modifier> convertToModifiersList(Map<int, List<ModifierDetail>> selectedModifiers) {
// //     List<Modifier> modifiersList = [];
// //
// //     selectedModifiers.forEach((modifierIndex, modifierDetails) {
// //       Modifier modifier = Modifier(
// //         modifierType: widget.modifierModel.modifiers![modifierIndex].modifierType.toString(),
// //         modifierDetails: modifierDetails,
// //       );
// //       modifiersList.add(modifier);
// //     });
// //
// //     return modifiersList;
// //   }
// // }
//
//
//

///Last check
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/model/cart_master.dart';
import 'package:pos/utils/constants.dart';

///1st
// class ModifiersOnly extends StatefulWidget {
//   ModifierModel modifierModel;
//
//   ModifiersOnly({
//     Key? key,
//     required this.modifierModel,
//   }) : super(key: key);
//
//   @override
//   State<ModifiersOnly> createState() => _ModifiersOnlyState();
// }
//
// class _ModifiersOnlyState extends State<ModifiersOnly> {
//   CartController _cartController = Get.find<CartController>();
//
//   List<int> selectedModifiers = [];
//
//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//         itemCount: widget.modifierModel.modifiers!.length,
//         shrinkWrap: true,
//         itemBuilder: (context, modifierIndex) {
//           return Column(children: [
//             Text(
//               widget.modifierModel.modifiers![modifierIndex].modifierType.toString(),
//               style: TextStyle(
//                 fontWeight: FontWeight.w800,
//                 color: Color(Constants.colorTheme),
//                 fontSize: 17,
//               ),
//             ),
//             ListView.builder(
//                 padding: EdgeInsets.zero,
//                 shrinkWrap: true,
//                 physics: const NeverScrollableScrollPhysics(),
//                 itemCount: widget.modifierModel
//                     .modifiers![modifierIndex].modifierDetails!.length,
//                 itemBuilder: (context, modifierDetailIndex) {
//               return CheckboxListTile(
//                   checkColor: selectedModifiers.contains(modifierDetailIndex) ? Color(Constants.colorTheme) : null,
//                   title: Text(widget.modifierModel
//                       .modifiers![modifierIndex].modifierDetails![modifierDetailIndex].modifierName.toString()),
//                   subtitle: Text("Price "+double.parse(widget.modifierModel
//                       .modifiers![modifierIndex].modifierDetails![modifierDetailIndex].modifierPrice.toString()).toStringAsFixed(2)),
//                 onChanged: (bool? value) {
//                   setState(() {
//                     if (value == true) {
//                       selectedModifiers.add(modifierDetailIndex);
//                     } else {
//                       selectedModifiers.remove(modifierDetailIndex);
//                     }
//                   });
//                 },
//                 value: selectedModifiers.contains(modifierDetailIndex),);
//                 })
//           ]);
//         });
//   }
// }

///Second
// class ModifiersOnly extends StatefulWidget {
//   ModifierModel modifierModel;
//
//   ModifiersOnly({
//     Key? key,
//     required this.modifierModel,
//   }) : super(key: key);
//
//   @override
//   State<ModifiersOnly> createState() => _ModifiersOnlyState();
// }
//
// class _ModifiersOnlyState extends State<ModifiersOnly> {
//   CartController _cartController = Get.find<CartController>();
//
//   Map<int, int> selectedModifiers = {}; // Map to store selected indices per modifier type
//
//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       itemCount: widget.modifierModel.modifiers!.length,
//       shrinkWrap: true,
//       itemBuilder: (context, modifierIndex) {
//         var modifierType = widget.modifierModel.modifiers![modifierIndex].modifierType;
//         return Column(
//           children: [
//             Text(
//               modifierType.toString(),
//               style: TextStyle(
//                 fontWeight: FontWeight.w800,
//                 color: Color(Constants.colorTheme),
//                 fontSize: 17,
//               ),
//             ),
//             ListView.builder(
//               padding: EdgeInsets.zero,
//               shrinkWrap: true,
//               physics: const NeverScrollableScrollPhysics(),
//               itemCount: widget.modifierModel.modifiers![modifierIndex].modifierDetails!.length,
//               itemBuilder: (context, modifierDetailIndex) {
//                 var modifierDetail =
//                 widget.modifierModel.modifiers![modifierIndex].modifierDetails![modifierDetailIndex];
//                 return CheckboxListTile(
//                   checkColor: selectedModifiers.containsKey(modifierIndex) &&
//                       selectedModifiers[modifierIndex] == modifierDetailIndex
//                       ? Color(Constants.colorTheme)
//                       : null,
//                   title: Text(modifierDetail.modifierName.toString()),
//                   subtitle: Text("Price " +
//                       double.parse(modifierDetail.modifierPrice.toString()).toStringAsFixed(2)),
//                   onChanged: (bool? value) {
//                     setState(() {
//                       if (value == true) {
//                         selectedModifiers[modifierIndex] = modifierDetailIndex;
//                       } else {
//                         selectedModifiers.remove(modifierIndex);
//                       }
//                     });
//                   },
//                   value: selectedModifiers.containsKey(modifierIndex) &&
//                       selectedModifiers[modifierIndex] == modifierDetailIndex,
//                 );
//               },
//             )
//           ],
//         );
//       },
//     );
//   }
// }

///Third Without Data
// class ModifiersOnly extends StatefulWidget {
//   ModifierModel modifierModel;
//
//   ModifiersOnly({
//     Key? key,
//     required this.modifierModel,
//   }) : super(key: key);
//
//   @override
//   State<ModifiersOnly> createState() => _ModifiersOnlyState();
// }
//
// class _ModifiersOnlyState extends State<ModifiersOnly> {
//   CartController _cartController = Get.find<CartController>();
//
//   Map<int, List<int>> selectedModifiers = {}; // Map to store selected indices per modifier type
//
//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       itemCount: widget.modifierModel.modifiers!.length,
//       shrinkWrap: true,
//       itemBuilder: (context, modifierIndex) {
//         var modifierType = widget.modifierModel.modifiers![modifierIndex].modifierType;
//         return Column(
//           children: [
//             Text(
//               modifierType.toString(),
//               style: TextStyle(
//                 fontWeight: FontWeight.w800,
//                 color: Color(Constants.colorTheme),
//                 fontSize: 17,
//               ),
//             ),
//             ListView.builder(
//               padding: EdgeInsets.zero,
//               shrinkWrap: true,
//               physics: const NeverScrollableScrollPhysics(),
//               itemCount: widget.modifierModel.modifiers![modifierIndex].modifierDetails!.length,
//               itemBuilder: (context, modifierDetailIndex) {
//                 var modifierDetail =
//                 widget.modifierModel.modifiers![modifierIndex].modifierDetails![modifierDetailIndex];
//                 return CheckboxListTile(
//                   checkColor: selectedModifiers.containsKey(modifierIndex) &&
//                       selectedModifiers[modifierIndex]!.contains(modifierDetailIndex)
//                       ? Color(Constants.colorTheme)
//                       : null,
//                   title: Text(modifierDetail.modifierName.toString()),
//                   subtitle: Text("Price " +
//                       double.parse(modifierDetail.modifierPrice.toString()).toStringAsFixed(2)),
//                   onChanged: (bool? value) {
//                     setState(() {
//                       if (value == true) {
//                         if (!selectedModifiers.containsKey(modifierIndex)) {
//                           selectedModifiers[modifierIndex] = [modifierDetailIndex];
//                         } else {
//                           selectedModifiers[modifierIndex]!.add(modifierDetailIndex);
//                         }
//                       } else {
//                         selectedModifiers[modifierIndex]!.remove(modifierDetailIndex);
//                         if (selectedModifiers[modifierIndex]!.isEmpty) {
//                           selectedModifiers.remove(modifierIndex);
//                         }
//                       }
//                     });
//                   },
//                   value: selectedModifiers.containsKey(modifierIndex) &&
//                       selectedModifiers[modifierIndex]!.contains(modifierDetailIndex),
//                 );
//               },
//             )
//           ],
//         );
//       },
//     );
//   }
// }

///Third With data
// class ModifiersOnly extends StatefulWidget {
//   ModifierModel modifierModel;
//
//   ModifiersOnly({
//     Key? key,
//     required this.modifierModel,
//   }) : super(key: key);
//
//   @override
//   State<ModifiersOnly> createState() => _ModifiersOnlyState();
// }
//
// class _ModifiersOnlyState extends State<ModifiersOnly> {
//   CartController _cartController = Get.find<CartController>();
//
//   Map<int, List<ModifierDetail>> selectedModifiers = {}; // Map to store selected items per modifier type
//
//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       itemCount: widget.modifierModel.modifiers!.length,
//       shrinkWrap: true,
//       itemBuilder: (context, modifierIndex) {
//         var modifierType = widget.modifierModel.modifiers![modifierIndex].modifierType;
//         return Column(
//           children: [
//             Text(
//               modifierType.toString(),
//               style: TextStyle(
//                 fontWeight: FontWeight.w800,
//                 color: Color(Constants.colorTheme),
//                 fontSize: 17,
//               ),
//             ),
//             ListView.builder(
//               padding: EdgeInsets.zero,
//               shrinkWrap: true,
//               physics: const NeverScrollableScrollPhysics(),
//               itemCount: widget.modifierModel.modifiers![modifierIndex].modifierDetails!.length,
//               itemBuilder: (context, modifierDetailIndex) {
//                 var modifierDetail =
//                 widget.modifierModel.modifiers![modifierIndex].modifierDetails![modifierDetailIndex];
//                 return CheckboxListTile(
//                   checkColor: selectedModifiers.containsKey(modifierIndex) &&
//                       selectedModifiers[modifierIndex]!.contains(modifierDetail)
//                       ? Color(Constants.colorTheme)
//                       : null,
//                   title: Text(modifierDetail.modifierName.toString()),
//                   subtitle: Text("Price " +
//                       double.parse(modifierDetail.modifierPrice.toString()).toStringAsFixed(2)),
//                   onChanged: (bool? value) {
//                     setState(() {
//                       if (value == true) {
//                         if (!selectedModifiers.containsKey(modifierIndex)) {
//                           selectedModifiers[modifierIndex] = [modifierDetail];
//                         } else {
//                           selectedModifiers[modifierIndex]!.add(modifierDetail);
//                         }
//                       } else {
//                         selectedModifiers[modifierIndex]!.remove(modifierDetail);
//                         if (selectedModifiers[modifierIndex]!.isEmpty) {
//                           selectedModifiers.remove(modifierIndex);
//                         }
//                       }
//                     });
//                   },
//                   value: selectedModifiers.containsKey(modifierIndex) &&
//                       selectedModifiers[modifierIndex]!.contains(modifierDetail),
//                 );
//               },
//             )
//           ],
//         );
//       },
//     );
//   }
// }

///Forth
// class ModifiersOnly extends StatefulWidget {
//   ModifierModel modifierModel;
//
//
//   ModifiersOnly({
//     Key? key,
//     required this.modifierModel,
//   }) : super(key: key);
//
//   @override
//   State<ModifiersOnly> createState() => _ModifiersOnlyState();
// }
//
// class _ModifiersOnlyState extends State<ModifiersOnly> {
//   Map<int, List<int>> selectedModifiers = {};
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         const Text(
//           "Modifiers",
//           style: TextStyle(
//             fontWeight: FontWeight.w800,
//             color: Colors.black,
//             fontSize: 20,
//           ),
//         ),
//         const SizedBox(height: 5),
//         ListView.builder(
//           itemCount: widget.modifierModel.modifiers!.length,
//           shrinkWrap: true,
//           itemBuilder: (context, modifierIndex) {
//             var modifierType = widget.modifierModel.modifiers![modifierIndex].modifierType;
//             var modifierDetails = widget.modifierModel.modifiers![modifierIndex].modifierDetails!;
//             return ExpansionTile(
//               title: Text(
//                 modifierType.toString(),
//                 style: TextStyle(
//                   fontWeight: FontWeight.w800,
//                   color: Color(Constants.colorTheme),
//                   fontSize: 17,
//                 ),
//               ),
//               children: [
//                 ListView.builder(
//                   padding: EdgeInsets.zero,
//                   shrinkWrap: true,
//                   physics: const NeverScrollableScrollPhysics(),
//                   itemCount: modifierDetails.length,
//                   itemBuilder: (context, modifierDetailIndex) {
//                     var modifierDetail = modifierDetails[modifierDetailIndex];
//                     return CheckboxListTile(
//                       checkColor: selectedModifiers.containsKey(modifierIndex) &&
//                           selectedModifiers[modifierIndex]!.contains(modifierDetailIndex)
//                           ? Color(Constants.colorTheme)
//                           : null,
//                       title: Text(modifierDetail.modifierName.toString()),
//                       subtitle: Text("Price " +
//                           double.parse(modifierDetail.modifierPrice.toString()).toStringAsFixed(2)),
//                       onChanged: (bool? value) {
//                         setState(() {
//                           if (value == true) {
//                             if (!selectedModifiers.containsKey(modifierIndex)) {
//                               selectedModifiers[modifierIndex] = [modifierDetailIndex];
//                             } else {
//                               selectedModifiers[modifierIndex]!.add(modifierDetailIndex);
//                             }
//                           } else {
//                             selectedModifiers[modifierIndex]!.remove(modifierDetailIndex);
//                             if (selectedModifiers[modifierIndex]!.isEmpty) {
//                               selectedModifiers.remove(modifierIndex);
//                             }
//                           }
//                         });
//                       },
//                       value: selectedModifiers.containsKey(modifierIndex) &&
//                           selectedModifiers[modifierIndex]!.contains(modifierDetailIndex),
//                     );
//                   },
//                 ),
//               ],
//             );
//           },
//         ),
//       ],
//     );
//   }
// }

///Fifth
// class ModifiersOnly extends StatefulWidget {
//   ModifierModel modifierModel;
//   Function(List<Modifier>) onModifiersSelected; // Callback function to handle selected modifiers
//
//   ModifiersOnly({
//     Key? key,
//     required this.modifierModel,
//     required this.onModifiersSelected,
//   }) : super(key: key);
//
//   @override
//   State<ModifiersOnly> createState() => _ModifiersOnlyState();
// }
//
// class _ModifiersOnlyState extends State<ModifiersOnly> {
//   List<Modifier> selectedModifiers = [];
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         const Text(
//           "Modifiers",
//           style: TextStyle(
//             fontWeight: FontWeight.w800,
//             color: Colors.black,
//             fontSize: 20,
//           ),
//         ),
//         const SizedBox(height: 5),
//         ListView.builder(
//           itemCount: widget.modifierModel.modifiers!.length,
//           shrinkWrap: true,
//           itemBuilder: (context, modifierIndex) {
//             var modifierType = widget.modifierModel.modifiers![modifierIndex].modifierType;
//             var modifierDetails = widget.modifierModel.modifiers![modifierIndex].modifierDetails!;
//             return ExpansionTile(
//               title: Text(
//                 modifierType.toString(),
//                 style: TextStyle(
//                   fontWeight: FontWeight.w800,
//                   color: Color(Constants.colorTheme),
//                   fontSize: 17,
//                 ),
//               ),
//               children: [
//                 ListView.builder(
//                   padding: EdgeInsets.zero,
//                   shrinkWrap: true,
//                   physics: const NeverScrollableScrollPhysics(),
//                   itemCount: modifierDetails.length,
//                   itemBuilder: (context, modifierDetailIndex) {
//                     var modifierDetail = modifierDetails[modifierDetailIndex];
//                     return CheckboxListTile(
//                       checkColor: selectedModifiers.contains(modifierDetail)
//                           ? Color(Constants.colorTheme)
//                           : null,
//                       title: Text(modifierDetail.modifierName.toString()),
//                       subtitle: Text(
//                         "Price " +
//                             double.parse(modifierDetail.modifierPrice.toString()).toStringAsFixed(2),
//                       ),
//                       onChanged: (bool? value) {
//                         setState(() {
//                           if (value == true) {
//                             selectedModifiers.add(widget.modifierModel.modifiers![modifierIndex]);
//                           } else {
//                             selectedModifiers.remove(widget.modifierModel.modifiers![modifierIndex]);
//                           }
//
//                           // Pass the selected modifiers to the callback function
//                           widget.onModifiersSelected(selectedModifiers);
//                         });
//                       },
//                       value: selectedModifiers.contains(widget.modifierModel.modifiers![modifierIndex]),
//                     );
//                   },
//                 ),
//               ],
//             );
//           },
//         ),
//       ],
//     );
//   }
// }

///Sixth /// Fifth is not perfect
// class ModifiersOnly extends StatefulWidget {
//   ModifierModel modifierModel;
//   Function(List<Modifier>) onModifiersSelected;
//   List<Modifier> cartModifiers;
//   // Callback function to handle selected modifiers
//
//   ModifiersOnly({
//     Key? key,
//     required this.modifierModel,
//     required this.onModifiersSelected,
//     required this.cartModifiers,
//   }) : super(key: key);
//
//   @override
//   State<ModifiersOnly> createState() => _ModifiersOnlyState();
// }
//
// class _ModifiersOnlyState extends State<ModifiersOnly> {
//   Map<int, List<ModifierDetail>> selectedModifiers = {};
//
//   @override
//   void initState() {
//     super.initState();
//     initializeSelectedModifiers();
//   }
//
//
//   void initializeSelectedModifiers() {
//     for (var cartModifier in widget.cartModifiers) {
//       var modifierIndex = widget.modifierModel.modifiers!.indexWhere((modifier) {
//         return modifier.modifierType.toString() == cartModifier.modifierType;
//       });
//
//       if (modifierIndex != -1) {
//         var modifierDetails = widget.modifierModel.modifiers![modifierIndex].modifierDetails!;
//         var selectedModifierDetails = cartModifier.modifierDetails;
//
//         List<ModifierDetail> selectedIndexes = [];
//
//         for (var selectedModifierDetail in selectedModifierDetails!) {
//           var modifierDetailIndex = modifierDetails.indexWhere((modifierDetail) {
//             return modifierDetail.modifierName == selectedModifierDetail.modifierName;
//           });
//
//           if (modifierDetailIndex != -1) {
//             selectedIndexes.add(modifierDetails[modifierDetailIndex]);
//           }
//         }
//
//         if (selectedIndexes.isNotEmpty) {
//           selectedModifiers[modifierIndex] = selectedIndexes;
//         }
//       }
//     }
//   }
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return  widget.modifierModel.modifiers!.isEmpty ? Container(
//       child: Center(
//         child: Text("No Modifiers"),
//       ),
//
//     ): SingleChildScrollView(
//       child: Column(
//         children: [
//           const Text(
//             "Modifiers",
//             style: TextStyle(
//               fontWeight: FontWeight.w800,
//               color: Colors.black,
//               fontSize: 20,
//             ),
//           ),
//           const SizedBox(height: 5),
//            ListView.builder(
//             itemCount: widget.modifierModel.modifiers!.length,
//             shrinkWrap: true,
//             itemBuilder: (context, modifierIndex) {
//               var modifierType = widget.modifierModel.modifiers![modifierIndex].modifierType;
//               var modifierDetails = widget.modifierModel.modifiers![modifierIndex].modifierDetails!;
//               return ExpansionTile(
//                 title: Text(
//                   modifierType.toString(),
//                   style: TextStyle(
//                     fontWeight: FontWeight.w800,
//                     color: Color(Constants.colorTheme),
//                     fontSize: 17,
//                   ),
//                 ),
//                 children: [
//                   ListView.builder(
//                     padding: EdgeInsets.zero,
//                     shrinkWrap: true,
//                     physics: const NeverScrollableScrollPhysics(),
//                     itemCount: modifierDetails.length,
//                     itemBuilder: (context, modifierDetailIndex) {
//                       var modifierDetail = modifierDetails[modifierDetailIndex];
//                       return CheckboxListTile(
//                         checkColor: selectedModifiers.containsKey(modifierIndex) &&
//                             selectedModifiers[modifierIndex]!.contains(modifierDetail)
//                             ? Color(Constants.colorTheme)
//                             : null,
//                         title: Text(modifierDetail.modifierName.toString()),
//                         subtitle: Text(
//                           "Price " +
//                               double.parse(modifierDetail.modifierPrice.toString()).toStringAsFixed(2),
//                         ),
//                         onChanged: (bool? value) {
//                           setState(() {
//                             if (value == true) {
//                               if (!selectedModifiers.containsKey(modifierIndex)) {
//                                 selectedModifiers[modifierIndex] = [modifierDetail];
//                               } else {
//                                 selectedModifiers[modifierIndex]!.add(modifierDetail);
//                               }
//                             } else {
//                               selectedModifiers[modifierIndex]!.remove(modifierDetail);
//                               if (selectedModifiers[modifierIndex]!.isEmpty) {
//                                 selectedModifiers.remove(modifierIndex);
//                               }
//                             }
//
//                             dynamic data = convertToModifiersList(selectedModifiers);
//                             // Pass the selected modifiers to the callback function
//                             widget.onModifiersSelected(data);
//                           });
//                         },
//                         value: selectedModifiers.containsKey(modifierIndex) &&
//                             selectedModifiers[modifierIndex]!.contains(modifierDetail),
//                       );
//                     },
//                   ),
//                 ],
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }
//
//
// ///Third
//   List<Modifier> convertToModifiersList(Map<int, List<ModifierDetail>> selectedModifiers) {
//     List<Modifier> modifiersList = [];
//
//     selectedModifiers.forEach((modifierIndex, modifierDetails) {
//       Modifier modifier = Modifier(
//         modifierType: widget.modifierModel.modifiers![modifierIndex].modifierType.toString(),
//         modifierDetails: modifierDetails,
//       );
//       modifiersList.add(modifier);
//     });
//
//     return modifiersList;
//   }
//
// }

///First Sixth
// class _ModifiersOnlyState extends State<ModifiersOnly> {
//   Map<int, List<ModifierDetail>> selectedModifiers = {};
//   String searchText = '';
//   List<Modifier> filteredModifiers = [];
//
//   @override
//   void initState() {
//     super.initState();
//     initializeSelectedModifiers();
//   }
//
//   void initializeSelectedModifiers() {
//     for (var cartModifier in widget.cartModifiers) {
//       var modifierIndex = widget.modifierModel.modifiers!.indexWhere((modifier) {
//         return modifier.modifierType.toString() == cartModifier.modifierType;
//       });
//
//       if (modifierIndex != -1) {
//         var modifierDetails = widget.modifierModel.modifiers![modifierIndex].modifierDetails!;
//         var selectedModifierDetails = cartModifier.modifierDetails;
//
//         List<ModifierDetail> selectedIndexes = [];
//
//         for (var selectedModifierDetail in selectedModifierDetails!) {
//           var modifierDetailIndex = modifierDetails.indexWhere((modifierDetail) {
//             return modifierDetail.modifierName == selectedModifierDetail.modifierName;
//           });
//
//           if (modifierDetailIndex != -1) {
//             selectedIndexes.add(modifierDetails[modifierDetailIndex]);
//           }
//         }
//
//         if (selectedIndexes.isNotEmpty) {
//           selectedModifiers[modifierIndex] = selectedIndexes;
//         }
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return widget.modifierModel.modifiers!.isEmpty
//         ? Container(
//       child: Center(
//         child: Text("No Modifiers"),
//       ),
//     )
//         : SingleChildScrollView(
//       child: Column(
//         children: [
//           const Text(
//             "Modifiers",
//             style: TextStyle(
//               fontWeight: FontWeight.w800,
//               color: Colors.black,
//               fontSize: 20,
//             ),
//           ),
//           const SizedBox(height: 5),
//           TextField(
//             onChanged: (value) {
//               setState(() {
//                 searchText = value;
//                 filterModifiers();
//               });
//             },
//             decoration: InputDecoration(
//               labelText: 'Search',
//             ),
//           ),
//           ListView.builder(
//             itemCount: filteredModifiers.length,
//             shrinkWrap: true,
//             itemBuilder: (context, modifierIndex) {
//               var modifierType = filteredModifiers[modifierIndex].modifierType;
//               var modifierDetails = filteredModifiers[modifierIndex].modifierDetails!;
//               return ExpansionTile(
//                 title: Text(
//                   modifierType.toString(),
//                   style: TextStyle(
//                     fontWeight: FontWeight.w800,
//                     color: Color(Constants.colorTheme),
//                     fontSize: 17,
//                   ),
//                 ),
//                 children: [
//                   ListView.builder(
//                     padding: EdgeInsets.zero,
//                     shrinkWrap: true,
//                     physics: const NeverScrollableScrollPhysics(),
//                     itemCount: modifierDetails.length,
//                     itemBuilder: (context, modifierDetailIndex) {
//                       var modifierDetail = modifierDetails[modifierDetailIndex];
//                       return CheckboxListTile(
//                         checkColor: selectedModifiers.containsKey(modifierIndex) &&
//                             selectedModifiers[modifierIndex]!.contains(modifierDetail)
//                             ? Color(Constants.colorTheme)
//                             : null,
//                         title: Text(modifierDetail.modifierName.toString()),
//                         subtitle: Text(
//                           "Price " +
//                               double.parse(modifierDetail.modifierPrice.toString()).toStringAsFixed(2),
//                         ),
//                         onChanged: (bool? value) {
//                           setState(() {
//                             if (value == true) {
//                               if (!selectedModifiers.containsKey(modifierIndex)) {
//                                 selectedModifiers[modifierIndex] = [modifierDetail];
//                               } else {
//                                 selectedModifiers[modifierIndex]!.add(modifierDetail);
//                               }
//                             } else {
//                               selectedModifiers[modifierIndex]!.remove(modifierDetail);
//                               if (selectedModifiers[modifierIndex]!.isEmpty) {
//                                 selectedModifiers.remove(modifierIndex);
//                               }
//                             }
//
//                             dynamic data = convertToModifiersList(selectedModifiers);
//                             // Pass the selected modifiers to the callback function
//                             widget.onModifiersSelected(data);
//                           });
//                         },
//                         value: selectedModifiers.containsKey(modifierIndex) &&
//                             selectedModifiers[modifierIndex]!.contains(modifierDetail),
//                       );
//                     },
//                   ),
//                 ],
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }
//
//   List<Modifier> convertToModifiersList(Map<int, List<ModifierDetail>> selectedModifiers) {
//     List<Modifier> modifiersList = [];
//
//     selectedModifiers.forEach((modifierIndex, modifierDetails) {
//       Modifier modifier = Modifier(
//         modifierType: filteredModifiers[modifierIndex].modifierType,
//         modifierDetails: modifierDetails,
//       );
//       modifiersList.add(modifier);
//     });
//
//     return modifiersList;
//   }
//
//   void filterModifiers() {
//     filteredModifiers = widget.modifierModel.modifiers!.where((modifier) {
//       return modifier.modifierDetails!.any((modifierDetail) {
//         return modifierDetail.modifierName!.toLowerCase().contains(searchText.toLowerCase());
//       });
//     }).toList();
//   }
// }

///Second Sixth perfect without first time list displayed
// class _ModifiersOnlyState extends State<ModifiersOnly> {
//   Map<String, List<ModifierDetail>> selectedModifiers = {};
//   String searchText = '';
//   List<Modifier> filteredModifiers = [];
//
//   @override
//   void initState() {
//     super.initState();
//     initializeSelectedModifiers();
//   }
//
//   void initializeSelectedModifiers() {
//     for (var cartModifier in widget.cartModifiers) {
//       var modifierType = cartModifier.modifierType;
//       var modifierDetails = cartModifier.modifierDetails;
//
//       if (modifierType != null && modifierDetails != null && modifierDetails.isNotEmpty) {
//         selectedModifiers[modifierType] = modifierDetails;
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return widget.modifierModel.modifiers!.isEmpty
//         ? Container(
//       child: Center(
//         child: Text("No Modifiers"),
//       ),
//     )
//         : SingleChildScrollView(
//       child: Column(
//         children: [
//           const Text(
//             "Modifiers",
//             style: TextStyle(
//               fontWeight: FontWeight.w800,
//               color: Colors.black,
//               fontSize: 20,
//             ),
//           ),
//           const SizedBox(height: 5),
//           TextField(
//             onChanged: (value) {
//               setState(() {
//                 searchText = value;
//                 filterModifiers();
//               });
//             },
//             decoration: InputDecoration(
//               labelText: 'Search',
//             ),
//           ),
//           ListView.builder(
//             itemCount: filteredModifiers.length,
//             shrinkWrap: true,
//             itemBuilder: (context, modifierIndex) {
//               var modifierType = filteredModifiers[modifierIndex].modifierType;
//               var modifierDetails = filteredModifiers[modifierIndex].modifierDetails!;
//               var isSelected = selectedModifiers.containsKey(modifierType) &&
//                   selectedModifiers[modifierType]!.isNotEmpty;
//
//               return ExpansionTile(
//                 title: Text(
//                   modifierType.toString(),
//                   style: TextStyle(
//                     fontWeight: FontWeight.w800,
//                     color: Color(Constants.colorTheme),
//                     fontSize: 17,
//                   ),
//                 ),
//                 children: [
//                   ListView.builder(
//                     padding: EdgeInsets.zero,
//                     shrinkWrap: true,
//                     physics: const NeverScrollableScrollPhysics(),
//                     itemCount: modifierDetails.length,
//                     itemBuilder: (context, modifierDetailIndex) {
//                       var modifierDetail = modifierDetails[modifierDetailIndex];
//                       var isDetailSelected = isSelected &&
//                           selectedModifiers[modifierType]!.contains(modifierDetail);
//
//                       return CheckboxListTile(
//                         checkColor: isDetailSelected ? Color(Constants.colorTheme) : null,
//                         title: Text(modifierDetail.modifierName.toString()),
//                         subtitle: Text(
//                           "Price " +
//                               double.parse(modifierDetail.modifierPrice.toString()).toStringAsFixed(2),
//                         ),
//                         onChanged: (bool? value) {
//                           setState(() {
//                             if (value == true) {
//                               if (!selectedModifiers.containsKey(modifierType)) {
//                                 selectedModifiers[modifierType!] = [modifierDetail];
//                               } else {
//                                 selectedModifiers[modifierType]!.add(modifierDetail);
//                               }
//                             } else {
//                               selectedModifiers[modifierType]!.remove(modifierDetail);
//                               if (selectedModifiers[modifierType]!.isEmpty) {
//                                 selectedModifiers.remove(modifierType);
//                               }
//                             }
//
//                             dynamic data = convertToModifiersList(selectedModifiers);
//                             // Pass the selected modifiers to the callback function
//                             widget.onModifiersSelected(data);
//                           });
//                         },
//                         value: isDetailSelected,
//                       );
//                     },
//                   ),
//                 ],
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }
//
//   List<Modifier> convertToModifiersList(Map<String, List<ModifierDetail>> selectedModifiers) {
//     List<Modifier> modifiersList = [];
//
//     selectedModifiers.forEach((modifierType, modifierDetails) {
//       Modifier modifier = Modifier(
//         modifierType: modifierType,
//         modifierDetails: modifierDetails,
//       );
//       modifiersList.add(modifier);
//     });
//
//     return modifiersList;
//   }
//
//   void filterModifiers() {
//     filteredModifiers = widget.modifierModel.modifiers!.where((modifier) {
//       return modifier.modifierDetails!.any((modifierDetail) {
//         return modifierDetail.modifierName!.toLowerCase().contains(searchText.toLowerCase());
//       });
//     }).toList();
//   }
// }

///Third Sixth Perfect with expansion tile
// class _ModifiersOnlyState extends State<ModifiersOnly> {
//   Map<String, List<ModifierDetail>> selectedModifiers = {};
//   String searchText = '';
//   List<Modifier> filteredModifiers = [];
//
//   @override
//   void initState() {
//     super.initState();
//     initializeSelectedModifiers();
//     filterModifiers();
//   }
//
//   void initializeSelectedModifiers() {
//     for (var cartModifier in widget.cartModifiers) {
//       var modifierType = cartModifier.modifierType;
//       var modifierDetails = cartModifier.modifierDetails;
//
//       if (modifierType != null && modifierDetails != null && modifierDetails.isNotEmpty) {
//         selectedModifiers[modifierType] = modifierDetails;
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return widget.modifierModel.modifiers!.isEmpty
//         ? Container(
//       child: Center(
//         child: Text("No Modifiers"),
//       ),
//     )
//         : SingleChildScrollView(
//       child: Column(
//         children: [
//           const Text(
//             "Modifiers",
//             style: TextStyle(
//               fontWeight: FontWeight.w800,
//               color: Colors.black,
//               fontSize: 20,
//             ),
//           ),
//           const SizedBox(height: 5),
//           TextField(
//             onChanged: (value) {
//               setState(() {
//                 searchText = value;
//                 filterModifiers();
//               });
//             },
//             decoration: InputDecoration(
//               labelText: 'Search',
//             ),
//           ),
//           ListView.builder(
//             itemCount: filteredModifiers.length,
//             shrinkWrap: true,
//             itemBuilder: (context, modifierIndex) {
//               var modifierType = filteredModifiers[modifierIndex].modifierType;
//               var modifierDetails = filteredModifiers[modifierIndex].modifierDetails!;
//               var isSelected = selectedModifiers.containsKey(modifierType) &&
//                   selectedModifiers[modifierType]!.isNotEmpty;
//
//               return ExpansionTile(
//                 title: Text(
//                   modifierType.toString(),
//                   style: TextStyle(
//                     fontWeight: FontWeight.w800,
//                     color: Color(Constants.colorTheme),
//                     fontSize: 17,
//                   ),
//                 ),
//                 children: [
//                   ListView.builder(
//                     padding: EdgeInsets.zero,
//                     shrinkWrap: true,
//                     physics: const NeverScrollableScrollPhysics(),
//                     itemCount: modifierDetails.length,
//                     itemBuilder: (context, modifierDetailIndex) {
//                       var modifierDetail = modifierDetails[modifierDetailIndex];
//                       var isDetailSelected = isSelected &&
//                           selectedModifiers[modifierType]!.contains(modifierDetail);
//
//                       return CheckboxListTile(
//                         checkColor: isDetailSelected ? Color(Constants.colorTheme) : null,
//                         title: Text(modifierDetail.modifierName.toString()),
//                         subtitle: Text(
//                           "Price " +
//                               double.parse(modifierDetail.modifierPrice.toString()).toStringAsFixed(2),
//                         ),
//                         onChanged: (bool? value) {
//                           setState(() {
//                             if (value == true) {
//                               if (!selectedModifiers.containsKey(modifierType)) {
//                                 selectedModifiers[modifierType!] = [modifierDetail];
//                               } else {
//                                 selectedModifiers[modifierType]!.add(modifierDetail);
//                               }
//                             } else {
//                               selectedModifiers[modifierType]!.remove(modifierDetail);
//                               if (selectedModifiers[modifierType]!.isEmpty) {
//                                 selectedModifiers.remove(modifierType);
//                               }
//                             }
//
//                             dynamic data = convertToModifiersList(selectedModifiers);
//                             // Pass the selected modifiers to the callback function
//                             widget.onModifiersSelected(data);
//                           });
//                         },
//                         value: isDetailSelected,
//                       );
//                     },
//                   ),
//                 ],
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }
//
//   List<Modifier> convertToModifiersList(Map<String, List<ModifierDetail>> selectedModifiers) {
//     List<Modifier> modifiersList = [];
//
//     selectedModifiers.forEach((modifierType, modifierDetails) {
//       Modifier modifier = Modifier(
//         modifierType: modifierType,
//         modifierDetails: modifierDetails,
//       );
//       modifiersList.add(modifier);
//     });
//
//     return modifiersList;
//   }
//
//   void filterModifiers() {
//     filteredModifiers = widget.modifierModel.modifiers!;
//     if (searchText.isNotEmpty) {
//       filteredModifiers = filteredModifiers.where((modifier) {
//         return modifier.modifierDetails!.any((modifierDetail) {
//           return modifierDetail.modifierName!.toLowerCase().contains(searchText.toLowerCase());
//         });
//       }).toList();
//     }
//   }
// }

///Forth Sixth perfect but only show modifier type when searching
// class ModifiersOnly extends StatefulWidget {
//   ModifierModel modifierModel;
//   Function(List<Modifier>) onModifiersSelected;
//   List<Modifier> cartModifiers;
//
//   // Callback function to handle selected modifiers
//
//   ModifiersOnly({
//     Key? key,
//     required this.modifierModel,
//     required this.onModifiersSelected,
//     required this.cartModifiers,
//   }) : super(key: key);
//
//   @override
//   State<ModifiersOnly> createState() => _ModifiersOnlyState();
// }
//
// class _ModifiersOnlyState extends State<ModifiersOnly> {
//   Map<String, List<ModifierDetail>> selectedModifiers = {};
//   String searchText = '';
//   List<Modifier> filteredModifiers = [];
//
//   @override
//   void initState() {
//     super.initState();
//     initializeSelectedModifiers();
//     filterModifiers();
//   }
//
//   void initializeSelectedModifiers() {
//     for (var cartModifier in widget.cartModifiers) {
//       var modifierType = cartModifier.modifierType;
//       var modifierDetails = cartModifier.modifierDetails;
//
//       if (modifierType != null &&
//           modifierDetails != null &&
//           modifierDetails.isNotEmpty) {
//         selectedModifiers[modifierType] = modifierDetails;
//       }
//     }
//   }
//
//   List<String> isExpandedList = [];
//
//   @override
//   Widget build(BuildContext context) {
//     return widget.modifierModel.modifiers!.isEmpty
//         ? Container(
//             child: Center(
//               child: Text("No Modifiers"),
//             ),
//           )
//         : SingleChildScrollView(
//             child: Column(
//               children: [
//                 Stack(
//                   alignment: Alignment.centerRight,
//                   children: [
//                     Align(
//                       alignment: Alignment.center,
//                       child: Text(
//                         "Modifiers",
//                         style: TextStyle(
//                           fontWeight: FontWeight.w800,
//                           color: Colors.black,
//                           fontSize: 20,
//                         ),
//                       ),
//                     ),
//                     IconButton(
//                       onPressed: () {
//                         // Call the callback function
//                         Get.back();
//                       },
//                       icon: Icon(Icons.clear),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 5),
//                 TextField(
//                   onChanged: (value) {
//                     setState(() {
//                       searchText = value;
//                       filterModifiers();
//                     });
//                   },
//                   decoration: InputDecoration(
//                     labelText: 'Search',
//                   ),
//                 ),
//                 ListView.builder(
//                   padding: EdgeInsets.zero,
//                   itemCount: filteredModifiers.length,
//                   shrinkWrap: true,
//                   physics: const NeverScrollableScrollPhysics(),
//                   itemBuilder: (context, modifierIndex) {
//                     var modifierType =
//                         filteredModifiers[modifierIndex].modifierType;
//                     var modifierDetails =
//                         filteredModifiers[modifierIndex].modifierDetails!;
//                     var isSelected =
//                         selectedModifiers.containsKey(modifierType) &&
//                             selectedModifiers[modifierType]!.isNotEmpty;
//                     var isExpanded = isExpandedList.contains(modifierType);
//                     return Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         InkWell(
//                           child: Container(
//                             padding: EdgeInsets.symmetric(vertical: 4),
//                             child: Text(
//                               modifierType.toString(),
//                               style: TextStyle(
//                                 fontWeight: FontWeight.w800,
//                                 color: Color(Constants.colorTheme),
//                                 fontSize: 18,
//                               ),
//                             ),
//                           ),
//                           onTap: () {
//                             setState(() {
//                               if (isExpanded) {
//                                 isExpandedList.remove(modifierType);
//                               } else {
//                                 isExpandedList.add(modifierType!);
//                               }
//                             });
//                           },
//                         ),
//                         // if (isExpandedList.isNotEmpty)
//                         if (isExpanded)
//                           // if (isExpandedList[modifierIndex])
//                           ListView.builder(
//                             padding: EdgeInsets.zero,
//                             shrinkWrap: true,
//                             physics: const NeverScrollableScrollPhysics(),
//                             itemCount: modifierDetails.length,
//                             itemBuilder: (context, modifierDetailIndex) {
//                               var modifierDetail =
//                                   modifierDetails[modifierDetailIndex];
//                               var isDetailSelected = isSelected &&
//                                   selectedModifiers[modifierType]!
//                                       .contains(modifierDetail);
//                               return InkWell(
//                                 splashColor: Colors.transparent,
//                                 highlightColor: Colors.transparent,
//                                 hoverColor: Colors.transparent,
//                                 onTap: () {},
//                                 child: Row(
//                                   children: [
//                                     Transform.scale(
//                                       scale: 1,
//                                       child: Checkbox(
//                                         visualDensity: VisualDensity
//                                             .adaptivePlatformDensity,
//                                         checkColor: isDetailSelected
//                                             ? Color(Constants.colorTheme)
//                                             : null,
//                                         value: isDetailSelected,
//                                         onChanged: (bool? value) {
//                                           setState(() {
//                                             if (value == true) {
//                                               if (!selectedModifiers
//                                                   .containsKey(modifierType)) {
//                                                 selectedModifiers[
//                                                     modifierType!] = [
//                                                   modifierDetail
//                                                 ];
//                                               } else {
//                                                 selectedModifiers[modifierType]!
//                                                     .add(modifierDetail);
//                                               }
//                                             } else {
//                                               selectedModifiers[modifierType]!
//                                                   .remove(modifierDetail);
//                                               if (selectedModifiers[
//                                                       modifierType]!
//                                                   .isEmpty) {
//                                                 selectedModifiers
//                                                     .remove(modifierType);
//                                               }
//                                             }
//
//                                             dynamic data =
//                                                 convertToModifiersList(
//                                                     selectedModifiers);
//                                             // Pass the selected modifiers to the callback function
//                                             widget.onModifiersSelected(data);
//                                           });
//                                         },
//                                       ),
//                                     ),
//                                     SizedBox(width: 10),
//                                     Text(
//                                         modifierDetail.modifierName.toString()),
//                                     SizedBox(width: 10),
//                                     Text(double.parse(modifierDetail
//                                             .modifierPrice
//                                             .toString())
//                                         .toStringAsFixed(2)),
//                                   ],
//                                 ),
//                               );
//                             },
//                           ),
//                       ],
//                     );
//                   },
//                 ),
//               ],
//             ),
//           );
//   }
//
//   List<Modifier> convertToModifiersList(
//       Map<String, List<ModifierDetail>> selectedModifiers) {
//     List<Modifier> modifiersList = [];
//
//     selectedModifiers.forEach((modifierType, modifierDetails) {
//       Modifier modifier = Modifier(
//         modifierType: modifierType,
//         modifierDetails: modifierDetails,
//       );
//       modifiersList.add(modifier);
//     });
//
//     return modifiersList;
//   }
//
//   void filterModifiers() {
//     filteredModifiers = widget.modifierModel.modifiers!;
//     if (searchText.isNotEmpty) {
//       filteredModifiers = filteredModifiers.where((modifier) {
//         return modifier.modifierDetails!.any((modifierDetail) {
//           return modifierDetail.modifierName!
//               .toLowerCase()
//               .contains(searchText.toLowerCase());
//         });
//       }).toList();
//     }
//   }
// }

///Fifth Sixth
// class ModifiersOnly extends StatefulWidget {
//   ModifierModel modifierModel;
//   Function(List<Modifier>) onModifiersSelected;
//   List<Modifier> cartModifiers;
//
//   // Callback function to handle selected modifiers
//
//   ModifiersOnly({
//     Key? key,
//     required this.modifierModel,
//     required this.onModifiersSelected,
//     required this.cartModifiers,
//   }) : super(key: key);
//
//   @override
//   State<ModifiersOnly> createState() => _ModifiersOnlyState();
// }
//
// class _ModifiersOnlyState extends State<ModifiersOnly> {
//   Map<String, List<ModifierDetail>> selectedModifiers = {};
//   String searchText = '';
//   ModifierModel filteredModifiers = ModifierModel(modifiers: []);
//
//   @override
//   void initState() {
//     super.initState();
//     initializeSelectedModifiers();
//     filterModifiers();
//   }
//
//   void initializeSelectedModifiers() {
//     for (var cartModifier in widget.cartModifiers) {
//       var modifierType = cartModifier.modifierType;
//       var modifierDetails = cartModifier.modifierDetails;
//
//       if (modifierType != null &&
//           modifierDetails != null &&
//           modifierDetails.isNotEmpty) {
//         selectedModifiers[modifierType] = modifierDetails;
//       }
//     }
//   }
//
//   List<String> isExpandedList = [];
//
//   @override
//   Widget build(BuildContext context) {
//     return widget.modifierModel.modifiers!.isEmpty
//         ? Container(
//             child: Center(
//               child: Text("No Modifiers"),
//             ),
//           )
//         : SingleChildScrollView(
//             child: Column(
//               children: [
//                 Stack(
//                   alignment: Alignment.centerRight,
//                   children: [
//                     Align(
//                       alignment: Alignment.center,
//                       child: Text(
//                         "Modifiers",
//                         style: TextStyle(
//                           fontWeight: FontWeight.w800,
//                           color: Colors.black,
//                           fontSize: 20,
//                         ),
//                       ),
//                     ),
//                     IconButton(
//                       onPressed: () {
//                         // Call the callback function
//                         Get.back();
//                       },
//                       icon: Icon(Icons.clear),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 5),
//                 TextField(
//                   onChanged: (value) {
//                     setState(() {
//                       searchText = value;
//                       filterModifiers();
//                     });
//                   },
//                   decoration: InputDecoration(
//                     labelText: 'Search',
//                     prefixIcon: Icon(Icons.search),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(8.0),
//                     ),
//                   ),
//                 ),
//                 ListView.builder(
//                   padding: EdgeInsets.zero,
//                   itemCount: filteredModifiers.modifiers!.length,
//                   shrinkWrap: true,
//                   physics: const NeverScrollableScrollPhysics(),
//                   itemBuilder: (context, modifierIndex) {
//                     var modifierType = filteredModifiers
//                         .modifiers![modifierIndex].modifierType;
//                     var modifierDetails = filteredModifiers
//                         .modifiers![modifierIndex].modifierDetails!;
//                     var isSelected =
//                         selectedModifiers.containsKey(modifierType) &&
//                             selectedModifiers[modifierType]!.isNotEmpty;
//                     var isExpanded = isExpandedList.contains(modifierType);
//                     return Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         InkWell(
//                           child: Container(
//                             padding: EdgeInsets.symmetric(vertical: 4),
//                             child: Text(
//                               modifierType.toString(),
//                               style: TextStyle(
//                                 fontWeight: FontWeight.w800,
//                                 color: Color(Constants.colorTheme),
//                                 fontSize: 18,
//                               ),
//                             ),
//                           ),
//                           onTap: () {
//                             setState(() {
//                               if (isExpanded) {
//                                 isExpandedList.remove(modifierType);
//                               } else {
//                                 isExpandedList.add(modifierType!);
//                               }
//                             });
//                           },
//                         ),
//                         // if (isExpandedList.isNotEmpty)
//                         if (isExpanded)
//                           // if (isExpandedList[modifierIndex])
//                           ListView.builder(
//                             padding: EdgeInsets.zero,
//                             shrinkWrap: true,
//                             physics: const NeverScrollableScrollPhysics(),
//                             itemCount: modifierDetails.length,
//                             itemBuilder: (context, modifierDetailIndex) {
//                               var modifierDetail =
//                                   modifierDetails[modifierDetailIndex];
//                               var isDetailSelected = isSelected &&
//                                   selectedModifiers[modifierType]!
//                                       .contains(modifierDetail);
//                               return InkWell(
//                                 splashColor: Colors.transparent,
//                                 highlightColor: Colors.transparent,
//                                 hoverColor: Colors.transparent,
//                                 onTap: () {},
//                                 child: Row(
//                                   children: [
//                                     Transform.scale(
//                                       scale: 1,
//                                       child: Checkbox(
//                                         visualDensity: VisualDensity
//                                             .adaptivePlatformDensity,
//                                         checkColor: isDetailSelected
//                                             ? Color(Constants.colorTheme)
//                                             : null,
//                                         value: isDetailSelected,
//                                         onChanged: (bool? value) {
//                                           setState(() {
//                                             if (value == true) {
//                                               if (!selectedModifiers
//                                                   .containsKey(modifierType)) {
//                                                 selectedModifiers[
//                                                     modifierType!] = [
//                                                   modifierDetail
//                                                 ];
//                                               } else {
//                                                 selectedModifiers[modifierType]!
//                                                     .add(modifierDetail);
//                                               }
//                                             } else {
//                                               selectedModifiers[modifierType]!
//                                                   .remove(modifierDetail);
//                                               if (selectedModifiers[
//                                                       modifierType]!
//                                                   .isEmpty) {
//                                                 selectedModifiers
//                                                     .remove(modifierType);
//                                               }
//                                             }
//
//                                             dynamic data =
//                                                 convertToModifiersList(
//                                                     selectedModifiers);
//                                             // Pass the selected modifiers to the callback function
//                                             widget.onModifiersSelected(data);
//                                           });
//                                         },
//                                       ),
//                                     ),
//                                     SizedBox(width: 10),
//                                     Text(
//                                         modifierDetail.modifierName.toString()),
//                                     SizedBox(width: 10),
//                                     Text(double.parse(modifierDetail
//                                             .modifierPrice
//                                             .toString())
//                                         .toStringAsFixed(2)),
//                                   ],
//                                 ),
//                               );
//                             },
//                           ),
//                       ],
//                     );
//                   },
//                 ),
//               ],
//             ),
//           );
//   }
//
//   List<Modifier> convertToModifiersList(
//       Map<String, List<ModifierDetail>> selectedModifiers) {
//     List<Modifier> modifiersList = [];
//
//     selectedModifiers.forEach((modifierType, modifierDetails) {
//       Modifier modifier = Modifier(
//         modifierType: modifierType,
//         modifierDetails: modifierDetails,
//       );
//       modifiersList.add(modifier);
//     });
//
//     return modifiersList;
//   }
//
//   void filterModifiers() {
//     filteredModifiers =
//         ModifierModel(modifiers: widget.modifierModel.modifiers!);
//     if (searchText.isNotEmpty) {
//       filteredModifiers.modifiers =
//           filteredModifiers.modifiers!.where((modifier) {
//         bool modifierTypeMatches = modifier.modifierType!
//             .toLowerCase()
//             .contains(searchText.toLowerCase());
//         bool modifierDetailMatches =
//             modifier.modifierDetails!.any((modifierDetail) {
//           return modifierDetail.modifierName!
//               .toLowerCase()
//               .contains(searchText.toLowerCase());
//         });
//         if (modifierDetailMatches) {
//           isExpandedList.add(modifier.modifierType!);
//         }
//         return modifierTypeMatches || modifierDetailMatches;
//       }).toList();
//     } else {
//       isExpandedList.clear();
//     }
//   }
// }

///Sixth Sixth perfect only modifier detail name is 2 show when matches 1
// class ModifiersOnly extends StatefulWidget {
//   ModifierModel modifierModel;
//   Function(List<Modifier>) onModifiersSelected;
//   List<Modifier> cartModifiers;
//
//   // Callback function to handle selected modifiers
//
//   ModifiersOnly({
//     Key? key,
//     required this.modifierModel,
//     required this.onModifiersSelected,
//     required this.cartModifiers,
//   }) : super(key: key);
//
//   @override
//   State<ModifiersOnly> createState() => _ModifiersOnlyState();
// }
//
// class _ModifiersOnlyState extends State<ModifiersOnly> {
//   Map<String, List<ModifierDetail>> selectedModifiers = {};
//   String searchText = '';
//   ModifierModel filteredModifiers = ModifierModel(modifiers: []);
//
//   @override
//   void initState() {
//     super.initState();
//     initializeSelectedModifiers();
//     filterModifiers();
//   }
//
//   void initializeSelectedModifiers() {
//     for (var cartModifier in widget.cartModifiers) {
//       var modifierType = cartModifier.modifierType;
//       var modifierDetails = cartModifier.modifierDetails;
//
//       if (modifierType != null &&
//           modifierDetails != null &&
//           modifierDetails.isNotEmpty) {
//         selectedModifiers[modifierType] = modifierDetails;
//       }
//     }
//   }
//
//   List<String> isExpandedList = [];
//
//   @override
//   Widget build(BuildContext context) {
//     return widget.modifierModel.modifiers!.isEmpty
//         ? Container(
//       child: Center(
//         child: Text("No Modifiers"),
//       ),
//     )
//         : SingleChildScrollView(
//       child: Column(
//         children: [
//           Stack(
//             alignment: Alignment.centerRight,
//             children: [
//               Align(
//                 alignment: Alignment.center,
//                 child: Text(
//                   "Modifiers",
//                   style: TextStyle(
//                     fontWeight: FontWeight.w800,
//                     color: Colors.black,
//                     fontSize: 20,
//                   ),
//                 ),
//               ),
//               IconButton(
//                 onPressed: () {
//                   // Call the callback function
//                   Get.back();
//                 },
//                 icon: Icon(Icons.clear),
//               ),
//             ],
//           ),
//           const SizedBox(height: 5),
//           TextField(
//             onChanged: (value) {
//               setState(() {
//                 searchText = value;
//                 filterModifiers();
//               });
//             },
//             decoration: InputDecoration(
//               labelText: 'Search',
//               prefixIcon: Icon(Icons.search),
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(8.0),
//               ),
//             ),
//           ),
//           ListView.builder(
//             padding: EdgeInsets.zero,
//             itemCount: filteredModifiers.modifiers!.length,
//             shrinkWrap: true,
//             physics: const NeverScrollableScrollPhysics(),
//             itemBuilder: (context, modifierIndex) {
//               var modifierType = filteredModifiers
//                   .modifiers![modifierIndex].modifierType;
//               var modifierDetails = filteredModifiers
//                   .modifiers![modifierIndex].modifierDetails!;
//               var isSelected =
//                   selectedModifiers.containsKey(modifierType) &&
//                       selectedModifiers[modifierType]!.isNotEmpty;
//               var isExpanded = isExpandedList.contains(modifierType);
//               return Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   InkWell(
//                     child: Container(
//                       padding: EdgeInsets.symmetric(vertical: 4),
//                       child: Text(
//                         modifierType.toString(),
//                         style: TextStyle(
//                           fontWeight: FontWeight.w800,
//                           color: Color(Constants.colorTheme),
//                           fontSize: 18,
//                         ),
//                       ),
//                     ),
//                     onTap: () {
//                       setState(() {
//                         if (isExpanded) {
//                           isExpandedList.remove(modifierType);
//                         } else {
//                           isExpandedList.add(modifierType!);
//                         }
//                       });
//                     },
//                   ),
//                   // if (isExpandedList.isNotEmpty)
//                   if (isExpanded)
//                   // if (isExpandedList[modifierIndex])
//                     ListView.builder(
//                       padding: EdgeInsets.zero,
//                       shrinkWrap: true,
//                       physics: const NeverScrollableScrollPhysics(),
//                       itemCount: modifierDetails.length,
//                       itemBuilder: (context, modifierDetailIndex) {
//                         var modifierDetail =
//                         modifierDetails[modifierDetailIndex];
//                         var isDetailSelected = isSelected &&
//                             selectedModifiers[modifierType]!
//                                 .contains(modifierDetail);
//                         return InkWell(
//                           splashColor: Colors.transparent,
//                           highlightColor: Colors.transparent,
//                           hoverColor: Colors.transparent,
//                           onTap: () {},
//                           child: Row(
//                             children: [
//                               Transform.scale(
//                                 scale: 1,
//                                 child: Checkbox(
//                                   visualDensity: VisualDensity
//                                       .adaptivePlatformDensity,
//                                   checkColor: isDetailSelected
//                                       ? Color(Constants.colorTheme)
//                                       : null,
//                                   value: isDetailSelected,
//                                   onChanged: (bool? value) {
//                                     setState(() {
//                                       if (value == true) {
//                                         if (!selectedModifiers
//                                             .containsKey(modifierType)) {
//                                           selectedModifiers[
//                                           modifierType!] = [
//                                             modifierDetail
//                                           ];
//                                         } else {
//                                           selectedModifiers[modifierType]!
//                                               .add(modifierDetail);
//                                         }
//                                       } else {
//                                         selectedModifiers[modifierType]!
//                                             .remove(modifierDetail);
//                                         if (selectedModifiers[
//                                         modifierType]!
//                                             .isEmpty) {
//                                           selectedModifiers
//                                               .remove(modifierType);
//                                         }
//                                       }
//
//                                       dynamic data =
//                                       convertToModifiersList(
//                                           selectedModifiers);
//                                       // Pass the selected modifiers to the callback function
//                                       widget.onModifiersSelected(data);
//                                     });
//                                   },
//                                 ),
//                               ),
//                               SizedBox(width: 10),
//                               Text(
//                                   modifierDetail.modifierName.toString()),
//                               SizedBox(width: 10),
//                               Text(double.parse(modifierDetail
//                                   .modifierPrice
//                                   .toString())
//                                   .toStringAsFixed(2)),
//                             ],
//                           ),
//                         );
//                       },
//                     ),
//                 ],
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }
//
//   List<Modifier> convertToModifiersList(
//       Map<String, List<ModifierDetail>> selectedModifiers) {
//     List<Modifier> modifiersList = [];
//
//     selectedModifiers.forEach((modifierType, modifierDetails) {
//       Modifier modifier = Modifier(
//         modifierType: modifierType,
//         modifierDetails: modifierDetails,
//       );
//       modifiersList.add(modifier);
//     });
//
//     return modifiersList;
//   }
//
//   void filterModifiers() {
//     filteredModifiers = ModifierModel(modifiers: widget.modifierModel.modifiers!);
//     if (searchText.isNotEmpty) {
//       filteredModifiers.modifiers = filteredModifiers.modifiers!.where((modifier) {
//         bool modifierDetailMatches = modifier.modifierDetails!.any((modifierDetail) {
//           return modifierDetail.modifierName!
//               .toLowerCase()
//               .contains(searchText.toLowerCase());
//         });
//         if (modifierDetailMatches) {
//           isExpandedList.add(modifier.modifierType!);
//         }
//         return modifierDetailMatches;
//       }).toList();
//     } else {
//       isExpandedList.clear();
//     }
//   }
//
// }

///Seventh Sixth perfect without full row select
// class ModifiersOnly extends StatefulWidget {
//   ModifierModel modifierModel;
//   Function(List<Modifier>) onModifiersSelected;
//   List<Modifier> cartModifiers;
//
//   // Callback function to handle selected modifiers
//
//   ModifiersOnly({
//     Key? key,
//     required this.modifierModel,
//     required this.onModifiersSelected,
//     required this.cartModifiers,
//   }) : super(key: key);
//
//   @override
//   State<ModifiersOnly> createState() => _ModifiersOnlyState();
// }
//
// class _ModifiersOnlyState extends State<ModifiersOnly> {
//   Map<String, List<ModifierDetail>> selectedModifiers = {};
//   String searchText = '';
//   ModifierModel filteredModifiers = ModifierModel(modifiers: []);
//
//   @override
//   void initState() {
//     super.initState();
//     initializeSelectedModifiers();
//     filterModifiers();
//   }
//
//   void initializeSelectedModifiers() {
//     for (var cartModifier in widget.cartModifiers) {
//       var modifierType = cartModifier.modifierType;
//       var modifierDetails = cartModifier.modifierDetails;
//
//       if (modifierType != null &&
//           modifierDetails != null &&
//           modifierDetails.isNotEmpty) {
//         selectedModifiers[modifierType] = modifierDetails;
//       }
//     }
//   }
//
//   List<String> isExpandedList = [];
//
//   @override
//   Widget build(BuildContext context) {
//     return widget.modifierModel.modifiers!.isEmpty
//         ? Container(
//       child: Center(
//         child: Text("No Modifiers"),
//       ),
//     )
//         : SingleChildScrollView(
//       child: Column(
//         children: [
//           Stack(
//             alignment: Alignment.centerRight,
//             children: [
//               Align(
//                 alignment: Alignment.center,
//                 child: Text(
//                   "Modifiers",
//                   style: TextStyle(
//                     fontWeight: FontWeight.w800,
//                     color: Colors.black,
//                     fontSize: 20,
//                   ),
//                 ),
//               ),
//               IconButton(
//                 onPressed: () {
//                   // Call the callback function
//                   Get.back();
//                 },
//                 icon: Icon(Icons.clear),
//               ),
//             ],
//           ),
//           const SizedBox(height: 5),
//           TextField(
//             onChanged: (value) {
//               setState(() {
//                 searchText = value;
//                 filterModifiers();
//               });
//             },
//             decoration: InputDecoration(
//               labelText: 'Search',
//               prefixIcon: Icon(Icons.search),
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(8.0),
//               ),
//             ),
//           ),
//           const SizedBox(height: 5),
//           ListView.builder(
//             padding: EdgeInsets.zero,
//             itemCount: filteredModifiers.modifiers!.length,
//             shrinkWrap: true,
//             physics: const NeverScrollableScrollPhysics(),
//             itemBuilder: (context, modifierIndex) {
//               var modifierType = filteredModifiers
//                   .modifiers![modifierIndex].modifierType;
//               var modifierDetails = filteredModifiers
//                   .modifiers![modifierIndex].modifierDetails!;
//               var isSelected =
//                   selectedModifiers.containsKey(modifierType) &&
//                       selectedModifiers[modifierType]!.isNotEmpty;
//               var isExpanded = isExpandedList.contains(modifierType);
//               return Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   InkWell(
//                     child: Container(
//                       padding: EdgeInsets.symmetric(vertical: 4),
//                       child: Text(
//                         modifierType.toString(),
//                         style: TextStyle(
//                           fontWeight: FontWeight.w800,
//                           color: Color(Constants.colorTheme),
//                           fontSize: 18,
//                         ),
//                       ),
//                     ),
//                     onTap: () {
//                       setState(() {
//                         if (isExpanded) {
//                           isExpandedList.remove(modifierType);
//                         } else {
//                           isExpandedList.add(modifierType!);
//                         }
//                       });
//                     },
//                   ),
//                   if (isExpanded)
//                     ListView.builder(
//                       padding: EdgeInsets.zero,
//                       shrinkWrap: true,
//                       physics: const NeverScrollableScrollPhysics(),
//                       itemCount: modifierDetails.length,
//                       itemBuilder: (context, modifierDetailIndex) {
//                         var modifierDetail =
//                         modifierDetails[modifierDetailIndex];
//                         var isDetailSelected = isSelected &&
//                             selectedModifiers[modifierType]!
//                                 .contains(modifierDetail);
//                         return InkWell(
//                           splashColor: Colors.transparent,
//                           highlightColor: Colors.transparent,
//                           hoverColor: Colors.transparent,
//                           onTap: () {},
//                           child: Row(
//                             children: [
//                               Transform.scale(
//                                 scale: 1,
//                                 child: Checkbox(
//                                   visualDensity: VisualDensity
//                                       .adaptivePlatformDensity,
//                                   checkColor: isDetailSelected
//                                       ? Color(Constants.colorTheme)
//                                       : null,
//                                   value: isDetailSelected,
//                                   onChanged: (bool? value) {
//                                     setState(() {
//                                       if (value == true) {
//                                         if (!selectedModifiers
//                                             .containsKey(modifierType)) {
//                                           selectedModifiers[
//                                           modifierType!] = [
//                                             modifierDetail
//                                           ];
//                                         } else {
//                                           selectedModifiers[modifierType]!
//                                               .add(modifierDetail);
//                                         }
//                                       } else {
//                                         selectedModifiers[modifierType]!
//                                             .remove(modifierDetail);
//                                         if (selectedModifiers[
//                                         modifierType]!
//                                             .isEmpty) {
//                                           selectedModifiers
//                                               .remove(modifierType);
//                                         }
//                                       }
//
//                                       dynamic data =
//                                       convertToModifiersList(
//                                           selectedModifiers);
//                                       // Pass the selected modifiers to the callback function
//                                       widget.onModifiersSelected(data);
//                                     });
//                                   },
//                                 ),
//                               ),
//                               SizedBox(width: 10),
//                               Text(
//                                   modifierDetail.modifierName.toString()),
//                               SizedBox(width: 10),
//                               Text(double.parse(modifierDetail
//                                   .modifierPrice
//                                   .toString())
//                                   .toStringAsFixed(2)),
//                             ],
//                           ),
//                         );
//                       },
//                     ),
//                 ],
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }
//
//   List<Modifier> convertToModifiersList(
//       Map<String, List<ModifierDetail>> selectedModifiers) {
//     List<Modifier> modifiersList = [];
//
//     selectedModifiers.forEach((modifierType, modifierDetails) {
//       Modifier modifier = Modifier(
//         modifierType: modifierType,
//         modifierDetails: modifierDetails,
//       );
//       modifiersList.add(modifier);
//     });
//
//     return modifiersList;
//   }
//
//   void filterModifiers() {
//     filteredModifiers = ModifierModel(modifiers: widget.modifierModel.modifiers!);
//     if (searchText.isNotEmpty) {
//       filteredModifiers.modifiers = filteredModifiers.modifiers!.map((modifier) {
//         var matchingModifierDetails = modifier.modifierDetails!.where((modifierDetail) {
//           return modifierDetail.modifierName!
//               .toLowerCase()
//               .contains(searchText.toLowerCase());
//         }).toList();
//         return Modifier(
//           modifierType: modifier.modifierType,
//           modifierDetails: matchingModifierDetails,
//         );
//       }).where((modifier) {
//         return modifier.modifierDetails!.isNotEmpty;
//       }).toList();
//       isExpandedList.addAll(filteredModifiers.modifiers!.map((modifier) => modifier.modifierType!));
//     } else {
//       isExpandedList.clear();
//     }
//   }
//
// }


///Eight Sixth
class ModifiersOnly extends StatefulWidget {
  ModifierModel modifierModel;
  Function(List<Modifier>) onModifiersSelected;
  List<Modifier> cartModifiers;

  // Callback function to handle selected modifiers

  ModifiersOnly({
    Key? key,
    required this.modifierModel,
    required this.onModifiersSelected,
    required this.cartModifiers,
  }) : super(key: key);

  @override
  State<ModifiersOnly> createState() => _ModifiersOnlyState();
}

class _ModifiersOnlyState extends State<ModifiersOnly> {
  Map<String, List<ModifierDetail>> selectedModifiers = {};
  String searchText = '';
  ModifierModel filteredModifiers = ModifierModel(modifiers: []);

  @override
  void initState() {
    super.initState();
    initializeSelectedModifiers();
    filterModifiers();
  }

  void initializeSelectedModifiers() {
    for (var cartModifier in widget.cartModifiers) {
      var modifierType = cartModifier.modifierType;

      if (modifierType != null) {
        var modifierIndex = widget.modifierModel.modifiers!.indexWhere((modifier) {
          return modifier.modifierType.toString() == modifierType;
        });

        if (modifierIndex != -1) {
          var modifierDetails = widget.modifierModel.modifiers![modifierIndex].modifierDetails;
          var selectedModifierDetails = cartModifier.modifierDetails;

          List<ModifierDetail> selectedIndexes = [];

          if (modifierDetails != null && selectedModifierDetails != null) {
            for (var selectedModifierDetail in selectedModifierDetails) {
              var modifierDetailIndex = modifierDetails.indexWhere((modifierDetail) {
                return modifierDetail.modifierName == selectedModifierDetail.modifierName;
              });

              if (modifierDetailIndex != -1) {
                selectedIndexes.add(modifierDetails[modifierDetailIndex]);
              }
            }
          }

          if (selectedIndexes.isNotEmpty) {
            selectedModifiers[modifierType] = selectedIndexes;
          }
        }
      }
    }
  }


  List<String> isExpandedList = [];

  @override
  Widget build(BuildContext context) {
    return widget.modifierModel.modifiers!.isEmpty
        ? Container(
      child: Center(
        child: Text("No Modifiers"),
      ),
    )
        : SingleChildScrollView(
      child: Column(
        children: [
          Stack(
            alignment: Alignment.centerRight,
            children: [
              Align(
                alignment: Alignment.center,
                child: Text(
                  "Modifiers",
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
                    fontSize: 20,
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  // Call the callback function
                  Get.back();
                },
                icon: Icon(Icons.clear),
              ),
            ],
          ),
          const SizedBox(height: 5),
          TextField(
            onChanged: (value) {
              setState(() {
                searchText = value;
                filterModifiers();
              });
            },
            decoration: InputDecoration(
              labelText: 'Search',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
          const SizedBox(height: 5),
          ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: filteredModifiers.modifiers!.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, modifierIndex) {
              var modifierType = filteredModifiers
                  .modifiers![modifierIndex].modifierType;
              var modifierDetails = filteredModifiers
                  .modifiers![modifierIndex].modifierDetails!;
              var isSelected =
                  selectedModifiers.containsKey(modifierType) &&
                      selectedModifiers[modifierType]!.isNotEmpty;
              var isExpanded = isExpandedList.contains(modifierType);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 4),
                      child: Text(
                        modifierType.toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          color: Color(Constants.colorTheme),
                          fontSize: 18,
                        ),
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        if (isExpanded) {
                          isExpandedList.remove(modifierType);
                        } else {
                          isExpandedList.add(modifierType!);
                        }
                      });
                    },
                  ),
                  if (isExpanded)
                    ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: modifierDetails.length,
                      itemBuilder: (context, modifierDetailIndex) {
                        var modifierDetail = modifierDetails[modifierDetailIndex];
                        var isDetailSelected = isSelected && selectedModifiers[modifierType]!.contains(modifierDetail);
                        return InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          onTap: () {
                            setState(() {
                              isDetailSelected = !isDetailSelected;
                              if (isDetailSelected) {
                                if (!selectedModifiers.containsKey(modifierType)) {
                                  selectedModifiers[modifierType!] = [modifierDetail];
                                } else {
                                  selectedModifiers[modifierType]!.add(modifierDetail);
                                }
                              } else {
                                selectedModifiers[modifierType]!.remove(modifierDetail);
                                if (selectedModifiers[modifierType]!.isEmpty) {
                                  selectedModifiers.remove(modifierType);
                                }
                              }
                              dynamic data = convertToModifiersList(selectedModifiers);
                              // Pass the selected modifiers to the callback function
                              widget.onModifiersSelected(data);
                            });
                          },
                          child: Row(
                            children: [
                              Checkbox(
                                visualDensity: VisualDensity.compact, // Reduce the size of the checkbox
                                checkColor: isDetailSelected ? Color(Constants.colorTheme) : null,
                                value: isDetailSelected,
                                onChanged: (bool? value) {
                                  setState(() {
                                    isDetailSelected = value ?? false;
                                    if (isDetailSelected) {
                                      if (!selectedModifiers.containsKey(modifierType)) {
                                        selectedModifiers[modifierType!] = [modifierDetail];
                                      } else {
                                        selectedModifiers[modifierType]!.add(modifierDetail);
                                      }
                                    } else {
                                      selectedModifiers[modifierType]!.remove(modifierDetail);
                                      if (selectedModifiers[modifierType]!.isEmpty) {
                                        selectedModifiers.remove(modifierType);
                                      }
                                    }
                                    dynamic data = convertToModifiersList(selectedModifiers);
                                    // Pass the selected modifiers to the callback function

                                    widget.onModifiersSelected(data);
                                  });
                                },
                              ),
                              SizedBox(width: 10),
                              Text(modifierDetail.modifierName.toString()),
                              SizedBox(width: 10),
                              Text(double.parse(modifierDetail.modifierPrice.toString()).toStringAsFixed(2)),
                            ],
                          ),
                        );
                      },
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  List<Modifier> convertToModifiersList(
      Map<String, List<ModifierDetail>> selectedModifiers) {
    List<Modifier> modifiersList = [];

    selectedModifiers.forEach((modifierType, modifierDetails) {
      Modifier modifier = Modifier(
        modifierType: modifierType,
        modifierDetails: modifierDetails,
      );
      modifiersList.add(modifier);
    });

    return modifiersList;
  }

  void filterModifiers() {
    filteredModifiers = ModifierModel(modifiers: widget.modifierModel.modifiers!);
    if (searchText.isNotEmpty) {
      filteredModifiers.modifiers = filteredModifiers.modifiers!.map((modifier) {
        var matchingModifierDetails = modifier.modifierDetails!.where((modifierDetail) {
          return modifierDetail.modifierName!
              .toLowerCase()
              .contains(searchText.toLowerCase());
        }).toList();
        return Modifier(
          modifierType: modifier.modifierType,
          modifierDetails: matchingModifierDetails,
        );
      }).where((modifier) {
        return modifier.modifierDetails!.isNotEmpty;
      }).toList();
      isExpandedList.addAll(filteredModifiers.modifiers!.map((modifier) => modifier.modifierType!));
    } else {
      isExpandedList.clear();
    }
  }

}

///Seventh
// class ModifiersOnly extends StatefulWidget {
//   ModifierModel modifierModel;
//   Function(List<Modifier>) onModifiersSelected;
//   List<Modifier> cartModifiers;
//
//   ModifiersOnly({
//     Key? key,
//     required this.modifierModel,
//     required this.onModifiersSelected,
//     required this.cartModifiers,
//   }) : super(key: key);
//
//   @override
//   State<ModifiersOnly> createState() => _ModifiersOnlyState();
// }
//
// class _ModifiersOnlyState extends State<ModifiersOnly> {
//   Map<int, List<ModifierDetail>> selectedModifiers = {};
//   TextEditingController searchController = TextEditingController();
//   List<Modifier> filteredModifiers = [];
//   List<bool> isExpandedList = [];
//
//   void handleDialogClose() {
//     setState(() {
//       searchController.clear(); // Clear the search query
//       filteredModifiers = List.from(widget.modifierModel.modifiers!);
//       isExpandedList = List.filled(widget.modifierModel.modifiers!.length, false);
//
//       // Restore the original modifier details for each item
//       for (var i = 0; i < widget.modifierModel.modifiers!.length; i++) {
//         var modifier = widget.modifierModel.modifiers![i];
//         modifier.modifierDetails = List.from(originalModifierDetails[i]);
//       }
//     });
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     initializeSelectedModifiers();
//     filteredModifiers = List.from(widget.modifierModel.modifiers!);
//     isExpandedList = List.filled(widget.modifierModel.modifiers!.length, false);
//
//     // Initialize original modifier details
//     originalModifierDetails = widget.modifierModel.modifiers!
//         .map((modifier) => List<ModifierDetail>.from(modifier.modifierDetails!))
//         .toList();
//
//     for (var modifierIndex in selectedModifiers.keys) {
//       isExpandedList[modifierIndex] = true;
//     }
//
//   }
//
//   void initializeSelectedModifiers() {
//     // Iterate through the cartModifiers and populate the selectedModifiers map
//     for (var cartModifier in widget.cartModifiers) {
//       var modifierIndex = widget.modifierModel.modifiers!.indexWhere((modifier) {
//         return modifier.modifierType.toString() == cartModifier.modifierType;
//       });
//
//       if (modifierIndex != -1) {
//         var modifierDetails = widget.modifierModel.modifiers![modifierIndex].modifierDetails!;
//         var selectedModifierDetails = cartModifier.modifierDetails;
//
//         List<ModifierDetail> selectedIndexes = [];
//
//         for (var selectedModifierDetail in selectedModifierDetails!) {
//           var modifierDetailIndex = modifierDetails.indexWhere((modifierDetail) {
//             return modifierDetail.modifierName == selectedModifierDetail.modifierName;
//           });
//
//           if (modifierDetailIndex != -1) {
//             selectedIndexes.add(modifierDetails[modifierDetailIndex]);
//           }
//         }
//
//         if (selectedIndexes.isNotEmpty) {
//           selectedModifiers[modifierIndex] = selectedIndexes;
//         }
//       }
//     }
//   }
//
//
//   List<List<ModifierDetail>> originalModifierDetails = [];
//
//   void filterModifiers(String query) {
//     setState(() {
//       if (query.isEmpty) {
//         // Restore the original modifier details
//         for (var i = 0; i < widget.modifierModel.modifiers!.length; i++) {
//           var modifier = widget.modifierModel.modifiers![i];
//           modifier.modifierDetails = List.from(originalModifierDetails[i]);
//         }
//         filteredModifiers = List.from(widget.modifierModel.modifiers!);
//         isExpandedList = List.filled(widget.modifierModel.modifiers!.length, false);
//       } else {
//         // Update the filteredModifiers list based on the search query
//         filteredModifiers = widget.modifierModel.modifiers!
//             .where((modifier) =>
//             modifier.modifierDetails!
//                 .any((modifierDetail) =>
//                 modifierDetail.modifierName!.toLowerCase().contains(query.toLowerCase())))
//             .toList();
//         isExpandedList = List.filled(filteredModifiers.length, true);
//
//         // Backup the original modifier details if it hasn't been done yet
//         if (originalModifierDetails.isEmpty) {
//           originalModifierDetails = widget.modifierModel.modifiers!
//               .map((modifier) => List<ModifierDetail>.from(modifier.modifierDetails!))
//               .toList();
//         }
//
//         // Modify the modifier details based on the search query
//         for (var modifier in widget.modifierModel.modifiers!) {
//           if (!filteredModifiers.contains(modifier)) {
//             modifier.modifierDetails!.clear();
//           } else {
//             modifier.modifierDetails!.removeWhere((modifierDetail) =>
//             !modifierDetail.modifierName!.toLowerCase().contains(query.toLowerCase()));
//           }
//         }
//       }
//     });
//   }
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return widget.modifierModel.modifiers!.isEmpty
//         ? Container(
//       child: Center(
//         child: Text("No Modifiers"),
//       ),
//     )
//         : SingleChildScrollView(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Stack(
//             alignment: Alignment.centerRight,
//             children: [
//               Align(
//                 alignment: Alignment.center,
//                 child: Text(
//                   "Modifiers",
//                   style: TextStyle(
//                     fontWeight: FontWeight.w800,
//                     color: Colors.black,
//                     fontSize: 20,
//                   ),
//                 ),
//               ),
//               IconButton(
//                 onPressed: () {
//                   handleDialogClose(); // Call the callback function
//                   Get.back();
//                 },
//                 icon: Icon(Icons.clear),
//               ),
//             ],
//           ),
//
//           TextField(
//             controller: searchController,
//             onChanged: (value) {
//               filterModifiers(value);
//             },
//             decoration: InputDecoration(
//               hintText: 'Search modifiers...',
//             ),
//           ),
//           const SizedBox(height: 10),
//           ListView.builder(
//             padding: EdgeInsets.zero,
//             itemCount: filteredModifiers.length,
//             shrinkWrap: true,
//             physics: const NeverScrollableScrollPhysics(),
//             itemBuilder: (context, modifierIndex) {
//               var modifierType = filteredModifiers[modifierIndex].modifierType;
//               var modifierDetails = filteredModifiers[modifierIndex].modifierDetails!;
//               return Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   InkWell(
//                     child: Container(
//                       padding: EdgeInsets.symmetric(vertical: 4),
//                       child: Text(
//                         modifierType.toString(),
//                         style: TextStyle(
//                           fontWeight: FontWeight.w800,
//                           color: Color(Constants.colorTheme),
//                           fontSize: 18,
//                         ),
//                       ),
//                     ),
//                     onTap: () {
//                       setState(() {
//                         isExpandedList[modifierIndex] = !isExpandedList[modifierIndex];
//                       });
//                     },
//                   ),
//                   // if (isExpandedList.isNotEmpty)
//                   if (isExpandedList.length > modifierIndex && isExpandedList[modifierIndex])
//                   // if (isExpandedList[modifierIndex])
//                     ListView.builder(
//                       padding: EdgeInsets.zero,
//                       shrinkWrap: true,
//                       physics: const NeverScrollableScrollPhysics(),
//                       itemCount: modifierDetails.length,
//                       itemBuilder: (context, modifierDetailIndex) {
//                         var modifierDetail = modifierDetails[modifierDetailIndex];
//                         return InkWell(
//                           splashColor: Colors.transparent,
//                           highlightColor: Colors.transparent,
//                           hoverColor: Colors.transparent,
//                           onTap: () {
//                             setState(() {
//                               bool isSelected = selectedModifiers.containsKey(modifierIndex) &&
//                                   selectedModifiers[modifierIndex]!.contains(modifierDetail);
//
//                               if (isSelected) {
//                                 selectedModifiers[modifierIndex]!.remove(modifierDetail);
//                                 if (selectedModifiers[modifierIndex]!.isEmpty) {
//                                   selectedModifiers.remove(modifierIndex);
//                                 }
//                               } else {
//                                 if (!selectedModifiers.containsKey(modifierIndex)) {
//                                   selectedModifiers[modifierIndex] = [modifierDetail];
//                                 } else {
//                                   selectedModifiers[modifierIndex]!.add(modifierDetail);
//                                 }
//                               }
//
//                               dynamic data = convertToModifiersList(selectedModifiers);
//                               widget.onModifiersSelected(data);
//                             });
//                           },
//                           child: Row(
//                             children: [
//                               Transform.scale(
//                                 scale: 1,
//                                 child: Checkbox(
//                                   visualDensity: VisualDensity.adaptivePlatformDensity,
//                                   checkColor: selectedModifiers.containsKey(modifierIndex) &&
//                                       selectedModifiers[modifierIndex]!.contains(modifierDetail)
//                                       ? Color(Constants.colorTheme)
//                                       : null,
//                                   value: selectedModifiers.containsKey(modifierIndex) &&
//                                       selectedModifiers[modifierIndex]!.contains(modifierDetail),
//                                   onChanged: (bool? value) {
//                                     setState(() {
//                                       if (value == true) {
//                                         if (!selectedModifiers.containsKey(modifierIndex)) {
//                                           selectedModifiers[modifierIndex] = [modifierDetail];
//                                         } else {
//                                           selectedModifiers[modifierIndex]!.add(modifierDetail);
//                                         }
//                                       } else {
//                                         selectedModifiers[modifierIndex]!.remove(modifierDetail);
//                                         if (selectedModifiers[modifierIndex]!.isEmpty) {
//                                           selectedModifiers.remove(modifierIndex);
//                                         }
//                                       }
//
//                                       dynamic data = convertToModifiersList(selectedModifiers);
//                                       widget.onModifiersSelected(data);
//                                     });
//                                   },
//                                 ),
//                               ),
//                               SizedBox(width: 10),
//                               Text(modifierDetail.modifierName.toString()),
//                               SizedBox(width: 10),
//                               Text(double.parse(modifierDetail.modifierPrice.toString()).toStringAsFixed(2)),
//                             ],
//                           ),
//                         );
//                       },
//                     ),
//
//                 ],
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }
//
//   List<Modifier> convertToModifiersList(Map<int, List<ModifierDetail>> selectedModifiers) {
//     List<Modifier> modifiersList = [];
//
//     selectedModifiers.forEach((modifierIndex, modifierDetails) {
//       Modifier modifier = Modifier(
//         modifierType: widget.modifierModel.modifiers![modifierIndex].modifierType.toString(),
//         modifierDetails: modifierDetails,
//       );
//       modifiersList.add(modifier);
//     });
//
//     return modifiersList;
//   }
// }

///Eight
// class ModifiersOnly extends StatefulWidget {
//   ModifierModel modifierModel;
//   Function(List<Modifier>) onModifiersSelected;
//   List<Modifier> cartModifiers;
//
//   ModifiersOnly({
//     Key? key,
//     required this.modifierModel,
//     required this.onModifiersSelected,
//     required this.cartModifiers,
//   }) : super(key: key);
//
//   @override
//   State<ModifiersOnly> createState() => _ModifiersOnlyState();
// }
//
// class _ModifiersOnlyState extends State<ModifiersOnly> {
//   Map<int, List<ModifierDetail>> selectedModifiers = {};
//   TextEditingController searchController = TextEditingController();
//   List<Modifier> filteredModifiers = [];
//   List<bool> isExpandedList = [];
//   List<List<ModifierDetail>> originalModifierDetails = [];
//
//   @override
//   void initState() {
//     super.initState();
//     initializeSelectedModifiers();
//     filteredModifiers = List.from(widget.modifierModel.modifiers!);
//     isExpandedList = List.filled(widget.modifierModel.modifiers!.length, false);
//     originalModifierDetails = List.generate(
//       widget.modifierModel.modifiers!.length,
//           (index) => List.from(widget.modifierModel.modifiers![index].modifierDetails!),
//     );
//   }
//
//   void initializeSelectedModifiers() {
//     // Iterate through the cartModifiers and populate the selectedModifiers map
//     for (var cartModifier in widget.cartModifiers) {
//       var modifierIndex = widget.modifierModel.modifiers!.indexWhere(
//             (modifier) => modifier.modifierType.toString() == cartModifier.modifierType,
//       );
//
//       if (modifierIndex != -1) {
//         var modifierDetails = widget.modifierModel.modifiers![modifierIndex].modifierDetails!;
//         var selectedModifierDetails = cartModifier.modifierDetails;
//
//         List<ModifierDetail> selectedIndexes = [];
//
//         for (var selectedModifierDetail in selectedModifierDetails!) {
//           var modifierDetailIndex = modifierDetails.indexWhere(
//                 (modifierDetail) => modifierDetail.modifierName == selectedModifierDetail.modifierName,
//           );
//
//           if (modifierDetailIndex != -1) {
//             selectedIndexes.add(modifierDetails[modifierDetailIndex]);
//           }
//         }
//
//         if (selectedIndexes.isNotEmpty) {
//           selectedModifiers[modifierIndex] = selectedIndexes;
//         }
//       }
//     }
//   }
//
//   void filterModifiers(String query) {
//     setState(() {
//       if (query.isEmpty) {
//         // Restore the original modifier details
//         filteredModifiers = List.from(widget.modifierModel.modifiers!);
//         isExpandedList = List.filled(widget.modifierModel.modifiers!.length, false);
//       } else {
//         // Update the filteredModifiers list based on the search query
//         filteredModifiers = widget.modifierModel.modifiers!
//             .where((modifier) =>
//             modifier.modifierDetails!.any(
//                   (modifierDetail) =>
//                   modifierDetail.modifierName!.toLowerCase().contains(query.toLowerCase()),
//             ))
//             .toList();
//         isExpandedList = List.filled(filteredModifiers.length, true);
//       }
//     });
//   }
//
//   void updateSelectedModifiers(int modifierIndex, ModifierDetail modifierDetail, bool isSelected) {
//     setState(() {
//       if (isSelected) {
//         if (!selectedModifiers.containsKey(modifierIndex)) {
//           selectedModifiers[modifierIndex] = [modifierDetail];
//         } else {
//           selectedModifiers[modifierIndex]!.add(modifierDetail);
//         }
//       } else {
//         selectedModifiers[modifierIndex]!.remove(modifierDetail);
//         if (selectedModifiers[modifierIndex]!.isEmpty) {
//           selectedModifiers.remove(modifierIndex);
//         }
//       }
//
//       dynamic data = convertToModifiersList(selectedModifiers);
//       widget.onModifiersSelected(data);
//     });
//   }
//
//   List<Modifier> convertToModifiersList(Map<int, List<ModifierDetail>> selectedModifiers) {
//     List<Modifier> modifiersList = [];
//
//     selectedModifiers.forEach((modifierIndex, modifierDetails) {
//       Modifier modifier = Modifier(
//         modifierType: widget.modifierModel.modifiers![modifierIndex].modifierType.toString(),
//         modifierDetails: modifierDetails,
//       );
//       modifiersList.add(modifier);
//     });
//
//     return modifiersList;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//           child: TextField(
//             controller: searchController,
//             onChanged: (value) {
//               filterModifiers(value);
//             },
//             decoration: InputDecoration(
//               labelText: 'Search',
//               prefixIcon: Icon(Icons.search),
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(8.0),
//               ),
//             ),
//           ),
//         ),
//         Expanded(
//           child: ListView.builder(
//             itemCount: filteredModifiers.length,
//             itemBuilder: (context, modifierIndex) {
//               var modifier = filteredModifiers[modifierIndex];
//               return ExpansionPanelList(
//                 elevation: 1,
//                 expandedHeaderPadding: EdgeInsets.zero,
//                 expansionCallback: (panelIndex, isExpanded) {
//                   setState(() {
//                     isExpandedList[modifierIndex] = !isExpanded;
//                   });
//                 },
//                 children: [
//                   ExpansionPanel(
//                     canTapOnHeader: true,
//                     isExpanded: isExpandedList[modifierIndex],
//                     headerBuilder: (context, isExpanded) {
//                       return ListTile(
//                         title: Text(modifier.modifierType!),
//                       );
//                     },
//                     body: ListView.builder(
//                       shrinkWrap: true,
//                       physics: ClampingScrollPhysics(),
//                       itemCount: modifier.modifierDetails!.length,
//                       itemBuilder: (context, detailIndex) {
//                         var modifierDetail = modifier.modifierDetails![detailIndex];
//                         var isSelected = selectedModifiers.containsKey(modifierIndex) &&
//                             selectedModifiers[modifierIndex]!.contains(modifierDetail);
//                         return CheckboxListTile(
//                           value: isSelected,
//                           onChanged: (value) {
//                             updateSelectedModifiers(modifierIndex, modifierDetail, value!);
//                           },
//                           title: Text(modifierDetail.modifierName!),
//                         );
//                       },
//                     ),
//                   ),
//                 ],
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }
// }

///Ninth
// class ModifiersOnly extends StatefulWidget {
//   ModifierModel modifierModel;
//   Function(List<Modifier>) onModifiersSelected;
//   List<Modifier> cartModifiers;
//
//   ModifiersOnly({
//     Key? key,
//     required this.modifierModel,
//     required this.onModifiersSelected,
//     required this.cartModifiers,
//   }) : super(key: key);
//
//   @override
//   State<ModifiersOnly> createState() => _ModifiersOnlyState();
// }
//
// class _ModifiersOnlyState extends State<ModifiersOnly> {
//   Map<int, List<ModifierDetail>> selectedModifiers = {};
//   TextEditingController searchController = TextEditingController();
//   List<Modifier> filteredModifiers = [];
//   List<bool> isExpandedList = [];
//
//   void handleDialogClose() {
//     setState(() {
//       searchController.clear(); // Clear the search query
//       filteredModifiers = List.from(widget.modifierModel.modifiers!);
//       isExpandedList = List.filled(widget.modifierModel.modifiers!.length, false);
//
//       // Restore the original modifier details for each item
//       for (var i = 0; i < widget.modifierModel.modifiers!.length; i++) {
//         var modifier = widget.modifierModel.modifiers![i];
//         modifier.modifierDetails = List.from(originalModifierDetails[i]);
//       }
//     });
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     initializeSelectedModifiers();
//     filteredModifiers = List.from(widget.modifierModel.modifiers!);
//     isExpandedList = List.filled(widget.modifierModel.modifiers!.length, false);
//
//     // Initialize original modifier details
//     originalModifierDetails = widget.modifierModel.modifiers!
//         .map((modifier) => List<ModifierDetail>.from(modifier.modifierDetails!))
//         .toList();
//
//     for (var modifierIndex in selectedModifiers.keys) {
//       isExpandedList[modifierIndex] = true;
//     }
//
//   }
//
//   void initializeSelectedModifiers() {
//     // Iterate through the cartModifiers and populate the selectedModifiers map
//     for (var cartModifier in widget.cartModifiers) {
//       var modifierIndex = widget.modifierModel.modifiers!.indexWhere((modifier) {
//         return modifier.modifierType.toString() == cartModifier.modifierType;
//       });
//
//       if (modifierIndex != -1) {
//         var modifierDetails = widget.modifierModel.modifiers![modifierIndex].modifierDetails!;
//         var selectedModifierDetails = cartModifier.modifierDetails;
//
//         List<ModifierDetail> selectedIndexes = [];
//
//         for (var selectedModifierDetail in selectedModifierDetails!) {
//           var modifierDetailIndex = modifierDetails.indexWhere((modifierDetail) {
//             return modifierDetail.modifierName == selectedModifierDetail.modifierName;
//           });
//
//           if (modifierDetailIndex != -1) {
//             selectedIndexes.add(modifierDetails[modifierDetailIndex]);
//           }
//         }
//
//         if (selectedIndexes.isNotEmpty) {
//           selectedModifiers[modifierIndex] = selectedIndexes;
//         }
//       }
//     }
//   }
//
//
//   List<List<ModifierDetail>> originalModifierDetails = [];
//
//   void filterModifiers(String query) {
//     setState(() {
//       if (query.isEmpty) {
//         // Restore the original modifier details
//         for (var i = 0; i < widget.modifierModel.modifiers!.length; i++) {
//           var modifier = widget.modifierModel.modifiers![i];
//           modifier.modifierDetails = List.from(originalModifierDetails[i]);
//         }
//         filteredModifiers = List.from(widget.modifierModel.modifiers!);
//         isExpandedList = List.filled(widget.modifierModel.modifiers!.length, false);
//       } else {
//         // Update the filteredModifiers list based on the search query
//         filteredModifiers = widget.modifierModel.modifiers!
//             .where((modifier) =>
//             modifier.modifierDetails!
//                 .any((modifierDetail) =>
//                 modifierDetail.modifierName!.toLowerCase().contains(query.toLowerCase())))
//             .toList();
//         isExpandedList = List.filled(filteredModifiers.length, true);
//
//         // Backup the original modifier details if it hasn't been done yet
//         if (originalModifierDetails.isEmpty) {
//           originalModifierDetails = widget.modifierModel.modifiers!
//               .map((modifier) => List<ModifierDetail>.from(modifier.modifierDetails!))
//               .toList();
//         }
//
//         // Modify the modifier details based on the search query
//         for (var modifier in widget.modifierModel.modifiers!) {
//           if (!filteredModifiers.contains(modifier)) {
//             modifier.modifierDetails!.clear();
//           } else {
//             modifier.modifierDetails!.removeWhere((modifierDetail) =>
//             !modifierDetail.modifierName!.toLowerCase().contains(query.toLowerCase()));
//           }
//         }
//       }
//     });
//   }
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return widget.modifierModel.modifiers!.isEmpty
//         ? Container(
//       child: Center(
//         child: Text("No Modifiers"),
//       ),
//     )
//         : SingleChildScrollView(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Stack(
//             alignment: Alignment.centerRight,
//             children: [
//               Align(
//                 alignment: Alignment.center,
//                 child: Text(
//                   "Modifiers",
//                   style: TextStyle(
//                     fontWeight: FontWeight.w800,
//                     color: Colors.black,
//                     fontSize: 20,
//                   ),
//                 ),
//               ),
//               IconButton(
//                 onPressed: () {
//                   handleDialogClose(); // Call the callback function
//                   Get.back();
//                 },
//                 icon: Icon(Icons.clear),
//               ),
//             ],
//           ),
//
//           TextField(
//             controller: searchController,
//             onChanged: (value) {
//               filterModifiers(value);
//             },
//             decoration: InputDecoration(
//               hintText: 'Search modifiers...',
//             ),
//           ),
//           const SizedBox(height: 10),
//           ListView.builder(
//             padding: EdgeInsets.zero,
//             itemCount: filteredModifiers.length,
//             shrinkWrap: true,
//             physics: const NeverScrollableScrollPhysics(),
//             itemBuilder: (context, modifierIndex) {
//               var modifierType = filteredModifiers[modifierIndex].modifierType;
//               var modifierDetails = filteredModifiers[modifierIndex].modifierDetails!;
//               return Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   InkWell(
//                     child: Container(
//                       padding: EdgeInsets.symmetric(vertical: 4),
//                       child: Text(
//                         modifierType.toString(),
//                         style: TextStyle(
//                           fontWeight: FontWeight.w800,
//                           color: Color(Constants.colorTheme),
//                           fontSize: 18,
//                         ),
//                       ),
//                     ),
//                     onTap: () {
//                       setState(() {
//                         isExpandedList[modifierIndex] = !isExpandedList[modifierIndex];
//                       });
//                     },
//                   ),
//                   // if (isExpandedList.isNotEmpty)
//                   if (isExpandedList.length > modifierIndex && isExpandedList[modifierIndex])
//                   // if (isExpandedList[modifierIndex])
//                     ListView.builder(
//                       padding: EdgeInsets.zero,
//                       shrinkWrap: true,
//                       physics: const NeverScrollableScrollPhysics(),
//                       itemCount: modifierDetails.length,
//                       itemBuilder: (context, modifierDetailIndex) {
//                         var modifierDetail = modifierDetails[modifierDetailIndex];
//                         return InkWell(
//                           splashColor: Colors.transparent,
//                           highlightColor: Colors.transparent,
//                           hoverColor: Colors.transparent,
//                           onTap: () {
//                             setState(() {
//                               bool isSelected = selectedModifiers.containsKey(modifierIndex) &&
//                                   selectedModifiers[modifierIndex]!.contains(modifierDetail);
//
//                               if (isSelected) {
//                                 selectedModifiers[modifierIndex]!.remove(modifierDetail);
//                                 if (selectedModifiers[modifierIndex]!.isEmpty) {
//                                   selectedModifiers.remove(modifierIndex);
//                                 }
//                               } else {
//                                 if (!selectedModifiers.containsKey(modifierIndex)) {
//                                   selectedModifiers[modifierIndex] = [modifierDetail];
//                                 } else {
//                                   selectedModifiers[modifierIndex]!.add(modifierDetail);
//                                 }
//                               }
//
//                               dynamic data = convertToModifiersList(selectedModifiers);
//                               widget.onModifiersSelected(data);
//                             });
//                           },
//                           child: Row(
//                             children: [
//                               Transform.scale(
//                                 scale: 1,
//                                 child: Checkbox(
//                                   visualDensity: VisualDensity.adaptivePlatformDensity,
//                                   checkColor: selectedModifiers.containsKey(modifierIndex) &&
//                                       selectedModifiers[modifierIndex]!.contains(modifierDetail)
//                                       ? Color(Constants.colorTheme)
//                                       : null,
//                                   value: selectedModifiers.containsKey(modifierIndex) &&
//                                       selectedModifiers[modifierIndex]!.contains(modifierDetail),
//                                   onChanged: (bool? value) {
//                                     setState(() {
//                                       if (value == true) {
//                                         if (!selectedModifiers.containsKey(modifierIndex)) {
//                                           selectedModifiers[modifierIndex] = [modifierDetail];
//                                         } else {
//                                           selectedModifiers[modifierIndex]!.add(modifierDetail);
//                                         }
//                                       } else {
//                                         selectedModifiers[modifierIndex]!.remove(modifierDetail);
//                                         if (selectedModifiers[modifierIndex]!.isEmpty) {
//                                           selectedModifiers.remove(modifierIndex);
//                                         }
//                                       }
//
//                                       dynamic data = convertToModifiersList(selectedModifiers);
//                                       widget.onModifiersSelected(data);
//                                     });
//                                   },
//                                 ),
//                               ),
//                               SizedBox(width: 10),
//                               Text(modifierDetail.modifierName.toString()),
//                               SizedBox(width: 10),
//                               Text(double.parse(modifierDetail.modifierPrice.toString()).toStringAsFixed(2)),
//                             ],
//                           ),
//                         );
//                       },
//                     ),
//
//                 ],
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }
//
//   List<Modifier> convertToModifiersList(Map<int, List<ModifierDetail>> selectedModifiers) {
//     List<Modifier> modifiersList = [];
//
//     selectedModifiers.forEach((modifierIndex, modifierDetails) {
//       Modifier modifier = Modifier(
//         modifierType: widget.modifierModel.modifiers![modifierIndex].modifierType.toString(),
//         modifierDetails: modifierDetails,
//       );
//       modifiersList.add(modifier);
//     });
//
//     return modifiersList;
//   }
// }

///Seventh With expansion tile but not working properly
// class _ModifiersOnlyState extends State<ModifiersOnly> {
//   Map<int, List<ModifierDetail>> selectedModifiers = {};
//   TextEditingController searchController = TextEditingController();
//   List<Modifier> filteredModifiers = [];
//   List<bool> isExpandedList = [];
//
//   @override
//   void initState() {
//     super.initState();
//     initializeSelectedModifiers();
//     filteredModifiers = List.from(widget.modifierModel.modifiers!);
//     isExpandedList = List.filled(widget.modifierModel.modifiers!.length, false);
//   }
//
//   void initializeSelectedModifiers() {
//     // Iterate through the cartModifiers and populate the selectedModifiers map
//     for (var cartModifier in widget.cartModifiers) {
//       var modifierIndex = widget.modifierModel.modifiers!.indexWhere((modifier) {
//         return modifier.modifierType.toString() == cartModifier.modifierType;
//       });
//
//       if (modifierIndex != -1) {
//         var modifierDetails = widget.modifierModel.modifiers![modifierIndex].modifierDetails!;
//         var selectedModifierDetails = cartModifier.modifierDetails;
//
//         List<ModifierDetail> selectedIndexes = [];
//
//         for (var selectedModifierDetail in selectedModifierDetails!) {
//           var modifierDetailIndex = modifierDetails.indexWhere((modifierDetail) {
//             return modifierDetail.modifierName == selectedModifierDetail.modifierName;
//           });
//
//           if (modifierDetailIndex != -1) {
//             selectedIndexes.add(modifierDetails[modifierDetailIndex]);
//           }
//         }
//
//         if (selectedIndexes.isNotEmpty) {
//           selectedModifiers[modifierIndex] = selectedIndexes;
//         }
//       }
//     }
//   }
//
//   void filterModifiers(String query) {
//     if (query.isEmpty) {
//       setState(() {
//         filteredModifiers = List.from(widget.modifierModel.modifiers!);
//         isExpandedList = List.filled(widget.modifierModel.modifiers!.length, false);
//       });
//     } else {
//       setState(() {
//         filteredModifiers = widget.modifierModel.modifiers!
//             .where((modifier) =>
//         modifier.modifierType.toString().toLowerCase().contains(query.toLowerCase()) ||
//             modifier.modifierDetails!
//                 .any((modifierDetail) => modifierDetail.modifierName!.toLowerCase().contains(query.toLowerCase())))
//             .toList();
//         isExpandedList = List.filled(filteredModifiers.length, true);
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return widget.modifierModel.modifiers!.isEmpty
//         ? Container(
//       child: Center(
//         child: Text("No Modifiers"),
//       ),
//     )
//         : SingleChildScrollView(
//       child: Column(
//         children: [
//           TextField(
//             controller: searchController,
//             onChanged: (value) {
//               filterModifiers(value);
//             },
//             decoration: InputDecoration(
//               hintText: 'Search modifiers...',
//             ),
//           ),
//           const SizedBox(height: 10),
//           const Text(
//             "Modifiers",
//             style: TextStyle(
//               fontWeight: FontWeight.w800,
//               color: Colors.black,
//               fontSize: 20,
//             ),
//           ),
//           const SizedBox(height: 5),
//           ListView.builder(
//             padding: EdgeInsets.zero,
//             itemCount: filteredModifiers.length,
//             shrinkWrap: true,
//             physics: const NeverScrollableScrollPhysics(),
//             itemBuilder: (context, modifierIndex) {
//               var modifierType = filteredModifiers[modifierIndex].modifierType;
//               var modifierDetails = filteredModifiers[modifierIndex].modifierDetails!;
//               return Column(
//                 children: [
//                   ExpansionTile(
//                     title: Text(
//                       modifierType.toString(),
//                       style: TextStyle(
//                         fontWeight: FontWeight.w800,
//                         color: Color(Constants.colorTheme),
//                         fontSize: 17,
//                       ),
//                     ),
//                     initiallyExpanded: isExpandedList[modifierIndex],
//                     onExpansionChanged: (expanded) {
//                       setState(() {
//                         isExpandedList[modifierIndex] = expanded;
//                       });
//                     },
//                     children: [
//                       ListView.builder(
//                         padding: EdgeInsets.zero,
//                         shrinkWrap: true,
//                         physics: const NeverScrollableScrollPhysics(),
//                         itemCount: modifierDetails.length,
//                         itemBuilder: (context, modifierDetailIndex) {
//                           var modifierDetail = modifierDetails[modifierDetailIndex];
//                           return ListTile(
//                             dense: true,
//                             contentPadding: EdgeInsets.symmetric(horizontal: 20),
//                             title: Row(
//                               children: [
//                                 Text(modifierDetail.modifierName.toString()),
//                                 SizedBox(width: 10),
//                                 Text(double.parse(modifierDetail.modifierPrice.toString()).toStringAsFixed(2)),
//                                 SizedBox(width: 10),
//                                 Transform.scale(
//                                   scale: 0.8,
//                                   child: Checkbox(
//                                     visualDensity: VisualDensity.adaptivePlatformDensity,
//                                     checkColor: selectedModifiers.containsKey(modifierIndex) &&
//                                         selectedModifiers[modifierIndex]!.contains(modifierDetail)
//                                         ? Color(Constants.colorTheme)
//                                         : null,
//                                     value: selectedModifiers.containsKey(modifierIndex) &&
//                                         selectedModifiers[modifierIndex]!.contains(modifierDetail),
//                                     onChanged: (bool? value) {
//                                       setState(() {
//                                         if (value == true) {
//                                           if (!selectedModifiers.containsKey(modifierIndex)) {
//                                             selectedModifiers[modifierIndex] = [modifierDetail];
//                                           } else {
//                                             selectedModifiers[modifierIndex]!.add(modifierDetail);
//                                           }
//                                         } else {
//                                           selectedModifiers[modifierIndex]!.remove(modifierDetail);
//                                           if (selectedModifiers[modifierIndex]!.isEmpty) {
//                                             selectedModifiers.remove(modifierIndex);
//                                           }
//                                         }
//
//                                         dynamic data = convertToModifiersList(selectedModifiers);
//                                         widget.onModifiersSelected(data);
//                                       });
//                                     },
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           );
//                         },
//                       ),
//                     ],
//                   ),
//                 ],
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }
//
//   List<Modifier> convertToModifiersList(Map<int, List<ModifierDetail>> selectedModifiers) {
//     List<Modifier> modifiersList = [];
//
//     selectedModifiers.forEach((modifierIndex, modifierDetails) {
//       Modifier modifier = Modifier(
//         modifierType: widget.modifierModel.modifiers![modifierIndex].modifierType.toString(),
//         modifierDetails: modifierDetails,
//       );
//       modifiersList.add(modifier);
//     });
//
//     return modifiersList;
//   }
// }

///First New
// void filterModifiers(String query) {
//   if (query.isEmpty) {
//     setState(() {
//       filteredModifiers = List.from(widget.modifierModel.modifiers!);
//       isExpandedList = List.filled(widget.modifierModel.modifiers!.length, false);
//     });
//   } else {
//     setState(() {
//       filteredModifiers = widget.modifierModel.modifiers!
//           .where((modifier) =>
//       modifier.modifierType.toString().toLowerCase().contains(query.toLowerCase()) ||
//           modifier.modifierDetails!
//               .any((modifierDetail) =>
//               modifierDetail.modifierName!.toLowerCase().contains(query.toLowerCase())))
//           .toList();
//       isExpandedList = List.filled(filteredModifiers.length, true);
//       for (var modifier in widget.modifierModel.modifiers!) {
//         if (!filteredModifiers.contains(modifier)) {
//           modifier.modifierDetails!.clear();
//         } else {
//           modifier.modifierDetails!.removeWhere((modifierDetail) =>
//           !modifierDetail.modifierName!.toLowerCase().contains(query.toLowerCase()));
//         }
//       }
//     });
//   }
// }

///Second New
// void filterModifiers(String query) {
//   if (query.isEmpty) {
//     setState(() {
//       filteredModifiers = List.from(widget.modifierModel.modifiers!);
//       isExpandedList = List.filled(widget.modifierModel.modifiers!.length, false);
//     });
//   } else {
//     setState(() {
//       filteredModifiers = widget.modifierModel.modifiers!
//           .where((modifier) =>
//           modifier.modifierDetails!
//               .any((modifierDetail) =>
//               modifierDetail.modifierName!.toLowerCase().contains(query.toLowerCase())))
//           .toList();
//       isExpandedList = List.filled(filteredModifiers.length, true);
//       for (var modifier in widget.modifierModel.modifiers!) {
//         if (!filteredModifiers.contains(modifier)) {
//           modifier.modifierDetails!.clear();
//         } else {
//           modifier.modifierDetails!.removeWhere((modifierDetail) =>
//           !modifierDetail.modifierName!.toLowerCase().contains(query.toLowerCase()));
//         }
//       }
//     });
//   }
// }
