function myTimeout (callback, delay){
  var startTime = Date.now();
  var endTime = delay;
  function inner () {
    console.log({"timeWorker": timeWorker});
    if (startTime + endTime <= Date.now()){
      workers.kill(timeWorker);
      timeWorker = null;
      callback();
    }  
  }
  var timeWorker = workers.create(inner);
}
myTimeout(function(){scheduler.schedule(audio.hat.buffer);},100)
