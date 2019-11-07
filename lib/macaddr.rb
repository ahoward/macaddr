##
# Cross platform MAC address determination.  Works for:
# * /sbin/ifconfig
# * /bin/ifconfig
# * ifconfig
# * ipconfig /all
# * cat /sys/class/net/*/address
#
# To return the first MAC address on the system:
#
#   Mac.address
#
# To return an array of all MAC addresses:
#
#   Mac.address.list
#

begin
  require 'rubygems'
rescue LoadError
  nil
end

require 'systemu'
require 'socket'

module Mac
  RE                      = %r/(?:[^:\-]|\A)(?:[0-9A-F][0-9A-F][:\-]){5}[0-9A-F][0-9A-F](?:[^:\-]|\Z)/io.freeze
  CMDS                    = ['/sbin/ifconfig', '/bin/ifconfig', 'ifconfig', 'ipconfig /all', 'cat /sys/class/net/*/address'].freeze
  PF_LINK                 = Socket.const_defined?(:PF_LINK) ? Socket::PF_LINK : nil
  PF_PACKET               = Socket.const_defined?(:PF_PACKET) ? Socket::PF_PACKET : nil
  INTERFACE_PACKET_FAMILY = PF_LINK || PF_PACKET # :nodoc:
  VERSION                 = '1.8.0'

  class << self
    def version
      VERSION
    end

    def dependencies
      {
        'systemu' => [ 'systemu' , '~> 2.6.5' ]
      }
    end

    def description
      'cross platform mac address determination for ruby'
    end

    ##
    # Discovers and returns the system's MAC addresses.  Returns the first
    # MAC address, and includes an accessor #list for the remaining addresses:
    #
    #   Mac.addr # => first address
    #   Mac.addr.list # => all addresses

    def address
      @mac_address ||= from_getifaddrs || from_cmds
    end

    ##
    # Shorter alias for #address

    alias_method :addr, :address

    def from_getifaddrs
      return unless Socket.respond_to?(:getifaddrs)

      interfaces = Socket.getifaddrs.map do |addr|
        # Some VPN ifcs don't have an addr - ignore them
        addr.addr if addr.addr.pfamily == INTERFACE_PACKET_FAMILY
      end.compact

      maddrs =
        if PF_LINK
          interfaces.map { |addr| addr.getnameinfo.first }.reject(&:empty?)
        elsif PF_PACKET
          interfaces.
            map { |addr| addr.inspect_sockaddr[/hwaddr=([\h:]+)/, 1] }.
            select { |mac_addr| mac_addr != '00:00:00:00:00:00' }
        end

      maddr = maddrs.first.dup

      maddr.instance_eval { @list = maddrs; def list() @list end }
      maddr
    end

    def from_cmds
      output = CMDS.detect do |cmd|
        _, stdout, _ = systemu(cmd) rescue next

        break parse(stdout)
      end

      output.nil? ? (raise "all of #{ CMDS.join ' ' } failed") : output
    end

    def parse(output)
      lines = output.split(/\n/)

      candidates = lines.map do |line|
        candidate = line[RE].to_s.strip

        candidate unless candidate.empty?
      end.compact

      maddr = candidates.first.dup

      raise 'no mac address found' unless maddr

      maddr.instance_eval { @list = candidates; def list() @list end }
      maddr
    end
  end
end

MacAddr = Macaddr = Mac
