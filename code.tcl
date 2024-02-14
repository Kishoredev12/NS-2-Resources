#***********************VANET Simulation*****************************************
set val(chan)           Channel/WirelessChannel    ;#Channel Type
set val(prop)           Propagation/TwoRayGround   ;# radio-propagation model
set val(netif)          Phy/WirelessPhy            ;# network interface type
set val(mac)            Mac/802_11                 ;# MAC type
set val(ifq)            Queue/DropTail/PriQueue    ;# interface queue type
set val(ll)             LL                         ;# link layer type
set val(ant)            Antenna/OmniAntenna        ;# antenna model
set val(ifqlen)         50                         ;# max packet in ifq
set val(nn)             128                         ;# number of mobilenodes
set val(rp)             DSDV                       ;# routing protocol
set val(x)		8500
set val(y)		8500
set val(stop)		100

######################################################################

Phy/WirelessPhyExt set CSThresh_                3.162e-12   ;#-85 dBm Wireless interface sensitivity (sensitivity defined in the standard)
Phy/WirelessPhyExt set Pt_                      0.001         
Phy/WirelessPhyExt set freq_                    5.9e+9
Phy/WirelessPhyExt set noise_floor_             1.26e-13    ;#-99 dBm for 10MHz bandwidth
Phy/WirelessPhyExt set L_                       1.0         ;#default radio circuit gain/loss
Phy/WirelessPhyExt set PowerMonitorThresh_      6.310e-14   ;#-102dBm power monitor  sensitivity
Phy/WirelessPhyExt set HeaderDuration_          0.000040    ;#40 us
Phy/WirelessPhyExt set BasicModulationScheme_   0
Phy/WirelessPhyExt set PreambleCaptureSwitch_   1
Phy/WirelessPhyExt set DataCaptureSwitch_       0
Phy/WirelessPhyExt set SINR_PreambleCapture_    2.5118;     ;# 4 dB
Phy/WirelessPhyExt set SINR_DataCapture_        100.0;      ;# 10 dB
Phy/WirelessPhyExt set trace_dist_              1e6         ;# PHY trace until distance of 1 Mio. km ("infinty")
Phy/WirelessPhyExt set PHY_DBG_                 0

Mac/802_11Ext set CWMin_                        15
Mac/802_11Ext set CWMax_                        1023
Mac/802_11Ext set SlotTime_                     0.000013
Mac/802_11Ext set SIFS_                         0.000032
Mac/802_11Ext set ShortRetryLimit_              7
Mac/802_11Ext set LongRetryLimit_               4
Mac/802_11Ext set HeaderDuration_               0.000040
Mac/802_11Ext set SymbolDuration_               0.000008
Mac/802_11Ext set BasicModulationScheme_        0
Mac/802_11Ext set use_802_11a_flag_             true
Mac/802_11Ext set RTSThreshold_                 2346
Mac/802_11Ext set MAC_DBG                       0


set ns [new Simulator] 

#Creating trace file and nam file

set tracefd       [open van.tr w]

set namtrace      [open van.nam w]

$ns trace-all $tracefd
$ns namtrace-all-wireless $namtrace $val(x) $val(y)


# set up topography object
set topo       [new Topography]

$topo load_flatgrid $val(x) $val(y)

create-god $val(nn)


# configure the nodes
        $ns node-config -adhocRouting $val(rp) \
                   -llType $val(ll) \
                   -macType $val(mac) \
                   -ifqType $val(ifq) \
                   -ifqLen $val(ifqlen) \
                   -antType $val(ant) \
                   -propType $val(prop) \
                   -phyType $val(netif) \
                   -channelType $val(chan) \
                   -topoInstance $topo \
                   -agentTrace ON \
                   -routerTrace ON \
                   -macTrace ON \
                   -movementTrace ON
                   
      for {set i 0} {$i < $val(nn) } { incr i } {
            set node_($i) [$ns node]     
      }

# Road mapping
$node_(0) set X_ -66.415
$node_(0) set Y_ 4154.68
$node_(0) set Z_ 0.0

$node_(1) set X_ 2177.45
$node_(1) set Y_ 4147.76
$node_(1) set Z_ 0.0

$node_(2) set X_ 2179.27
$node_(2) set Y_ 5856.6
$node_(2) set Z_ 0.0

$node_(3) set X_ 3223.2
$node_(3) set Y_ 5846.71
$node_(3) set Z_ 0.0

$node_(4) set X_ 3219.76
$node_(4) set Y_ 4150.35
$node_(4) set Z_ 0.0

$node_(5) set X_ 5549.98
$node_(5) set Y_ 4151.36
$node_(5) set Z_ 0.0

$node_(6) set X_ 3219.8
$node_(6) set Y_ 1153.77
$node_(6) set Z_ 0.0

$node_(7) set X_ 3215.91
$node_(7) set Y_ 2923.74
$node_(7) set Z_ 0.0

$node_(8) set X_ 5529.65
$node_(8) set Y_ 2926.93
$node_(8) set Z_ 0.0

$node_(9) set X_ -86.122
$node_(9) set Y_ 2920.48
$node_(9) set Z_ 0.0

$node_(10) set X_ 2183.82
$node_(10) set Y_ 2920.39
$node_(10) set Z_ 0.0

