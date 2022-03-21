require "xx_hash"
require "mac_address"
require "clim"

module Xxhash2mac
  VERSION = "0.1.0"

  def self.gen(str)
    hashed_last = (XXHash.hash32 str).to_s(16)
    hashed_first = (XXHash.hash64 hashed_last).to_s(16).chars[0..3].join
    joined = (hashed_first + hashed_last).chars
    formatted = joined.map_with_index {|c,i|
      ((i + 1) % 2 == 0 && i < joined.size) ? c + ":" : c}.join

    MacAddress::MAC.new formatted
  end

  class Cli < Clim
    main do
      version Xxhash2mac::VERSION

      desc "Generate MAC-address from XXHash'ing of a string"
      usage "xxhash2mac [the string] or echo [the string] | xxhash2mac"

      argument "str",
               type: String,
               required: true,
               desc: "String to xxhash and convert to MAC address"

      run do |opts, args|
        mac_addr = Xxhash2mac.gen args.str

        case mac_addr
        when .multicast?
          puts "unfortunate choice [multicast] - " + mac_addr.hex
        when .broadcast?
          puts "unfortunate choice [broadcast] - " + mac_addr.hex
        when .unicast?
          print mac_addr.hex
        else
          raise "WTF are we doing in this branch?!"
        end
      end
    end
  end
end

Xxhash2mac::Cli.start(STDIN.tty? ? ARGV : [ STDIN.gets_to_end.chomp ])
