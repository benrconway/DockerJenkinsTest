'use strict';

const express = require('express');

// Constants
const PORT = 3000;
const HOST = '0.0.0.0';

// App
const app = express();
app.get('/api', (req, res) => {
  res.send({name:"John"});
});

app.listen(PORT, HOST);
console.log(`Running on http://${HOST}:${PORT}`);
