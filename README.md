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

## 初始数据

创建并连接好数据库后，运行

    rake db:seed

确保config/settings.yml里的kalading\_management_api配置好，并且指向的测试服务器可用时，运行

    rake qa:update_token
    rake qa:sync_dispatcher_data
    rake qa:sync_engineer_data
    rake qa:sync_specialist_data
    rake qa:sync_support_manager_data
    rake qa:sync_auto_data

一般来说，本地开发的话，这些数据只需要同步一次。
