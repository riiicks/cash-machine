exports.error  = (code, status, message, errors) => {
    return  {
        "CODE": code,
        "STATUS":  status,
        "MESSAGE": message,
        "errors": errors
    } 
}

exports.success  = (code, status, message, result='') => {
    return  {
        "CODE": code,
        "STATUS":  status,
        "MESSAGE": message,
        "data": result
    }
}


