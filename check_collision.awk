#!/usr/bin/awk -f

set -uex

function count_diff(line1,line2,limit){
	#
	# char by char comparison
	#
	split(line1,arr1,"")
	split(line2,arr2,"")
	diffs=0
	for ( char in arr1 )
	{
		if ( arr1[char] != arr2[char] )
			diffs++;
		if ( diffs > limit ) # no need to continue comparing if more than limit differences found
			return diffs
	}
	return diffs
}

FNR>1{
	# FNR > 1 to exlude Header line from the input.
	# read file into array r
	record[FNR]=$0
	line1_col2[FNR]=$2
	line2_col2[FNR]=$2
	line1_col4[FNR]=$4
	line2_col4[FNR]=$4
}
END{
	#
	# process 
	#
	for ( line1=2; line1 <= FNR; line1++ )
	{
		for ( line2=(line1+1); line2 <= FNR; line2++ )
		{
			if ( ( count_diff( line1_col2[line1], line2_col2[line2], 3 ) < 3 ) )
				if ( ( count_diff( line1_col4[line1], line2_col4[line2], 3 ) < 3 ) )
					printf( "%s\n%s\n\n", record[line1],  record[line2] )
		}
	}
}