$node_(11) set X_ 2184.5
$node_(11) set Y_ 1135.54
$node_(11) set Z_ 0.0

$node_(12) set X_ -119.54
$node_(12) set Y_ 3542.58
$node_(12) set Z_ 0.0

$node_(13) set X_ 2174.69
$node_(13) set Y_ 3540.44
$node_(13) set Z_ 0.0

$node_(14) set X_ 2200.7
$node_(14) set Y_ 2920.21
$node_(14) set Z_ 0.0

$node_(15) set X_ 3198.82
$node_(15) set Y_ 2922.95
$node_(15) set Z_ 0.0

$node_(16) set X_ 2178.16
$node_(16) set Y_ 2935.97
$node_(16) set Z_ 0.0

$node_(17) set X_ 2175.89
$node_(17) set Y_ 4127.3
$node_(17) set Z_ 0.0

$node_(18) set X_ 2193.02
$node_(18) set Y_ 4152.16
$node_(18) set Z_ 0.0

$node_(19) set X_ 3205.16
$node_(19) set Y_ 4151.98
$node_(19) set Z_ 0.0

$node_(20) set X_ 2710.09
$node_(20) set Y_ 1139.07
$node_(20) set Z_ 0.0

$node_(21) set X_ 2707.79
$node_(21) set Y_ 2923.85
$node_(21) set Z_ 0.0

$node_(22) set X_ 3216.0
$node_(22) set Y_ 4140.47
$node_(22) set Z_ 0.0

$node_(23) set X_ 3215.86
$node_(23) set Y_ 2947.73
$node_(23) set Z_ 0.0

$node_(24) set Y_ 4164.43
$node_(24) set X_ 2711.03
$node_(24) set Z_ 0.0

$node_(25) set Y_ 5857.66
$node_(25) set X_ 2711.03
$node_(25) set Z_ 0.0




##############

$node_(26) set Y_ 3543.88
$node_(26) set X_ 2203.08
$node_(26) set Z_ 0.0

$node_(27) set Y_ 3543.88
$node_(27) set X_ 3186.02
$node_(27) set Z_ 0.0

$node_(28) set Y_ 2944.81
$node_(28) set X_ 2716.19
$node_(28) set Z_ 0.0

$node_(29) set Y_ 4134.03
$node_(29) set X_ 2716.19
$node_(29) set Z_ 0.0

$node_(30) set X_ 5506.65
$node_(30) set Y_ 3546.77
$node_(30) set Z_ 0.0

$node_(31) set X_ 3216.6
$node_(31) set Y_ 3545.81
$node_(31) set Z_ 0.0


#################


$node_(32) set X_ -66.400
$node_(32) set Y_ 3928.80
$node_(32) set Z_ 0.0

$node_(33) set X_ 3177.35
$node_(33) set Y_ 3934.36
$node_(33) set Z_ 0.0

$node_(34) set X_ -69.3372
$node_(34) set Y_ 3720.88
$node_(34) set Z_ 0.0

$node_(35) set X_ 3181.41
$node_(35) set Y_ 3716.9
$node_(35) set Z_ 0.0

$node_(36) set X_ -85.81
$node_(36) set Y_ 3336.63
$node_(36) set Z_ 0.0

$node_(37) set X_ 2714.33
$node_(37) set Y_ 3343.74
$node_(37) set Z_ 0.0

$node_(38) set X_ -84.29
$node_(38) set Y_ 3121.72
$node_(38) set Z_ 0.0

$node_(39) set X_ 2709.29
$node_(39) set Y_ 3120.99
$node_(39) set Z_ 0.0

$node_(40) set X_ 2390.68
$node_(40) set Y_ 4158.5
$node_(40) set Z_ 0.0

$node_(41) set X_ 2371.09
$node_(41) set Y_ 5859.19
$node_(41) set Z_ 0.0

$node_(42) set X_ 2566.56
$node_(42) set Y_ 4165.75
$node_(42) set Z_ 0.0

$node_(43) set X_ 2562.81
$node_(43) set Y_ 5856.13
$node_(43) set Z_ 0.0

$node_(44) set X_ 2883.58
$node_(44) set Y_ 2968.68
$node_(44) set Z_ 0.0

$node_(45) set X_ 2902.46
$node_(45) set Y_ 5867.21
$node_(45) set Z_ 0.0

$node_(46) set X_ 3052.42
$node_(46) set Y_ 2957.97
$node_(46) set Z_ 0.0

$node_(47) set X_ 3065.72
$node_(47) set Y_ 5859.64
$node_(47) set Z_ 0.0

$node_(48) set X_ 3215.31
$node_(48) set Y_ 3935.73
$node_(48) set Z_ 0.0

$node_(49) set X_ 8393.83
$node_(49) set Y_ 3944.92
$node_(49) set Z_ 0.0

$node_(50) set X_ 3218.04
$node_(50) set Y_ 3721.85
$node_(50) set Z_ 0.0

$node_(51) set X_ 8387.29
$node_(51) set Y_ 3740.53
$node_(51) set Z_ 0.0

$node_(52) set X_ 2699.53
$node_(52) set Y_ 3340.07
$node_(52) set Z_ 0.0

