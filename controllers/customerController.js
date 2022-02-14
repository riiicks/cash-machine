const customerService = require("../services/customerServices");
const log4js = require("log4js");
const logger = log4js.getLogger("Customers ::::");
logger.level = "debug";


exports.saveCustomer = async (req, res) => {

  try {
    let result = await customerService.saveCustomer(req.body);
    res.status(result.CODE).json(result);
  }
  catch (error) {
    logger.error(error);
    res.status(error.CODE).json(error);
  }
}

