import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:lykke_mobile_mavn/base/remote_data_source/api/customer/response_model/real_estate_properties_response_model.dart';

class ExtendedInstalmentModel extends Equatable {
  const ExtendedInstalmentModel({
    @required this.instalment,
    @required this.isOverdue,
    @required this.localDueDate,
    @required this.formattedDate,
  });

  final Instalment instalment;
  final bool isOverdue;
  final DateTime localDueDate;
  final String formattedDate;

  @override
  List get props => [
        instalment,
        isOverdue,
        localDueDate,
        formattedDate,
      ];
}