$node_(53) set X_ 8457.29
$node_(53) set Y_ 3365.5
$node_(53) set Z_ 0.0

$node_(54) set X_ 2719.36
$node_(54) set Y_ 3122.54
$node_(54) set Z_ 0.0

$node_(55) set X_ 8468.8
$node_(55) set Y_ 3149.42
$node_(55) set Z_ 0.0

$node_(56) set X_ 2388.11
$node_(56) set Y_ 4130.05
$node_(56) set Z_ 0.0

$node_(57) set X_ 2384.85
$node_(57) set Y_ 1162.84
$node_(57) set Z_ 0.0

$node_(58) set X_ 2572.41
$node_(58) set Y_ 4134.76
$node_(58) set Z_ 0.0

$node_(59) set X_ 2550.06
$node_(59) set Y_ 1172.48
$node_(59) set Z_ 0.0

$node_(60) set X_ 2881.2
$node_(60) set Y_ 2921.86
$node_(60) set Z_ 0.0

$node_(61) set X_ 2881.3
$node_(61) set Y_ 1181.44
$node_(61) set Z_ 0.0

$node_(62) set X_ 3050.14
$node_(62) set Y_ 2919.77
$node_(62) set Z_ 0.0

$node_(63) set X_ 3065.91
$node_(63) set Y_ 1174.17
$node_(63) set Z_ 0.0

$node_(100) set X_ 6596.38
$node_(100) set Y_ 2918.74
$node_(100) set Z_ 0.0

$node_(101) set X_ 5574.51
$node_(101) set Y_ 4146.66
$node_(101) set Z_ 0.0

###########


$node_(102) set X_ 6567.17
$node_(102) set Y_ 4165.24
$node_(102) set Z_ 0.0

$node_(103) set X_ 132.70
$node_(103) set Y_ 4050.83
$node_(103) set Z_ 0.0

$node_(104) set X_ 51.73
$node_(104) set Y_ 4044.24
$node_(104) set Z_ 0.0

$node_(105) set X_ -34.33
$node_(105) set Y_ 4042.24
$node_(105) set Z_ 0.0

$node_(106) set X_ 2970.4
$node_(106) set Y_ 5460.58
$node_(106) set Z_ 0.0

$node_(107) set X_ 2977.16
$node_(107) set Y_ 5090.8
$node_(107) set Z_ 0.0

$node_(108) set X_ 435.0
$node_(108) set Y_ 3813.26
$node_(108) set Z_ 0.0

$node_(109) set X_ 656.53
$node_(109) set Y_ 3625.14
$node_(109) set Z_ 0.0

$node_(110) set X_ 6368.26
$node_(110) set Y_ 5756.52
$node_(110) set Z_ 0.0

$node_(111) set X_ 6535.27
$node_(111) set Y_ 5468.82
$node_(111) set Z_ 0.0

$node_(112) set X_ 5803.99
$node_(112) set Y_ 1345.52
$node_(112) set Z_ 0.0


$node_(114) set X_ 5621.89
$node_(114) set Y_ 1524.75
$node_(114) set Z_ 0.0

$node_(113) set X_ 6016.92
$node_(113) set Y_ 1548.41
$node_(113) set Z_ 0.0

$node_(115) set X_ 5813.94
$node_(115) set Y_ 1716.93
$node_(115) set Z_ 0.0


$node_(116) set X_ 7824.67
$node_(116) set Y_ 3037.64
$node_(116) set Z_ 0.0

$node_(117) set X_ 7810.88
$node_(117) set Y_ 3414.12
$node_(117) set Z_ 0.0


$node_(118) set X_ 8209.18
$node_(118) set Y_ 3255.86
$node_(118) set Z_ 0.0

$node_(119) set X_ 8026.88
$node_(119) set Y_ 3250.51
$node_(119) set Z_ 0.0

##########

$node_(120) set X_ 1695.68
$node_(120) set Y_ 2490.31
$node_(120) set Z_ 0.0


$node_(121) set X_ 5030.90
$node_(121) set Y_ 4547.70
$node_(121) set Z_ 0.0

$node_(122) set X_ 4018.78
$node_(122) set Y_ 4496.18
$node_(122) set Z_ 0.0

$node_(123) set X_ 4328.34
$node_(123) set Y_ 2493.90
$node_(123) set Z_ 0.0


$node_(124) set X_ 8175.41
$node_(124) set Y_ 4525.14
$node_(124) set Z_ 0.0

$node_(125) set X_ 77.490
$node_(125) set Y_ 4599.26
$node_(125) set Z_ 0.0

$node_(126) set X_ 6887.34
$node_(126) set Y_ 2565.54
$node_(126) set Z_ 0.0

$node_(127) set X_ 4243.31
$node_(127) set Y_ 6563.42
$node_(127) set Z_ 0.0

# subclass Agent/MessagePassing to make it do flooding

    # extract message ID from message
	    #puts "\nNode [$node_ node-addr] got message $message_id\n"
		
