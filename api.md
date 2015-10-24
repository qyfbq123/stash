客户列表：/client/page
参数：{page,rows}
返回：数组

新增客户：/client/create
参数：｛name,address,contacts:[{name,tel,email}]},desc}
返回：{status,message}

客户更新：/client/update
参数：｛name,address,contacts:[{name,tel,email}]},desc}
返回：{status,message}

客户禁用：/client/disabled
参数：ids(单个禁用就传一个id，多个禁用传一个id数组)
返回：{status, message}


----------------------------------------------------------
----------------------------------------------------------
----------------------------------------------------------


用户列表:/user/page
参数：{page, rows}
返回：{total: xxx, rows: [{id,created,modified,locked,username,address,tel,cname,客户数据(object),角色列表(array)}…]}

用户新增：/user/create
参数：{id,created,modified,locked,username,address,tel,cname,客户数据(object),角色列表(array)}
返回：{status, message}


获取客户的所有角色列表：/client/allRoles
参数：clientId（不传代表获取当前客户组的所有角色)
返回：角色数组


客户2种
 issystem字段，
    为1系统客户 --- 可看所有客户的 产品，用户，
    为0普通客户 ---

角色
    管理员
    操作员
    观察员
