#!/usr/bin/perl

# idea from https://github.com/amaunz/data-yeast-ac/blob/master/sdf2gsp.pl

# usage: perl sdf2gsp.pl <path to sdf files>
#        <sdf file list in correct label order> <targets file>

# Copyright (C) 2006  Christoph Helma <helma@in-silico.de>
#
#
#    This program is free software; you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation; either version 2 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program; if not, write to the Free Software
#    Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA

use autodie;

$at{"H"}	= 1;
$at{"He"}	= 2;
$at{"Li"}	= 3;
$at{"Be"}	= 4;
$at{"B"}	= 5;
$at{"C"}	= 6;
$at{"N"}	= 7;
$at{"O"}	= 8;
$at{"F"}	= 9;
$at{"Ne"}	= 10;
$at{"Na"}	= 11;
$at{"Mg"}	= 12;
$at{"Al"}	= 13;
$at{"Si"}	= 14;
$at{"P"}	= 15;
$at{"S"}	= 16;
$at{"Cl"}	= 17;
$at{"Ar"}	= 18;
$at{"K"}	= 19;
$at{"Ca"}	= 20;
$at{"Sc"}	= 21;
$at{"Ti"}	= 22;
$at{"V"}	= 23;
$at{"Cr"}	= 24;
$at{"Mn"}	= 25;
$at{"Fe"}	= 26;
$at{"Co"}	= 27;
$at{"Ni"}	= 28;
$at{"Cu"}	= 29;
$at{"Zn"}	= 30;
$at{"Ga"}	= 31;
$at{"Ge"}	= 32;
$at{"As"}	= 33;
$at{"Se"}	= 34;
$at{"Br"}	= 35;
$at{"Kr"}	= 36;
$at{"Rb"}	= 37;
$at{"Sr"}	= 38;
$at{"Y"}	= 39;
$at{"Zr"}	= 40;
$at{"Nb"}	= 41;
$at{"Mo"}	= 42;
$at{"Tc"}	= 43;
$at{"Ru"}	= 44;
$at{"Rh"}	= 45;
$at{"Pd"}	= 46;
$at{"Ag"}	= 47;
$at{"Cd"}	= 48;
$at{"In"}	= 49;
$at{"Sn"}	= 50;
$at{"Sb"}	= 51;
$at{"Te"}	= 52;
$at{"I"}	= 53;
$at{"Xe"}	= 54;
$at{"Cs"}	= 55;
$at{"Ba"}	= 56;
$at{"Hf"}	= 57;
$at{"Ta"}	= 58;
$at{"W"}	= 59;
$at{"Re"}	= 60;
$at{"Os"}	= 61;
$at{"Ir"}	= 62;
$at{"Pt"}	= 63;
$at{"Au"}	= 64;
$at{"Hg"}	= 65;
$at{"Tl"}	= 66;
$at{"Pb"}	= 67;
$at{"Bi"}	= 68;
$at{"Po"}	= 69;
$at{"At"}	= 70;
$at{"Rn"}	= 71;
$at{"Fr"}	= 72;
$at{"Ra"}	= 73;
$at{"Pt"}	= 74;
$at{"Ac"}	= 75;
$at{"La"}	= 76;
$at{"U"}	= 77;
$at{"Sm"}	= 78;
$at{"Ce"}	= 79;
$at{"Nd"}	= 80;
$at{"Eu"}	= 81;
$at{"Gd"}	= 82;
$at{"Dy"}	= 83;
$at{"Er"}	= 84;
$at{"Rh"}	= 85;

$i = 0;
@targets;

$sdf_dir_path = @ARGV[0];
$sdf_list = @ARGV[1];
$sdf_targets = @ARGV[2];

sub ltrim { my $s = shift; $s =~ s/^\s+//; return $s };

########## Read targets

open(my $fh, "<", $sdf_targets)
	or die "cannot open $sdf_labels: $!";

chomp($fh);

while(<$fh>) {
	chomp;
	s/^\s+//;
	push (@targets, $_);
}

# for debug, you don't want that in the output
# print scalar @targets . " targets read.\n";

########### Read sdf's given in list

open(my $fh, "<", $sdf_list)
	or die "cannot open $sdf_list: $!";

chomp($fh);

while(<$fh>) {
	chomp;
	s/^\s+//;

	chdir $sdf_dir_path;

	open(my $fh_sdf, "<", "$sdf_dir_path$_")
		or die "cannot open " . $sdf_dir_path . $_ . ": $!";

	chomp($fh_sdf);
	s/^\s+//;

	# read this SDF file
	while(<$fh_sdf>) {

		# process current line in sdf file
		if (/V2000/) {

			## ($nr_atoms,$nr_bonds,$rest) = split /\s+/, $_;
			# above code used before but some lines are not seperated by whitespaces
			# if the atom/bond numbers go into 3 digits (awesome kegg format)
			my @fields = $_ =~ /.{2}\S/g;
			$nr_atoms = ltrim(@fields[0]);
			$nr_bonds = ltrim(@fields[1]);

			$atom_nr=0;
			$bond_nr=0;
	 		print "t # $i " . @targets[$i] . "\n";
			next;
		}
		elsif ($atom_nr < $nr_atoms) { # atom block

			# here it seems to work with whitespace seperation in kegg as the first
			# values are floats and they seem to always be whitespace seperated
			# (actually they also have a limited char width of 10 characters but
			# there was no test case where it extended to 10 chars and
			# eliminated the test case)
			($x,$y,$z,$element,$rest) = split /\s+/, $_;
			print "v $atom_nr $at{$element}\n";
			$atom_nr++;
			next;
		}
		elsif ($bond_nr < $nr_bonds) { # bond block

			## ($a1,$a2,$type,$rest) = split /\s+/, $_;
			# above code used before but some lines are not seperated by whitespaces
			# if the atom/bond numbers go into 3 digits (awesome kegg format)
			my @fields = $_ =~ /.{2}\S/g;
			$a1 = ltrim(@fields[0]);
			$a2 = ltrim(@fields[1]);
			$type = ltrim(@fields[2]);

			$a1--;
			$a2--;
			print "e $a1 $a2 $type\n";
			$bond_nr++;
			next;
		}
		if (/\$\$\$\$/) {
			$i++;
			print "\n";
			next;
		}
	}
}

# for debug, you don't want that in the output
# print scalar $i . " sdf files read.\n";
