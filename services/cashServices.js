const genericMessage = require('../helpers/generic-messages.helper')
const genericResponse = require('../helpers/generic-response.helper')
const Joi = require('joi');
const { pool } = require("../configuration/pg_db");

const schema = Joi.object({
    customerId: Joi.number().required(),
    monto: Joi.number().required()
});

exports.withdrawals = async (body, typeAccount) => {

    try {

        const { error } = schema.validate(body);

        if (error)
            return genericResponse.error(genericMessage.error400.CODE, genericMessage.error400.STATUS,
                genericMessage.errorRequest.MESSAGE, "");
        else {
            const retiro = await pool.query("select withdrawals($1, $2, $3)", [body.customerId, body.monto, typeAccount]);

            if (retiro.rows[0].withdrawals == 1)
                return genericResponse.success(genericMessage.successRetiro.CODE,
                    genericMessage.successRetiro.STATUS, genericMessage.successRetiro.MESSAGE, "");
            else
                return genericResponse.error(genericMessage.error400.CODE, genericMessage.error400.STATUS,
                    genericMessage.ErrorAlRetirar.MESSAGE, "");
        }
    } catch (error) {
        console.log(error)
        return genericResponse.error(genericMessage.error400.CODE,
            genericMessage.error400.STATUS, genericMessage.successUpdateNotFound.MESSAGE, err);

    }
};

exports.addMoneyAccountDebit = async (body, typeAccountIn) => {

    try {

        const { error } = schema.validate(body);

        if (error)
            return genericResponse.error(genericMessage.error400.CODE,
                genericMessage.error400.STATUS, genericMessage.errorRequest.MESSAGE, "");
        else {
            const retiro = await pool.query("select addMoneyAccount($1, $2, $3)", [body.customerId, typeAccountIn, body.monto]);

            if (retiro.rows[0].addmoneyaccount == 1)
                return genericResponse.success(
                    genericMessage.successAddMoney.CODE, genericMessage.successAddMoney.STATUS,
                    genericMessage.successAddMoney.MESSAGE, "");
            else
                return genericResponse.error(genericMessage.error400.CODE, genericMessage.error400.STATUS,
                    genericMessage.ErrorAlRetirar.MESSAGE, "");
        }
    } catch (error) {
        console.log(error)
        return genericResponse.error(genericMessage.error400.CODE, genericMessage.error400.STATUS,
            genericMessage.successUpdateNotFound.MESSAGE, err);

    }
};

