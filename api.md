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
