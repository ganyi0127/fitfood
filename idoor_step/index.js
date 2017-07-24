var restify=require('restify');
var router=require('./route.js');
var business=require('./business.js');

var server=restify.createServer({
  name:'recordstepsserver'
});
server.listen(8080);
server.use(restify.plugins.throttle({
  burst:100,  //并发次数
  rate:50,    //每秒请求次数
  ip:true,
  overrides:{
    '192.168.1.1':{
      rate:0,
      burst:0
    }
  }
}));

server.use(restify.plugins.acceptParser(server.acceptable));
server.use(restify.plugins.queryParser());
server.use(restify.plugins.gzipResponse());
server.use(restify.plugins.bodyParser());
server.use(restify.plugins.jsonp());

router.route(server,{
  '上传步数':{
    'path':'/addsteps',
    'method':'post',
    'respond':business.updateSteps
  },
  '查询步数':{
    'path':'/selectsteps',
    'method':'post',
    'respond':business.getSteps
  }
});

