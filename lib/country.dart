import 'package:flutter/material.dart';

class Country {
  var capital = '', currencyName = "", currencyCode = "";
  double gdp = 0.0, gdpGrow = 0.0, population = 0.0;
  Country(this.capital, this.currencyName, this.currencyCode, this.gdp,
      this.gdpGrow, this.population);
}
