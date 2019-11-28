<?php
$action = assertRequest("a");

if($action == "save"){
    $set = strtolower(getWord(assertRequest("set")));
    $level = strtolower(getWord(assertRequest("level")));
    $data = assertRequest("data");
    $file = "../levels/".$set."/".$level.".json";
    if(file_exists($file)){
        copy($file,$file.".bk");
    }
    file_put_contents($file,$data);
    echo '{"success":"true"}';
}
else{
    echo '{"success":"false","error":"Invalid action"}';
}

function getWord($input){
    $pattern = '/([a-zA-Z0-9]+)/';
    preg_match($pattern, $input, $matches);
    if(count($matches) == 0) return "";
    return $matches[0];
}
function assertRequest($id){
    if(!isset($_REQUEST[$id])){
        echo '{"success":"false","error":"Missing field '.$id.'"}';
        exit();
    }
    return $_REQUEST[$id];
}
?>