Class Agent/MessagePassing/Flooding -superclass Agent/MessagePassing
Agent/MessagePassing/Flooding instproc recv {source sport size data} {
    $self instvar messages_seen node_
    global ns BROADCAST_ADDR 
    set message_id [lindex [split $data ":"] 0]
    if {[lsearch $messages_seen $message_id] == -1} {
	lappend messages_seen $message_id
        $ns trace-annotate "[$node_ node-addr] received HELLO {$data} from $source"
        $ns trace-annotate "[$node_ node-addr] sending HELLO message $message_id"
	$self sendto $size $data $BROADCAST_ADDR $sport
    } else {    
    }
}

Agent/MessagePassing/Flooding instproc send_message {size message_id data port} {
    $self instvar messages_seen node_
    global ns MESSAGE_PORT BROADCAST_ADDR

    lappend messages_seen $message_id
    $ns trace-annotate "[$node_ node-addr] sending HELLO message $message_id"
    $self sendto $size "$message_id:$data" $BROADCAST_ADDR $port
}

set SequenceID                  0
set PrevSequenceID              0
set TotalPacketsRecieved        0

set InputVideoSequence Verbose_DieFirma_16.dat
set InputVideoSequenceFD [open $InputVideoSequence r]
while {[eof $InputVideoSequenceFD] == 0} {
  gets $InputVideoSequenceFD current_line
  if {[string length $current_line] == 0 ||
      [string compare [string index $current_line 0] "#"] == 0} {
    continue  
  }
  scan $current_line "%d%s%d" next_time type length


#set length [expr $length / 10] 
  
  set SheduledTime [ expr $next_time.0 /1000.0 ] 
  
     puts "$SheduledTime $length"
     
  #puts $SheduledTime
  #$ns at $SheduledTime "$MultipathAgent(0) send_to_node 9 $AGENT_PORT  $length {#VF#$SequenceID#}"
  #$ns at $SheduledTime "$ns trace-annotate \"$SheduledTime : The Video Packet with ID : $SequenceID has been Transmitted\""
  set SequenceID [expr $SequenceID + 1 ]
  #puts $fpSent "[expr $next_time] [expr $length]"
}


close $InputVideoSequenceFD


set finishtime [expr $SheduledTime +  1 ]
    $ns at $finishtime  "finish"
set finishtime [expr $SheduledTime +  2 ]
    $ns at $finishtime "puts \"NS EXITING...\" ; $ns halt"


#Making Road map
$ns duplex-link $node_(0) $node_(1) 0Mb 100ms DropTail
$ns duplex-link $node_(1) $node_(2) 0Mb 100ms DropTail

$ns duplex-link $node_(3) $node_(4) 0Mb 100ms DropTail
$ns duplex-link $node_(4) $node_(5) 0Mb 100ms DropTail


$ns duplex-link $node_(6) $node_(7) 0Mb 100ms DropTail
$ns duplex-link $node_(7) $node_(8) 0Mb 100ms DropTail

$ns duplex-link $node_(9) $node_(10) 0Mb 100ms DropTail
$ns duplex-link $node_(10) $node_(11) 0Mb 100ms DropTail

$ns duplex-link $node_(81) $node_(82) 0Mb 100ms DropTail
$ns duplex-link $node_(82) $node_(83) 0Mb 100ms DropTail
$ns duplex-link $node_(83) $node_(88) 0Mb 100ms DropTail
$ns duplex-link $node_(88) $node_(81) 0Mb 100ms DropTail

$ns duplex-link $node_(12) $node_(13) 0Mb 100ms DropTail
$ns duplex-link $node_(14) $node_(15) 0Mb 100ms DropTail
$ns duplex-link $node_(16) $node_(17) 0Mb 100ms DropTail
$ns duplex-link $node_(18) $node_(19) 0Mb 100ms DropTail
$ns duplex-link $node_(20) $node_(21) 0Mb 100ms DropTail
$ns duplex-link $node_(22) $node_(23) 0Mb 100ms DropTail
$ns duplex-link $node_(24) $node_(25) 0Mb 100ms DropTail
$ns duplex-link $node_(26) $node_(27) 0Mb 100ms DropTail
$ns duplex-link $node_(28) $node_(29) 0Mb 100ms DropTail
$ns duplex-link $node_(30) $node_(31) 0Mb 100ms DropTail

$ns duplex-link-op $node_(14) $node_(15) color "white"
$ns duplex-link-op $node_(16) $node_(17) color "white"
$ns duplex-link-op $node_(18) $node_(19) color "white"
$ns duplex-link-op $node_(22) $node_(23) color "white"
$ns duplex-link-op $node_(26) $node_(27) color "white"
$ns duplex-link-op $node_(28) $node_(29) color "white"

$ns duplex-link-op $node_(81) $node_(82) color "red"
$ns duplex-link-op $node_(82) $node_(83) color "red"
$ns duplex-link-op $node_(83) $node_(88) color "red"
$ns duplex-link-op $node_(88) $node_(81) color "red"


$ns duplex-link $node_(32) $node_(33) 0Mb 100ms DropTail
$ns duplex-link $node_(34) $node_(35) 0Mb 100ms DropTail
$ns duplex-link $node_(36) $node_(37) 0Mb 100ms DropTail
$ns duplex-link $node_(38) $node_(39) 0Mb 100ms DropTail

$ns duplex-link $node_(40) $node_(41) 0Mb 100ms DropTail
$ns duplex-link $node_(42) $node_(43) 0Mb 100ms DropTail
$ns duplex-link $node_(44) $node_(45) 0Mb 100ms DropTail
$ns duplex-link $node_(46) $node_(47) 0Mb 100ms DropTail

