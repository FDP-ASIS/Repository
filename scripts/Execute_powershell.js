let spawn = require("child_process").spawn;

let file_name="\\Install_Eclipse.ps1";
let file= process.cwd()+file_name;

let child = spawn("powershell.exe",[file]);
child.stdout.on("data",function(data){
    console.log("Powershell Data: " + data);
});
child.stderr.on("data",function(data){
    console.log("Powershell Errors: " + data);
});
child.on("exit",function(){
    console.log("Powershell Script finished");
});
child.stdin.end();

///// Switch function to call a script form the code --- To Finish ////
/*
let choose_file= "button pressed by user";
switch(choose_file) {
    case "Install_eclipse":
        file_name="\\Install_eclipse.ps1";
        break;
    case "Install_jdk8":
        file_name="\\Install_jdk8.ps1";
        break;
    case "Install_PycharmCommunity":
        file_name="\\Install_PycharmCommunity.ps1";
        break;
    case "Install_Python37":
        file_name="\\Install_Python37.ps1";
        break;
    case "Delete_eclipse":
        file_name="\\Delete_eclipse.ps1";
        break;
    case "Delete_jdk8":
        file_name="\\Delete_jdk8.ps1";
        break;
    case "Delete_PycharmCommunity":
        file_name="\\Delete_PycharmCommunity.ps1";
        break;
    case "Delete_Python37":
        file_name="\\Delete_Python37.ps1";
        break;
    default:
        file_name="no such file";
}*/