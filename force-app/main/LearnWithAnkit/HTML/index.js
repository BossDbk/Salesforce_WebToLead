console.log("Hello from JS file");
/*let arr1 = [1,2,3];
let arr2 = [4,5,6];
let conArray1 = [...arr1, ...arr2];
conArray1 = [...conArray1,7,8,9,10];
console.log(conArray1);

let arr3 = ["T1",10,"T2",20,"T3",30];
let [arr4, , arr5, ,arr6] = arr3;

console.log(arr3);
console.log(arr4);
console.log(arr5);
console.log(arr6);

let arr = ['a', 'b', 'c', 'd', 'e'];
for([index, value] of arr.entries())
{
    console.log(`${index} : ${value} `);
}

for(let arr1 of arr.values())
{
    console.log(` Value:${arr1} `);
}
let arr = ['a', 'b', 'c', 'd', 'e'];
for(let ind in arr)
{
    console.log(` ${ind}:${arr[ind]} `);
}*/

/*let offTimings = {
    Mon: {o:9,c:11},
    Tue: {o:10,c:12},
    Wed: {o:8,c:9},
    Thu: {o:6,c:6},
    Fri: {o:9,c:11},
    Sat: {o:9,c:11},
    Sun: {o:12,c:12}  }

    for(let day in offTimings)
    {
        let {o, c} = offTimings[day];
        console.log(`On ${day} office opens at ${o} and closes at ${c}`);
    }
    for(let [day,{o,c}] of Object.entries(offTimings))
    {
        console.log(`On ${day} office opens at ${o} and closes at ${c}`);
    }

let funRes = function fun1(param1, param2){
    let sum = param1 + param2;
    return sum;
}
console.log(funRes(10,20));

let funResArrow = (param1, param2) => {
    let sum = param1 + param2;
    return sum;
}
console.log(funResArrow(10,20));

let funResArrow2 = () => 'Blank Arrow Function';
console.log(funResArrow2());

let Testing = (fun1,callMe) => {
    console.log(`${fun1} Arrow Function with callBack`);
    callMe();
};

() => console.log('Hey Calling anonymous function');
function fun3()
{
    console.log('Hey Calling function fun3');
}
function fun4()
{
    console.log('Hey Calling function fun4');
}

Testing('Testing1', fun4);
Testing('Testing2', fun3);
    

let str = 'Babji Rao Dhana';
let spStr = str.split(' ').map((item) => item[0].toUpperCase()).join('');
console.log(spStr);


function mouseHoverHandler(){
    console.log('Mouse Hover');
    let element = document.querySelector('.hover');
    element.style.display = "None";
}

function mouseOutHandler(){
    console.log('Mouse Out');
    let element = document.querySelector('.hover');
    element.style.display = "block";
}
*/
//Listen to Custom Event
document.addEventListener('myEvent',(event) => {
    console.log("Event Listener Data",event.detail.message);
});
function changeHandler(event){
    let eVal = event.target.value;
    console.log('Event Value',eVal);
debugger;
    if(eVal == 10){
        const myEvent = new CustomEvent('myEvent',{
            detail:{
                message: "Hey There I am from changeHandler",
            }
        });
        document.dispatchEvent(myEvent);
    }
}