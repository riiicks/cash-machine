const cashService = require("../services/cashServices");
const accountTypeEnum = require("../enums/typeAccount");
const log4js = require("log4js");
const logger = log4js.getLogger("Cash ::::");
logger.level = "debug";

exports.withdrawals = async (req, res) => {

  try {
    let result = await cashService.withdrawals(req.body, accountTypeEnum.DEBITO);
    res.status(result.CODE).json(result);
  }
  catch (error) {
    logger.error(error);
    res.status(error.CODE).json(error);
  }
}

exports.addDebitAccount = async (req, res) => {

  try {
    let result = await cashService.addMoneyAccountDebit(req.body, accountTypeEnum.DEBITO);
    res.status(result.CODE).json(result);
  }
  catch (error) {
    logger.error(error);
    res.status(error.CODE).json(error);
  }
};

exports.creditCardWithdrawals = async (req, res) => {

  try {
    req.body.monto = (req.body.monto * 1.05)
    let result = await cashService.withdrawals(req.body, accountTypeEnum.CREDITO);
    res.status(result.CODE).json(result);
  }
  catch (error) {
    logger.error(error);
    res.status(error.CODE).json(error);
  }
};

exports.payCreditAccount = async (req, res) => {

  try {
    let result = await cashService.addMoneyAccountDebit(req.body, accountTypeEnum.CREDITO);
    res.status(result.CODE).json(result);
  }
  catch (error) {
    logger.error(error);
    res.status(error.CODE).json(error);
  }
};