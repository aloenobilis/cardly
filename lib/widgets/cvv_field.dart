import 'package:flutter/material.dart';
import 'package:cardly/blocs/card_bloc.dart';

Widget cvvField(CardBloc bloc) {
  return StreamBuilder(
    stream: bloc.cvv,
    builder: (context, snapshot) {
      return TextField(
        onChanged: bloc.changeCvv,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          hintStyle: TextStyle(color: Colors.grey[600]),
          hintText: '123',
          labelText: 'CVV',
          prefixIcon: const Icon(Icons.password),
          // ignore: prefer_null_aware_operators
          errorText: snapshot.error == null ? null : snapshot.error.toString(),
        ),
      );
    },
  );
}
