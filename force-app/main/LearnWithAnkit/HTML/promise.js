function genPromise(msg){
    return new Promise((resolve, reject) => {
        if(!msg){
            reject(`No Message`);
        }else{
            setTimeout(() => {
                console.log(`Promise Resolved: `,msg);
                resolve(msg);
            }, 1000);
        }
    });
}

/*genPromise('Promise 1')
.then((res) => {
    console.log('1st Promise Resolved', res);
    return genPromise('Promise 2');
})
.then((res) => {
    console.log('2nd Promise Resolved', res);
    return genPromise();
})
.catch((err) => {
    console.log('Promise Error', err);
});*/

async function asyncMethodPromise(){
    try{
        await genPromise('Promise 1');
        await genPromise('Promise 2');
        await genPromise();
    }catch(err){
        console.log('Promise Error', err);
    }
}
asyncMethodPromise();