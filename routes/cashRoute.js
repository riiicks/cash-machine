const cashController = require("../controllers/cashControllers")

module.exports = function (app, base_api) {
  app.post(base_api + '/cash/withdrawals', cashController.withdrawals);
  app.post(base_api + '/cash/addDebitAccount', cashController.addDebitAccount);
  app.post(base_api + '/cash/creditCard/withdrawals', cashController.creditCardWithdrawals);
  app.post(base_api + '/pay/creditAccount', cashController.payCreditAccount);
}
