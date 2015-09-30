var express = require('express');
var app = express();

app.set('views', './client')
app.set('view engine', 'jade');
app.engine('jade', require('jade').__express);

app.use('/lib', express.static('./bower_components'));
app.use('/public', express.static('./client'));

app.listen(3000);

app.all('*', function (req, res) {
  res.render('index');
})
