const customerController = require("../controllers/customerController")

module.exports = function (app, base_api) {
  
  app.post(base_api + '/customer/registro', customerController.saveCustomer);
};


