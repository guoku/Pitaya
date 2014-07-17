Pitaya
======

在果库（Blueberry）和果库HD（Pitaya）项目开发中，积累了核心的 `Model` 层 和 `Network` 层。

核心 `Model` 层基于 `GKBaseModel` 类，具备如下特性：

* 支持同时使用服务端和客户端的参数名来生成 `model`，使用 `+ (NSDictionary *)dictionaryForServerAndClientKeys` 来返回一个服务端字段名与客户端属性名的字典。
* 支持联合主键， `+ (NSArray *)keyNames` 用来返回主键属性名的数组。
* 支持通过 `NSDictionary` 来映射 `GKBaseModel`，如果同主键的 `Model` 已存在，则使用 `NSDictionary` 中的值来替换原有 `Model` 的值，然后返回。
* 支持 `KVO`，对于主键相同的 `model`，全局只存在一个实例，因此可以对其进行 `KVO`，从而实现全局的数据同步。
* 支持使用 `NSKeyedArchiver` 和 `NSKeyedUnarchiver` 将 `model` 保存到 `NSUserDefaults`，`GKBaseModel` 已经覆写了 `- (void)encodeWithCoder:(NSCoder *)coder` 和 `- (void)encodeWithCoder:(NSCoder *)coder` 方法。
* 支持忽略服务端的冗余参数，如果不想总是看到不需要的 `Log` 警告，可以使用 `+ (NSArray *)banNames` 来返回要忽略的参数名数组。

核心 `Network` 层基于 `AFNetworking` 1.x 版本，封装了 `GKBaseHTTPClient`、`GKHTTPClient`、`GKAPI`、`GKDataManager` 等类，主要作用是对网络层进行分层并简化网络调用过程，便于调试、修改。

* `GKBaseHTTPClient` 封装了基础的网络请求。
* `GKHTTPClient` 封装了签名、数据跟踪等方法。
* `GKAPI` 封装了服务器的 API 接口。
* `GKDataManager` 封装了网络与本地数据的处理过程。

方法都有详细的注释描述，调用方法可以参考已有项目。
