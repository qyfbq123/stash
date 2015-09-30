var mergeData = [];

angular.module('stashApp').controller('clientManagementCtrl', ['$rootScope', '$scope', '$http', '$state', 'Auth',
  function($rootScope, $scope, $http, $state, Auth) {
    $('#mainLayout').layout();
    $('#contentLayout').layout();
    $('createClientDlg').dialog();

    $('#clients').datagrid({'loadFilter': function (ret) {
      var rets = [];
      console.log(ret);

      for(var i = 0; i < ret.rows.length; i++) {
        var clientInfo = ret.rows[i];
        var merge = {};

        if (clientInfo.contacts.length == 0) {
          rets.push(clientInfo);
        } else{
          mergeData.push({index:i, rowspan:clientInfo.contacts.length});
          for(var j = 0; j < clientInfo.contacts.length; j++) {
            var contractInfo = clientInfo.contacts[j];
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

    $('#addClientBtn').bind('click', function () {
      console.log('addClientBtn');
      $('createClientDlg').dialog('open');
    });

    $('#editClientBtn').bind('click', function () {
      console.log('editClientBtn');
      $('createClientDlg').dialog('close');
    });

    $('#removeClientBtn').bind('click', function () {
      console.log('removeClientBtn');
    });

    $('#disableClientBtn').bind('click', function () {
      console.log('disableClientBtn');
    });

    $('#enableClientBtn').bind('click', function () {
      console.log('enableClientBtn');
    });
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
