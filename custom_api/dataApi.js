
const http = require('http');

const data = [
{name: "Suraj", age: 22, address : "Pune"},
{name: "PP", age: 20 , address : "Delhi"},
{name: "Aamir", age: 21 , address : "Maharashtra"},
{name: "Zaki", age: 18 , address : "Rajasthan"},
{name: "Gaurav", age: 16 , address : "Bengaluru"},
{name: "Dev", age: 10 , address : "Nepal"},
{name: "Ganesh", age: 25 , address : "Mumbai"},
{name: "Preety", age: 30 , address : "Pune"}
];

http.createServer((req, res) => {
    if(req.method === "GET"){
        res.writeHead(200,{'Content-Type':'application/json'});
        res.end(JSON.stringify(data));
    } 
    else{
        res.writeHead(405,{'Content-Type':'text/plain'});
        res.end(JSON.stringify({message:"GET method required"}));
    }


}).listen(4000);