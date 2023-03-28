class DataSingleVendor {
  DataSingleVendor({
    required this.menuCategory,
  });
  List<MenuCategory>? menuCategory;
}

class MenuCategory {
  MenuCategory({
    required this.id,
    required this.name,
    required this.status,
    required this.type,
    required this.singleMenu,
  });
  int id;
  String name;
  int status;
  String type;
  List<SingleMenu>? singleMenu;
  bool selected=false;
}

class SingleMenu {
  SingleMenu({
    required this.menu,
  });
  Menu? menu;
}

class Menu {
  Menu({ required this.id,
    required this.name,
  });
  int id;
  String name;
}

