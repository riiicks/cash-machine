const genericMessage = require('../helpers/generic-messages.helper')
const genericResponse = require('../helpers/generic-response.helper')
const Joi = require('joi');
const { pool } = require("../configuration/pg_db");

const saveCustomerSchema = Joi.object({
    name: Joi.string().required(),
    lastNameFather: Joi.string().optional().allow('', null),
    cellphone: Joi.string().optional().allow('', null)
});

exports.saveCustomer = async (body) => {

    try {

        const { error } = saveCustomerSchema.validate(body);

        if (error)
            return genericResponse.error(
                genericMessage.error400.CODE,
                genericMessage.error400.STATUS,
                genericMessage.errorRequest.MESSAGE,
                "");
        else {
            const data = await pool.query("select saveCustomer($1, $2, $3)", [body.name, body.lastNameFather, body.cellphone]);

            return genericResponse.success(
                genericMessage.successCreate.CODE,
                genericMessage.successCreate.STATUS,
                genericMessage.successCreate.MESSAGE,
                { customerId: data.rows[0].savecustomer });
        }
    } catch (error) {
        console.log(error)
        return genericResponse.error(
            genericMessage.error400.CODE,
            genericMessage.error400.STATUS,
            genericMessage.successUpdateNotFound.MESSAGE,
            err);

    }
};

