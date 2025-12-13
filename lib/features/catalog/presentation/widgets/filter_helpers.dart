import 'package:flutter/material.dart';

String getFilterTitle(String filterKey) {
  switch (filterKey) {
    case 'sort':
      return 'Порядок';
    case 'color':
      return 'Цвет';
    case 'type':
      return 'Тип';
    case 'sugar':
      return 'Сахар';
    case 'price':
      return 'Цена';
    case 'country':
      return 'Страна';
    case 'region':
      return 'Регион';
    case 'grape':
      return 'Сорт';
    case 'rating':
      return 'Рейтинг';
    case 'year':
      return 'Год';
    case 'volume':
      return 'Объем';
    default:
      return filterKey;
  }
}