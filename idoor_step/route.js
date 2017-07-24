function route(server,url_map){
  for (var name in url_map){
    var config=url_map[name];
    var path=config.path;
    var method=config.method;
    var respond=config.respond;
    server[method](path,respond);
    console.log(respond);
  }
  console.log('route completed');
}

module.exports={
  route:route
};
