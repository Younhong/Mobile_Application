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

import 'product.dart';

class ProductsRepository {
  static List<Product> loadProducts(Category category) {
    const allProducts = <Product> [
      Product(
        category: Category.accessories,
        id: 0,
        starNum: 3,
        name: 'Laguna Hills Lodge',
        address: '23932 Paseo De Valencia, Laguna Hills, CA, 92653, USA',
        phone: '+48 22 318 25 00',
        text: 'This hotel is Laguna Hills Lodge located at 23932 Paseo De Valencia, Laguna Hills, CA, 92653, USA. This hotel is built friendly to nature, with lots of trees planted right beside the hotel.',
      ),
      Product(
        category: Category.accessories,
        id: 1,
        starNum: 2,
        name: 'Marriott Hotel',
        address: '881 Baker St, Costa Mesa, CA, 92626, USA',
        phone: '+48 55 236 27 22',
          text: 'This hotel is Marriott Hotel located at 881 Baker St, Costa Mesa, CA, 92626, USA. Rooms are very clean, and you can feel very comfortable and cozy.',
      ),
      Product(
        category: Category.accessories,
        id: 2,
        starNum: 1,
        name: 'Hyatt Regency',
        address: '1107 Jamboree Rd, Newport Beach, CA, 92660, USA',
        phone: '+49 25 236 48 75',
        text: 'This hotel is Hyatt Regency located at 1107 Jamboree Rd, Newport Beach, CA, 92660, USA.',
      ),
      Product(
        category: Category.accessories,
        id: 3,
        starNum: 5,
        name: 'Hotel Irvine',
        address: '17900 Jamboree Rd, Irvine, CA, 92614, USA',
        phone: '+46 95 749 48 65',
        text: 'This hotel is Hotel Irvine located at 17900 Jamboree Rd, Irvine, CA, 92614, USA.',
      ),
      Product(
        category: Category.accessories,
        id: 4,
        starNum: 4,
        name: 'Wyndham Orange County',
        address: '1400 Bristol Street, Costa Mesa, CA, 92707, USA',
        phone: '+48 65 223 64 01',
        text: 'This hotel is Wyndham Orange County located at 1400 Bristol Street, Costa Mesa, CA, 92707, USA.',
      ),
      Product(
        category: Category.accessories,
        id: 5,
        starNum: 5,
        name: 'Western Orange County',
        address: '2700 Hotel Terrace Dr., Santana, CA, 92705, USA',
        phone: '+48 32 216 97 87',
        text: 'This hotel is Western  Orange County located at 2700 Hotel Terrace Dr., Santana, CA, 92705, USA.',
      ),
    ];
    if (category == Category.all) {
      return allProducts;
    } else {
      return allProducts.where((Product p) {
        return p.category == category;
      }).toList();
    }
  }
}
