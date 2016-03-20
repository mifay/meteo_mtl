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
require LWP::UserAgent;
my $ua = LWP::UserAgent->new;
$ua->agent('Mozilla/5.0');
$ua->timeout(10);
$ua->env_proxy;
my $URL = "http://www.meteomedia.com/meteo/canada/quebec/montreal";   
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
open RedacteurDeFichier,">input.txt" or die $!;
print RedacteurDeFichier "$HTML";
close RedacteurDeFichier;
print "\n\n    =====================================================================\n";
print "    ==============~*=~*=~*=~*=~*=~* METEO *~=*~=*~=*~=*~=*~==============\n";
print "    =====================================================================\n";
open LecteurDeFichier,"<input.txt" or die "E/S : $!\n";
while (my $Ligne = <LecteurDeFichier>)
{
   if($Ligne =~ /day_(\d)/)
   {
      if ($Ligne =~ /<span class=\"day_title\">(\w{3})<\/span><span>(\d{1,2}) (.{3,10})<\/span>/)
      {
         print "    $1 le $2 $3: \n";
      }
      if ($Ligne =~ /<div class=\"feels-like seven_days_metric seven_days_metric_c \">	&nbsp;<span>(-|)(\d{1,2})<\/span>/)
      {
         print "\tTR=\"$1$2 C\" \n";
      }
      if ($Ligne =~ /<div class=\"fx-details \">	&nbsp;(\d{1,3}%)	<\/div>/)
      {
         print "\tPDP=\"$1\" \n";
      }
      if ($Ligne =~ /<div class=\"fx-details seven_days_metric seven_days_metric_kmh snow \">\W*&nbsp;(.{4,15})\W*<\/div>/)
      {
         print "\tNeige=\"$1\" \n";
      }
      if ($Ligne =~ /<div class=\"fx-details seven_days_metric rain seven_days_metric_kmh\">	&nbsp;(.{4,15})	<\/div>/)
      {
         print "\tPluie=\"$1\" \n";
      }
      if ($Ligne =~ /<div class=\"fx-details seven_days_metric seven_days_metric_kmh wind \">	&nbsp;(\d{1,3})&nbsp;km\/h&nbsp;(.{1,10})	<\/div>/)
      {
         print "\tVent=\"$1km/h $2\" \n";
      }
      if ($Ligne =~ /<div class=\"fx-details sun \">	&nbsp;(\d+)	<\/div>/)
      {
         print "\tSoleil=\"$1\" \n";
      }


      print "\n";
   }
}       
print "\n\n";
close LecteurDeFichier;
system("rm input.txt");
