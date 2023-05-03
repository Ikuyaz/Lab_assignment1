import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:weather/country.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ndialog/ndialog.dart';

void main() => runApp(const MainApp());

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CountrySearch',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Country Searching'),
        ),
        body: const Homepage(),
      ),
    );
  }
}

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Homepage> {
  String _country = '';
  var capital = "", currencyName = "", currencyCode = "", desc = "";
  double gdp = 0.0, gdpGrow = 0.0, population = 0.0;
  var iso2 = "";
  String flag = '';
  Country counInfo = Country("", "", "", 0.0, 0.0, 0.0);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const Text(
            "Country Searching",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          TextField(
            onChanged: (value) {
              setState(() {
                _country = value;
              });
            },
            decoration: InputDecoration(hintText: 'Enter Country'),
          ),
          ElevatedButton(
            onPressed: _searchCountry,
            child: const Text("Search Country"),
          ),
          Text(
            desc,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (flag.isNotEmpty)
            Image.network(
              flag,
              width: 80,
              height: 80,
            ),
          const SizedBox(height: 20),
          Expanded(child: counGrid(counInfo: counInfo)),
        ],
      ),
    );
  }

  void _searchCountry() async {
    ProgressDialog progressDialog = ProgressDialog(context,
        message: const Text("Progress"), title: const Text("Searching..."));
    progressDialog.show();
    var apiid = "xkvvSRQWpWftdhlW+M66BQ==ywsWsent1NQ9vNTe";
    var url = Uri.parse('https://api.api-ninjas.com/v1/country?name=$_country');
    try {
      var response = await http.get(url, headers: {
        'X-Api-Key': apiid,
      });
      var rescode = response.statusCode;
      if (rescode == 200) {
        var jsonData = response.body;
        var parsedJson = json.decode(jsonData);
        if (parsedJson.isNotEmpty) {
          setState(() {
            capital = parsedJson[0]['capital'];
            currencyName = parsedJson[0]['currency']['name'];
            currencyCode = parsedJson[0]['currency']['code'];
            gdp = parsedJson[0]['gdp'];
            population = parsedJson[0]['population'];
            gdpGrow = parsedJson[0]['gdp_growth'];
            iso2 = parsedJson[0]['iso2'];
            counInfo = Country(
                capital, currencyName, currencyCode, gdp, gdpGrow, population);
            flag = 'https://flagsapi.com/$iso2/shiny/64.png';
            progressDialog.dismiss();
          });
        } else {
          setState(() {
            desc = "The Country is Not Available";
            flag = "";
            progressDialog.dismiss();
          });
        }
      } else {
        setState(() {
          desc = "The Country is Not Available";
          flag = "";
          progressDialog.dismiss();
        });
      }
    } catch (e) {
      setState(() {
        progressDialog.dismiss();
      });
    }
  }
}

class counGrid extends StatefulWidget {
  final Country counInfo;

  const counGrid({Key? key, required this.counInfo}) : super(key: key);

  @override
  _counGridState createState() => _counGridState();
}

class _counGridState extends State<counGrid> {
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      primary: false,
      padding: const EdgeInsets.all(20),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      crossAxisCount: 2,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text("Capital"),
              const Icon(
                Icons.location_city,
                size: 64,
              ),
              Text(widget.counInfo.capital)
            ],
          ),
          color: Colors.blue[100],
        ),
        Container(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text("Currency Name"),
              const Icon(
                Icons.currency_exchange,
                size: 64,
              ),
              Text(widget.counInfo.currencyName)
            ],
          ),
          color: Colors.blue[100],
        ),
        Container(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text("Currency Code"),
              const Icon(
                Icons.currency_yen,
                size: 64,
              ),
              Text(widget.counInfo.currencyCode.toString())
            ],
          ),
          color: Colors.blue[100],
        ),
        Container(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text("GDP"),
              const Icon(
                Icons.money,
                size: 64,
              ),
              Text(widget.counInfo.gdp.toString())
            ],
          ),
          color: Colors.blue[100],
        ),
        Container(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text("GDP Growth"),
              const Icon(
                Icons.money_rounded,
                size: 64,
              ),
              Text(widget.counInfo.gdpGrow.toString())
            ],
          ),
          color: Colors.blue[100],
        ),
        Container(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text("Population"),
              const Icon(
                Icons.people,
                size: 64,
              ),
              Text(widget.counInfo.population.toString())
            ],
          ),
          color: Colors.blue[100],
        ),
      ],
    );
  }
}
