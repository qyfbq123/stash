var express = require('express');
var exphbs  = require('express-handlebars');
var app = express();

app.set('views', './client/view')
app.set('view engine', 'jade');
app.engine('jade', require('jade').__express);

app.use('/js', express.static('./client/js'));
app.use('/views', express.static('./client/view'));
app.use('/public', express.static('./bower_components'));
app.use('/static', express.static('./client/static'));

app.listen(3000);

app.all('*', function (req, res) {
  res.render('index');
})
