class PopupMenuAdventure{
  static const String Edit = "Edit Mode";
  static const String Order = "Order";

  static const List<String> choices = <String>[
    Edit,
    Order
  ];
}

class PopupMenu{
  static const String Edit = "Edit Mode";

  static const List<String> choices = <String>[
    Edit,
  ];
}

class PopupMenuPlayer{
  static const String EditPlayer = "Edit info";
  static const String Leave = "Leave";


  static const List<String> choices = <String>[
    EditPlayer,
    Leave,

  ];
}

class PopupMenuMaster{
  static const String Master = "Make master";
  static const String Remove = "Remove";
  static const String EditMaster = "Edit info";


  static const List<String> choices = <String>[
    Master,
    EditMaster,
    Remove,
  ];
}