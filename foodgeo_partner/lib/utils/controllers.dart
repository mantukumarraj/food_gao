import 'package:flutter/cupertino.dart';

import '../models/user_model.dart';

class BankController extends ChangeNotifier {
  String? _selectedBank;


  String? get selectedBank => _selectedBank;

  void selectBank(String bank) {
    _selectedBank = bank;
    notifyListeners();
  }

  List<Bank> getBanks() {
    return [
      Bank('State Bank of India (SBI)', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT9dhBBncqAyN9i7ieF5iNiNqVU7jVmae6A_Q&s'),
      Bank('Punjab National Bank (PNB)', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRHKZIBRYWiGMt9humlZd2eFgugtoafCpkUgw&s'),
      Bank('Bank of India (BOI)', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQEaM_Hzxicc-RheSVs4XFo5es6BdnB6bsp6Q&s'),
      Bank('HDFC Bank', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTROMzSAtGwQ7HC7z5nCjp_sxsh9V0j-FHNtA&s'),
      Bank('ICICI Bank', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR90VPUlXQZYk95XoXwrcjXGD_ybFAlGUIgeA&s'),
      Bank('Axis Bank', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQVywZyfh-81ewm_R9ReCrH5F47RoYJDTYc3g&s'),
      Bank('Kotak Mahindra Bank', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRq5F3StdgqmvXqE-MUS5MwYrrdOpMWO66l3w&s'),
      Bank('Yes Bank', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTgjck1mLj1D55sBcqvT_RXJT-7GBK0xgfQFg&s'),
    ];
  }
}

