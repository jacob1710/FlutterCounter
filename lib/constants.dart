import 'package:flutter/material.dart';


const kNotAllowedNames = ["add","all","alter","and","as","autoincrement","between","case","check","collate","commit","constraint","create","default","deferrable","delete","distinct","drop","else","escape","except","exists","foreign","from","group","having","if","in","index","insert","intersect","into","is","isnull","join","limit","not","notnull","null","on","or","order","primary","references","select","set","table","then","to","transaction","union","unique","update","using","values","when","where"];
const Map<int,String> kNameErrorCodes = {406:"Name not allowed",409:"Name in use",200:"Ok"};