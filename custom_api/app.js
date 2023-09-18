const http = require('http');

const server = http.createServer((req, res) => {
  if (req.method === 'POST' && req.url === '/') {
    let requestBody = '';

    req.on('data', (chunk) => {
      requestBody += chunk;
    });

    req.on('end', () => {
      const requestData = JSON.parse(requestBody);
      const responseMessage = requestData.name === 'Suraj' ? 'Hello Suraj' : JSON.stringify(requestData);

      res.writeHead(200, { 'Content-Type': 'application/json' });
      res.end(responseMessage);
    });
    
  } else {
    res.writeHead(404, { 'Content-Type': 'text/plain' });
    res.end(req.url);
  }
});

const port = 4000;
server.listen(port, () => {
  console.log(`Server is running on port ${port}`);
});