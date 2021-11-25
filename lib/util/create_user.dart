import 'package:bip39/bip39.dart';
import 'package:skynet/skynet.dart';

Future<bool> createUser(String mnemonic) async {
  final SkynetClient client = SkynetClient();
  final SkynetUser user = await SkynetUser.fromMySkySeedRaw(mnemonicToSeed(mnemonic));

  return false;
}
