const config = {
    PORT: process.env.PORT || '8180',
    API_VERSION: process.env.API_VERSION || '/v1',
    API_PATH: process.env.API_PATH || '/backend-atm',
    NODE_ENV: process.env.NODE_ENV || 'development'
};

module.exports = config
  
  