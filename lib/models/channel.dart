// To parse this JSON data, do
//
//     final channel = channelFromJson(jsonString);

import 'dart:convert';

Channel channelFromJson(String str) => Channel.fromJson(json.decode(str));

String channelToJson(Channel data) => json.encode(data.toJson());

String channelsToJson(List<Channel> data) {
  final dyn = new List<dynamic>.from(data.map((x) => x.toJson()));
  return json.encode(dyn);
}

List<Channel> channelsFromJson(String str) {
  final jsonData = json.decode(str);
  return new List<Channel>.from(jsonData.map((x) => Channel.fromJson(x)));
}

class Channel {
  String channelId;
  String channelName;
  double price;
  String channelCost;
  bool selected;
  bool package;
  String billable;

  Channel({
    this.channelId,
    this.channelName,
    this.price,
    this.channelCost,
    this.selected,
    this.package,
    this.billable,
  });

  factory Channel.fromJson(Map<String, dynamic> json) => new Channel(
        channelId: json["id"] == null ? null : json["id"],
        channelName: json["channelName"] == null ? null : json["channelName"],
        price: json["price"] == null ? null : json["price"].toDouble(),
        selected: json["isChannel"] == null ? false : json["isChannel"],
      );

  Map<String, dynamic> toJson() => {
        "id": channelId == null ? null : channelId,
        "channelName": channelName == null ? null : channelName,
        "price": price == null ? null : price,
      };
}
