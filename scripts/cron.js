// Description:
//   ipukun の Cronjob 機能
//

var cronJob = require('cron').CronJob;
var meigen = require('../src/class/ipuhubot-meigen');
var printf = require('printf');

module.exports = function(robot) {
  send = function(room, msg) {
    robot.messageRoom(room, msg);
  }

  // {{{ Daily
  new cronJob('0 0 0 * * *', function() {
    send("#general", "夜更かししちゃだめだぞ");
  }).start();
  // }}}

  // {{{ WeekDay
  new cronJob('0 0 9 * * 1,2,3,4,5', function() {
    send("#general", "今日も一日がんばりましょー！");
    meigen.get('', function(body) {
      if (body == 'error') {
        send("#general", "No meigen No Life");
      } else {
        send("#general", printf('%s by %s\n%s', body.meigen, body.author, body.image));
      }
    })
  }).start();

  new cronJob('0 0 12 * * 1,2,3,4,5', function() {
    send("#general", "午後も張り切っていこー！");
  }).start();

  new cronJob('0 0 18 * * 1,2,3,4,5', function() {
    send("#general", "今日も一日お疲れ様！");
  }).start();
  // }}}
}
