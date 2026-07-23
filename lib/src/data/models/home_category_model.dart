// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class HomeCategoryModel {
  final String catName;
  final String catIcon;
  final VoidCallback onTap;

  const HomeCategoryModel({
    required this.catName,
    required this.catIcon,
    required this.onTap,
  });
}
