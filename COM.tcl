#
########################################################################
# serie de comandos utiles para cargar en vmd

namespace eval ::SBG_Tools:: {
    namespace export SBGTools
    variable version "1.0"

  }


package provide SBGTools 


proc COM_din {molid out_nc} {
	set nf [molinfo $molid get numframes] 
	set CA_selection [atomselect $molid "protein and name CA"]
	set resid_list [ lsort -real -unique -increasing [$CA_selection get resid] ]
	unset CA_selection
	for {set f 0} {$f < $nf} {incr f} {
		foreach r $resid_list {
			#puts "$i $r"
			# Sidechain selection
			set sc_sel [atomselect $molid "resid $r and sidechain" frame $f]
			set sc_com [measure center $sc_sel weight mass]
			unset sc_sel
			set CA_sel [atomselect $molid "resid $r and name CA"]
			$CA_sel set x [lindex $sc_com 0];$CA_sel set y [lindex $sc_com 1];$CA_sel set z [lindex $sc_com 2]
			unset CA_sel
			}
	}
	set CA_all [atomselect $molid "name CA" frame 0]
	# write topology
	$CA_all writepdb ${out_nc}.pdb
	unset CA_all
	set CA_all [atomselect $molid "name CA"]
	# write the complete trajectory to disk 
	animate write dcd ${out_nc}.dcd beg 1 end [expr $nf-1] waitfor all sel $CA_all $molid
	unset CA_all
}


COM_din 0 salida
#quit 
