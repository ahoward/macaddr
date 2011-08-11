require 'mac/version'

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
#   Mac.address.list
#

begin
  require 'rubygems'
rescue LoadError
  nil
end

require 'systemu'



module Mac
  class << self
    def version
      ::Mac::VERSION
    end

    ##
    # Accessor for the system's first MAC address, requires a call to #address
    # first

    attr_accessor "mac_address"

    ##
    # Discovers and returns the system's MAC addresses.  Returns the first
    # MAC address, and includes an accessor #list for the remaining addresses:
    #
    #   Mac.addr # => first address
    #   Mac.addr.list # => all addresses

    def address
      return @mac_address if defined? @mac_address and @mac_address
      re = %r/[^:\-](?:[0-9A-F][0-9A-F][:\-]){5}[0-9A-F][0-9A-F][^:\-]/io
      cmds = '/sbin/ifconfig', '/bin/ifconfig', 'ifconfig', 'ipconfig /all'

      null = test(?e, '/dev/null') ? '/dev/null' : 'NUL'

      lines = nil
      cmds.each do |cmd|
        status, stdout, stderr = systemu(cmd) rescue next
        next unless stdout and stdout.size > 0
        lines = stdout.split(/\n/) and break
      end
      raise "all of #{ cmds.join ' ' } failed" unless lines

      candidates = lines.select{|line| line =~ re}
      raise 'no mac address candidates' unless candidates.first
      candidates.map!{|c| c[re].strip}

      maddr = candidates.first
      raise 'no mac address found' unless maddr

      maddr.strip!
      maddr.instance_eval{ @list = candidates; def list() @list end }

      @mac_address = maddr
    end

    ##
    # Shorter alias for #address

    alias_method "addr", "address"
  end
end

Macaddr = Mac
