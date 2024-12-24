async function fetchCatImgs(){
    try{
        let fetchApiRes = await fetch('https://api.thecatapi.com/v1/images/search',{
            method: 'GET',
        });
        let data = await fetchApiRes.json();
        
        let img = data[0].url;
        let imgElem = document.querySelector('.catimg');
        imgElem.setAttribute('src',img);

    }catch(err){
        console.log(err);
    }

}

fetchCatImgs(); 