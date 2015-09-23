var mergeData = [];

angular.module('stashApp').controller('clientManagementCtrl', ['$rootScope', '$scope', '$http', '$state', 'Auth',
  function($rootScope, $scope, $http, $state, Auth) {
    $('#mainLayout').layout();
    $('#contentLayout').layout();

    $('#clients').datagrid({'loadFilter': function (ret) {
      var rets = [];

      for(var i = 0; i < ret.items.length; i++) {
        var clientInfo = ret.items[i];
        var merge = {};

        if (clientInfo.contactList.length == 0) {
          rets.push(clientInfo);
        } else{
          mergeData.push({index:i, rowspan:clientInfo.contactList.length});
          for(var j = 0; j < clientInfo.contactList.length; j++) {
            var contractInfo = clientInfo.contactList[j];
            var newClientInfo = {
              name: clientInfo.name,
              address: clientInfo.address,
              contacts_name: contractInfo.name,
              contacts_tel: contractInfo.tel,
              contacts_email: contractInfo.email,
              desc: clientInfo.desc,
            };
            rets.push(newClientInfo);
          }
        }
      }

      return {total: rets.length, rows:rets};
    }});
  }
]);

var mergeCol = function (merge, colName) {
  $('#clients').datagrid('mergeCells', {
    index: merge.index,
    field: colName,
    rowspan: merge.rowspan
  });
}

var onLoadSuccess = function (data) {
  for(var i = 0; i < mergeData.length; i++) {
    var merge = mergeData[i];
    mergeCol(merge, 'name');
    mergeCol(merge, 'address');
    mergeCol(merge, 'desc');
  }
}
