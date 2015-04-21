http = require('http');

var app = http.createServer(function(req,res){
    res.setHeader('Content-Type', 'application/json');
    res.end(JSON.stringify(
                           {
                           "invoices": [
                                        {
                                        "id": 211540727,
                                        "name": "Pay me!",
                                        "slug": "pay-me",
                                        "amount": "1000000.0",
                                        "company": {
                                        "company": {
                                        "name": "So Awesome Inc",
                                        "subdomain": "so-awesome-inc",
                                        "stripe_publishable_key": "pk_test_vF002lCaOLnLI4eiV9DESFNu",
                                        "token": "88b1db70-e2cb-4c80-85fa-dd7541907702"
                                        }
                                        },
                                        "created_at": "2014-11-07T20:56:45.000Z",
                                        "payment": null
                                        },
                                        {
                                        "id": 1010617246,
                                        "name": "so little money",
                                        "slug": null,
                                        "amount": "1.0",
                                        "company": {
                                        "company": {
                                        "name": "So Awesome Inc",
                                        "subdomain": "so-awesome-inc",
                                        "stripe_publishable_key": "pk_test_vF002lCaOLnLI4eiV9DESFNu",
                                        "token": "88b1db70-e2cb-4c80-85fa-dd7541907702"
                                        }
                                        },
                                        "created_at": "2014-11-07T20:56:45.000Z",
                                        "payment": null
                                        },
                                        {
                                        "id": 113629430,
                                        "name": "Entertainment",
                                        "slug": "entertainment",
                                        "amount": "1500.0",
                                        "company": {
                                        "company": {
                                        "name": "So Awesome Inc",
                                        "subdomain": "so-awesome-inc",
                                        "stripe_publishable_key": "pk_test_vF002lCaOLnLI4eiV9DESFNu",
                                        "token": "88b1db70-e2cb-4c80-85fa-dd7541907702"
                                        }
                                        },
                                        "created_at": "2014-11-07T20:56:45.000Z",
                                        "payment": {
                                        "created_at": "2014-11-07T20:56:45.000Z",
                                        "last_four": null,
                                        "brand": null
                                        }
                                        }
                                        ]
                           }
		, null, 3));
});
app.listen(3000);