$ns duplex-link $node_(48) $node_(49) 0Mb 100ms DropTail
$ns duplex-link $node_(50) $node_(51) 0Mb 100ms DropTail
$ns duplex-link $node_(52) $node_(53) 0Mb 100ms DropTail
$ns duplex-link $node_(54) $node_(55) 0Mb 100ms DropTail

$ns duplex-link $node_(56) $node_(57) 0Mb 100ms DropTail
$ns duplex-link $node_(58) $node_(59) 0Mb 100ms DropTail
$ns duplex-link $node_(60) $node_(61) 0Mb 100ms DropTail
$ns duplex-link $node_(62) $node_(63) 0Mb 100ms DropTail

##########

$ns duplex-link $node_(5) $node_(64) 0Mb 100ms DropTail

$ns duplex-link $node_(65) $node_(66) 0Mb 100ms DropTail
$ns duplex-link $node_(66) $node_(67) 0Mb 100ms DropTail

$ns duplex-link $node_(68) $node_(69) 0Mb 100ms DropTail
$ns duplex-link $node_(69) $node_(70) 0Mb 100ms DropTail

$ns duplex-link $node_(8) $node_(71) 0Mb 100ms DropTail

$ns duplex-link $node_(72) $node_(73) 0Mb 100ms DropTail

$ns duplex-link $node_(74) $node_(75) 0Mb 100ms DropTail

$ns duplex-link $node_(76) $node_(77) 0Mb 100ms DropTail

$ns duplex-link $node_(78) $node_(79) 0Mb 100ms DropTail

$ns duplex-link $node_(84) $node_(85) 0Mb 100ms DropTail

$ns duplex-link $node_(86) $node_(87) 0Mb 100ms DropTail

$ns duplex-link $node_(89) $node_(90) 0Mb 100ms DropTail

$ns duplex-link $node_(91) $node_(92) 0Mb 100ms DropTail
$ns duplex-link $node_(93) $node_(94) 0Mb 100ms DropTail
$ns duplex-link $node_(95) $node_(96) 0Mb 100ms DropTail
$ns duplex-link $node_(97) $node_(98) 0Mb 100ms DropTail
$ns duplex-link $node_(99) $node_(100) 0Mb 100ms DropTail
$ns duplex-link $node_(101) $node_(102) 0Mb 100ms DropTail

#########
$ns duplex-link-op $node_(32) $node_(33) color "yellow"
$ns duplex-link-op $node_(34) $node_(35) color "yellow"
$ns duplex-link-op $node_(36) $node_(37) color "yellow"
$ns duplex-link-op $node_(38) $node_(39) color "yellow"
$ns duplex-link-op $node_(40) $node_(41) color "yellow"
$ns duplex-link-op $node_(42) $node_(43) color "yellow"
$ns duplex-link-op $node_(44) $node_(45) color "yellow"
$ns duplex-link-op $node_(46) $node_(47) color "yellow"
$ns duplex-link-op $node_(48) $node_(49) color "yellow"
$ns duplex-link-op $node_(50) $node_(51) color "yellow"
$ns duplex-link-op $node_(52) $node_(53) color "yellow"
$ns duplex-link-op $node_(54) $node_(55) color "yellow"
$ns duplex-link-op $node_(56) $node_(57) color "yellow"
$ns duplex-link-op $node_(58) $node_(59) color "yellow"
$ns duplex-link-op $node_(60) $node_(61) color "yellow"
$ns duplex-link-op $node_(62) $node_(63) color "yellow"
$ns duplex-link-op $node_(78) $node_(79) color "yellow"
$ns duplex-link-op $node_(84) $node_(85) color "yellow"
$ns duplex-link-op $node_(86) $node_(87) color "yellow"
$ns duplex-link-op $node_(89) $node_(90) color "yellow"


$ns duplex-link-op $node_(91) $node_(92) color "white"
$ns duplex-link-op $node_(93) $node_(94) color "white"
$ns duplex-link-op $node_(95) $node_(96) color "white"
$ns duplex-link-op $node_(97) $node_(98) color "white"
$ns duplex-link-op $node_(99) $node_(100) color "white"
$ns duplex-link-op $node_(101) $node_(102) color "white"







######Back end vehicles

$node_(64) set X_ 5548.75
$node_(64) set Y_ 5926.91
$node_(64) set Z_ 0.0

$node_(65) set X_ 6597.65
$node_(65) set Y_ 5930.49
$node_(65) set Z_ 0.0

$node_(66) set X_ 6597.67
$node_(66) set Y_ 4179.7
$node_(66) set Z_ 0.0

$node_(67) set X_ 8376.51
$node_(67) set Y_ 4186.95
$node_(67) set Z_ 0.0


$node_(68) set X_ 8453.49
$node_(68) set Y_ 2921.77
$node_(68) set Z_ 0.0

$node_(69) set X_ 6596.38
$node_(69) set Y_ 2918.74
$node_(69) set Z_ 0.0

$node_(70) set X_ 6594.92
$node_(70) set Y_ 1267.98
$node_(70) set Z_ 0.0

