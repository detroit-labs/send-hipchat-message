Send HipChat Messages via Ruby Script
====================

Use this repository if you wish to send HipChat messages to any given room via a Ruby script through Hubot.

Description
---

This is used to send "Get Up!" notifications every 15 minutes. We use this to remind us to stand up, stretch out, and maybe walk around, every 15 minutes throughout the work day.

Usage
---

This uses [Ruby Gems](https://rubygems.org/), along with [Bundler](http://bundler.io/) for dependency management. See the websites for isntallation instructions.

Remember to run `bundle install`.

You must create your own `.env` file and store it in the root of this repository in order for the script(s) to work as expected. The script(s) use [dotenv](https://github.com/bkeepers/dotenv) to load the environment variables. The `.env` file is *not*, and should not be in source control.

The format for the `.env` file should be as follows:

```
HUBOT_BADGER_KEY=<your key>
HUBOT_REMIND_URL=<your hubot remind endpoint>
```

For more on the `HUBOT_REMIND_URL`, see [this repository](github.com/detroit-labs/hubot-badger).


Use the script `send_message_to_room.rb` to send a message to any room. This script requires 2 command line arugments:

- 1st argument is the room XXMP JID (which can be found on the HipChat web client; see image below)
- 2nd argument is the message text

<p align="center" >
  <img src="https://raw.githubusercontent.com/detroit-labs/send-hipchat-message/master/assets/xmpp_jid_location.png" title="xmpp_jid_location">
</p>

Example:

```bash
ruby send_message_to_room.rb 12345_roomname@conf.hipchat.com "Get up and stretch."
```

We use `crontab` to schedule reminders to send the get up notification. We made a script to call the Ruby script to send the message. We didn't commit this, because it contains sensitive information, such as the room `XMPP JID`.

**GOTCHYA**: Since this Ruby script has dependencies, they need to be installed in the environment in which cron runs. To do this, use the command `rvm cron setup` to setup the `rvm` environment inside the cron environment.

The crontab instruction for that is as follows:

```bash
15,30,45,59 15-16,18-21 * * 1-5 sh /path/to/repo/send_get_up_message.sh 
```

This calls `send_get_up_message.sh` on the 15, 30, 45, and 59 minute mark of every hour from 15:00-21:00 (UTC time), excluding from 17:00-18:00 (lunch), Monday-Friday. For more information about cronjobs, check out [this](http://www.thegeekstuff.com/2009/06/15-practical-crontab-examples/).


