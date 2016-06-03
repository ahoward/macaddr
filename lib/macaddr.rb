##
# Cross platform MAC address determination.  Works for:
# * /sbin/ifconfig
# * /bin/ifconfig
# * ifconfig
# * ipconfig /all
#
# To return the first MAC address on the system:
#
#   Mac.address
#
# To return an array of all MAC addresses:
#
#   Mac.addresses
#

begin
  require 'rubygems'
rescue LoadError
  nil
end

require 'systemu'
require 'socket'

module Mac
  VERSION = '2.0.0'

  def Mac.version
    ::Mac::VERSION
  end

  def Mac.dependencies
    {
      'systemu' => [ 'systemu' , '~> 2.6.2' ]
    }
  end

  def Mac.description
    'cross platform mac address determination for ruby'
  end


  class << self

    ##
    # Accessor for the system's first MAC address, requires a call to #address
    # first

    attr_accessor "mac_address"

    ##
    # Discovers and returns the system's MAC addresses.  Returns the first
    # MAC address, and includes an accessor #list for the remaining addresses:
    #
    #   Mac.addr # => first address
    #   Mac.addrs # => all addresses

    def address
      @mac_address ||= addresses.first
    end

    def addresses
      @mac_addresses ||= from_getifaddrs || from_system
    end

    link   = Socket::PF_LINK   if Socket.const_defined? :PF_LINK
    packet = Socket::PF_PACKET if Socket.const_defined? :PF_PACKET
    INTERFACE_PACKET_FAMILY = link || packet # :nodoc:

    ##
    # Shorter alias for #address

    alias_method "addr", "address"
    alias_method "addrs", "addresses"

    private

    def from_getifaddrs
      return unless Socket.respond_to? :getifaddrs

      interfaces = Socket.getifaddrs.select do |addr|
        addr.addr && addr.addr.pfamily == INTERFACE_PACKET_FAMILY
      end

      if Socket.const_defined? :PF_LINK then
        interfaces.map do |addr|
          addr.addr.getnameinfo
        end.flatten.select do |m|
          !m.empty?
        end
      elsif Socket.const_defined? :PF_PACKET then
        interfaces.map do |addr|
          addr.addr.inspect_sockaddr[/hwaddr=([\h:]+)/, 1]
        end.select do |mac_addr|
          mac_addr != '00:00:00:00:00:00'
        end
      end
    end

    def from_system
      cmds = '/sbin/ifconfig', '/bin/ifconfig', 'ifconfig', 'ipconfig /all', 'cat /sys/class/net/*/address'

      output = nil
      cmds.each do |cmd|
        _, stdout, _ = systemu(cmd) rescue next
        next unless stdout and stdout.size > 0
        output = stdout and break
      end
      raise "all of #{ cmds.join ' ' } failed" unless output

      lines = output.split(/\n/)

      macs = lines.select{|line| line =~ RE}
      macs.map!{|c| c[RE].strip}
    end
  end

  RE = %r/(?:[^:\-]|\A)(?:[0-9A-F][0-9A-F][:\-]){5}[0-9A-F][0-9A-F](?:[^:\-]|\Z)/io
end

MacAddr = Macaddr = Mac
