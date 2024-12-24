function beforesubmit(){
    debugger;
    let outputdate = document.querySelector(".outputleaddate");
    let inputdate = document.querySelector(".inputleaddate");

    console.log("inputdate.value",inputdate.value);
    outputdate.value = new Date(inputdate.value).toLocaleDateString("en-US");
    console.log("outputdate.value",outputdate.value);
}