$node_(71) set X_ 5531.94
$node_(71) set Y_ 1221.94
$node_(71) set Z_ 0.0

$node_(72) set X_ 6085.86
$node_(72) set Y_ 2937.67
$node_(72) set Z_ 0.0

$node_(73) set X_ 6086.37
$node_(73) set Y_ 1277.58
$node_(73) set Z_ 0.0

$node_(74) set X_ 8409.09
$node_(74) set Y_ 3539.14
$node_(74) set Z_ 0.0

$node_(75) set X_ 6577.07
$node_(75) set Y_ 3539.11
$node_(75) set Z_ 0.0

$node_(76) set X_ 6081.34
$node_(76) set Y_ 4157.94
$node_(76) set Z_ 0.0

$node_(77) set X_ 6083.6
$node_(77) set Y_ 5912.22
$node_(77) set Z_ 0.0


$node_(78) set X_ 5714.38
$node_(78) set Y_ 5900.95
$node_(78) set Z_ 0.0

$node_(79) set X_ 5715.37
$node_(79) set Y_ 1212.44
$node_(79) set Z_ 0.0

$node_(80) set X_ 7816.00
$node_(80) set Y_ 3414.12
$node_(80) set Z_ 0.0

$node_(81) set X_ 3909.13
$node_(81) set Y_ 6643.96
$node_(81) set Z_ 0.0

$node_(82) set X_ 4591.83
$node_(82) set Y_ 6643.93
$node_(82) set Z_ 0.0

$node_(83) set X_ 4339.01
$node_(83) set Y_ 6335.83
$node_(83) set Z_ 0.0

$node_(84) set X_ 6282.46
$node_(84) set Y_ 1255.23
$node_(84) set Z_ 0.0

$node_(85) set X_ 6274.74
$node_(85) set Y_ 5917.57
$node_(85) set Z_ 0.0

$node_(86) set X_ 5912.79
$node_(86) set Y_ 1238.07
$node_(86) set Z_ 0.0

$node_(87) set X_ 5898.32
$node_(87) set Y_ 5896.47
$node_(87) set Z_ 0.0

$node_(88) set X_ 4136.04
$node_(88) set Y_ 6335.81
$node_(88) set Z_ 0.0

$node_(89) set X_ 6438.05
$node_(89) set Y_ 1292.98
$node_(89) set Z_ 0.0


$node_(90) set X_ 6451.08
$node_(90) set Y_ 5922.57
$node_(90) set Z_ 0.0

$node_(91) set X_ 6082.08
$node_(91) set Y_ 2970.19
$node_(91) set Z_ 0.0

$node_(92) set X_ 6078.57
$node_(92) set Y_ 4129.5
$node_(92) set Z_ 0.0

$node_(93) set X_ 6600.99
$node_(93) set Y_ 4165.19
$node_(93) set Z_ 0.0

$node_(94) set X_ 6598.21
$node_(94) set Y_ 2923.98
$node_(94) set Z_ 0.0

$node_(95) set X_ 6571.23
$node_(95) set Y_ 3537.63
$node_(95) set Z_ 0.0

$node_(96) set X_ 5544.89
$node_(96) set Y_ 3540.27
$node_(96) set Z_ 0.0

$node_(97) set X_ 5551.4
$node_(97) set Y_ 4126.22
$node_(97) set Z_ 0.0

$node_(98) set X_ 5548.01
$node_(98) set Y_ 2936.97
$node_(98) set Z_ 0.0

$node_(99) set X_ 5536.91
$node_(99) set Y_ 2923.54
$node_(99) set Z_ 0.0


$ns at 1.5 "$node_(103) setdest 3701.77 4050.83 150.0"
$ns at 23.5 "$node_(103) setdest 3846.83 3837.06 150.0"
$ns at 25.5 "$node_(103) setdest 6350.94 3852.33 150.0"
$ns at 43.5 "$node_(103) setdest 6373.83 1424.55 150.0"

$ns at 16.0 "$node_(104) setdest 510.25 4042.38 150.0"
$ns at 20.0 "$node_(104) setdest 605.68 3839.58 150.0"
$ns at 21.0 "$node_(104) setdest 8186.74 3847.22 150.0"

$ns at 18.0 "$node_(105) setdest 510.25 4042.38 150.0"
$ns at 23.0 "$node_(105) setdest 605.68 3839.58 150.0"
$ns at 24.0 "$node_(105) setdest 8000.74 3847.22 150.0"


$ns at 2.2 "$node_(106) setdest 2950.5 4025.97 150.0"
$ns at 21.2 "$node_(106) setdest 8178.49 4097.31 150.0"

$ns at 0.5 "$node_(107) setdest 2965.15 1582.07 150.0"

$ns at 0.5 "$node_(108) setdest 8260.35 3855.16 150.0"


$ns at 0.3 "$node_(109) setdest 5786.91 3648.04 150.0"
$ns at 39.0 "$node_(109) setdest 5802.18 5778.07 150.0"


$ns at 15.3 "$node_(111) setdest 6536.42 1480.27 150.0"

$ns at 4.6 "$node_(112) setdest 5819.02 5805.8 150.0"


##########

