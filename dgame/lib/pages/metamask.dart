import 'package:dgame/providers/wallet_provider.dart';
import 'package:dgame/utils/buttons.dart';
import 'package:dgame/widgets/nfts_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slider_button/slider_button.dart';
import 'package:web3dart/crypto.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var connector = WalletConnect(
      bridge: 'https://bridge.walletconnect.org',
      clientMeta: const PeerMeta(
          name: 'My App',
          description: 'An app for converting pictures to NFT',
          url: 'https://walletconnect.org',
          icons: [
            'https://files.gitbook.com/v0/b/gitbook-legacy-files/o/spaces%2F-LJJeCjcLrr53DcT1Ml7%2Favatar.png?alt=media'
          ]));

  var _session, _uri, _signature;

  loginUsingMetamask(BuildContext context) async {
    if (!connector.connected) {
      try {
        var session = await connector.createSession(onDisplayUri: (uri) async {
          _uri = uri;
          await launchUrlString(uri, mode: LaunchMode.externalApplication);
        });
        print(session.accounts[0]);
        print(session.chainId);
        setState(() {
          _session = session;
        });
      } catch (exp) {
        print(exp);
      }
    }
  }

  // signMessageWithMetamask(BuildContext context, String message) async {
  //   if (connector.connected) {
  //     try {
  //       print("Message received");
  //       print(message);

  //       EthereumWalletConnectProvider provider =
  //           EthereumWalletConnectProvider(connector);
  //       launchUrlString(_uri, mode: LaunchMode.externalApplication);
  //       var signature = await provider.personalSign(
  //           message: message, address: _session.accounts[0], password: "");
  //       print(signature);
  //       setState(() {
  //         _signature = signature;
  //       });
  //     } catch (exp) {
  //       print("Error while signing transaction");
  //       print(exp);
  //     }
  //   }
  // }

  getNetworkName(chainId) {
    switch (chainId) {
      case 1:
        return 'Ethereum Mainnet';
      case 3:
        return 'Ropsten Testnet';
      case 4:
        return 'Rinkeby Testnet';
      case 5:
        return 'Goreli Testnet';
      case 42:
        return 'Kovan Testnet';
      case 137:
        return 'Polygon Mainnet';
      case 80001:
        return 'Mumbai Testnet';
      default:
        return 'Unknown Chain';
    }
  }

  getMyNfts() async {
    await context.read<WalletProvider>().getMyNft();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getMyNfts();
    });
  }

  @override
  Widget build(BuildContext context) {
    connector.on(
        'connect',
        (session) => setState(
              () {
                _session = _session;
                context.read<WalletProvider>().setWalletAddress(
                      wallAdd: _session.accounts[0],
                      chain: _session.chainId,
                    );
              },
            ));
    connector.on(
        'session_update',
        (payload) => setState(() {
              _session = payload;

              print(_session.accounts[0]);
              print(_session.chainId);
            }));
    connector.on(
        'disconnect',
        (payload) => setState(() {
              _session = null;
            }));

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              SizedBox(height: 50),
              Image.asset("assets/images/metamask.gif", fit: BoxFit.fitHeight),
              SizedBox(height: 50),
              //Lottie.network("https://assets5.lottiefiles.com/packages/lf20_2omr5gpu.json",animate:true,fit: BoxFit.fitHeight),
              (_session != null ||
                      context.read<WalletProvider>().walletAddress != null)
                  ? Container(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Public Address:',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          Text(
                            // '${_session.accounts[0]}',
                            context
                                .read<WalletProvider>()
                                .walletAddress
                                .toString(),
                            style: GoogleFonts.inconsolata(fontSize: 16),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Text(
                                'Chain: ',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              Text(
                                getNetworkName(
                                  context.read<WalletProvider>().chainId,
                                ),
                                style: GoogleFonts.inconsolata(fontSize: 16),
                              )
                            ],
                          ),
                          const SizedBox(height: 20),
                          (context.read<WalletProvider>().chainId != 80001)
                              ? Row(
                                  children: const [
                                    Icon(Icons.warning,
                                        color: Colors.redAccent, size: 15),
                                    Text('Network not supported. Switch to '),
                                    Text(
                                      'Mumbai Testnet',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    // Row(
                                    //   children: [
                                    //     Text(
                                    //       "Signature: ",
                                    //       style: TextStyle(
                                    //           fontWeight: FontWeight.bold,
                                    //           fontSize: 16),
                                    //     ),
                                    //     Text(
                                    //         truncateString(
                                    //             _signature.toString(), 4, 2),
                                    //         style: GoogleFonts.inconsolata(
                                    //             fontSize: 16))
                                    //   ],
                                    // ),
                                    // const SizedBox(height: 20),
                                    // SliderButton(
                                    //   action: () async {
                                    //     // TODO: Navigate to main page
                                    //   },
                                    //   label: const Text('Slide to login'),
                                    //   icon: const Icon(Icons.check),
                                    // )
                                  ],
                                )
                        ],
                      ))
                  : FancyButton(
                      child: Text("Connect with Metamask"),
                      color: Color(0xffFF2281),
                      size: 20,
                      onPressed: () => loginUsingMetamask(context),
                    ),
              SizedBox(
                height: 12,
              ),
              context.watch<WalletProvider>().myNftData.isEmpty
                  ? Center(
                      child: Text(
                        "Please Buy Some Nfts",
                        style: TextStyle(color: Colors.red),
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount:
                          context.watch<WalletProvider>().myNftData.length,
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        var data =
                            context.read<WalletProvider>().myNftData[index];
                        return NFTCard(
                          index: index,
                          jsonData: data,
                          context: context,
                          isMyNft: true,
                        );
                      },
                    )
              // : ElevatedButton(
              // onPressed: () => loginUsingMetamask(context),
              // child: const Text("Connect with Metamask"))
            ],
          ),
        ),
      ),
    );
  }
}

String truncateString(String text, int front, int end) {
  int size = front + end;

  if (text.length > size) {
    String finalString =
        "${text.substring(0, front)}...${text.substring(text.length - end)}";
    return finalString;
  }

  return text;
}

String generateSessionMessage(String accountAddress) {
  String message =
      'Hello $accountAddress, welcome to our app. By signing this message you agree to learn and have fun with blockchain';
  print(message);

  var hash = keccakUtf8(message);
  final hashString = '0x${bytesToHex(hash).toString()}';

  return hashString;
}
