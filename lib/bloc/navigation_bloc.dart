


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NavigationCubit extends Cubit<Widget>{

  NavigationCubit() : super(SizedBox.shrink());

  final List<Widget> navigatorStack = [];

  void push(Widget page){
    navigatorStack.add(page);
    emit(page);
  }

  void pushReplacement(Widget page){
    navigatorStack.clear();
    navigatorStack.add(page);
    emit(page);
  }

  void pop(){

    if(navigatorStack.isEmpty) return;
    navigatorStack.remove(navigatorStack.last);

    if(navigatorStack.isEmpty) return;
    emit(navigatorStack.last);
  }

}