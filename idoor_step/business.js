var datahandler=require('./datahandler.js');
var database=require('./database.js');
var moment=require('moment');

var query=database.query;

//上传步数
function update_steps(req,res,next){
  console.log('update steps');

  var user_id=req.body.userId;
  var steps=req.body.steps;
  var d=new Date(req.body.date);

  var date=moment(d).format('YYYY-MM-DD');
  console.log('userId:'+user_id+'\ndate:'+date+'\nsteps:'+steps);

  //打开数据库
  //var conn=database.connectDB();

  //查找当天是否存在数据
  var user_sel_sql='SELECT * FROM user WHERE userid=? AND date=?';
  query(user_sel_sql,[user_id,date],function(err,results,fields){
    console.log('selected completed------');
    console.log('err:'+err);
    if(err){
      console.log('select user err:'+err.code);
      datahandler.sendFailure(res,'查找数据错误');
    }else{
      console.log('length:'+results.length);
      if(results.length===0){
        //插入数据
        var user_ins_sql='INSERT INTO user(userid,steps,date) VALUES(?,?,?)';
        query(user_ins_sql,[user_id,steps,date],function(err,results,fields){
          if(err){
            console.log('insert err:'+err.code);
            datahandler.sendFailure(res,'插入数据错误');
          }else{
            datahandler.sendSuccess(res,'添加数据成功');
          }
        });

      }else{
        //更新数据
        var user_upd_sql='UPDATE user SET steps=? WHERE userid=? AND date=?';
        query(user_upd_sql,[steps,user_id,date], function(err,results,fields){
          if(err){
            console.log('update err:'+err.code);
            datahandler.sendFailure(res,'更新数据错误');
          }else{
            datahandler.sendSuccess(res,'更新数据成功');
          }
        });
      }
    }
    //database.closeDB(conn);
  });
  return next();
}

//日期格式化
Date.prototype.Format=function(fmt){
  var o={
    "M+":this.getMonth()+1,
    "d+":this.getDate(),
    "h+":this.getHours(),
    "m+":this.getMinutes(),
    "s+":this.getSeconds(),                 //秒
    "q+":Math.floor((this.getMonth()+3)/3), //季度
    "S":this.getMilliseconds()              //毫秒
  };
  if(/(y+)/.test(fmt)) fmt=fmt.replace(RegExp.$1,(this.getFullYear()+"").substr(4-RegExp.$1.length));
  for(var k in o)
    if (new RegExp("("+k+")").test(fmt)){
      fmt=fmt.replace(RegExp.$1,(RegExp.$1.length==1) ? (o[k]) : (("00"+o[k]).substr((""+o[k]).length)));
    }
  return fmt;
}


//查询步数
function get_steps(req,res,next){
  console.log('get steps');

  var target=req.body.target;
  //var date=Date(req.body.date).Format("yyyy-MM-dd");
  var d=new Date(req.body.date);
  var d2=moment(d).format('YYYY-MM-DD');
  var date=d.toLocaleDateString()+' '+d.toLocaleTimeString();
  console.log('target:'+target+'\ndate:'+date);

  //打开数据库
  var conn=database.connectDB();

  var user_sel_sql="SELECT * FROM user WHERE DATE_FORMAT(date,'%y-%m-%d')=DATE_FORMAT(?,'%y-%m-%d') AND steps>=?";

  //查找数据
  query(user_sel_sql,[d2,target],function(err,results,fields){
    if(err){
      console.log('select user err:'+err.code);
      datahandler.sendFailure(res,'查找数据失败');
    }else{
      var customResult = [];
      for (var i in results){
        var result=results[i];
        customResult.push({
          'userId': result.userid,
          'steps':result.steps,
          'date':d2
        });
      }
      var sortResult=customResult.sort(function(a,b){ return b.steps-a.steps});
      datahandler.sendSuccess(res,sortResult);
    }
    database.closeDB(conn);
  });
}
//output
module.exports={
  updateSteps:update_steps,
  getSteps:get_steps
};
