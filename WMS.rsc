#LOGGING, true/false#
:local iDebug "true"
#WLAN INTERFACE#
:local iFace "wlan1"
#GW ID#
:local gwId "WAG-D4-GBL"
#WLAN ID#
:local wlanId "PTPATXXXXX-N/TLK-CI-XXXXX:XX"
#USERNAME, note: word sebelum @freeMS di bagian fetch itu random / acak, terserah mau diganti / tidak.#
:local userId "user"
#PASSWORD#
:local passId "password"
 
:if ($iDebug = "true") do={:log warning "init, release dhcp-client..."};
/ip dns cache flush
/ip dhcp-client release [find interface=$iFace];
:delay 10
:local ipAdd [/ip address get [/ip address find interface=$iFace] address];
:local ipAddr [put [:pick $ipAdd 0 [:find $ipAdd "/"]]];
:local macAddr [/interface wireless get [find default-name=$iFace] mac-address];
:local iUrl ("https://welcome2.wifi.id/wms/auth/authnew/autologin/quarantine.php\?ipc=$ipAddr&gw_id=$gwId&mac=$macAddr&redirect=&wlan=$wlanId&landURL=&username_=$userId&username=$userId.1QWl@freeMS&password=$passId")
/tool fetch http-method=post http-header-field="user-agent: Mozilla/5.0" url="$iUrl" dst-path=wms.txt
:delay 5
:if ($iDebug = "true") do={
 :local iRes [/file get wms.txt contents];
 :log warning $iRes
 :file remove wms.txt
} else={:file remove wms.txt};
