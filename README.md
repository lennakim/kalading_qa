## 用户登录

在config/settings.yml里，确保kalading\_management_api.uri指向后台API测试服务器"http://t.kalading.com:81"（默认值）

预先创建的帐号如下：

### 客服
* 18655551001
* 18655551002
* 18655551003

### 客服主管
* 18655552001

### 专家

* 18655554001
* 18655554002
* 18655554003

### 总裁

* 18655555001

密码都是6个1

如果测试服务器暂时不可用，可以把config/settings.yml里的use\_local\_data\_to\_sign_in改为true（默认是false），用本地数据来登录，不调用后台API。
