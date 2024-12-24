function beforesubmit(){
    debugger;
    let outputdate = document.querySelector(".outputleaddate");
    let inputdate = document.querySelector(".inputleaddate");

    console.log("inputdate.value",inputdate.value);
    outputdate.value = new Date(inputdate.value).toLocaleDateString("en-US");
    console.log("outputdate.value",outputdate.value);
}


function timestamp() 
{ var response = document.getElementById("g-recaptcha-response"); 
    if (response == null || response.value.trim() == "") 
        {var elems = JSON.parse(document.getElementsByName("captcha_settings")[0].value);
            elems["ts"] = JSON.stringify(new Date().getTime());
            document.getElementsByName("captcha_settings")[0].value = JSON.stringify(elems); 
    } 
} 
setInterval(timestamp, 500);