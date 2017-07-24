var mysql=require('mysql');
var crypte=require('crypto');

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
  closeDB:closeDB
};
