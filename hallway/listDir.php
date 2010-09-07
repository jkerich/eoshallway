<?php


// Build the path

//$path = "/some_directory/" . $_POST[ 'path' ];
$path = $_POST[ 'path' ];


// Initalise some variables

$output_string = '';

$file_number = 0;



// Get the directory handle

$dir = dir( $path ); 

// Read all files / dirs in the directory

while ( false !== ( $file_name = $dir->read() ) ) { 



	// Exclude this dir and parent dir

	if( $file_name[0] != '.' ){

		// Add file to the output string

		$output_string .= "&file_" . ++$file_number . "=" .$file_name;

	}

} 

$dir->close(); 


// Return the result

echo "file_count=".$file_number.$output_string;


?>
