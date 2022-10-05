## ENAuth

![](https://badgen.net/badge/stable/1.1.2/blue)

It's responsible to check modules license.
You can work either locally or online as you wish. If you want to work offline, you have to pass in `ENAuthConfig` your jwt token.

Then ENAuth checks its validity and that every module has a valid license and it's not expired.
If everything is ok, you get a success response.
If not, you'll receive back an error with detailed modules with problems.
If you are passing a jwt, ENAuth also tries to call ENAuth server through the baseUrl you've defined and other parameters, so that you can receive back an updated jwt, if you are authorized and connected to the network.
