=begin
Use this script to send any given message to any given room.

This script requires 2 arguments:
	1st argument is the room XXMP JID (which can be found on the HipChat web client)
	2nd argument is the message text

This script uses environment variables for the badger reminder URL, and the badger key.
The environment varilables are in the .env file (note: this is not in source control). If
there is no .env file in this directory, this script will not work.
=end

require 'httparty'
require 'openssl'
require 'json'
require 'dotenv'

Dotenv.load

if ARGV.length != 2
	abort "\nError: This script requires 2 arguments. The first one 
	is the room XMPP JID (which can be found on the HipChat web client,
	and the second one is the message to be sent to that room. Aborting.\n\n"
end

room_jid = ARGV[0]
message = ARGV[1]

puts 'Sending message to room...'

payload = {:room => room_jid, :message => message}
json_string = payload.to_json.to_s

digest = OpenSSL::Digest.new("md5")
hash = OpenSSL::HMAC.hexdigest(digest, ENV['HUBOT_BADGER_KEY'], json_string)

headers = {"Content-Type" => "application/json", "X-BADGER-HMAC-MD5" => hash}
res = HTTParty.post(ENV['HUBOT_REMIND_URL'], {:body => json_string, :headers => headers})

puts res.body