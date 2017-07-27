var mysql=require('mysql');
var crypte=require('crypto');

var pool=mysql.createPool({
  host:'localhost',
  port:'3306',
  user:'root',
  password:'123',
  database:'maindb',
});

var query=function(sql,params,callback){
  pool.getConnection(function(err,conn){
    if(err){
      callback(err,null,null);
    }else{
      conn.query(sql,params,function(qerr,results,fields){
        conn.release();
        callback(qerr,results,fields);
      });
    }
  });
};
function connectDB(){

  var conn=mysql.createConnection({
    host:'localhost',
    port:'3306',
    user:'root',
    password:'123'
  });

  conn.query('USE maindb');
  return conn;
}

function closeDB(conn){
  conn.end();
}

module.exports={
  connectDB:connectDB,
  closeDB:closeDB,
  query:query
};
