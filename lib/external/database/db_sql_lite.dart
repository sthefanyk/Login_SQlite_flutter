import 'package:login_with_sqllite/external/database/user_table_schema.dart';
import 'package:login_with_sqllite/model/user_mapper.dart';
import 'package:login_with_sqllite/model/user_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SqlLiteDb {
  //static final SqlLiteDb instance = SqlLiteDb._();
  static Database? _db;

  //SqlLiteDb._();
  Future<Database> get dbInstance async {
    // retorna a intancia se já tiver sido criada
    if (_db != null) return _db!;

    _db = await _initDB('users.db');
    UserModel admin = UserModel(
        userId: 'admin',
        userName: 'administrador',
        userEmail: 'admin@email.com',
        userPassword: 'admin',
        userType: 'admin');
    _db?.insert(UserTableSchema.nameTable, UserMapper.toMapBD(admin));
    return _db!;
  }

  Future<Database> _initDB(String dbName) async {
    // definie o caminho padrao para salvar o banco
    final dbPath = await getDatabasesPath();

    // define nome e onde sera salvo o banco
    String path = join(dbPath, dbName);

    // cria o banco
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreateSchema,
    );
  }

  // executa script de criacao de tabelas
  Future<void> _onCreateSchema(Database db, int? versao) async {
    await db.execute(UserTableSchema.createUserTableScript());
  }

  Future<int> saveUser(UserModel user) async {
    var dbClient = await dbInstance;
    var res = await dbClient.insert(
      UserTableSchema.nameTable,
      UserMapper.toMapBD(user),
    );

    return res;
  }

  Future<UserModel?> getUser(String userId) async {
    var dbClient = await dbInstance;
    var res = await dbClient.rawQuery(
      "SELECT * FROM ${UserTableSchema.nameTable} WHERE "
      "${UserTableSchema.userIDColumn} = '$userId'",
    );

    if (res.isNotEmpty) {
      return UserMapper.fromMapBD(res.first);
    }

    return null;
  }

  Future<List<UserModel>?> getAllUser() async {
    var dbClient = await dbInstance;
    var res = await dbClient.rawQuery(
      "SELECT * FROM ${UserTableSchema.nameTable}"
    );

    List<UserModel> users = List.empty(growable: true);

    for (var user in res) {
      if (UserMapper.fromMapBD(user).userType != 'admin') {
        users.add(UserMapper.fromMapBD(user));
      }
    }

    return users;
  }

  Future<int> updateUser(UserModel user) async {
    var dbClient = await dbInstance;
    var res = await dbClient.update(
      UserTableSchema.nameTable,
      UserMapper.toMapBD(user),
      where: '${UserTableSchema.userIDColumn} = ?',
      whereArgs: [user.userId],
    );
    return res;
  }

  Future<int> deleteUser(String userId) async {
    var dbClient = await dbInstance;
    var res = await dbClient.delete(
      UserTableSchema.nameTable,
      where: '${UserTableSchema.userIDColumn} = ?',
      whereArgs: [userId],
    );
    return res;
  }

  Future<UserModel?> getLoginUser(String userId, String password) async {
    var dbClient = await dbInstance;
    var res = await dbClient.rawQuery(
      "SELECT * FROM ${UserTableSchema.nameTable} WHERE "
      "${UserTableSchema.userIDColumn} = '$userId' AND "
      "${UserTableSchema.userPasswordColumn} = '$password'",
    );

    if (res.isNotEmpty) {
      return UserMapper.fromMapBD(res.first);
    }

    return null;
  }
}
