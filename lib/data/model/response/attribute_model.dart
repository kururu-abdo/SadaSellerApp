import 'package:flutter/material.dart';
import 'package:eamar_seller_app/data/model/response/attr.dart';

class AttributeModel {
  Attr attribute;
  bool active;
  TextEditingController controller;
  List<String> variants;


  AttributeModel({@required this.attribute, @required this.active, @required this.controller, @required this.variants});
}