set val(chan)   Channel/WirelessChannel    ;# channel type
set val(prop)   Propagation/TwoRayGround   ;# radio-propagation model
set val(netif)  Phy/WirelessPhy            ;# network interface type
set val(mac)    Mac/802_11                 ;# MAC type
set val(ifq)    Queue/DropTail/PriQueue    ;# interface queue type
set val(ll)     LL                         ;# link layer type
set val(ant)    Antenna/OmniAntenna        ;# antenna model
set val(ifqlen) 50                         ;# max packet in ifq
set val(nn)     76                         ;# number of mobilenodes
set val(rp)     AODV                       ;# routing protocol
set val(x)      1500                       ;# X dimension of topography
set val(y)      1500                       ;# Y dimension of topography
set val(stop)   500.0                      ;# time of simulation end

#Create a ns simulator
set ns [new Simulator]

set dist(20m) 4.80696e-07
set dist(26m) 2.84435e-07
set dist(27m) 2.63756e-07
set dist(28m) 2.45253e-07
set dist(25m) 3.07645e-07
set dist(30m) 2.13643e-07
set dist(35m) 1.56962e-07
set dist(50m) 7.69113e-08
set dist(75m) 3.41828e-08
set dist(60m) 5.34106e-08
set dist(70m) 3.92405e-08
# unity gain, omni-directional antennas
# set up the antennas to be centered in the node and 1.5 meters above it
Antenna/OmniAntenna set X_ 0
Antenna/OmniAntenna set Y_ 0
Antenna/OmniAntenna set Z_ 1.5
Antenna/OmniAntenna set Gt_ 1.0
Antenna/OmniAntenna set Gr_ 1.0
# Initialize the SharedMedia interface with parameters to make
# it work like the 914MHz Lucent WaveLAN DSSS radio interface

$val(netif) set CPThresh_ 10.0
$val(netif) set CSThresh_ $dist(70m)
$val(netif) set RXThresh_ $dist(75m)
$val(netif) set Rb_ 2*1e6
$val(netif) set Pt_ 0.2818
$val(netif) set freq_ 914e+6
$val(netif) set L_ 1.0

#Setup topography object
set topo       [new Topography]
$topo load_flatgrid $val(x) $val(y)
create-god $val(nn)

#Open the NAM trace file
set namfile [open FSAD.nam w]
$ns namtrace-all $namfile
$ns namtrace-all-wireless $namfile $val(x) $val(y)
set chan [new $val(chan)];#Create wireless channel
#===================================
#     Mobile node parameter setup
#===================================
$ns node-config -adhocRouting  $val(rp) \
                -llType        $val(ll) \
                -macType       $val(mac) \
                -ifqType       $val(ifq) \
                -ifqLen        $val(ifqlen) \
                -antType       $val(ant) \
                -propType      $val(prop) \
                -phyType       $val(netif) \
                -channel       $chan \
                -topoInstance  $topo \
                -agentTrace    ON \
                -routerTrace   ON \
                -macTrace      ON \
                -movementTrace ON


	$ns attach-agent $n($SA1) $null($SA1)
	set cbr0 [attach-cbr-traffic $n($OBU1) $null($SA1) 500 0.08]
	$ns at $t1 "$cbr0 start"
	puts "OBU1:$OBU1"
	$ns at [expr $t1] "$n($OBU1) add-mark m0 yellow"
	$ns at [expr $t1+0.5] "$n($OBU1) delete-mark m0"
	$ns at [expr $t1+0.5] "$cbr0 stop"
	$ns attach-agent $n($rs) $null($rs)
	set cbr0 [attach-cbr-traffic $n($SA1) $null($rs) 500 0.008]
	$ns at 5.08 "$cbr0 start"
	$ns at [expr 5.13] "$cbr0 stop"	

proc RSUcom {chn1 rf tt} {
	global ns array names n array names null array names null ff chn
	set rr $rf
	set t $tt
		for { set sin 0} {$sin<$chn1} {incr sin} {	
			set chnn [lindex $chn $sin]
			puts chnn:$chnn 
			$ns attach-agent $n($chnn) $null($chnn)
			set cbr0 [attach-cbr-traffic $n($rr) $null($chnn) 500 0.006]
			$ns at $t "$cbr0 start"
			$ns at $t "$n($chnn) add-mark m0 magenta square"
			$ns at [expr $t+0.5] "$n($chnn) delete-mark m0"
			$ns at [expr $t+0.5] "$cbr0 stop"	
		}	  
}

set chn [list 13 46 49 47 11]
set chn1 [llength $chn]
puts "chn1:$chn1"
$ns at 5.15 "RSUcom $chn1 $rs 5.15"

proc RSUcom1 {chn1 rf1 tt} {
	global ns array names n array names null array names null chn2
	set rr $rf1
	set t $tt
		for { set sin 0} {$sin<$chn1} {incr sin} {	
			set chnn [lindex $chn2 $sin]
			puts chnn:$chnn 
			$ns attach-agent $n($chnn) $null($chnn)
			set cbr0 [attach-cbr-traffic $n($rr) $null($chnn) 500 0.06]
			$ns at $t "$cbr0 start"
			$ns at $t "$n($chnn) add-mark m0 cyan square"
			$ns at [expr $t+0.5] "$n($chnn) delete-mark m0"
			$ns at [expr $t+0.5] "$cbr0 stop"	
		}	  
}

set OBU2 51
set SA2 65
set rs1 42
	set t2 7.0
	$ns attach-agent $n($SA2) $null($SA2)
	set cbr0 [attach-cbr-traffic $n($OBU2) $null($SA2) 500 0.06]
	$ns at $t2 "$cbr0 start"
	$ns at [expr $t2] "$n($OBU2) add-mark m0 yellow"
	$ns at [expr $t2+0.4] "$n($OBU2) delete-mark m0"
	$ns at [expr $t2+0.4] "$cbr0 stop"
	$ns attach-agent $n($rs1) $null($rs1)
	set cbr0 [attach-cbr-traffic $n($SA2) $null($rs1) 500 0.06]
	$ns at 7.04 "$cbr0 start"
	$ns at [expr 7.08] "$cbr0 stop"	
	set chn2 [list 22 53 56 54 44 52 55 51 50]
set chnn1 [llength $chn2]
$ns at 7.09 "RSUcom1 $chnn1 $rs1 7.09"
set dg [Ran 5 17] 
set tn 17
proc Avlinkinst { } {
	global dg tn
	set LI [expr ($dg/$tn*($tn-1))]
	puts LI:$LI
	set ALI [$LI/$tn]
	puts ALI:$ALI
}
set IB 11
set PKS 500
proc Avband {} {
	global IB dg PKS
	set t [$ns now]
	set BA [expr (($IB-0.008)/2)]
	set CBW [expr ($IB-$BA/2)] 
	set ABW [expr $PKS*$dg/$t]
}	


proc finish {} {
    global ns tracefile namfile
    $ns flush-trace
    close $tracefile
    close $namfile
    exec nam out.nam &
    exit 0
}

for {set i 0} {$i < $val(nn) } { incr i } {
    $ns at 100 "\$n($i) reset"
}

$ns at 100 "$ns nam-end-wireless $val(stop)"
$ns at 100 "finish"
$ns at 100 "puts \"done\" ; $ns halt"
$ns run
