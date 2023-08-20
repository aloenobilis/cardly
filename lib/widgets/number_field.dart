import 'package:flutter/material.dart';
import 'package:cardly/blocs/card_bloc.dart';

Widget numberField(CardBloc bloc) {
  return StreamBuilder(
    stream: bloc.number,
    builder: (context, snapshot) {
      return TextField(
        onChanged: bloc.changeNumber,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          hintStyle: TextStyle(color: Colors.grey[600]),
          hintText: '1234 4567 8910 1112',
          labelText: 'Card Number',
          // ignore: prefer_null_aware_operators
          errorText: snapshot.error == null ? null : snapshot.error.toString(),
        ),
      );
    },
  );
}