$ns at 3.3 "$node_(115) setdest 5798.05 3045.2 150.0"
$ns at 12.3 "$node_(115) setdest 3138.52 3044.84 150.0"
$ns at 30.0 "$node_(115) setdest 3133.52 1334.78S 150.0"


$ns at 4.4 "$node_(113) setdest 6006.08 5752.99 150.0"

$ns at 4.4 "$node_(114) setdest 5639.79 3040.93 150.0"
$ns at 14.4 "$node_(114) setdest 32.40 3026.0 150.0"

#############
$ns at 9.5 "$node_(119) setdest 91.80 3240.97 150.0"
$ns at 9.3 "$node_(118) setdest 120.80 3240.97 150.0"
$ns at 11.2 "$node_(80) setdest 120.80 3414.12 150.0"

$ns at 11.2 "$node_(117) setdest 6366.32 3414.12 150.0"
$ns at 19.8 "$node_(117) setdest 6366.32 3662.39 150.0"
$ns at 21.8 "$node_(117) setdest 8259.67 3662.39 150.0"

$ns at 11.0 "$node_(116) setdest 6366.32 3051.76 150.0"
$ns at 19.3 "$node_(116) setdest 6366.32 1350.41 150.0"


$ns at 0.0 "$node_(106) label A"
$ns at 0.0 "$node_(108) label B"


###########

$node_(120) color red
$ns at 0.0 "$node_(120) add-mark co1or purple hexagon"
$ns at 0.0 "$node_(120) label OBU1"
$node_(126) color red
$ns at 0.0 "$node_(126) add-mark co1or purple hexagon"
$ns at 0.0 "$node_(126) label OBU2"
$node_(122) color red
$ns at 0.0 "$node_(122) add-mark co1or purple hexagon"
$ns at 0.0 "$node_(122) label OBU3"

$node_(125) color red
$ns at 0.0 "$node_(125) add-mark co1or green hexagon"
$ns at 0.0 "$node_(125) label RSU1"
$node_(121) color red
$ns at 0.0 "$node_(121) add-mark co1or green hexagon"
$ns at 0.0 "$node_(121) label RSU2"
$node_(124) color red
$ns at 0.0 "$node_(124) add-mark co1or green hexagon"
$ns at 0.0 "$node_(124) label RSU3"
$node_(123) color red
$ns at 0.0 "$node_(123) add-mark co1or green hexagon"
$ns at 0.0 "$node_(123) label RSU4"



$node_(127) color red
$ns at 0.0 "$node_(127) add-mark co1or red hexagon"
$ns at 0.0 "$node_(127) label Server"

##### Vehicle

$node_(103) color blue
$ns at 0.0 "$node_(103) add-mark co1or blue square"
$node_(104) color blue
$ns at 0.0 "$node_(104) add-mark co1or blue square"
$node_(105) color blue
$ns at 0.0 "$node_(105) add-mark co1or blue square"
$node_(108) color blue
$ns at 0.0 "$node_(108) add-mark co1or blue square"
$node_(109) color blue
$ns at 0.0 "$node_(109) add-mark co1or blue square"
$node_(106) color blue
$ns at 0.0 "$node_(106) add-mark co1or blue square"
$node_(107) color blue
$ns at 0.0 "$node_(107) add-mark co1or blue square"
$node_(110) color blue
$ns at 0.0 "$node_(110) add-mark co1or blue square"
$node_(111) color blue
$ns at 0.0 "$node_(111) add-mark co1or blue square"
$node_(112) color blue
$ns at 0.0 "$node_(112) add-mark co1or blue square"
$node_(113) color blue
$ns at 0.0 "$node_(113) add-mark co1or blue square"
$node_(114) color blue
$ns at 0.0 "$node_(114) add-mark co1or blue square"
$node_(115) color blue
$ns at 0.0 "$node_(115) add-mark co1or blue square"
$node_(116) color blue
$ns at 0.0 "$node_(116) add-mark co1or blue square"
$node_(117) color blue
$ns at 0.0 "$node_(117) add-mark co1or blue square"
$node_(118) color blue
$ns at 0.0 "$node_(118) add-mark co1or blue square"
$node_(119) color blue
$ns at 0.0 "$node_(119) add-mark co1or blue square"


# Printing the window size

proc plotWindow {tcpSource file} {
global ns
set time 0.01
set now [$ns now]
set cwnd [$tcpSource set cwnd_]
puts $file "$now $cwnd"
$ns at [expr $now+$time] "plotWindow $tcpSource $file" }


Agent/TCP set packetSize_	2000
set tcp1 [new Agent/TCP/Newreno]
$tcp1 set class_ 2
set sink118 [new Agent/TCPSink/DelAck]
$ns attach-agent $node_(80) $tcp1
$ns attach-agent $node_(118) $sink118
$ns connect $tcp1 $sink118
set ftp1 [new Application/FTP]
$ftp1 attach-agent $tcp1
$ns at 0.0 "$ftp1 start" 
$ns at 15.0 "$ftp1 stop"



Agent/TCP set packetSize_	2000

set tcp4 [new Agent/TCP/Newreno]
$tcp4 set class_ 2
set sink116 [new Agent/TCPSink/DelAck]
$ns attach-agent $node_(118) $tcp4
$ns attach-agent $node_(116) $sink116
$ns connect $tcp4 $sink116
set ftp4 [new Application/FTP]
$ftp4 attach-agent $tcp4
$ns at 0.0 "$ftp4 start" 
$ns at 19.0 "$ftp4 stop"

