const http = require('http')

http.createServer((req, res) => {

    if(req.method === "POST"){

        let jsonData = "";
        req.on('data', (chunk) =>{
            jsonData += chunk; 
        });
    
        req.on("end" , () => {
            const data = JSON.parse(jsonData);
            console.log(data.name);

            if(data.name === "Suraj" && data.age === 22){
                res.writeHead(200,{'Content-Type':'application/json'});
            res.end(JSON.stringify({message:"Sign In Success"}));
            }
            else{
                res.writeHead(500,{'Content-Type':'text/plain'});
                res.end(JSON.stringify({message:"Sign In Failed"}));
            }
            
        });

    }

    else{
        console.log('404');
        res.writeHead(500,{'Content-Type':'text/plain'});
        res.end(JSON.stringify({message:"POST method required"}));
    }

}).listen(4000);