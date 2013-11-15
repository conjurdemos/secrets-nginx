Nginx Secret Headers
====================

This example shows how to use conjur with nginx to fetch conjur secrets
using host credentials and store them in a request header passed to 
a backend service.

In this example we assume that the host has access to a variable with
a fixed id for simplicity.  However it would also be possible to fetch
a named variable from an environment available to the host.

The script loads the id of the variable from a file called variable_id.  We have
to create it *before* starting the VM like so:

```bash
conjur variable:create -k secret -m text/plain | jsonfield id > variable_id
conjur variable:values:add `cat variable_id` "top secret"
```

(if you already started the VM, you can just ssh to it and run `sudo service nginx restart`).

## cURL the service
(from the *host* machine, on the *guest* you can just ommit the port)
```bash
curl localhost:9080
The secret is: top secret
```


