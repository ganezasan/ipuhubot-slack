# Description:
#   Github
#
# Commands:
#   hubot issue list - show issues list
#   hubot add issue <title> <body> - post issue
#   hubot committer list - show committer list

github = require 'githubot'
printf = require 'printf'

module.exports = (robot) ->
    unless (url_api_base = process.env.HUBOT_GITHUB_API)?
        url_api_base = "https://api.github.com"

    robot.respond /ISSUES$/i, (msg) ->
        github.get "#{url_api_base}/repos/sasarky/ipuhubot/issues", (issues) ->
          for issue in issues
            # pull req はここではみせない
            if issue.pull_request
              continue
            msg.send printf "[#%d] %s ( %s ) By %s", issue['number'], issue['title'], issue['html_url'], issue['user']['login']

    robot.respond /ADD\sISSUE (.*) (.*)$/i, (msg) ->
        # 行頭および行末の ' もしくは " を削除
        title = msg.match[1].replace(/^[\'\"]|[\'\"]$/g, '')
        body = msg.match[2].replace(/^[\'\"]|[\'\"]$/g, '')
        github.post "#{url_api_base}/repos/sasarky/ipuhubot/issues", {title: title, body: body}, (issue) ->
            console.log issue
            msg.send "ありがとう！issue #{issue.number} 「#{issue.title}」 を発行したよ！ #{issue.html_url}"

    robot.respond /CLOSE\sISSUE\s(\d*)$/i, (msg) ->
        num = msg.match[1]
        github.patch "#{url_api_base}/repos/sasarky/ipuhubot/issues/#{num}", {state: 'closed'}, (issue) ->
            msg.send "おめでとう！issue #{issue.number} 「#{issue.title}」 を完了したよ！ #{issue.html_url}"

    robot.respond /CONTRIBUTORS$/i, (msg) ->
        github.get "#{url_api_base}/repos/sasarky/ipuhubot-slack/contributors", (info) ->
          for i in info
            msg.send printf "%s: %d", i.login, i.contributions

    robot.respond /OCTOCAT$/i, (msg) ->
        base_url = "https://octodex.github.com"
        github.get "https://octodexapi.herokuapp.com", (info) ->
            msg.send "#{base_url}#{msg.random(info)['image']}"

    robot.respond /PR\sLIST/i, (msg) ->
        github.get "#{url_api_base}/repos/sasarky/ipuhubot/pulls", (pull_requests) ->
            unless pull_requests.length
              msg.send 'ない！\n Pull Request がない！'
              return
            message = 'Pull Request だよ！見てあげてね！\n'
            for pr in pull_requests
                message = message + "[##{pr.number}][#{pr.title}] #{pr.html_url} by #{pr.user.login}\n"
            msg.send message
