// Copyright 2018-present the Flutter authors. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'package:flutter/foundation.dart';

enum Category { all, accessories, clothing, home, }

class Product {
  const Product({
    @required this.category,
    @required this.id,
    @required this.starNum,
    @required this.name,
    @required this.address,
    @required this.phone,
    @required this.text,
  })  : assert(category != null),
        assert(id != null),
        assert(starNum != null),
        assert(name != null),
        assert(address != null),
        assert(phone != null),
        assert(text != null);
  final Category category;
  final int id;
  final int starNum;
  final String name;
  final String address;
  final String phone;
  final String text;

  String get assetName => 'assets/$id-0.png';

  @override
  String toString() => "$name (id=$id)";
}
