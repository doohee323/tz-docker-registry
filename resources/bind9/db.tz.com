;
; BIND data file for local loopback interface
;
$TTL    604800
@       IN      SOA     tz.com. root.tz.com. (
                              2         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@       IN      NS      ns.tz.com.
@       IN      A       PUBLIC_IP
@       IN      AAAA    ::1
ns      IN       A       PUBLIC_IP
