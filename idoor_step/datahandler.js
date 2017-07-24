function sendSuccess(res, result){
  res.send({
    'resultCode':1,
    'data':result
  });
}

function sendFailure(res,reason){
  res.send({
    'result':0,
    'data':reason
  });
}

module.exports={
  sendSuccess:sendSuccess,
  sendFailure:sendFailure
};
