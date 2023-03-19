import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:web3dart/web3dart.dart';

class WalletProvider with ChangeNotifier {
  String? walletAddress;
  int? chainId;
  late http.Client httpClient;
  late Web3Client ethClient;
  List nftData = [];
  bool loadingNFT = true;
  List myNftData = [];

  void initializeClients() {
    httpClient = http.Client();
    ethClient = Web3Client(
        "https://polygon-mumbai.g.alchemy.com/v2/COKz8_epH0YoMSNB2TYNwIcj0RmoqCtm",
        httpClient);
    notifyListeners();
  }

  Future<dynamic> submit({
    required String functionName,
    required List<dynamic> args,
  }) async {
    if (walletAddress == null) {
      print("Connect Wallet");
      return "Connect wallet";
    }
    EthPrivateKey creds = EthPrivateKey.fromHex(
      "4a6afa7d929efbabf550774690c023a8350da900eece39acbbcb6b3b3f308d4f",
    );
    DeployedContract contract = await loadContract();
    final ethFunction = contract.function(functionName);

    try {
      final senderAddress = EthereumAddress.fromHex(walletAddress!);
      final transactionCount =
          await ethClient.getTransactionCount(senderAddress);
      final gasPrice = await ethClient.getGasPrice();
      print("the tra is ${senderAddress}");

      // final gp = gasPrice  BigInt.from(2);

      final result = await ethClient.sendTransaction(
        creds,
        Transaction.callContract(
          contract: contract,
          function: ethFunction,
          parameters: args,
          from: senderAddress,
          nonce:
              transactionCount + 10, // Set nonce to highest known nonce minus 1
          gasPrice: gasPrice, // Set a high gas price
          maxGas: 9000000,

          // Gas limit for a simple ETH transfer
          // to: senderAddress, // Send to self
          value: EtherAmount.zero(), //
          // nonce: transactionCount,
          // gasPrice: EtherAmount.inWei(BigInt.one),
          // maxGas: 100000,
        ),
        // fetchChainIdFromNetworkId: true,
        chainId: 80001,
      );
      print("result is $result");
      return result;
    } catch (e) {
      print("the error was $e");
      return {
        "error": e,
        "status": "error",
      };
    }
  }

  Future<String> buyNFT(
      {required tokenID, required BuildContext context}) async {
    var response = await submit(functionName: "buyNft", args: [tokenID]);
    if (response["status"] == "error") {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              'Error',
              style: TextStyle(color: Colors.red),
            ),
            content: Text('Something Went Wrong.\n\n\n${response["error"]}'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
    // if (response) print("Bought Nft $response");
    return response;
  }

  Future<void> getAllNft() async {
    if (nftData.length > 0) {
      return;
    }
    loadingNFT = true;
    notifyListeners();
    final contract = await loadContract();
    List<dynamic> result = await query(functionName: "getAllNFTs", args: []);
    List data = result[0];
    List<Future<Map<String, dynamic>>> jsonData = data.map((e) async {
      var result = await query(functionName: "tokenURI", args: [e.first]);
      var tokenURI = result[0];
      var meta = await http.get(Uri.parse(tokenURI));
      var datame = jsonDecode(meta.body);
      print("the datame is $datame");
      var json = {
        "player": e[2],
        "owner": e[1],
        "tokenId": e[0],
        "viewurl": datame["viewurl"],
        "decription": datame["decription"],
        "price": datame["price"],
        "name": datame["name"],
      };
      print("the json is $json");
      return json;
    }).toList();
    // var jsonData = data.first.first;
    print("the data is $data and json is ${jsonData.runtimeType}");
    // List nD = jsonData.map((e) async {
    //   var m = await e;
    //   return m;
    // }).toList();
    // print("the runtype is ${nD.runtimeType}");

    List<Map<String, dynamic>> resultList = await Future.wait(jsonData);

    nftData.addAll(resultList);
    loadingNFT = false;
    notifyListeners();
  }

  Future<void> getMyNft() async {
    loadingNFT = true;
    notifyListeners();
    final contract = await loadContract();
    List<dynamic> result = await query(functionName: "getMyNFTs", args: []);
    List data = result[0];
    print("mynfts data is $data");
    List<Future<Map<String, dynamic>>> jsonData = data.map((e) async {
      var result = await query(functionName: "tokenURI", args: [e.first]);
      var tokenURI = result[0];
      var meta = await http.get(Uri.parse(tokenURI));
      var datame = jsonDecode(meta.body);
      print("the datame is $datame");
      var json = {
        "player": e[2],
        "owner": e[1],
        "tokenId": e[0],
        "viewurl": datame["viewurl"],
        "decription": datame["decription"],
        "price": datame["price"],
        "name": datame["name"],
      };
      print("the json is $json");
      return json;
    }).toList();
    // var jsonData = data.first.first;
    print("the MYNFT data  is $data and json is ${jsonData.runtimeType}");
    // List nD = jsonData.map((e) async {
    //   var m = await e;
    //   return m;
    // }).toList();
    // print("the runtype is ${nD.runtimeType}");

    List<Map<String, dynamic>> resultList = await Future.wait(jsonData);

    myNftData.addAll(resultList);
    loadingNFT = false;
    notifyListeners();
  }

  Future<List<dynamic>> query(
      {required String functionName, required List<dynamic> args}) async {
    final contract = await loadContract();
    final ethFunction = contract.function(functionName);
    final senderAddress =
        walletAddress != null ? EthereumAddress.fromHex(walletAddress!) : null;
    print("The Sender address is ${senderAddress} for function $functionName");
    final result = await ethClient.call(
      contract: contract,
      function: ethFunction,
      params: args,
      sender: senderAddress,
    );
    return result;
  }

  Future<DeployedContract> loadContract() async {
    String abi = await rootBundle.loadString("assets/abi.json");
    String address = "0xa2d8142ab8952a1E494159DF6C0C1A311075A9FB";
    final contract = DeployedContract(
        ContractAbi.fromJson(abi, "NFTMarketplace"),
        EthereumAddress.fromHex(address));
    return contract;
  }

  void setWalletAddress({required String wallAdd, required int chain}) {
    walletAddress = wallAdd;
    chainId = chain;
    notifyListeners();
  }

  String? getWallAdd() {
    return walletAddress;
  }
}
