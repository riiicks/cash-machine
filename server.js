const express = require('express');
const app = express();
const bodyParser = require('body-parser');
const config = require('./configuration/config');


app.use(bodyParser.json())
app.use(bodyParser.urlencoded({ extended: false }));
  

const BASE_API = config.API_PATH + config.API_VERSION



require('./routes/customerRoute')(app, BASE_API);
require('./routes/cashRoute')(app, BASE_API);

app.listen( config.PORT, () => {
    console.log(`Welcome Api Listening on port ${config.PORT}`);
})