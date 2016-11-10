# get-LevenshtienDistance.ps1
# Levenshtein Distance is the # of edits it takes to get from 1 string to another.
# This is one way of measuring the "similarity" of 2 strings.
#
# Many useful purposes that can help in determining if 2 strings are similar possibly
# with different punctuation or misspellings/typos.

# Cribbing heavily from https://en.wikipedia.org/wiki/Levenshtein_distance
 
param([string] $first, [string] $second, [switch] $ignoreCase)
 
$len1 = $first.length
$len2 = $second.length
 
# If either of the strings is zero length, return the length of the other string
if ( $len1 -eq 0 ) { return $len2 }
if ( $len2 -eq 0 ) { return $len1 }
 
# make everything lowercase if ignoreCase flag is set
if ( $ignoreCase -eq $true )
{
	$first = $first.tolowerinvariant()
	$second = $second.tolowerinvariant()
}
 
# create 2 dimensonal array to hold the distances
$dist = new-object -type 'int[,]' -arg ($len1 + 1), ($len2 + 1)
 
# initialize the first row and first column which represent the 2 strings we're comparing
for( $i = 0; $i -le $len1; $i++ )
{
	$dist[$i, 0] = $i
}

for( $j = 0; $j -le $len2; $j++ ) 
{
	$dist[0, $j] = $j
}
 
$distributionCost = 0
 
for( $i = 1; $i -le $len1; $i++ )
{
  for( $j = 1; $j -le $len2; $j++ )
  {
	# Test if last characters of the strings match 
	if ( $second[$j - 1] -ceq $first[$i - 1] )
	{
	  $distributionCost = 0
	}
	else   
	{
	  $distributionCost = 1
	}
	
	# Just for readability, spliting these out...

	# 1. The cell immediately above plus 1
	$possibility1 = [int]$dist[ ($i - 1) ,  $j     ] + 1
	# 2. The cell immediately to the left plus 1
	$possibility2 = [int]$dist[  $i      , ($j - 1)] + 1
	# 3. The cell diagonally above and to the left plus the 'cost'
	$possibility3 = [int]$dist[ ($i - 1) , ($j - 1)] + $distributionCost

	# What is the minimum value
	$min = [System.Math]::Min($possibility1, $possibility2)

	# Store the value
	$dist[$i, $j] = [System.Math]::Min($min, $possibility3)
	
#	$tempmin = [System.Math]::Min( ([int]$dist[ ($i-1), $j] + 1 ) , ( [int]$dist[$i, ($j - 1) ] + 1) )
#	$dist[$i, $j] = [System.Math]::Min($tempmin, ( [int]$dist[ ($i - 1), ($j - 1 ) ] + $distributionCost) )
  }
}

# TODO:  Use Out-Gridview to visualize the table
Out-GridView -InputObject $dist
 
# The actual distance is stored in the bottom right cell
return $dist[$len1, $len2];