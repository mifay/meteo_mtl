#!/usr/bin/perl

# Copyright 2015 Michael Fayad
#
# This file is part of meteo_mtl.
#
# This file is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This file is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this file.  If not, see <http://www.gnu.org/licenses/>.

use strict;
use warnings;
use open ':std', ':encoding(UTF-8)';
use JSON qw( decode_json );

require LWP::UserAgent;

my $ua = LWP::UserAgent->new;
$ua->agent('Mozilla/5.0');
$ua->timeout(10);
$ua->env_proxy;
my $URL = "https://www.meteomedia.com/api/data/caqc0363/cm?ts=1232";   
my $response = $ua->get("$URL");
my $HTML = "";
if ($response->is_success) 
   {
   $HTML = $response->decoded_content;
   }
else 
   {
   die $response->status_line;
   } 

my $decodeJson = decode_json($HTML);
my @septJours = @{$decodeJson->{'sevendays'}{'periods'}};
foreach my $jour ( @septJours ) {
    my $date = $jour->{"sd"};
    my $tr = $jour->{"f"};     
    my $pdp = $jour->{"pdp"};  
    my $neige = $jour->{"s"};     
    my $neigeUnite = $jour->{"su"};    
    my $pluie = $jour->{"r"}; 
    my $pluieUnite = $jour->{"ru"};    
    my $vent = $jour->{"w"};     
    my $ventUnite = $jour->{"wu"}; 
    my $ventDir = $jour->{"wd"}; 
    my $soleil = $jour->{"sun_hours"};         
    
    my $neigeFinal = "";
    if($neige ne "-")
    {
        $neigeFinal=" $neige $neigeUnite";
    }   
    
    my $pluieFinal = "";
    if($pluie ne "-")
    {
        $pluieFinal=" $pluie $pluieUnite";
    }      
    
    print "$date:\tTR=$tr" . "C\tV=$vent$ventUnite $ventDir\tSol=$soleil\tPDP=$pdp%$neigeFinal$pluieFinal\n";
}
