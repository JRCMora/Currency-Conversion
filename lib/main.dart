import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const CurrencyConverter());
}

class CurrencyConverter extends StatefulWidget {
  const CurrencyConverter({Key? key}) : super(key: key);

  @override
  _CurrencyConverterState createState() => _CurrencyConverterState();
}

class _CurrencyConverterState extends State<CurrencyConverter> {
  final amount = TextEditingController();
  final result = TextEditingController();

  String _selectedCurrency1 = 'PHP';
  String _selectedCurrency2 = 'USD';

  Future<void> _fetchExchangeRates({
    required String fromCurrency,
    required String toCurrency,
    required String amount,
  }) async {
    final response = await http.get(
        Uri.parse(
            'https://api.apilayer.com/exchangerates_data/convert?to=$toCurrency&from=$fromCurrency&amount=$amount'),
        headers: {'apikey': '405wDSX8lCW6BEJJEpUjFpA926CEZU6E'});

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        result.text = data['result'].toStringAsFixed(2);
      });
    } else {
      throw Exception('Failed to fetch exchange rates');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchExchangeRates(
      fromCurrency: _selectedCurrency1,
      toCurrency: _selectedCurrency2,
      amount: amount.text,
    );
  }

  void _convertCurrency() {
    _fetchExchangeRates(
      fromCurrency: _selectedCurrency1,
      toCurrency: _selectedCurrency2,
      amount: amount.text,
    );
  }

  void _swapCurrencies() {
    setState(() {
      final temp = _selectedCurrency1;
      _selectedCurrency1 = _selectedCurrency2;
      _selectedCurrency2 = temp;
      final amountValue = amount.text;
      amount.text = result.text;
      result.text = amountValue;
    });
    _convertCurrency();
  }

  final _currencyFlags = {
    'BRL': 'assets/br.png',
    'CAD': 'assets/ca.png',
    'CNY': 'assets/cn.jpg',
    'EUR': 'assets/eu.jpg',
    'GBP': 'assets/gb.jpg',
    'HKD': 'assets/hk.jpg',
    'ILS': 'assets/ils.png',
    'INR': 'assets/inr.jpg',
    'JPY': 'assets/jp.jpg',
    'KRW': 'assets/kr.jpg',
    'MYR': 'assets/my.png',
    'NOK': 'assets/no.png',
    'NZD': 'assets/nz.png',
    'PHP': 'assets/ph.png',
    'QAR': 'assets/qa.png',
    'RUB': 'assets/ru.png',
    'SAR': 'assets/sa.png',
    'SEK': 'assets/se.png',
    'SGD': 'assets/sg.png',
    'THB': 'assets/th.png',
    'TRY': 'assets/tr.png',
    'USD': 'assets/us.png',
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Currency Converter',
            style: TextStyle(fontSize: 24, letterSpacing: 1.5),
          ),
          actions: const [
            Icon(
              Icons.storage,
              size: 50,
            )
          ],
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 16.0),
                TextField(
                    controller: amount,
                    decoration: const InputDecoration(
                      filled: true,
                      labelText: 'Amount',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true)),
                const SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            filled: true,
                            labelText: 'From',
                            border: OutlineInputBorder(),
                          ),
                          value: _selectedCurrency1,
                          onChanged: (value) {
                            setState(() {
                              _selectedCurrency1 = value!;
                            });
                            _convertCurrency();
                          },
                          items: _currencyFlags.keys.map((currency) {
                            return DropdownMenuItem(
                              value: currency,
                              child: Row(
                                children: [
                                  Image.asset(
                                    _currencyFlags[currency]!,
                                    height: 30,
                                    width: 30,
                                  ),
                                  const SizedBox(width: 10.0),
                                  Text(currency),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _swapCurrencies,
                      child: const SizedBox(
                        width: 30,
                        height: 30,
                        child: Icon(Icons.swap_horiz, size: 30),
                      ),
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            filled: true,
                            labelText: 'To',
                            border: OutlineInputBorder(),
                          ),
                          value: _selectedCurrency2,
                          onChanged: (value) {
                            setState(() {
                              _selectedCurrency2 = value!;
                            });
                            _convertCurrency();
                          },
                          items: _currencyFlags.keys.map((currency) {
                            return DropdownMenuItem(
                              value: currency,
                              child: Row(
                                children: [
                                  Image.asset(
                                    _currencyFlags[currency]!,
                                    height: 30,
                                    width: 30,
                                  ),
                                  const SizedBox(width: 8.0),
                                  Text(currency),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: result,
                  decoration: const InputDecoration(
                    filled: true,
                    labelText: 'Result',
                    border: OutlineInputBorder(),
                  ),
                  readOnly: true,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _convertCurrency,
                  child: const Text('Convert', style: TextStyle(fontSize: 25)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