##### server #####

Agent/TCP set packetSize_	2000

set tcp5 [new Agent/TCP/Newreno]
$tcp5 set class_ 2
set sink127 [new Agent/TCPSink/DelAck]
$ns attach-agent $node_(127) $tcp5
$ns attach-agent $node_(121) $sink127
$ns connect $tcp5 $sink127
set ftp5 [new Application/FTP]
$ftp5 attach-agent $tcp5
$ns at 2.0 "$ftp5 start" 

Agent/TCP set packetSize_	2000

set tcp6 [new Agent/TCP/Newreno]
$tcp6 set class_ 2
set sink127 [new Agent/TCPSink/DelAck]
$ns attach-agent $node_(127) $tcp6
$ns attach-agent $node_(123) $sink127
$ns connect $tcp6 $sink127
set ftp6 [new Application/FTP]
$ftp6 attach-agent $tcp6
$ns at 4.0 "$ftp6 start" 


#### Infra ####

Agent/TCP set packetSize_	2000

set tcp7 [new Agent/TCP/Newreno]
$tcp7 set class_ 2
set sink121 [new Agent/TCPSink/DelAck]
$ns attach-agent $node_(121) $tcp7
$ns attach-agent $node_(122) $sink121
$ns connect $tcp7 $sink121
set ftp7 [new Application/FTP]
$ftp7 attach-agent $tcp7
$ns at 6.0 "$ftp7 start" 

Agent/TCP set packetSize_	2000

set tcp8 [new Agent/TCP/Newreno]
$tcp8 set class_ 2
set sink121 [new Agent/TCPSink/DelAck]
$ns attach-agent $node_(121) $tcp8
$ns attach-agent $node_(124) $sink121
$ns connect $tcp8 $sink121
set ftp8 [new Application/FTP]
$ftp8 attach-agent $tcp8
$ns at 6.0 "$ftp8 start" 


Agent/TCP set packetSize_	2000

set tcp9 [new Agent/TCP/Newreno]
$tcp9 set class_ 2
set sink123 [new Agent/TCPSink/DelAck]
$ns attach-agent $node_(123) $tcp9
$ns attach-agent $node_(122) $sink123
$ns connect $tcp9 $sink123
set ftp9 [new Application/FTP]
$ftp9 attach-agent $tcp9
$ns at 6.0 "$ftp7 start" 

Agent/TCP set packetSize_	2000

set tcp10 [new Agent/TCP/Newreno]
$tcp10 set class_ 2
set sink123 [new Agent/TCPSink/DelAck]
$ns attach-agent $node_(123) $tcp10
$ns attach-agent $node_(125) $sink123
$ns connect $tcp10 $sink123
set ftp10 [new Application/FTP]
$ftp10 attach-agent $tcp10
$ns at 6.0 "$ftp7 start" 

Agent/TCP set packetSize_	2000

set tcp11 [new Agent/TCP/Newreno]
$tcp11 set class_ 2
set sink114 [new Agent/TCPSink/DelAck]
$ns attach-agent $node_(114) $tcp11
$ns attach-agent $node_(115) $sink114
$ns connect $tcp11 $sink114
set ftp11 [new Application/FTP]
$ftp11 attach-agent $tcp11
$ns at 6.0 "$ftp11 start" 

Agent/TCP set packetSize_	2000

set tcp12 [new Agent/TCP/Newreno]
$tcp12 set class_ 2
set sink112 [new Agent/TCPSink/DelAck]
$ns attach-agent $node_(112) $tcp12
$ns attach-agent $node_(113) $sink112
$ns connect $tcp12 $sink112
set ftp12 [new Application/FTP]
$ftp12 attach-agent $tcp12
$ns at 6.0 "$ftp12 start" 


#Size of nodes
for {set i 0} {$i < 102} { incr i } {
$ns initial_node_pos $node_($i) 2
}

for {set i 102} {$i < 118} {incr i} {
$ns initial_node_pos $node_($i) 40
}

for {set i 118} {$i < 119} {incr i} {
$ns initial_node_pos $node_($i) 50
}

for {set i 119} {$i < $val(nn)} {incr i} {
$ns initial_node_pos $node_($i) 120
}

# Telling nodes when the simulation ends
for {set i 0} {$i < $val(nn) } { incr i } {
    $ns at $val(stop) "$node_($i) reset";
}

# ending nam and the simulation
$ns at $val(stop) "$ns nam-end-wireless $val(stop)"
$ns at $val(stop) "stop"
$ns at 150.0 "puts \"end simulation\" ; $ns halt"
proc stop {} {
    global ns tracefd namtrace
    $ns flush-trace
    close $tracefd
    close $namtrace
exec nam van.nam &
exec xgraph -m -P -bg white  Delayx -geometry 350x350 &
exec xgraph -m -P -bg white  Throughput -geometry 400x480 &
exec xgraph -m -P -bg white  Deliveryx -geometry 350x350 &
exec xgraph -m -P -bg white  Replicas -geometry 640x480 &
exit 0

}
$ns run

