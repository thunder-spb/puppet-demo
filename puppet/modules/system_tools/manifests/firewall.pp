# Class: system_tools::firewall
#
# Setup base firewall rules:
# - accept ping (ICMP packets)
# - accept established and related connetions
# - connections to default ssh port (22)
# - NetBIOS ports 137/138 opened
# - all connections on local interface accepted
# - all outgoing connections allowed
#
# For debug I've added logging for rejected queries to syslog
#
# Parameters:
#   No input parameters
#
# Examples:
#   require system_tools::firewall
#
# Authors:
#   alex thunder shevchenko // iam@thunder.spb.ru, 2016
class system_tools::firewall {
exec { 'base-firewall-rules':
  path => ["/bin", "/sbin", "/usr/bin", "/usr/sbin"],
  command => "iptables -P INPUT DROP \
    && iptables -P FORWARD DROP \
    && iptables --flush \
    && iptables -t nat --flush \
    && iptables --delete-chain \
    && iptables -P FORWARD DROP \
    && iptables -P INPUT DROP \
    && iptables -A INPUT -i lo -j ACCEPT \
    && iptables -A INPUT -m state --state INVALID -j DROP \
    && iptables -A INPUT -m state --state \"ESTABLISHED,RELATED\" -j ACCEPT \
    && iptables -A INPUT -p icmp --icmp-type destination-unreachable -j ACCEPT \
    && iptables -A INPUT -p icmp --icmp-type time-exceeded -j ACCEPT \
    && iptables -A INPUT -p icmp --icmp-type echo-request -j ACCEPT \
    && iptables -A INPUT -p icmp --icmp-type echo-reply -j ACCEPT \
    && iptables -A INPUT -p udp --dport 137 -j ACCEPT \
    && iptables -A INPUT -p udp --dport 138 -j ACCEPT \
    && iptables -A INPUT -p tcp --dport ssh -j ACCEPT \
    && iptables -A INPUT -j LOG --log-prefix \"INPUT:DROP:\" --log-level 6 \
    && iptables -A INPUT -j DROP",
  }
}

# == Define: system_tools::open_port
#
# Full description of defined resource type system_tools::open_port here.
# add to iptables port and protocol
# 
# number "INPUT 10" means that all rules will be inserted before "ssh" port rule (see "")
#
# === Parameters
#
# Document parameters here
#
# - "name" - unique
# - port - port to be opened, required
# - protocol - protocol (tcp|udp) , optional, default tcp
# - comment - comment for that port/proto, optional, default empty
#
# === Examples
#
# Provide some examples on how to use this type:
#
#   system_tools::open_port { http: port => 80, protocol => tcp, comment => 'http port for apache' }
#
define system_tools::open_port ($port, $protocol = 'tcp', $comment = '') {
  exec { "open $name":
    path => ["/bin", "/sbin", "/usr/bin", "/usr/sbin"],
    command => "iptables -I INPUT 10 -p $protocol --dport $port -m comment --comment '$comment' -j ACCEPT",
    require => Exec['base-firewall-rules'],
  }
  ## ugly hack, save every time iptables rules into file.
  exec { "save-iptables-$name":
    path => ["/bin", "/sbin", "/usr/bin", "/usr/sbin"],
    command => 'iptables-save > /etc/sysconfig/iptables',
    require => Exec["open $name"],
  }
}
