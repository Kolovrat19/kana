import 'package:appwrite/appwrite.dart';
import 'package:kana/utils/constants.dart';


class DBConectionSingleton {
  DBConectionSingleton._internal();

  static final DBConectionSingleton _singleton =
      DBConectionSingleton._internal();

  factory DBConectionSingleton() {
    return _singleton;
  }

  Account get account {
    Client client = getClient();
    final Account account = Account(client);
    return account;
  }

  Databases get database {
    Client client = getClient();
    final Databases database = Databases(client);
    return database;
  }

  Storage get storage {
    Client client = getClient();
    final Storage storage = Storage(client);
    return storage;
  }

  Realtime get realtime {
    Client client = getClient();
    final Realtime realtime = Realtime(client);
    return realtime;
  }

  Client getClient() {
    Client client = Client();
    Client getClient = client
        .setEndpoint(Constants.appServerUrl)
        .setProject(Constants.projectId)
        .setSelfSigned();
    return getClient;
  }
}
