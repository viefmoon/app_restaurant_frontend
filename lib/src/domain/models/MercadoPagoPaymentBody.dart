import 'dart:convert';

import 'package:ecommerce_flutter/src/domain/models/MercadoPagoCardTokenBody.dart';
import 'package:ecommerce_flutter/src/domain/models/Order.dart';
import 'package:ecommerce_flutter/src/domain/models/Product.dart';

MercadoPagoPaymentBody mercadoPagoPaymentBodyFromJson(String str) => MercadoPagoPaymentBody.fromJson(json.decode(str));

String mercadoPagoPaymentBodyToJson(MercadoPagoPaymentBody data) => json.encode(data.toJson());

class MercadoPagoPaymentBody {
    int transactionAmount;
    String token;
    int installments;
    String issuerId;
    String paymentMethodId;
    Payer payer;
    OrderBody order;

    MercadoPagoPaymentBody({
        required this.transactionAmount,
        required this.token,
        required this.installments,
        required this.issuerId,
        required this.paymentMethodId,
        required this.payer,
        required this.order,
    });

    factory MercadoPagoPaymentBody.fromJson(Map<String, dynamic> json) => MercadoPagoPaymentBody(
        transactionAmount: json["transaction_amount"],
        token: json["token"],
        installments: json["installments"],
        issuerId: json["issuer_id"],
        paymentMethodId: json["payment_method_id"],
        payer: Payer.fromJson(json["payer"]),
        order: OrderBody.fromJson(json["order"]),
    );

    Map<String, dynamic> toJson() => {
        "transaction_amount": transactionAmount,
        "token": token,
        "installments": installments,
        "issuer_id": issuerId,
        "payment_method_id": paymentMethodId,
        "payer": payer.toJson(),
        "order": order.toJson(),
    };
}

class OrderBody {
    int idClient;
    int idAddress;
    List<Product> products;

    OrderBody({
        required this.idClient,
        required this.idAddress,
        required this.products,
    });

    factory OrderBody.fromJson(Map<String, dynamic> json) => OrderBody(
        idClient: json["id_client"],
        idAddress: json["id_address"],
        products: List<Product>.from(json["products"].map((x) => Product.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id_client": idClient,
        "id_address": idAddress,
        "products": List<dynamic>.from(products.map((x) => x.toJson())),
    };
}

class Payer {
    String email;
    Identification identification;

    Payer({
        required this.email,
        required this.identification,
    });

    factory Payer.fromJson(Map<String, dynamic> json) => Payer(
        email: json["email"],
        identification: Identification.fromJson(json["identification"]),
    );

    Map<String, dynamic> toJson() => {
        "email": email,
        "identification": identification.toJson(),
    };
}


